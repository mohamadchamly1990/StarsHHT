codeunit 51000 "Stars Handheld Utilities"
{
    Access = internal;
    PROCEDURE ImportTransferOrderLines(VAR TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
        TempBarcodes: Record "LSC Barcodes" temporary;
        Barcodes: Record "LSC Barcodes";
        ImportScannedItems: XMLport "Stars Import Scanned Items";
        LineNo: Integer;
        WinL: Dialog;
        CountL: Integer;
        CounterL: Integer;
        Text001L: Label 'Importing Transfer Lines @1@@@@@@@@@@';
    begin
        TransferHeader.TESTFIELD("Transfer-from Code");
        TransferHeader.TESTFIELD("Transfer-to Code");
        TransferHeader.TESTFIELD(Status, TransferHeader.Status::Open);

        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF TransferLine.FINDLAST THEN
            LineNo := TransferLine."Line No.";

        CLEAR(TransferLine);

        ImportScannedItems.fGroupByOption(0);
        ImportScannedItems.RUN;
        ImportScannedItems.GetBarcodeTmpTable(TempBarcodes);
        CLEAR(ImportScannedItems);

        IF TempBarcodes.FIND('-') THEN BEGIN
            WinL.OPEN(Text001L);
            CounterL := 0;
            CountL := TempBarcodes.COUNT;
            REPEAT
                LineNo := LineNo + 10000;

                Barcodes.GET(TempBarcodes."Barcode No.");

                TransferLine.INIT;
                TransferLine."Document No." := TransferHeader."No.";
                TransferLine."Line No." := LineNo;
                TransferLine.INSERT(TRUE);
                TransferLine.VALIDATE("Item No.", Barcodes."Item No.");
                TransferLine."Stars Barcode No." := Barcodes."Barcode No.";
                TransferLine.VALIDATE("Variant Code", Barcodes."Variant Code");
                TransferLine.VALIDATE("Unit of Measure Code", Barcodes."Unit of Measure Code");
                TransferLine.VALIDATE(Quantity, TempBarcodes."Discount %");
                TransferLine.VALIDATE("Qty. to Ship", TempBarcodes."Discount %");
                TransferLine.MODIFY(TRUE);

                CounterL += 1;
                WinL.UPDATE(1, ROUND(CounterL / CountL * 10000, 1));
            UNTIL TempBarcodes.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    PROCEDURE ImportStockTake(VAR ItemJournalLine: Record "Item Journal Line")
    var
        TempItemVariant: Record "Item Unit of Measure" temporary;
        ImportScannedItems: XMLport "Stars Import Scanned Items";
        LineNo: Integer;
        DocNo: Code[20];
        TemName: Code[10];
        BatchName: Code[10];
        PostDate: Date;
        Loc: Code[20];
        CalcQtyOnHand: Report "Calculate Inventory";
        Item2: Record Item;
        WinL: Dialog;
        CountL: Integer;
        CounterL: Integer;
        Text001L: Label 'Importing Stock Take @1@@@@@@@@@@';
    begin
        ImportScannedItems.fGroupByOption(1);
        ImportScannedItems.RUN;
        ImportScannedItems.GetItemVariantTmpTable(TempItemVariant);
        ImportScannedItems.GetLocationCode(Loc);

        CLEAR(ImportScannedItems);
        ItemJournalLine.SETRANGE("Item No.");
        ItemJournalLine.SETRANGE("Variant Code");
        IF ItemJournalLine.FIND('+') THEN BEGIN
            LineNo := ItemJournalLine."Line No.";
            DocNo := ItemJournalLine."Document No.";
            TemName := ItemJournalLine."Journal Template Name";
            BatchName := ItemJournalLine."Journal Batch Name";
            PostDate := ItemJournalLine."Posting Date";
        END ELSE BEGIN
            LineNo := 0;
            DocNo := ItemJournalLine."Document No.";
            TemName := ItemJournalLine."Journal Template Name";
            BatchName := ItemJournalLine."Journal Batch Name";
            PostDate := ItemJournalLine."Posting Date";
        END;

        IF TempItemVariant.FIND('-') THEN BEGIN
            WinL.OPEN(Text001L);
            CounterL := 0;
            CountL := TempItemVariant.COUNT;
            REPEAT
                ItemJournalLine.SETRANGE("Item No.", TempItemVariant."Item No.");
                ItemJournalLine.SETRANGE("Variant Code", TempItemVariant.Code);
                IF ItemJournalLine.FINDFIRST THEN BEGIN
                    ItemJournalLine.VALIDATE("Qty. (Phys. Inventory)", TempItemVariant.Length / ItemJournalLine."Qty. per Unit of Measure");
                    ItemJournalLine."Stars Updated from Handheld" := TRUE;
                    ItemJournalLine.MODIFY(TRUE);
                END ELSE BEGIN
                    LineNo += 10000;
                    ItemJournalLine.SETRANGE("Item No.");
                    ItemJournalLine.SETRANGE("Variant Code");

                    ItemJournalLine.INIT;
                    ItemJournalLine.VALIDATE("Journal Template Name", TemName);
                    ItemJournalLine.VALIDATE("Journal Batch Name", BatchName);
                    ItemJournalLine.VALIDATE("Line No.", LineNo);
                    IF Loc <> '' THEN
                        ItemJournalLine."Location Code" := Loc;
                    ItemJournalLine.INSERT(TRUE);
                    ItemJournalLine.VALIDATE("Posting Date", PostDate);
                    ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                    ItemJournalLine.VALIDATE("Document No.", DocNo);
                    ItemJournalLine.VALIDATE("Item No.", TempItemVariant."Item No.");
                    ItemJournalLine.VALIDATE("Variant Code", TempItemVariant.Code);
                    ItemJournalLine.VALIDATE("Location Code", Loc);
                    Item2.GET(TempItemVariant."Item No.");
                    Item2.SETFILTER("Location Filter", Loc);
                    Item2.SETFILTER("Variant Filter", TempItemVariant.Code); //Stars03.00
                    Item2.CALCFIELDS(Item2."Net Change");
                    ItemJournalLine.VALIDATE("Qty. (Calculated)", Item2."Net Change");
                    ItemJournalLine.VALIDATE("Qty. (Phys. Inventory)", TempItemVariant.Length);
                    ItemJournalLine."Stars Updated from Handheld" := TRUE;
                    ItemJournalLine.MODIFY(TRUE);
                END;
                CounterL += 1;
                WinL.UPDATE(1, ROUND(CounterL / CountL * 10000, 1));
            UNTIL TempItemVariant.NEXT = 0;
            ItemJournalLine.SETRANGE("Item No.");
            ItemJournalLine.SETRANGE("Variant Code");
            WinL.CLOSE;
        END;

    end;

    PROCEDURE GetFileNameFromFullPath(FullPathName: Text[1024]): Code[20]
    var
        i: Integer;
        DotPos: Integer;
        BackSlashPos: Integer;
    begin
        DotPos := 0;
        BackSlashPos := 0;
        FOR i := STRLEN(FullPathName) DOWNTO 1
        DO BEGIN
            IF (FullPathName[i] = '.') AND (DotPos = 0) THEN
                DotPos := i;
            IF (FullPathName[i] = '\') AND (BackSlashPos = 0) THEN
                BackSlashPos := i + 1;
            IF (DotPos <> 0) AND (BackSlashPos <> 0) THEN
                EXIT(COPYSTR(FullPathName, BackSlashPos, DotPos - BackSlashPos));
        END;
        EXIT('');
    end;


    PROCEDURE GetIntFromBoolean(VAR BoolVar: Boolean): Integer
    var

    begin
        IF BoolVar THEN
            EXIT(1);
        EXIT(0);
    end;

    PROCEDURE ImportPOReceive(VAR PurchHeaderP: Record "Purchase Header")
    var
        InventorySetupL: Record "Inventory Setup";
        PurchLineL: Record "Purchase Line";
        TempItemVariant: Record "Item Unit of Measure" temporary;
        Item: Record Item;
        ImportScannedItems: XMLport "Stars Import Scanned Items";
        DPFileName: Text[250];
        QtyScnd: Decimal;
        RemQty: Decimal;
        NewQty: Decimal;
        Text001: Label 'Import Purchase Order @1@@@@@@@@@@';
    begin
        InventorySetupL.GET;

        ImportScannedItems.fGroupByOption(1);
        ImportScannedItems.RUN;
        ImportScannedItems.GetItemVariantTmpTable(TempItemVariant);
        DPFileName := GetFileNameFromFullPath(ImportScannedItems.FILENAME);
        CLEAR(ImportScannedItems);

        PurchLineL.RESET;
        PurchLineL.SETRANGE("Document Type", PurchLineL."Document Type"::Order);
        PurchLineL.SETRANGE("Document No.", PurchHeaderP."No.");

        IF PurchLineL.FIND('-') THEN
            REPEAT
                PurchLineL.VALIDATE("Qty. to Receive", 0);
                PurchLineL.MODIFY(TRUE);
            UNTIL PurchLineL.NEXT = 0;

        IF TempItemVariant.FIND('-') THEN BEGIN
            Win.OPEN(Text001);
            C := 0;
            Cnt := TempItemVariant.COUNT;
            REPEAT
                QtyScnd := TempItemVariant.Length;

                PurchLineL.SETRANGE("No.", TempItemVariant."Item No.");
                PurchLineL.SETRANGE("Variant Code", TempItemVariant.Code);
                IF PurchLineL.FIND('-') THEN
                    REPEAT
                        RemQty := PurchLineL."Quantity (Base)" - PurchLineL."Qty. Received (Base)";
                        IF QtyScnd > RemQty THEN
                            NewQty := RemQty
                        ELSE
                            NewQty := QtyScnd;
                        PurchLineL.VALIDATE("Qty. to Receive", NewQty / PurchLineL."Qty. per Unit of Measure");
                        PurchLineL.MODIFY(TRUE);
                        QtyScnd := QtyScnd - NewQty;
                    UNTIL (PurchLineL.NEXT = 0) OR (QtyScnd <= 0);

                C := C + 1;
                Win.UPDATE(1, ROUND(C / Cnt * 10000, 1));
            UNTIL TempItemVariant.NEXT = 0;
            Win.CLOSE;
        END;
    end;

    PROCEDURE ImportTOReceipt(VAR TransferHeaderP: Record "Transfer Header")
    var
        InventorySetupL: Record "Inventory Setup";
        TransferLineL: Record "Transfer Line";
        TempItemVariant: Record "Item Unit of Measure" temporary;
        Item: Record Item;
        ImportScannedItems: XMLport "Stars Import Scanned Items";
        DPFileName: Text[250];
        QtyScnd: Decimal;
        RemQty: Decimal;
        NewQty: Decimal;
        Text001: Label 'Import Purchase Order @1@@@@@@@@@@';
    begin
        InventorySetupL.GET;

        ImportScannedItems.fGroupByOption(1);
        ImportScannedItems.RUN;
        ImportScannedItems.GetItemVariantTmpTable(TempItemVariant);
        DPFileName := GetFileNameFromFullPath(ImportScannedItems.FILENAME);
        CLEAR(ImportScannedItems);

        TransferLineL.RESET;
        TransferLineL.SETRANGE("Document No.", TransferHeaderP."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);

        IF TransferLineL.FIND('-') THEN
            REPEAT
                TransferLineL.VALIDATE("Qty. to Receive", 0);
                TransferLineL.MODIFY(TRUE);
            UNTIL TransferLineL.NEXT = 0;

        IF TempItemVariant.FIND('-') THEN BEGIN
            Win.OPEN(Text001);
            C := 0;
            Cnt := TempItemVariant.COUNT;
            REPEAT
                QtyScnd := TempItemVariant.Length;

                TransferLineL.SETRANGE("Item No.", TempItemVariant."Item No.");
                TransferLineL.SETRANGE("Variant Code", TempItemVariant.Code);
                IF TransferLineL.FIND('-') THEN
                    REPEAT
                        RemQty := TransferLineL."Qty. Shipped (Base)" - TransferLineL."Qty. Received (Base)";
                        IF QtyScnd > RemQty THEN
                            NewQty := RemQty
                        ELSE
                            NewQty := QtyScnd;
                        TransferLineL.VALIDATE("Qty. to Receive", NewQty / TransferLineL."Qty. per Unit of Measure");
                        TransferLineL.MODIFY(TRUE);
                        QtyScnd := QtyScnd - NewQty;
                    UNTIL (TransferLineL.NEXT = 0) OR (QtyScnd <= 0);

                C := C + 1;
                Win.UPDATE(1, ROUND(C / Cnt * 10000, 1));
            UNTIL TempItemVariant.NEXT = 0;
            Win.CLOSE;
        END;

    end;

    PROCEDURE ImportTOShipment(VAR TransferHeaderP: Record "Transfer Header")
    var
        InventorySetupL: Record "Inventory Setup";
        TransferLineL: Record "Transfer Line";
        TempItemVariant: Record "Item Unit of Measure" temporary;
        Item: Record Item;
        ImportScannedItems: XMLport "Stars Import Scanned Items";
        DPFileName: Text[250];
        QtyScnd: Decimal;
        RemQty: Decimal;
        NewQty: Decimal;
        Text001: Label 'Import Purchase Order @1@@@@@@@@@@';
    begin
        InventorySetupL.GET;

        ImportScannedItems.fGroupByOption(1);
        ImportScannedItems.RUN;
        ImportScannedItems.GetItemVariantTmpTable(TempItemVariant);
        DPFileName := GetFileNameFromFullPath(ImportScannedItems.FILENAME);
        CLEAR(ImportScannedItems);

        TransferLineL.RESET;
        TransferLineL.SETRANGE("Document No.", TransferHeaderP."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);

        IF TransferLineL.FIND('-') THEN
            REPEAT
                TransferLineL.VALIDATE("Qty. to Ship", 0);
                TransferLineL.MODIFY(TRUE);
            UNTIL TransferLineL.NEXT = 0;

        IF TempItemVariant.FIND('-') THEN BEGIN
            Win.OPEN(Text001);
            C := 0;
            Cnt := TempItemVariant.COUNT;
            REPEAT
                QtyScnd := TempItemVariant.Length;

                TransferLineL.SETRANGE("Item No.", TempItemVariant."Item No.");
                TransferLineL.SETRANGE("Variant Code", TempItemVariant.Code);
                IF TransferLineL.FIND('-') THEN
                    REPEAT
                        RemQty := TransferLineL."Quantity (Base)" - TransferLineL."Qty. Shipped (Base)";
                        IF QtyScnd > RemQty THEN
                            NewQty := RemQty
                        ELSE
                            NewQty := QtyScnd;
                        TransferLineL.VALIDATE("Qty. to Ship", NewQty / TransferLineL."Qty. per Unit of Measure");
                        TransferLineL.MODIFY(TRUE);
                        QtyScnd := QtyScnd - NewQty;
                    UNTIL (TransferLineL.NEXT = 0) OR (QtyScnd <= 0);

                C := C + 1;
                Win.UPDATE(1, ROUND(C / Cnt * 10000, 1));
            UNTIL TempItemVariant.NEXT = 0;
            Win.CLOSE;
        END;
    end;

    PROCEDURE GetSessions(VAR JournalTemplateName_p: Code[10]; JournalBatchName_p: Code[10]; DocumentNo_p: Code[20]; UserID_p: Code[50]; LocationCode_p: Code[10]; Processed_p: Boolean)
    var
        HandheldDistinct_l: Query "Stars Handheld Distinct";
        HandheldSessions_l: Record "Stars HandHeld Sessions";
    begin
        HandheldSessions_l.DELETEALL;
        HandheldDistinct_l.SETRANGE(HandheldDistinct_l.Journal_Template_Name, JournalTemplateName_p);
        HandheldDistinct_l.SETRANGE(HandheldDistinct_l.Journal_Batch_Name, JournalBatchName_p);
        //HandheldDistinct_l.SETRANGE(HandheldDistinct_l.Document_No,DocumentNo_p);
        HandheldDistinct_l.SETRANGE(HandheldDistinct_l.Deleted, FALSE);
        HandheldDistinct_l.SETRANGE(HandheldDistinct_l.Location_Code, LocationCode_p);
        HandheldDistinct_l.SETRANGE(Processed, Processed_p);
        HandheldDistinct_l.OPEN;
        WHILE HandheldDistinct_l.READ DO BEGIN
            HandheldSessions_l."Journal Template Name" := HandheldDistinct_l.Journal_Template_Name;
            HandheldSessions_l."Journal Batch Name" := HandheldDistinct_l.Journal_Batch_Name;
            //HandheldSessions_l."Document No." := HandheldDistinct_l.Document_No;
            HandheldSessions_l."Phys. Inv. Session" := HandheldDistinct_l.Phys_Inv_Session;
            HandheldSessions_l."Location Code" := HandheldDistinct_l.Location_Code;
            HandheldSessions_l."Scanned By" := HandheldDistinct_l.User_ID;
            HandheldSessions_l."Line Count" := HandheldDistinct_l.Count_;
            HandheldSessions_l."User ID" := UserID_p;
            IF NOT HandheldSessions_l.GET(HandheldDistinct_l.Journal_Template_Name, HandheldDistinct_l.Journal_Batch_Name, DocumentNo_p, HandheldDistinct_l.Phys_Inv_Session, UserID_p, LocationCode_p) THEN
                HandheldSessions_l.INSERT;
        END;
        HandheldDistinct_l.CLOSE;
    end;

    PROCEDURE DeleteSessions(): Boolean
    var
        HandheldSessions_l: Record "Stars HandHeld Sessions";
        SessionsText_l: Text[250];
        HandheldScan_l: Record "Stars HandHeld Scan";
        Text001L: Label 'Are you sure you want to delete the selected sessions?';
        Text002L: Label 'Please select line first!';
    begin
        HandheldSessions_l.RESET;
        HandheldSessions_l.SETRANGE("User ID", USERID);
        HandheldSessions_l.SETRANGE("Mark Session", TRUE);
        IF HandheldSessions_l.FINDFIRST THEN BEGIN
            //REPEAT
            //IF SessionsText_l = '' THEN
            //SessionsText_l := HandheldSessions_l."Phys. Inv. Session"
            //ELSE
            //SessionsText_l := SessionsText_l + ', ' + HandheldSessions_l."Phys. Inv. Session";    
            //UNTIL HandheldSessions_l.NEXT = 0; 
            IF CONFIRM(Text001L, TRUE) THEN BEGIN
                HandheldSessions_l.RESET;
                HandheldSessions_l.SETRANGE("User ID", USERID);
                HandheldSessions_l.SETRANGE(HandheldSessions_l."Mark Session", TRUE);
                IF HandheldSessions_l.FINDFIRST THEN BEGIN
                    REPEAT
                        HandheldScan_l.SETRANGE("Journal Template Name", HandheldSessions_l."Journal Template Name");
                        HandheldScan_l.SETRANGE("Journal Batch Name", HandheldSessions_l."Journal Batch Name");
                        //HandheldScan_l.SETRANGE("Document No.",HandheldSessions_l."Document No.");
                        HandheldScan_l.SETRANGE("Phys. Inv. Session", HandheldSessions_l."Phys. Inv. Session");
                        HandheldScan_l.SETRANGE("Location Code", HandheldSessions_l."Location Code");
                        HandheldScan_l.SETRANGE("User ID", HandheldSessions_l."Scanned By");
                        HandheldScan_l.VALIDATE(Deleted, TRUE);
                        HandheldScan_l.MODIFYALL("Delete By", USERID);
                        HandheldScan_l.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
                        HandheldScan_l.MODIFYALL(Deleted, TRUE, TRUE);
                    UNTIL HandheldSessions_l.NEXT = 0;
                    HandheldSessions_l.RESET;
                    HandheldSessions_l.SETRANGE("User ID", USERID);
                    HandheldSessions_l.DELETEALL;
                    EXIT(TRUE);
                END;
            END;
        END ELSE BEGIN
            ERROR(Text002L);
        END;
    end;

    PROCEDURE UnprocessSessions(): Boolean
    var
        HandheldSessions_l: Record "Stars HandHeld Sessions";
        SessionsText_l: Text[250];
        HandheldScan_l: Record "Stars HandHeld Scan";
        Text001L: Label 'Are you sure you want to unprocess the selected sessions?';
        Text002L: Label 'Please select line first!';
    begin
        HandheldSessions_l.RESET;
        HandheldSessions_l.SETRANGE("User ID", USERID);
        HandheldSessions_l.SETRANGE("Mark Session", TRUE);
        IF HandheldSessions_l.FINDFIRST THEN BEGIN
            //REPEAT
            //IF SessionsText_l = '' THEN
            //SessionsText_l := HandheldSessions_l."Phys. Inv. Session"
            //ELSE
            //SessionsText_l := SessionsText_l + ', ' + HandheldSessions_l."Phys. Inv. Session";    
            //UNTIL HandheldSessions_l.NEXT = 0; 
            IF CONFIRM(Text001L, TRUE) THEN BEGIN
                HandheldSessions_l.RESET;
                HandheldSessions_l.SETRANGE("User ID", USERID);
                HandheldSessions_l.SETRANGE(HandheldSessions_l."Mark Session", TRUE);
                IF HandheldSessions_l.FINDFIRST THEN BEGIN
                    REPEAT
                        HandheldScan_l.SETRANGE("Journal Template Name", HandheldSessions_l."Journal Template Name");
                        HandheldScan_l.SETRANGE("Journal Batch Name", HandheldSessions_l."Journal Batch Name");
                        //HandheldScan_l.SETRANGE("Document No.",HandheldSessions_l."Document No.");
                        HandheldScan_l.SETRANGE("Phys. Inv. Session", HandheldSessions_l."Phys. Inv. Session");
                        HandheldScan_l.SETRANGE("Location Code", HandheldSessions_l."Location Code");
                        HandheldScan_l.SETRANGE("User ID", HandheldSessions_l."Scanned By");
                        HandheldScan_l.VALIDATE(Processed, FALSE);
                        HandheldScan_l.MODIFYALL("Processed By", USERID);
                        HandheldScan_l.MODIFYALL("Processed Date/Time", CURRENTDATETIME);
                        HandheldScan_l.MODIFYALL(Processed, FALSE, TRUE);
                    UNTIL HandheldSessions_l.NEXT = 0;
                    HandheldSessions_l.RESET;
                    HandheldSessions_l.SETRANGE("User ID", USERID);
                    HandheldSessions_l.DELETEALL;
                    EXIT(TRUE);
                END;
            END;
        END ELSE BEGIN
            ERROR(Text002L);
        END;
    end;

    PROCEDURE UpdateHandheldScanPhysInventory(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" TEMPORARY;
        HandheldTempTableExistsL: Boolean;
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Phys. Inventory Lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Phys. Inventory %1 %2.';
        ItemJournalLineToInsertL: Record "Item Journal Line";
        ItemL: Record Item;
        LineNo: Integer;
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETFILTER("Bin Code", '=%1', ''); //PhysInvBin
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, ItemJournalLineP."Journal Template Name", ItemJournalLineP."Journal Batch Name");

        //Zero phys. inventory lines
        ItemJournalLineL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        ItemJournalLineL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        IF ItemJournalLineL.FINDSET THEN
            REPEAT
                ItemJournalLineL.VALIDATE("Qty. (Phys. Inventory)", 0);
                ItemJournalLineL.MODIFY(TRUE)
            UNTIL ItemJournalLineL.NEXT = 0;

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse receipt lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to update the warehouse receipt lines
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL.Processed := TRUE;
            HandheldScanL."Processed By" := USERID;
            HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Loop through Scanned Items and update phys. inventory lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN



            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
                ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                IF ItemJournalLineL.FINDFIRST() THEN BEGIN
                    ItemJournalLineL.VALIDATE("Qty. (Phys. Inventory)", HandheldTempTableL."Quantity (Base)");
                    ItemJournalLineL."Stars Updated from Handheld" := TRUE;
                    ItemJournalLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    ItemJournalLineToInsertL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    IF ItemJournalLineToInsertL.FIND('+') THEN
                        LineNo := ItemJournalLineToInsertL."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    ItemJournalLineToInsertL.INIT;
                    ItemJournalLineToInsertL.VALIDATE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.VALIDATE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL."Location Code" := HandheldTempTableL."Location Code";//RS
                    ItemJournalLineToInsertL.INSERT(TRUE);
                    ItemJournalLineToInsertL.VALIDATE("Posting Date", ItemJournalLineP."Posting Date");
                    ItemJournalLineToInsertL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::"Positive Adjmt.");
                    ItemJournalLineToInsertL.VALIDATE("Document No.", ItemJournalLineP."Document No.");
                    ItemJournalLineToInsertL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    ItemJournalLineToInsertL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL.VALIDATE("Location Code", HandheldTempTableL."Location Code");

                    ItemL.GET(HandheldTempTableL."Item No.");
                    ItemL.SETFILTER("Location Filter", HandheldTempTableL."Location Code");
                    ItemL.SETFILTER("Variant Filter", HandheldTempTableL."Variant Code");
                    ItemL.CALCFIELDS(ItemL."Net Change");
                    ItemJournalLineToInsertL.VALIDATE("Qty. (Calculated)", ItemL."Net Change");
                    ItemJournalLineToInsertL.VALIDATE("Qty. (Phys. Inventory)", HandheldTempTableL."Quantity (Base)");
                    ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;
                    ItemJournalLineToInsertL."Stars Updated witht Calculated" := TRUE;
                    ItemJournalLineToInsertL.MODIFY(TRUE);
                END;

                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    PROCEDURE ShowScansPhysInventory(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        //HandheldScanL.SETRANGE("Location Code", ItemJournalLineP."Location Code");
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    PROCEDURE UpdateHandheldScanPhysInventoryWithBin(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" TEMPORARY;
        HandheldTempTableExistsL: Boolean;
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Phys. Inventory Lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Phys. Inventory %1 %2.';
        ItemJournalLineToInsertL: Record "Item Journal Line";
        ItemL: Record Item;
        LineNo: Integer;
        BinContent: Record "Bin Content";//MC
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETFILTER("Bin Code", '<>%1', '');
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, ItemJournalLineP."Journal Template Name", ItemJournalLineP."Journal Batch Name");

        //Zero phys. inventory lines
        ItemJournalLineL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        ItemJournalLineL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        IF ItemJournalLineL.FINDSET THEN
            REPEAT
                ItemJournalLineL.VALIDATE("Qty. (Phys. Inventory)", 0);
                ItemJournalLineL.MODIFY(TRUE)
            UNTIL ItemJournalLineL.NEXT = 0;

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse receipt lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableL.SetRange("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to update the warehouse receipt lines
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableL."Serial No. To" := HandheldScanL."Unit of Measure Code";
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL.Processed := TRUE;
            HandheldScanL."Processed By" := USERID;
            HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Loop through Scanned Items and update phys. inventory lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN



            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
                ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                ItemJournalLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
                IF ItemJournalLineL.FINDFIRST() THEN BEGIN
                    ItemJournalLineL.VALIDATE("Qty. (Phys. Inventory)", HandheldTempTableL."Quantity (Base)");
                    ItemJournalLineL."Stars Updated from Handheld" := TRUE;
                    ItemJournalLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    ItemJournalLineToInsertL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    IF ItemJournalLineToInsertL.FIND('+') THEN
                        LineNo := ItemJournalLineToInsertL."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    ItemJournalLineToInsertL.INIT;
                    ItemJournalLineToInsertL.VALIDATE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.VALIDATE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL."Location Code" := HandheldTempTableL."Location Code";//RS
                    ItemJournalLineToInsertL.INSERT(TRUE);
                    ItemJournalLineToInsertL.VALIDATE("Posting Date", ItemJournalLineP."Posting Date");
                    ItemJournalLineToInsertL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::"Positive Adjmt.");
                    ItemJournalLineToInsertL.VALIDATE("Document No.", ItemJournalLineP."Document No.");
                    ItemJournalLineToInsertL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    ItemJournalLineToInsertL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
                    ItemJournalLineToInsertL.VALIDATE("Bin Code", HandheldTempTableL."Bin Code");

                    // ItemL.GET(HandheldTempTableL."Item No.");
                    // ItemL.SETFILTER("Location Filter", HandheldTempTableL."Location Code");
                    // ItemL.SETFILTER("Variant Filter", HandheldTempTableL."Variant Code");
                    // iteml.SETFILTER("Bin Filter", HandheldTempTableL."Bin Code");
                    // ItemL.CALCFIELDS(ItemL."Net Change");
                    // ItemJournalLineToInsertL.VALIDATE("Qty. (Calculated)", ItemL."Net Change");
                    // ItemJournalLineToInsertL.VALIDATE("Qty. (Phys. Inventory)", HandheldTempTableL."Quantity (Base)");
                    // ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;
                    // ItemJournalLineToInsertL.MODIFY(TRUE);
                    BinContent.Reset();
                    If BinContent.Get(HandheldTempTableL."Location Code", HandheldTempTableL."Bin Code", HandheldTempTableL."Item No.", HandheldTempTableL."Variant Code", HandheldTempTableL."Serial No. To") then begin
                        BinContent.CalcFields("Quantity (Base)");
                        ItemJournalLineToInsertL.VALIDATE("Qty. (Calculated)", BinContent."Quantity (Base)");
                        ItemJournalLineToInsertL.VALIDATE("Qty. (Phys. Inventory)", HandheldTempTableL."Quantity (Base)");
                        ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;
                        ItemJournalLineToInsertL."Stars Updated witht Calculated" := TRUE;
                        ItemJournalLineToInsertL.MODIFY(TRUE);
                    end
                    else begin
                        ItemJournalLineToInsertL.VALIDATE("Qty. (Calculated)", 0);
                        ItemJournalLineToInsertL.VALIDATE("Qty. (Phys. Inventory)", HandheldTempTableL."Quantity (Base)");
                        ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;
                        ItemJournalLineToInsertL."Stars Updated witht Calculated" := TRUE;
                        ItemJournalLineToInsertL.MODIFY(TRUE);

                    end;



                END;

                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    PROCEDURE UpdateHandheldScanItemReclassBinToBin(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" TEMPORARY;
        HandheldTempTableExistsL: Boolean;
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Item Reclassification Lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Item Reclassification %1 %2.';
        ItemJournalLineToInsertL: Record "Item Journal Line";
        ItemL: Record Item;
        LineNo: Integer;
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclassification Bin To Bin");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETFILTER("Bin Code", '<>%1', '');
        HandheldScanL.SETFILTER("Bin Code To", '<>%1', '');
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, ItemJournalLineP."Journal Template Name", ItemJournalLineP."Journal Batch Name");

        //Zero phys. inventory lines
        ItemJournalLineL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        ItemJournalLineL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        IF ItemJournalLineL.FINDSET THEN
            REPEAT
                ItemJournalLineL.VALIDATE("Quantity", 0);
                ItemJournalLineL.MODIFY(TRUE)
             UNTIL ItemJournalLineL.NEXT = 0;

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse receipt lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableL.SetRange("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableL.SetRange("Bin Code To", HandheldScanL."Bin Code To");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to update the warehouse receipt lines
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableL."Bin Code To" := HandheldScanL."Bin Code To";
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL.Processed := TRUE;
            HandheldScanL."Processed By" := USERID;
            HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Loop through Scanned Items and update item reclass lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN



            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
                ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                ItemJournalLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
                ItemJournalLineL.SETRANGE("New Bin Code", HandheldTempTableL."Bin Code To");
                ItemJournalLineL.SETRANGE("New Location Code", HandheldTempTableL."Location Code");
                IF ItemJournalLineL.FINDFIRST() THEN BEGIN
                    ItemJournalLineL.VALIDATE("Quantity", HandheldTempTableL."Quantity");
                    ItemJournalLineL."Stars Updated from Handheld" := TRUE;
                    ItemJournalLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    ItemJournalLineToInsertL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    IF ItemJournalLineToInsertL.FIND('+') THEN
                        LineNo := ItemJournalLineToInsertL."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    ItemJournalLineToInsertL.INIT;
                    ItemJournalLineToInsertL.VALIDATE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.VALIDATE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL."Location Code" := HandheldTempTableL."Location Code";//RS
                    ItemJournalLineToInsertL.INSERT(TRUE);
                    ItemJournalLineToInsertL.VALIDATE("Posting Date", ItemJournalLineP."Posting Date");
                    ItemJournalLineToInsertL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::Transfer);
                    ItemJournalLineToInsertL.VALIDATE("Document No.", ItemJournalLineP."Document No.");
                    ItemJournalLineToInsertL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    ItemJournalLineToInsertL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
                    ItemJournalLineToInsertL.VALIDATE("Bin Code", HandheldTempTableL."Bin Code");
                    ItemJournalLineToInsertL.VALIDATE("New Location Code", HandheldTempTableL."Location Code");
                    ItemJournalLineToInsertL.VALIDATE("New Bin Code", HandheldTempTableL."Bin Code To");

                    ItemL.GET(HandheldTempTableL."Item No.");
                    ItemL.SETFILTER("Location Filter", HandheldTempTableL."Location Code");
                    ItemL.SETFILTER("Variant Filter", HandheldTempTableL."Variant Code");
                    ItemL.CALCFIELDS(ItemL."Net Change");
                    ItemJournalLineToInsertL.VALIDATE("Quantity", HandheldTempTableL."Quantity");
                    ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;

                    ItemJournalTemplate.Get(ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.Validate("Source Code", ItemJournalTemplate."Source Code");

                    ItemJournalLineToInsertL.MODIFY(TRUE);
                END;

                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    PROCEDURE UpdateHandheldScanItemReclassPick(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" TEMPORARY;
        HandheldTempTableExistsL: Boolean;
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Item Reclassification Lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Item Reclassification %1 %2.';
        ItemJournalLineToInsertL: Record "Item Journal Line";
        ItemL: Record Item;
        LineNo: Integer;
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclass. Pick");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETFILTER("Bin Code", '<>%1', '');
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, ItemJournalLineP."Journal Template Name", ItemJournalLineP."Journal Batch Name");

        //Zero phys. inventory lines
        ItemJournalLineL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        ItemJournalLineL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        IF ItemJournalLineL.FINDSET THEN
            REPEAT
                ItemJournalLineL.VALIDATE("Quantity", 0);
                ItemJournalLineL.MODIFY(TRUE)
             UNTIL ItemJournalLineL.NEXT = 0;

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse receipt lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableL.SetRange("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to update the warehouse receipt lines
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableL."Location Code To" := HandheldScanL."Location Code To";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL.Processed := TRUE;
            HandheldScanL."Processed By" := USERID;
            HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Loop through Scanned Items and update item reclass lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN



            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
                ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                ItemJournalLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
                ItemJournalLineL.SETRANGE("New Location Code", HandheldTempTableL."Location Code To");
                IF ItemJournalLineL.FINDFIRST() THEN BEGIN
                    ItemJournalLineL.VALIDATE("Quantity", HandheldTempTableL."Quantity");
                    ItemJournalLineL."Stars Updated from Handheld" := TRUE;
                    ItemJournalLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    ItemJournalLineToInsertL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    IF ItemJournalLineToInsertL.FIND('+') THEN
                        LineNo := ItemJournalLineToInsertL."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    ItemJournalLineToInsertL.INIT;
                    ItemJournalLineToInsertL.VALIDATE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.VALIDATE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL."Location Code" := HandheldTempTableL."Location Code";//RS
                    ItemJournalLineToInsertL.INSERT(TRUE);
                    ItemJournalLineToInsertL.VALIDATE("Posting Date", ItemJournalLineP."Posting Date");
                    ItemJournalLineToInsertL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::Transfer);
                    ItemJournalLineToInsertL.VALIDATE("Document No.", ItemJournalLineP."Document No.");
                    ItemJournalLineToInsertL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    ItemJournalLineToInsertL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
                    ItemJournalLineToInsertL.VALIDATE("Bin Code", HandheldTempTableL."Bin Code");
                    ItemJournalLineToInsertL.VALIDATE("New Location Code", HandheldTempTableL."Location Code To");

                    ItemL.GET(HandheldTempTableL."Item No.");
                    ItemL.SETFILTER("Location Filter", HandheldTempTableL."Location Code");
                    ItemL.SETFILTER("Variant Filter", HandheldTempTableL."Variant Code");
                    ItemL.CALCFIELDS(ItemL."Net Change");
                    ItemJournalLineToInsertL.VALIDATE("Quantity", HandheldTempTableL."Quantity");
                    ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;

                    ItemJournalTemplate.Get(ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.Validate("Source Code", ItemJournalTemplate."Source Code");

                    ItemJournalLineToInsertL.MODIFY(TRUE);
                END;

                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    PROCEDURE UpdateHandheldScanItemReclassPutAway(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" TEMPORARY;
        HandheldTempTableExistsL: Boolean;
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Item Reclassification Lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Item Reclassification %1 %2.';
        ItemJournalLineToInsertL: Record "Item Journal Line";
        ItemL: Record Item;
        LineNo: Integer;
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclass. PutAway");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETFILTER("Bin Code To", '<>%1', '');
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, ItemJournalLineP."Journal Template Name", ItemJournalLineP."Journal Batch Name");

        //Zero phys. inventory lines
        ItemJournalLineL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        ItemJournalLineL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        IF ItemJournalLineL.FINDSET THEN
            REPEAT
                ItemJournalLineL.VALIDATE("Quantity", 0);
                ItemJournalLineL.MODIFY(TRUE)
             UNTIL ItemJournalLineL.NEXT = 0;

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse receipt lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableL.SetRange("Bin Code To", HandheldScanL."Bin Code To");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to update the warehouse receipt lines
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableL."Location Code To" := HandheldScanL."Location Code To";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL."Bin Code To" := HandheldScanL."Bin Code To";
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL.Processed := TRUE;
            HandheldScanL."Processed By" := USERID;
            HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Loop through Scanned Items and update item reclass lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN



            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
                ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                ItemJournalLineL.SETRANGE("New Bin Code", HandheldTempTableL."Bin Code To");
                ItemJournalLineL.SETRANGE("New Location Code", HandheldTempTableL."Location Code To");
                IF ItemJournalLineL.FINDFIRST() THEN BEGIN
                    ItemJournalLineL.VALIDATE("Quantity", HandheldTempTableL."Quantity");
                    ItemJournalLineL."Stars Updated from Handheld" := TRUE;
                    ItemJournalLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    ItemJournalLineToInsertL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    IF ItemJournalLineToInsertL.FIND('+') THEN
                        LineNo := ItemJournalLineToInsertL."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    ItemJournalLineToInsertL.INIT;
                    ItemJournalLineToInsertL.VALIDATE("Journal Template Name", ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.VALIDATE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL."Location Code" := HandheldTempTableL."Location Code";//RS
                    ItemJournalLineToInsertL.INSERT(TRUE);
                    ItemJournalLineToInsertL.VALIDATE("Posting Date", ItemJournalLineP."Posting Date");
                    ItemJournalLineToInsertL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::Transfer);
                    ItemJournalLineToInsertL.VALIDATE("Document No.", ItemJournalLineP."Document No.");
                    ItemJournalLineToInsertL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    ItemJournalLineToInsertL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    ItemJournalLineToInsertL.VALIDATE("Line No.", LineNo);
                    ItemJournalLineToInsertL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
                    ItemJournalLineToInsertL.VALIDATE("New Location Code", HandheldTempTableL."Location Code To");
                    ItemJournalLineToInsertL.VALIDATE("New Bin Code", HandheldTempTableL."Bin Code To");

                    ItemL.GET(HandheldTempTableL."Item No.");
                    ItemL.SETFILTER("Location Filter", HandheldTempTableL."Location Code");
                    ItemL.SETFILTER("Variant Filter", HandheldTempTableL."Variant Code");
                    ItemL.CALCFIELDS(ItemL."Net Change");
                    ItemJournalLineToInsertL.VALIDATE("Quantity", HandheldTempTableL."Quantity");
                    ItemJournalLineToInsertL."Stars Updated from Handheld" := TRUE;

                    ItemJournalTemplate.Get(ItemJournalLineP."Journal Template Name");
                    ItemJournalLineToInsertL.Validate("Source Code", ItemJournalTemplate."Source Code");

                    ItemJournalLineToInsertL.MODIFY(TRUE);
                END;

                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    PROCEDURE ShowScansItemReclassBinToBin(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclassification Bin To Bin");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    PROCEDURE ShowScansItemReclassPick(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclass. Pick");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    PROCEDURE ShowScansItemReclassPutAway(var ItemJournalLineP: Record "Item Journal Line"): Boolean
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclass. PutAway");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Deleted, FALSE);
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    var
        Win: Dialog;
        C: Integer;
        Cnt: Integer;
        Text001: Label 'Export Barcodes @1@@@@@@@@@@@@@';
        SETUP_FILE: Label 'Setup';
        BARCODE_FILE: Label 'Barcodes';
        INDEX_FILE: Label 'Index';
        FILE_EXTENTION: Label '.txt';
        FILE_SEPARATOR: Label '|';


}