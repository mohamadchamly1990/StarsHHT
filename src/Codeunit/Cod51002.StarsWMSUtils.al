codeunit 51002 "Stars WMS Utils"
{
    Access = internal;

    Permissions = TableData 27 = rimd,
                  TableData 32 = rimd,
                  TableData 82 = rimd,
                  TableData 83 = rimd,
                  TableData 233 = rimd,
                  TableData 337 = rimd,
                  TableData 6550 = rimd,
                  TableData 7302 = rimd,
                  TableData 7326 = rimd,
                  TableData 7327 = rimd,
                  TableData 7328 = rimd,
                  TableData 51000 = rimd,
                  TableData 51005 = rimd,
                  TableData 51004 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Creating documents from interface lines @1@@@@@@@@@@';

    //[Scope('OnPrem')]

    //Test Adv+
    // procedure UpdateHandheldScanWarehouseReceipt(WarehouseReceiptHeaderP: Record "Warehouse Receipt Header")
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableExistsL: Boolean;
    //     HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableResEntryExistsL: Boolean;
    //     WarehouseReceiptLineL: Record "Warehouse Receipt Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     QtyScndL: Decimal;
    //     NewQtyL: Decimal;
    //     RemQtyL: Decimal;
    //     ReservationEntryL: Record "Reservation Entry";
    //     Text001L: Label 'Importing Warehouse Receipt Lines @1@@@@@@@@@@.';
    //     ReservationEntryNoL: Integer;
    //     ItemL: Record Item;
    //     Text002L: Label 'There are no Handheld Scan lines for Warehouse Receipt %1.';
    // begin
    //     GroupByOptionL := GroupByOptionL::"By Item/Variant";
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Warehouse Receipt");
    //     HandheldScanL.SETRANGE("Document No.", WarehouseReceiptHeaderP."No.");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L, WarehouseReceiptHeaderP."No.");

    //     //Zero Warehouse Receipt Lines Qty. to Receive
    //     WarehouseReceiptLineL.SETRANGE(WarehouseReceiptLineL."No.", WarehouseReceiptHeaderP."No.");
    //     IF WarehouseReceiptLineL.FINDSET(TRUE) THEN BEGIN
    //         REPEAT
    //             ReservationEntryL.SETRANGE("Location Code", WarehouseReceiptLineL."Location Code");
    //             ReservationEntryL.SETRANGE("Source Type", WarehouseReceiptLineL."Source Type");
    //             ReservationEntryL.SETRANGE("Source Subtype", WarehouseReceiptLineL."Source Subtype");
    //             ReservationEntryL.SETRANGE("Source ID", WarehouseReceiptLineL."Source No.");
    //             ReservationEntryL.SETRANGE("Source Ref. No.", WarehouseReceiptLineL."Source Line No.");
    //             ReservationEntryL.SETRANGE("Item No.", WarehouseReceiptLineL."Item No.");
    //             ReservationEntryL.SETRANGE("Variant Code", WarehouseReceiptLineL."Variant Code");
    //             ReservationEntryL.MODIFYALL("Quantity (Base)", 0, TRUE);
    //             WarehouseReceiptLineL.VALIDATE("Qty. to Receive", 0);
    //             WarehouseReceiptLineL.MODIFY(TRUE);
    //         UNTIL WarehouseReceiptLineL.NEXT() = 0
    //     END;

    //     REPEAT
    //         //Check if the line should be grouped
    //         //HandheldTempTableLoc is used to update the warehouse receipt lines
    //         HandheldTempTableL.RESET();
    //         HandheldTempTableExistsL := FALSE;
    //         IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //             HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //             HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
    //         END ELSE BEGIN
    //             HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //             HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //             HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
    //         END;

    //         //Check if the line should be grouped
    //         //HandheldTempTableL is used to update the warehouse receipt lines
    //         IF HandheldTempTableExistsL THEN BEGIN
    //             HandheldTempTableL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableL.INIT();
    //             HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.INSERT();
    //         END;

    //         //Check if the line should be grouped again this time by SerialNo & LotNo
    //         //HandheldTempTableResEntryL is used to update the reservation entries
    //         IF ((HandheldScanL."Lot No." <> '') OR (HandheldScanL."Serial No." <> '') OR
    //           (HandheldScanL.Expiry <> 0D)) THEN BEGIN
    //             HandheldTempTableResEntryL.RESET();
    //             HandheldTempTableResEntryExistsL := FALSE;
    //             IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //                 HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //                 HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //                 HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //             END ELSE BEGIN
    //                 HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //                 HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //                 HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //                 HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //             END;

    //             IF HandheldTempTableResEntryExistsL THEN BEGIN
    //                 HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
    //                 HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //                 HandheldTempTableResEntryL.MODIFY();
    //             END ELSE BEGIN
    //                 HandheldTempTableResEntryL.INIT();
    //                 HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
    //                 HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
    //                 HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
    //                 HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
    //                 HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
    //                 HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
    //                 HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
    //                 HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //                 HandheldTempTableResEntryL.INSERT();
    //             END;
    //         END;
    //         //Set Handheld Scans as processed
    //         HandheldScanL.Processed := TRUE;
    //         HandheldScanL."Processed By" := USERID;
    //         HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
    //         HandheldScanL.MODIFY(TRUE);
    //     UNTIL HandheldScanL.NEXT() = 0;

    //     //Now that we have the lines from the temp table grouped in two temp tables
    //     //We can start the import process

    //     //Loop through Scanned Items and Update Warehouse Receipt Lines
    //     HandheldTempTableL.RESET();
    //     IF HandheldTempTableL.FINDSET() THEN BEGIN
    //         WinL.OPEN(Text001L);
    //         LineNumberL := 0;
    //         LineCountL := HandheldTempTableL.COUNT;
    //         REPEAT
    //             QtyScndL := HandheldTempTableL."Quantity (Base)";
    //             WarehouseReceiptLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
    //             WarehouseReceiptLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
    //             IF WarehouseReceiptLineL.FINDSET(TRUE) THEN
    //                 REPEAT
    //                     RemQtyL := WarehouseReceiptLineL."Qty. (Base)" - WarehouseReceiptLineL."Qty. Received (Base)";
    //                     IF QtyScndL > RemQtyL THEN
    //                         NewQtyL := RemQtyL
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     WarehouseReceiptLineL.VALIDATE("Qty. to Receive", NewQtyL / WarehouseReceiptLineL."Qty. per Unit of Measure");
    //                     WarehouseReceiptLineL.MODIFY(TRUE);
    //                     QtyScndL := QtyScndL - NewQtyL;
    //                 UNTIL (WarehouseReceiptLineL.NEXT = 0) OR (QtyScndL <= 0);
    //             LineNumberL += 1;
    //             WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //         UNTIL HandheldTempTableL.NEXT = 0;
    //         WinL.CLOSE;
    //     END;

    //     //Create Reservation Entries
    //     HandheldTempTableResEntryL.RESET();
    //     QtyScndL := 0;
    //     WarehouseReceiptLineL.RESET;
    //     WarehouseReceiptLineL.SETRANGE("No.", WarehouseReceiptHeaderP."No.");
    //     IF WarehouseReceiptLineL.FINDSET(TRUE) THEN BEGIN
    //         REPEAT
    //             QtyScndL := WarehouseReceiptLineL."Qty. to Receive (Base)";
    //             HandheldTempTableResEntryL.SETRANGE("Item No.", WarehouseReceiptLineL."Item No.");
    //             HandheldTempTableResEntryL.SETRANGE("Variant Code", WarehouseReceiptLineL."Variant Code");
    //             HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
    //             IF HandheldTempTableResEntryL.FINDSET(TRUE) THEN BEGIN
    //                 REPEAT
    //                     IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
    //                         NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     QtyScndL := QtyScndL - NewQtyL;

    //                     ReservationEntryL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
    //                     ReservationEntryL.SETRANGE("Variant Code", HandheldTempTableResEntryL."Variant Code");
    //                     ReservationEntryL.SETRANGE("Location Code", WarehouseReceiptLineL."Location Code");
    //                     ReservationEntryL.SETRANGE("Source Type", WarehouseReceiptLineL."Source Type");
    //                     ReservationEntryL.SETRANGE("Source Subtype", WarehouseReceiptLineL."Source Subtype");
    //                     ReservationEntryL.SETRANGE("Source ID", WarehouseReceiptLineL."Source No.");
    //                     ReservationEntryL.SETRANGE("Source Ref. No.", WarehouseReceiptLineL."Source Line No.");
    //                     ReservationEntryL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
    //                     ReservationEntryL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
    //                     ReservationEntryL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
    //                     IF ReservationEntryL.FINDFIRST THEN BEGIN
    //                         ReservationEntryL."Quantity (Base)" += NewQtyL;
    //                         ReservationEntryL.Quantity += NewQtyL / WarehouseReceiptLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL.MODIFY;
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END ELSE BEGIN
    //                         CLEAR(ReservationEntryL);
    //                         IF ReservationEntryL.FINDLAST() THEN
    //                             ReservationEntryNoL := ReservationEntryL."Entry No." + 1
    //                         ELSE
    //                             ReservationEntryNoL := 1;
    //                         CLEAR(ReservationEntryL);
    //                         ReservationEntryL.INIT;
    //                         ReservationEntryL."Entry No." := ReservationEntryNoL;
    //                         ReservationEntryL.Positive := TRUE;
    //                         ReservationEntryL."Item No." := HandheldTempTableResEntryL."Item No.";
    //                         ReservationEntryL."Location Code" := WarehouseReceiptLineL."Location Code";
    //                         ReservationEntryL."Quantity (Base)" := NewQtyL;
    //                         ReservationEntryL."Reservation Status" := ReservationEntryL."Reservation Status"::Surplus;
    //                         IF ItemL.GET(ReservationEntryL."Item No.") THEN BEGIN
    //                             ReservationEntryL.Description := ItemL.Description;
    //                         END;
    //                         ReservationEntryL."Creation Date" := WORKDATE;
    //                         ReservationEntryL."Source Type" := WarehouseReceiptLineL."Source Type";
    //                         ReservationEntryL."Source Subtype" := WarehouseReceiptLineL."Source Subtype";
    //                         ReservationEntryL."Source ID" := WarehouseReceiptLineL."Source No.";
    //                         ReservationEntryL."Source Ref. No." := WarehouseReceiptLineL."Source Line No.";
    //                         ReservationEntryL."Expected Receipt Date" := WarehouseReceiptLineL."Due Date";
    //                         ReservationEntryL."Variant Code" := WarehouseReceiptLineL."Variant Code";
    //                         ReservationEntryL."Created By" := USERID;
    //                         ReservationEntryL."Qty. per Unit of Measure" := WarehouseReceiptLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL.Quantity := NewQtyL / WarehouseReceiptLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
    //                         IF ((HandheldTempTableResEntryL."Serial No." <> '') AND (HandheldTempTableResEntryL."Lot No." <> '')) THEN
    //                             ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot and Serial No."
    //                         ELSE
    //                             IF (HandheldTempTableResEntryL."Serial No." <> '') THEN
    //                                 ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Serial No."
    //                             ELSE
    //                                 IF (HandheldTempTableResEntryL."Lot No." <> '') THEN
    //                                     ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot No.";
    //                         ReservationEntryL."Serial No." := HandheldTempTableResEntryL."Serial No.";
    //                         ReservationEntryL."Lot No." := HandheldTempTableResEntryL."Lot No.";
    //                         ReservationEntryL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
    //                         ReservationEntryL.INSERT;
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END;
    //                 UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
    //             END;
    //         UNTIL WarehouseReceiptLineL.NEXT = 0;
    //     END;
    // end;

    procedure UpdateHandheldScanWarehouseReceipt(WarehouseReceiptHeaderP: Record "Warehouse Receipt Header")
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableResEntryExistsL: Boolean;
        WarehouseReceiptLineL: Record "Warehouse Receipt Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        QtyScndL: Decimal;
        NewQtyL: Decimal;
        RemQtyL: Decimal;
        ReservationEntryL: Record "Reservation Entry";
        Text001L: Label 'Importing Warehouse Receipt Lines @1@@@@@@@@@@.';
        ReservationEntryNoL: Integer;
        ItemL: Record Item;
        Text002L: Label 'There are no Handheld Scan lines for Warehouse Receipt %1.';
        HandheldScanL2: Record "Stars HandHeld Scan";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Warehouse Receipt");
        HandheldScanL.SETRANGE("Document No.", WarehouseReceiptHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        //HandheldScanL.SETRANGE("Over Receiving",FALSE);//Stars02.00
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, WarehouseReceiptHeaderP."No.");

        //Zero Warehouse Receipt Lines Qty. to Receive
        WarehouseReceiptLineL.SETRANGE(WarehouseReceiptLineL."No.", WarehouseReceiptHeaderP."No.");
        IF WarehouseReceiptLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                ReservationEntryL.SETRANGE("Location Code", WarehouseReceiptLineL."Location Code");
                ReservationEntryL.SETRANGE("Source Type", WarehouseReceiptLineL."Source Type");
                ReservationEntryL.SETRANGE("Source Subtype", WarehouseReceiptLineL."Source Subtype");
                ReservationEntryL.SETRANGE("Source ID", WarehouseReceiptLineL."Source No.");
                ReservationEntryL.SETRANGE("Source Ref. No.", WarehouseReceiptLineL."Source Line No.");
                ReservationEntryL.SETRANGE("Item No.", WarehouseReceiptLineL."Item No.");
                ReservationEntryL.SETRANGE("Variant Code", WarehouseReceiptLineL."Variant Code");
                ReservationEntryL.MODIFYALL("Quantity (Base)", 0, TRUE);
                WarehouseReceiptLineL.VALIDATE("Qty. to Receive", 0);
                WarehouseReceiptLineL.MODIFY(TRUE);
            UNTIL WarehouseReceiptLineL.NEXT() = 0
        END;

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse receipt lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
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
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL.INSERT();
            END;

            //Check if the line should be grouped again this time by SerialNo & LotNo
            //HandheldTempTableResEntryL is used to update the reservation entries
            IF ((HandheldScanL."Lot No." <> '') OR (HandheldScanL."Serial No." <> '') OR
              (HandheldScanL.Expiry <> 0D)) THEN BEGIN
                HandheldTempTableResEntryL.RESET();
                HandheldTempTableResEntryExistsL := FALSE;
                IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                    HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                    HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                    HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                    HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                    HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
                END ELSE BEGIN
                    HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
                    HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                    HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                    HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                    HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                    HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
                END;

                IF HandheldTempTableResEntryExistsL THEN BEGIN
                    HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
                    HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                    HandheldTempTableResEntryL.MODIFY();
                END ELSE BEGIN
                    HandheldTempTableResEntryL.INIT();
                    HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
                    HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
                    HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
                    HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
                    HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
                    HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
                    HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
                    HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                    HandheldTempTableResEntryL.INSERT();
                END;
            END;
            //Set Handheld Scans as processed
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.Processed := TRUE;
            HandheldScanL2."Processed By" := USERID;
            HandheldScanL2."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL2.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Now that we have the lines from the temp table grouped in two temp tables
        //We can start the import process

        //Loop through Scanned Items and Update Warehouse Receipt Lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN
            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                QtyScndL := HandheldTempTableL."Quantity (Base)";
                WarehouseReceiptLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                WarehouseReceiptLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                IF WarehouseReceiptLineL.FINDSET(TRUE) THEN
                    REPEAT
                        RemQtyL := WarehouseReceiptLineL."Qty. (Base)" - WarehouseReceiptLineL."Qty. Received (Base)";
                        IF QtyScndL > RemQtyL THEN
                            NewQtyL := RemQtyL
                        ELSE
                            NewQtyL := QtyScndL;
                        WarehouseReceiptLineL.VALIDATE("Qty. to Receive", NewQtyL / WarehouseReceiptLineL."Qty. per Unit of Measure");
                        WarehouseReceiptLineL.MODIFY(TRUE);
                        QtyScndL := QtyScndL - NewQtyL;
                    UNTIL (WarehouseReceiptLineL.NEXT = 0) OR (QtyScndL <= 0);
                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;

        //Create Reservation Entries
        HandheldTempTableResEntryL.RESET();
        QtyScndL := 0;
        WarehouseReceiptLineL.RESET;
        WarehouseReceiptLineL.SETRANGE("No.", WarehouseReceiptHeaderP."No.");
        IF WarehouseReceiptLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                QtyScndL := WarehouseReceiptLineL."Qty. to Receive (Base)";
                HandheldTempTableResEntryL.SETRANGE("Item No.", WarehouseReceiptLineL."Item No.");
                HandheldTempTableResEntryL.SETRANGE("Variant Code", WarehouseReceiptLineL."Variant Code");
                HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
                IF HandheldTempTableResEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
                            NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
                        ELSE
                            NewQtyL := QtyScndL;
                        QtyScndL := QtyScndL - NewQtyL;

                        ReservationEntryL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
                        ReservationEntryL.SETRANGE("Variant Code", HandheldTempTableResEntryL."Variant Code");
                        ReservationEntryL.SETRANGE("Location Code", WarehouseReceiptLineL."Location Code");
                        ReservationEntryL.SETRANGE("Source Type", WarehouseReceiptLineL."Source Type");
                        ReservationEntryL.SETRANGE("Source Subtype", WarehouseReceiptLineL."Source Subtype");
                        ReservationEntryL.SETRANGE("Source ID", WarehouseReceiptLineL."Source No.");
                        ReservationEntryL.SETRANGE("Source Ref. No.", WarehouseReceiptLineL."Source Line No.");
                        ReservationEntryL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
                        ReservationEntryL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
                        ReservationEntryL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
                        IF ReservationEntryL.FINDFIRST THEN BEGIN
                            ReservationEntryL."Quantity (Base)" += NewQtyL;
                            ReservationEntryL.Quantity += NewQtyL / WarehouseReceiptLineL."Qty. per Unit of Measure";
                            ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL.MODIFY;
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END ELSE BEGIN
                            CLEAR(ReservationEntryL);
                            IF ReservationEntryL.FINDLAST() THEN
                                ReservationEntryNoL := ReservationEntryL."Entry No." + 1
                            ELSE
                                ReservationEntryNoL := 1;
                            CLEAR(ReservationEntryL);
                            ReservationEntryL.INIT;
                            ReservationEntryL."Entry No." := ReservationEntryNoL;
                            ReservationEntryL.Positive := TRUE;
                            ReservationEntryL."Item No." := HandheldTempTableResEntryL."Item No.";
                            ReservationEntryL."Location Code" := WarehouseReceiptLineL."Location Code";
                            ReservationEntryL."Quantity (Base)" := NewQtyL;
                            ReservationEntryL."Reservation Status" := ReservationEntryL."Reservation Status"::Surplus;
                            IF ItemL.GET(ReservationEntryL."Item No.") THEN BEGIN
                                ReservationEntryL.Description := ItemL.Description;
                            END;
                            ReservationEntryL."Creation Date" := WORKDATE;
                            ReservationEntryL."Source Type" := WarehouseReceiptLineL."Source Type";
                            ReservationEntryL."Source Subtype" := WarehouseReceiptLineL."Source Subtype";
                            ReservationEntryL."Source ID" := WarehouseReceiptLineL."Source No.";
                            ReservationEntryL."Source Ref. No." := WarehouseReceiptLineL."Source Line No.";
                            ReservationEntryL."Expected Receipt Date" := WarehouseReceiptLineL."Due Date";
                            ReservationEntryL."Variant Code" := WarehouseReceiptLineL."Variant Code";
                            ReservationEntryL."Created By" := USERID;
                            ReservationEntryL."Qty. per Unit of Measure" := WarehouseReceiptLineL."Qty. per Unit of Measure";
                            ReservationEntryL.Quantity := NewQtyL / WarehouseReceiptLineL."Qty. per Unit of Measure";
                            ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
                            IF ((HandheldTempTableResEntryL."Serial No." <> '') AND (HandheldTempTableResEntryL."Lot No." <> '')) THEN
                                ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot and Serial No."
                            ELSE
                                IF (HandheldTempTableResEntryL."Serial No." <> '') THEN
                                    ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Serial No."
                                ELSE
                                    IF (HandheldTempTableResEntryL."Lot No." <> '') THEN
                                        ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot No.";
                            ReservationEntryL."Serial No." := HandheldTempTableResEntryL."Serial No.";
                            ReservationEntryL."Lot No." := HandheldTempTableResEntryL."Lot No.";
                            ReservationEntryL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
                            ReservationEntryL.INSERT;
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END;
                    UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
                END;
            UNTIL WarehouseReceiptLineL.NEXT = 0;
        END;
    end;

    //Test Adv-


    //Test Adv+

    // [Scope('OnPrem')]
    // procedure UpdateHandheldScanWarehouseShipment(WarehouseShipmentHeaderP: Record "Warehouse Shipment Header")
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     LocationL: Record Location;
    //     SkipResEntryCreationL: Boolean;
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableExistsL: Boolean;
    //     HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableResEntryExistsL: Boolean;
    //     WarehouseShipmentLineL: Record "Warehouse Shipment Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     QtyScndL: Decimal;
    //     NewQtyL: Decimal;
    //     RemQtyL: Decimal;
    //     ReservationEntryL: Record "Reservation Entry";
    //     Text001L: Label 'Importing Warehouse Shipment Lines @1@@@@@@@@@@.';
    //     ReservationEntryNoL: Integer;
    //     ItemL: Record Item;
    //     Text002L: Label 'There are no Handheld Scan lines for Warehouse Shipment %1.';
    // begin
    //     GroupByOptionL := GroupByOptionL::"By Item/Variant";
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Warehouse Shipment");
    //     HandheldScanL.SETRANGE("Document No.", WarehouseShipmentHeaderP."No.");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L, WarehouseShipmentHeaderP."No.");

    //     LocationL.GET(WarehouseShipmentHeaderP."Location Code");
    //     SkipResEntryCreationL := LocationL."Require Pick";

    //     //Zero Warehouse Shipment Lines Qty. to Ship
    //     WarehouseShipmentLineL.SETRANGE("No.", WarehouseShipmentHeaderP."No.");
    //     WarehouseShipmentLineL.MODIFYALL("Qty. to Ship", 0);

    //     REPEAT
    //         //Check if the line should be grouped
    //         //HandheldTempTableLoc is used to update the warehouse shipment lines
    //         HandheldTempTableL.RESET();
    //         HandheldTempTableExistsL := FALSE;
    //         IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //             HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //             HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
    //         END ELSE BEGIN
    //             HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //             HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //             HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
    //         END;

    //         //Check if the line should be grouped
    //         //HandheldTempTableL is used to update the warehouse shipment lines
    //         IF HandheldTempTableExistsL THEN BEGIN
    //             HandheldTempTableL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableL.INIT();
    //             HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.INSERT();
    //         END;

    //         //Check if the line should be grouped again this time by SerialNo & LotNo
    //         //HandheldTempTableResEntryL is used to update the reservation entries
    //         IF (NOT SkipResEntryCreationL) AND ((HandheldScanL."Lot No." <> '') OR (HandheldScanL."Serial No." <> '') OR
    //           (HandheldScanL.Expiry <> 0D)) THEN BEGIN
    //             HandheldTempTableResEntryL.RESET();
    //             HandheldTempTableResEntryExistsL := FALSE;
    //             IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //                 HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //                 HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //                 HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //             END ELSE BEGIN
    //                 HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //                 HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //                 HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //                 HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //                 HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //             END;

    //             IF HandheldTempTableResEntryExistsL THEN BEGIN
    //                 HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
    //                 HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //                 HandheldTempTableResEntryL.MODIFY();
    //             END ELSE BEGIN
    //                 HandheldTempTableResEntryL.INIT();
    //                 HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
    //                 HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
    //                 HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
    //                 HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
    //                 HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
    //                 HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
    //                 HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
    //                 HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //                 HandheldTempTableResEntryL.INSERT();
    //             END;
    //         END;
    //         //Set Handheld Scans as processed
    //         HandheldScanL.Processed := TRUE;
    //         HandheldScanL."Processed By" := USERID;
    //         HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
    //         HandheldScanL.MODIFY(TRUE);
    //     UNTIL HandheldScanL.NEXT() = 0;

    //     //Now that we have the lines from the temp table grouped in two temp tables
    //     //We can start the import process

    //     //Loop through Scanned Items and Update Warehouse Shipment Lines
    //     HandheldTempTableL.RESET();
    //     IF HandheldTempTableL.FINDSET() THEN BEGIN
    //         WinL.OPEN(Text001L);
    //         LineNumberL := 0;
    //         LineCountL := HandheldTempTableL.COUNT;
    //         REPEAT
    //             QtyScndL := HandheldTempTableL."Quantity (Base)";
    //             WarehouseShipmentLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
    //             WarehouseShipmentLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
    //             IF WarehouseShipmentLineL.FINDSET(TRUE) THEN
    //                 REPEAT
    //                     RemQtyL := WarehouseShipmentLineL."Qty. (Base)" - WarehouseShipmentLineL."Qty. Shipped (Base)";
    //                     IF QtyScndL > RemQtyL THEN
    //                         NewQtyL := RemQtyL
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     WarehouseShipmentLineL.VALIDATE("Qty. to Ship", NewQtyL / WarehouseShipmentLineL."Qty. per Unit of Measure");
    //                     WarehouseShipmentLineL.MODIFY(TRUE);
    //                     QtyScndL := QtyScndL - NewQtyL;
    //                 UNTIL (WarehouseShipmentLineL.NEXT = 0) OR (QtyScndL <= 0);
    //             LineNumberL += 1;
    //             WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //         UNTIL HandheldTempTableL.NEXT = 0;
    //         WinL.CLOSE;
    //     END;

    //     //Create Reservation Entries
    //     HandheldTempTableResEntryL.RESET();
    //     QtyScndL := 0;
    //     WarehouseShipmentLineL.RESET;
    //     WarehouseShipmentLineL.SETRANGE("No.", WarehouseShipmentHeaderP."No.");
    //     IF NOT SkipResEntryCreationL AND WarehouseShipmentLineL.FINDSET(TRUE) THEN BEGIN
    //         REPEAT
    //             QtyScndL := WarehouseShipmentLineL."Qty. to Ship (Base)";
    //             HandheldTempTableResEntryL.SETRANGE("Item No.", WarehouseShipmentLineL."Item No.");
    //             HandheldTempTableResEntryL.SETRANGE("Variant Code", WarehouseShipmentLineL."Variant Code");
    //             HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
    //             IF HandheldTempTableResEntryL.FINDSET(TRUE) THEN BEGIN
    //                 REPEAT
    //                     IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
    //                         NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     QtyScndL := QtyScndL - NewQtyL;

    //                     IF ReservationEntryL.FINDLAST() THEN
    //                         ReservationEntryNoL := ReservationEntryL."Entry No." + 1
    //                     ELSE
    //                         ReservationEntryNoL := 1;

    //                     ReservationEntryL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
    //                     ReservationEntryL.SETRANGE("Variant Code", HandheldTempTableResEntryL."Variant Code");
    //                     ReservationEntryL.SETRANGE("Location Code", WarehouseShipmentLineL."Location Code");
    //                     ReservationEntryL.SETRANGE("Source Type", WarehouseShipmentLineL."Source Type");
    //                     ReservationEntryL.SETRANGE("Source Subtype", WarehouseShipmentLineL."Source Subtype");
    //                     ReservationEntryL.SETRANGE("Source ID", WarehouseShipmentLineL."Source No.");
    //                     ReservationEntryL.SETRANGE("Source Ref. No.", WarehouseShipmentLineL."Source Line No.");
    //                     ReservationEntryL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
    //                     ReservationEntryL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
    //                     ReservationEntryL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
    //                     IF ReservationEntryL.FINDFIRST THEN BEGIN
    //                         ReservationEntryL."Quantity (Base)" += -NewQtyL;
    //                         ReservationEntryL.Quantity += -NewQtyL / WarehouseShipmentLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL.MODIFY;
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END ELSE BEGIN
    //                         ReservationEntryL.INIT;
    //                         ReservationEntryL."Entry No." := ReservationEntryNoL;
    //                         ReservationEntryL.Positive := FALSE;
    //                         ReservationEntryL."Item No." := HandheldTempTableResEntryL."Item No.";
    //                         ReservationEntryL."Variant Code" := WarehouseShipmentLineL."Variant Code";
    //                         ReservationEntryL."Location Code" := WarehouseShipmentLineL."Location Code";
    //                         ReservationEntryL."Reservation Status" := ReservationEntryL."Reservation Status"::Surplus;
    //                         IF ItemL.GET(ReservationEntryL."Item No.") THEN BEGIN
    //                             ReservationEntryL.Description := ItemL.Description;
    //                         END;
    //                         ReservationEntryL."Creation Date" := WORKDATE;
    //                         ReservationEntryL."Source Type" := WarehouseShipmentLineL."Source Type";
    //                         ReservationEntryL."Source Subtype" := WarehouseShipmentLineL."Source Subtype";
    //                         ReservationEntryL."Source ID" := WarehouseShipmentLineL."Source No.";
    //                         ReservationEntryL."Source Ref. No." := WarehouseShipmentLineL."Source Line No.";
    //                         ReservationEntryL."Shipment Date" := WarehouseShipmentLineL."Shipment Date";
    //                         ReservationEntryL."Created By" := USERID;
    //                         ReservationEntryL."Quantity (Base)" := -NewQtyL;
    //                         ReservationEntryL."Qty. per Unit of Measure" := WarehouseShipmentLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL.Quantity := -NewQtyL / WarehouseShipmentLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
    //                         IF ((HandheldTempTableResEntryL."Serial No." <> '') AND (HandheldTempTableResEntryL."Lot No." <> '')) THEN
    //                             ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot and Serial No."
    //                         ELSE
    //                             IF (HandheldTempTableResEntryL."Serial No." <> '') THEN
    //                                 ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Serial No."
    //                             ELSE
    //                                 IF (HandheldTempTableResEntryL."Lot No." <> '') THEN
    //                                     ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot No.";
    //                         ReservationEntryL."Lot No." := HandheldTempTableResEntryL."Lot No.";
    //                         ReservationEntryL."Serial No." := HandheldTempTableResEntryL."Serial No.";
    //                         ReservationEntryL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
    //                         ReservationEntryL.INSERT;
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END;
    //                 UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
    //             END;
    //         UNTIL WarehouseShipmentLineL.NEXT = 0;
    //     END;
    // end;

    procedure UpdateHandheldScanWarehouseShipment(WarehouseShipmentHeaderP: Record "Warehouse Shipment Header")
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        LocationL: Record Location;
        SkipResEntryCreationL: Boolean;
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableResEntryExistsL: Boolean;
        WarehouseShipmentLineL: Record "Warehouse Shipment Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        QtyScndL: Decimal;
        NewQtyL: Decimal;
        RemQtyL: Decimal;
        ReservationEntryL: Record "Reservation Entry";
        Text001L: Label 'Importing Warehouse Shipment Lines @1@@@@@@@@@@.';
        ReservationEntryNoL: Integer;
        ItemL: Record Item;
        Text002L: Label 'There are no Handheld Scan lines for Warehouse Shipment %1.';
        HandheldScanL2: Record "Stars HandHeld Scan";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Warehouse Shipment");
        HandheldScanL.SETRANGE("Document No.", WarehouseShipmentHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDFIRST THEN
            ERROR(Text002L, WarehouseShipmentHeaderP."No.");

        //Zero Warehouse Shipment Lines Qty. to Ship
        WarehouseShipmentLineL.SETRANGE("No.", WarehouseShipmentHeaderP."No.");

        //Stars03.00+
        IF WarehouseShipmentLineL.FINDSET THEN
            REPEAT
                WarehouseShipmentLineL.VALIDATE("Qty. to Ship", 0);
                WarehouseShipmentLineL.MODIFY(TRUE);
            UNTIL WarehouseShipmentLineL.NEXT = 0;
        //Stars03.00-
        //Stars03.00 WarehouseShipmentLineL.MODIFYALL("Qty. to Ship", 0);


        LocationL.GET(WarehouseShipmentHeaderP."Location Code");
        SkipResEntryCreationL := LocationL."Require Pick";

        REPEAT
            //Check if the line should be grouped
            //HandheldTempTableLoc is used to update the warehouse shipment lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to update the warehouse shipment lines
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL.INSERT();
            END;

            //Check if the line should be grouped again this time by SerialNo & LotNo
            //HandheldTempTableResEntryL is used to update the reservation entries
            IF (NOT SkipResEntryCreationL) AND ((HandheldScanL."Lot No." <> '') OR (HandheldScanL."Serial No." <> '') OR
              (HandheldScanL.Expiry <> 0D)) THEN BEGIN
                HandheldTempTableResEntryL.RESET();
                HandheldTempTableResEntryExistsL := FALSE;
                IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                    HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                    HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                    HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                    HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                    HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
                END ELSE BEGIN
                    HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
                    HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                    HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                    HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                    HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                    HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
                END;

                IF HandheldTempTableResEntryExistsL THEN BEGIN
                    HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
                    HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                    HandheldTempTableResEntryL.MODIFY();
                END ELSE BEGIN
                    HandheldTempTableResEntryL.INIT();
                    HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
                    HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
                    HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
                    HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
                    HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
                    HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
                    HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
                    HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                    HandheldTempTableResEntryL.INSERT();
                END;
            END;

            //Set Handheld Scans as processed
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.Processed := TRUE;
            HandheldScanL2."Processed By" := USERID;
            HandheldScanL2."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL2.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Now that we have the lines from the temp table grouped in two temp tables
        //We can start the import process

        //Loop through Scanned Items and Update Warehouse Shipment Lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN
            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                QtyScndL := HandheldTempTableL."Quantity (Base)";
                WarehouseShipmentLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                WarehouseShipmentLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                IF WarehouseShipmentLineL.FINDSET(TRUE) THEN
                    REPEAT

                        //Stars03.00+
                        IF SkipResEntryCreationL THEN
                            RemQtyL := WarehouseShipmentLineL."Qty. Picked (Base)" - WarehouseShipmentLineL."Qty. Shipped (Base)"
                        ELSE
                            //Stars03.00-

                            RemQtyL := WarehouseShipmentLineL."Qty. (Base)" - WarehouseShipmentLineL."Qty. Shipped (Base)";

                        IF QtyScndL > RemQtyL THEN
                            NewQtyL := RemQtyL
                        ELSE
                            NewQtyL := QtyScndL;
                        WarehouseShipmentLineL.VALIDATE("Qty. to Ship", NewQtyL / WarehouseShipmentLineL."Qty. per Unit of Measure");
                        WarehouseShipmentLineL.MODIFY(TRUE);
                        QtyScndL := QtyScndL - NewQtyL;
                    UNTIL (WarehouseShipmentLineL.NEXT = 0) OR (QtyScndL <= 0);
                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;

        //Create Reservation Entries
        HandheldTempTableResEntryL.RESET();
        QtyScndL := 0;
        WarehouseShipmentLineL.RESET;
        WarehouseShipmentLineL.SETRANGE("No.", WarehouseShipmentHeaderP."No.");
        IF NOT SkipResEntryCreationL AND WarehouseShipmentLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                QtyScndL := WarehouseShipmentLineL."Qty. to Ship (Base)";
                HandheldTempTableResEntryL.SETRANGE("Item No.", WarehouseShipmentLineL."Item No.");
                HandheldTempTableResEntryL.SETRANGE("Variant Code", WarehouseShipmentLineL."Variant Code");
                HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
                IF HandheldTempTableResEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
                            NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
                        ELSE
                            NewQtyL := QtyScndL;
                        QtyScndL := QtyScndL - NewQtyL;

                        IF ReservationEntryL.FINDLAST() THEN
                            ReservationEntryNoL := ReservationEntryL."Entry No." + 1
                        ELSE
                            ReservationEntryNoL := 1;

                        ReservationEntryL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
                        ReservationEntryL.SETRANGE("Variant Code", HandheldTempTableResEntryL."Variant Code");
                        ReservationEntryL.SETRANGE("Location Code", WarehouseShipmentLineL."Location Code");
                        ReservationEntryL.SETRANGE("Source Type", WarehouseShipmentLineL."Source Type");
                        ReservationEntryL.SETRANGE("Source Subtype", WarehouseShipmentLineL."Source Subtype");
                        ReservationEntryL.SETRANGE("Source ID", WarehouseShipmentLineL."Source No.");
                        ReservationEntryL.SETRANGE("Source Ref. No.", WarehouseShipmentLineL."Source Line No.");
                        ReservationEntryL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
                        ReservationEntryL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
                        ReservationEntryL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
                        IF ReservationEntryL.FINDFIRST THEN BEGIN
                            ReservationEntryL."Quantity (Base)" += -NewQtyL;
                            ReservationEntryL.Quantity += -NewQtyL / WarehouseShipmentLineL."Qty. per Unit of Measure";
                            ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL.MODIFY;
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END ELSE BEGIN
                            ReservationEntryL.INIT;
                            ReservationEntryL."Entry No." := ReservationEntryNoL;
                            ReservationEntryL.Positive := FALSE;
                            ReservationEntryL."Item No." := HandheldTempTableResEntryL."Item No.";
                            ReservationEntryL."Variant Code" := WarehouseShipmentLineL."Variant Code";
                            ReservationEntryL."Location Code" := WarehouseShipmentLineL."Location Code";
                            ReservationEntryL."Reservation Status" := ReservationEntryL."Reservation Status"::Surplus;
                            IF ItemL.GET(ReservationEntryL."Item No.") THEN BEGIN
                                ReservationEntryL.Description := ItemL.Description;
                            END;
                            ReservationEntryL."Creation Date" := WORKDATE;
                            ReservationEntryL."Source Type" := WarehouseShipmentLineL."Source Type";
                            ReservationEntryL."Source Subtype" := WarehouseShipmentLineL."Source Subtype";
                            ReservationEntryL."Source ID" := WarehouseShipmentLineL."Source No.";
                            ReservationEntryL."Source Ref. No." := WarehouseShipmentLineL."Source Line No.";
                            ReservationEntryL."Shipment Date" := WarehouseShipmentLineL."Shipment Date";
                            ReservationEntryL."Created By" := USERID;
                            ReservationEntryL."Quantity (Base)" := -NewQtyL;
                            ReservationEntryL."Qty. per Unit of Measure" := WarehouseShipmentLineL."Qty. per Unit of Measure";
                            ReservationEntryL.Quantity := -NewQtyL / WarehouseShipmentLineL."Qty. per Unit of Measure";
                            ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
                            IF ((HandheldTempTableResEntryL."Serial No." <> '') AND (HandheldTempTableResEntryL."Lot No." <> '')) THEN
                                ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot and Serial No."
                            ELSE
                                IF (HandheldTempTableResEntryL."Serial No." <> '') THEN
                                    ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Serial No."
                                ELSE
                                    IF (HandheldTempTableResEntryL."Lot No." <> '') THEN
                                        ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot No.";
                            ReservationEntryL."Lot No." := HandheldTempTableResEntryL."Lot No.";
                            ReservationEntryL."Serial No." := HandheldTempTableResEntryL."Serial No.";
                            ReservationEntryL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
                            ReservationEntryL.INSERT;
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END;
                    UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
                END;
            UNTIL WarehouseShipmentLineL.NEXT = 0;
        END;
    end;

    //Test Adv-

    //Test Adv+

    // [Scope('OnPrem')]
    // procedure CreateHandheldScanItemReclassifications()
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     UserBatchL: Record "Stars User Batch";
    //     ItemJournalTemplateL: Record "Item Journal Template";
    //     ItemJournalBatchL: Record "Item Journal Batch";
    //     HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableExistsL: Boolean;
    //     HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableResEntryExistsL: Boolean;
    //     LastItemJournalLineL: Record "Item Journal Line";
    //     ItemJournalLineL: Record "Item Journal Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     QtyScndL: Decimal;
    //     NewQtyL: Decimal;
    //     RemQtyL: Decimal;
    //     ReservationEntryL: Record "Reservation Entry";
    //     Text001L: Label 'Importing Item Reclassification Lines @1@@@@@@@@@@.';
    //     LastReservationEntryL: Integer;
    //     Text002L: Label 'There are no Handheld Scan lines for Item Reclassification.';
    //     DocumentNoL: Code[20];
    //     NoSeriesMgtCUL: Codeunit NoSeriesManagement;
    // begin
    //     GroupByOptionL := GroupByOptionL::"By Item/Variant";
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Create);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclassification");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L);

    //     REPEAT
    //         //Get User Batch by User, Type & Location
    //         UserBatchL.GET(USERID, UserBatchL.Type::Transfer, HandheldScanL."Location Code");

    //         ItemJournalTemplateL.GET(UserBatchL.Template);
    //         ItemJournalBatchL.GET(UserBatchL.Template, UserBatchL.Batch);

    //         //Check if the line should be grouped
    //         //HandheldTempTableL is used to create item reclassification lines
    //         HandheldTempTableL.RESET();
    //         HandheldTempTableExistsL := FALSE;
    //         IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //             HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //             HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
    //         END ELSE BEGIN
    //             HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //             HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //             HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
    //         END;

    //         //Check if the line should be grouped
    //         //HandheldTempTableL is used to create item reclassification lines
    //         IF HandheldTempTableExistsL THEN BEGIN
    //             HandheldTempTableL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableL.INIT();
    //             HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
    //             HandheldTempTableL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.INSERT();
    //         END;

    //         //Check if the line should be grouped again this time by "Serial No.", "Lot No." & "Lot No. To"
    //         //HandheldTempTableResEntryL is used to update the reservation entries
    //         HandheldTempTableResEntryL.RESET();
    //         HandheldTempTableResEntryExistsL := FALSE;
    //         IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //             HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //             HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //             HandheldTempTableResEntryL.SETRANGE("Lot No. To", HandheldScanL."Lot No. To");
    //             HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //             HandheldTempTableResEntryL.SETRANGE("Serial No. To", HandheldScanL."Serial No. To");
    //             HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //             HandheldTempTableResEntryL.SETRANGE("Expiry To", HandheldScanL."Expiry To");
    //             HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //         END ELSE BEGIN
    //             HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //             HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //             HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //             HandheldTempTableResEntryL.SETRANGE("Lot No. To", HandheldScanL."Lot No. To");
    //             HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //             HandheldTempTableResEntryL.SETRANGE("Serial No. To", HandheldScanL."Serial No. To");
    //             HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //             HandheldTempTableResEntryL.SETRANGE("Expiry To", HandheldScanL."Expiry To");
    //             HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //         END;

    //         IF HandheldTempTableResEntryExistsL THEN BEGIN
    //             HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableResEntryL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableResEntryL.INIT();
    //             HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableResEntryL."Location Code" := HandheldScanL."Location Code";
    //             HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
    //             HandheldTempTableResEntryL."Lot No. To" := HandheldScanL."Lot No. To";
    //             HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
    //             HandheldTempTableResEntryL."Serial No. To" := HandheldScanL."Serial No. To";
    //             HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
    //             HandheldTempTableResEntryL."Expiry To" := HandheldScanL."Expiry To";
    //             HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableResEntryL.INSERT();
    //         END;
    //         //Set Handheld Scans as processed
    //         HandheldScanL.Processed := TRUE;
    //         HandheldScanL."Processed By" := USERID;
    //         HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
    //         HandheldScanL.MODIFY(TRUE);
    //     UNTIL HandheldScanL.NEXT() = 0;

    //     //Now that we have the lines from the temp table grouped in two temp tables
    //     //We can start the import process

    //     LineNumberL := 0;
    //     LastItemJournalLineL.SETRANGE("Journal Template Name", UserBatchL.Template);
    //     LastItemJournalLineL.SETRANGE("Journal Batch Name", UserBatchL.Batch);
    //     IF LastItemJournalLineL.FINDLAST() THEN BEGIN
    //         LineNumberL := LastItemJournalLineL."Line No.";
    //         DocumentNoL := LastItemJournalLineL."Document No.";
    //     END ELSE BEGIN
    //         DocumentNoL := NoSeriesMgtCUL.GetNextNo(ItemJournalBatchL."No. Series", TODAY, FALSE);
    //     END;

    //     //Loop through Scanned Items and Create Item Journal Lines
    //     HandheldTempTableL.RESET();
    //     IF HandheldTempTableL.FINDSET() THEN BEGIN
    //         WinL.OPEN(Text001L);
    //         LineCountL := HandheldTempTableL.COUNT;
    //         REPEAT
    //             ItemJournalLineL.SETRANGE("Journal Template Name", UserBatchL.Template);
    //             ItemJournalLineL.SETRANGE("Journal Batch Name", UserBatchL.Batch);
    //             ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
    //             ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
    //             ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
    //             IF ItemJournalLineL.FINDFIRST() THEN BEGIN
    //                 ItemJournalLineL."Quantity (Base)" += HandheldTempTableL."Quantity (Base)";
    //                 ItemJournalLineL.MODIFY(TRUE);
    //             END ELSE BEGIN
    //                 LineNumberL += 10000;
    //                 ItemJournalLineL.INIT();
    //                 ItemJournalLineL.VALIDATE("Journal Template Name", UserBatchL.Template);
    //                 ItemJournalLineL.VALIDATE("Journal Batch Name", UserBatchL.Batch);
    //                 ItemJournalLineL.VALIDATE("Line No.", LineNumberL);
    //                 ItemJournalLineL.INSERT(TRUE);
    //                 ItemJournalLineL.VALIDATE("Document No.", DocumentNoL);
    //                 ItemJournalLineL.VALIDATE("Posting Date", TODAY);
    //                 ItemJournalLineL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::Transfer);
    //                 ItemJournalLineL.VALIDATE("Source Code", ItemJournalTemplateL."Source Code");
    //                 ItemJournalLineL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
    //                 ItemJournalLineL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
    //                 ItemJournalLineL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
    //                 ItemJournalLineL.VALIDATE("Quantity (Base)", HandheldTempTableL."Quantity (Base)");
    //                 ItemJournalLineL.MODIFY(TRUE);
    //             END;
    //             WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //         UNTIL HandheldTempTableL.NEXT = 0;
    //         WinL.CLOSE;
    //     END;

    //     //Create Reservation Entries
    //     HandheldTempTableResEntryL.RESET();
    //     QtyScndL := 0;
    //     LastReservationEntryL := 0;
    //     IF ReservationEntryL.FINDLAST() THEN
    //         LastReservationEntryL := ReservationEntryL."Entry No.";

    //     ItemJournalLineL.RESET;
    //     ItemJournalLineL.SETRANGE("Journal Template Name", UserBatchL.Template);
    //     ItemJournalLineL.SETRANGE("Journal Batch Name", UserBatchL.Batch);
    //     ItemJournalLineL.SETRANGE("Document No.", DocumentNoL);
    //     IF ItemJournalLineL.FINDSET() THEN BEGIN
    //         REPEAT
    //             QtyScndL := ItemJournalLineL."Quantity (Base)";
    //             HandheldTempTableResEntryL.SETRANGE("Location Code", ItemJournalLineL."Location Code");
    //             HandheldTempTableResEntryL.SETRANGE("Item No.", ItemJournalLineL."Item No.");
    //             HandheldTempTableResEntryL.SETRANGE("Variant Code", ItemJournalLineL."Variant Code");
    //             HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
    //             IF HandheldTempTableResEntryL.FINDSET() THEN BEGIN
    //                 REPEAT
    //                     IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
    //                         NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     QtyScndL := QtyScndL - NewQtyL;

    //                     ReservationEntryL.RESET();
    //                     ReservationEntryL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
    //                     ReservationEntryL.SETRANGE("Location Code", ItemJournalLineL."Location Code");
    //                     ReservationEntryL.SETRANGE("Variant Code", ItemJournalLineL."Variant Code");
    //                     ReservationEntryL.SETRANGE("Source Type", DATABASE::"Item Journal Line");
    //                     ReservationEntryL.SETRANGE("Source Subtype", ItemJournalLineL."Entry Type");
    //                     ReservationEntryL.SETRANGE("Source ID", ItemJournalBatchL."Journal Template Name");
    //                     ReservationEntryL.SETRANGE("Source Batch Name", ItemJournalBatchL.Name);
    //                     ReservationEntryL.SETRANGE("Source Ref. No.", ItemJournalLineL."Line No.");
    //                     ReservationEntryL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
    //                     ReservationEntryL.SETRANGE("New Lot No.", HandheldTempTableResEntryL."Lot No. To");
    //                     ReservationEntryL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
    //                     ReservationEntryL.SETRANGE("New Serial No.", HandheldTempTableResEntryL."Serial No. To");
    //                     ReservationEntryL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
    //                     ReservationEntryL.SETRANGE("New Expiration Date", HandheldTempTableResEntryL."Expiry To");
    //                     IF ReservationEntryL.FINDFIRST THEN BEGIN
    //                         ReservationEntryL."Quantity (Base)" += -NewQtyL;
    //                         ReservationEntryL.Quantity += -NewQtyL / ItemJournalLineL."Qty. per Unit of Measure";
    //                         ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
    //                         ReservationEntryL.MODIFY;
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END ELSE BEGIN
    //                         ReservationEntryL.INIT;
    //                         LastReservationEntryL += 1;
    //                         ReservationEntryL.VALIDATE("Entry No.", LastReservationEntryL);
    //                         ReservationEntryL.VALIDATE(Positive, FALSE);
    //                         ReservationEntryL.INSERT(TRUE);
    //                         ReservationEntryL.VALIDATE("Source Type", DATABASE::"Item Journal Line");
    //                         ReservationEntryL.VALIDATE("Source Subtype", ItemJournalLineL."Entry Type");
    //                         ReservationEntryL.VALIDATE("Source ID", ItemJournalBatchL."Journal Template Name");
    //                         ReservationEntryL.VALIDATE("Source Batch Name", ItemJournalBatchL.Name);
    //                         ReservationEntryL.VALIDATE("Source Ref. No.", ItemJournalLineL."Line No.");
    //                         ReservationEntryL.VALIDATE("Reservation Status", ReservationEntryL."Reservation Status"::Prospect);
    //                         ReservationEntryL.VALIDATE("Location Code", ItemJournalLineL."Location Code");
    //                         ReservationEntryL.VALIDATE("Item No.", ItemJournalLineL."Item No.");
    //                         ReservationEntryL.Description := ItemJournalLineL.Description;
    //                         ReservationEntryL.VALIDATE("Variant Code", ItemJournalLineL."Variant Code");
    //                         ReservationEntryL.VALIDATE("Quantity (Base)", -NewQtyL);
    //                         ReservationEntryL.VALIDATE("Qty. per Unit of Measure", ItemJournalLineL."Qty. per Unit of Measure");
    //                         IF ((HandheldTempTableResEntryL."Serial No." <> '') AND (HandheldTempTableResEntryL."Lot No." <> '')) THEN
    //                             ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot and Serial No."
    //                         ELSE
    //                             IF (HandheldTempTableResEntryL."Serial No." <> '') THEN
    //                                 ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Serial No."
    //                             ELSE
    //                                 IF (HandheldTempTableResEntryL."Lot No." <> '') THEN
    //                                     ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot No.";
    //                         ReservationEntryL."Serial No." := HandheldTempTableResEntryL."Serial No.";
    //                         ReservationEntryL."New Serial No." := HandheldTempTableResEntryL."Serial No. To";
    //                         ReservationEntryL."Lot No." := HandheldTempTableResEntryL."Lot No.";
    //                         ReservationEntryL."New Lot No." := HandheldTempTableResEntryL."Lot No. To";
    //                         ReservationEntryL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
    //                         ReservationEntryL."New Expiration Date" := HandheldTempTableResEntryL."Expiry To";
    //                         ReservationEntryL."Creation Date" := WORKDATE;
    //                         ReservationEntryL."Created By" := USERID;
    //                         ReservationEntryL.MODIFY(TRUE);
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END;
    //                 UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
    //             END;
    //         UNTIL (ItemJournalLineL.NEXT = 0);
    //     END;
    // end;

    procedure CreateHandheldScanItemReclassifications()
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        UserBatchL: Record "Stars HHT User Batch";
        ItemJournalTemplateL: Record "Item Journal Template";
        ItemJournalBatchL: Record "Item Journal Batch";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableResEntryExistsL: Boolean;
        LastItemJournalLineL: Record "Item Journal Line";
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        QtyScndL: Decimal;
        NewQtyL: Decimal;
        RemQtyL: Decimal;
        ReservationEntryL: Record "Reservation Entry";
        Text001L: Label 'Importing Item Reclassification Lines @1@@@@@@@@@@.';
        LastReservationEntryL: Integer;
        Text002L: Label 'There are no Handheld Scan lines for Item Reclassification.';
        DocumentNoL: Code[20];
        NoSeriesMgtCUL: Codeunit NoSeriesManagement;
        HandheldScanL2: Record "Stars HandHeld Scan";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Create);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclassification");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L);

        REPEAT
            //Get User Batch by User, Type & Location
            UserBatchL.GET(USERID, UserBatchL.Type::Transfer, HandheldScanL."Location Code");

            ItemJournalTemplateL.GET(UserBatchL.Template);
            ItemJournalBatchL.GET(UserBatchL.Template, UserBatchL.Batch);

            //Check if the line should be grouped
            //HandheldTempTableL is used to create item reclassification lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableExistsL := HandheldTempTableL.GET(HandheldScanL."Barcode No.");
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to create item reclassification lines
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

            //Check if the line should be grouped again this time by "Serial No.", "Lot No." & "Lot No. To"
            //HandheldTempTableResEntryL is used to update the reservation entries
            HandheldTempTableResEntryL.RESET();
            HandheldTempTableResEntryExistsL := FALSE;
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                HandheldTempTableResEntryL.SETRANGE("Lot No. To", HandheldScanL."Lot No. To");
                HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                HandheldTempTableResEntryL.SETRANGE("Serial No. To", HandheldScanL."Serial No. To");
                HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                HandheldTempTableResEntryL.SETRANGE("Expiry To", HandheldScanL."Expiry To");
                HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
            END ELSE BEGIN
                HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                HandheldTempTableResEntryL.SETRANGE("Lot No. To", HandheldScanL."Lot No. To");
                HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                HandheldTempTableResEntryL.SETRANGE("Serial No. To", HandheldScanL."Serial No. To");
                HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                HandheldTempTableResEntryL.SETRANGE("Expiry To", HandheldScanL."Expiry To");
                HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
            END;

            IF HandheldTempTableResEntryExistsL THEN BEGIN
                HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableResEntryL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableResEntryL.INIT();
                HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableResEntryL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
                HandheldTempTableResEntryL."Lot No. To" := HandheldScanL."Lot No. To";
                HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
                HandheldTempTableResEntryL."Serial No. To" := HandheldScanL."Serial No. To";
                HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
                HandheldTempTableResEntryL."Expiry To" := HandheldScanL."Expiry To";
                HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableResEntryL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.Processed := TRUE;
            HandheldScanL2."Processed By" := USERID;
            HandheldScanL2."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL2.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Now that we have the lines from the temp table grouped in two temp tables
        //We can start the import process

        LineNumberL := 0;
        LastItemJournalLineL.SETRANGE("Journal Template Name", UserBatchL.Template);
        LastItemJournalLineL.SETRANGE("Journal Batch Name", UserBatchL.Batch);
        IF LastItemJournalLineL.FINDLAST() THEN BEGIN
            LineNumberL := LastItemJournalLineL."Line No.";
            DocumentNoL := LastItemJournalLineL."Document No.";
        END ELSE BEGIN
            DocumentNoL := NoSeriesMgtCUL.GetNextNo(ItemJournalBatchL."No. Series", TODAY, FALSE);
        END;

        //Loop through Scanned Items and Create Item Journal Lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN
            WinL.OPEN(Text001L);
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                ItemJournalLineL.SETRANGE("Journal Template Name", UserBatchL.Template);
                ItemJournalLineL.SETRANGE("Journal Batch Name", UserBatchL.Batch);
                ItemJournalLineL.SETRANGE("Location Code", HandheldTempTableL."Location Code");
                ItemJournalLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                ItemJournalLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                IF ItemJournalLineL.FINDFIRST() THEN BEGIN
                    ItemJournalLineL."Quantity (Base)" += HandheldTempTableL."Quantity (Base)";
                    ItemJournalLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    LineNumberL += 10000;
                    ItemJournalLineL.INIT();
                    ItemJournalLineL.VALIDATE("Journal Template Name", UserBatchL.Template);
                    ItemJournalLineL.VALIDATE("Journal Batch Name", UserBatchL.Batch);
                    ItemJournalLineL.VALIDATE("Line No.", LineNumberL);
                    ItemJournalLineL.INSERT(TRUE);
                    ItemJournalLineL.VALIDATE("Document No.", DocumentNoL);
                    ItemJournalLineL.VALIDATE("Posting Date", TODAY);
                    ItemJournalLineL.VALIDATE("Entry Type", ItemJournalLineL."Entry Type"::Transfer);
                    ItemJournalLineL.VALIDATE("Source Code", ItemJournalTemplateL."Source Code");
                    ItemJournalLineL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    ItemJournalLineL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    ItemJournalLineL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
                    ItemJournalLineL.VALIDATE("Quantity (Base)", HandheldTempTableL."Quantity (Base)");
                    ItemJournalLineL.MODIFY(TRUE);
                END;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;

        //Create Reservation Entries
        HandheldTempTableResEntryL.RESET();
        QtyScndL := 0;
        LastReservationEntryL := 0;
        IF ReservationEntryL.FINDLAST() THEN
            LastReservationEntryL := ReservationEntryL."Entry No.";

        ItemJournalLineL.RESET;
        ItemJournalLineL.SETRANGE("Journal Template Name", UserBatchL.Template);
        ItemJournalLineL.SETRANGE("Journal Batch Name", UserBatchL.Batch);
        ItemJournalLineL.SETRANGE("Document No.", DocumentNoL);
        IF ItemJournalLineL.FINDSET() THEN BEGIN
            REPEAT
                QtyScndL := ItemJournalLineL."Quantity (Base)";
                HandheldTempTableResEntryL.SETRANGE("Location Code", ItemJournalLineL."Location Code");
                HandheldTempTableResEntryL.SETRANGE("Item No.", ItemJournalLineL."Item No.");
                HandheldTempTableResEntryL.SETRANGE("Variant Code", ItemJournalLineL."Variant Code");
                HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
                IF HandheldTempTableResEntryL.FINDSET() THEN BEGIN
                    REPEAT
                        IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
                            NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
                        ELSE
                            NewQtyL := QtyScndL;
                        QtyScndL := QtyScndL - NewQtyL;

                        ReservationEntryL.RESET();
                        ReservationEntryL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
                        ReservationEntryL.SETRANGE("Location Code", ItemJournalLineL."Location Code");
                        ReservationEntryL.SETRANGE("Variant Code", ItemJournalLineL."Variant Code");
                        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Item Journal Line");
                        ReservationEntryL.SETRANGE("Source Subtype", ItemJournalLineL."Entry Type");
                        ReservationEntryL.SETRANGE("Source ID", ItemJournalBatchL."Journal Template Name");
                        ReservationEntryL.SETRANGE("Source Batch Name", ItemJournalBatchL.Name);
                        ReservationEntryL.SETRANGE("Source Ref. No.", ItemJournalLineL."Line No.");
                        ReservationEntryL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
                        ReservationEntryL.SETRANGE("New Lot No.", HandheldTempTableResEntryL."Lot No. To");
                        ReservationEntryL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
                        ReservationEntryL.SETRANGE("New Serial No.", HandheldTempTableResEntryL."Serial No. To");
                        ReservationEntryL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
                        ReservationEntryL.SETRANGE("New Expiration Date", HandheldTempTableResEntryL."Expiry To");
                        IF ReservationEntryL.FINDFIRST THEN BEGIN
                            ReservationEntryL."Quantity (Base)" += -NewQtyL;
                            ReservationEntryL.Quantity += -NewQtyL / ItemJournalLineL."Qty. per Unit of Measure";
                            ReservationEntryL."Qty. to Handle (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL."Qty. to Invoice (Base)" := ReservationEntryL."Quantity (Base)";
                            ReservationEntryL.MODIFY;
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END ELSE BEGIN
                            ReservationEntryL.INIT;
                            LastReservationEntryL += 1;
                            ReservationEntryL.VALIDATE("Entry No.", LastReservationEntryL);
                            ReservationEntryL.VALIDATE(Positive, FALSE);
                            ReservationEntryL.INSERT(TRUE);
                            ReservationEntryL.VALIDATE("Source Type", DATABASE::"Item Journal Line");
                            ReservationEntryL.VALIDATE("Source Subtype", ItemJournalLineL."Entry Type");
                            ReservationEntryL.VALIDATE("Source ID", ItemJournalBatchL."Journal Template Name");
                            ReservationEntryL.VALIDATE("Source Batch Name", ItemJournalBatchL.Name);
                            ReservationEntryL.VALIDATE("Source Ref. No.", ItemJournalLineL."Line No.");
                            ReservationEntryL.VALIDATE("Reservation Status", ReservationEntryL."Reservation Status"::Prospect);
                            ReservationEntryL.VALIDATE("Location Code", ItemJournalLineL."Location Code");
                            ReservationEntryL.VALIDATE("Item No.", ItemJournalLineL."Item No.");
                            ReservationEntryL.Description := ItemJournalLineL.Description;
                            ReservationEntryL.VALIDATE("Variant Code", ItemJournalLineL."Variant Code");
                            ReservationEntryL.VALIDATE("Quantity (Base)", -NewQtyL);
                            ReservationEntryL.VALIDATE("Qty. per Unit of Measure", ItemJournalLineL."Qty. per Unit of Measure");
                            IF ((HandheldTempTableResEntryL."Serial No." <> '') AND (HandheldTempTableResEntryL."Lot No." <> '')) THEN
                                ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot and Serial No."
                            ELSE IF (HandheldTempTableResEntryL."Serial No." <> '') THEN
                                ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Serial No."
                            ELSE IF (HandheldTempTableResEntryL."Lot No." <> '') THEN
                                ReservationEntryL."Item Tracking" := ReservationEntryL."Item Tracking"::"Lot No.";
                            ReservationEntryL."Serial No." := HandheldTempTableResEntryL."Serial No.";
                            ReservationEntryL."New Serial No." := HandheldTempTableResEntryL."Serial No. To";
                            ReservationEntryL."Lot No." := HandheldTempTableResEntryL."Lot No.";
                            ReservationEntryL."New Lot No." := HandheldTempTableResEntryL."Lot No. To";
                            ReservationEntryL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
                            ReservationEntryL."New Expiration Date" := HandheldTempTableResEntryL."Expiry To";
                            ReservationEntryL."Creation Date" := WORKDATE;
                            ReservationEntryL."Created By" := USERID;
                            ReservationEntryL.MODIFY(TRUE);
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END;
                    UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
                END;
            UNTIL (ItemJournalLineL.NEXT = 0);
        END;
    end;

    //Test Adv-

    //Test Adv+

    // [Scope('OnPrem')]
    // procedure CreateHandheldScanMovementByItem()
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     UserBatchL: Record "Stars User Batch";
    //     WhseWorksheetTemplateL: Record "Whse. Worksheet Template";
    //     WhseWorksheetNameL: Record "Whse. Worksheet Name";
    //     HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableExistsL: Boolean;
    //     HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableResEntryExistsL: Boolean;
    //     LastWhseWorksheetLineL: Record "Whse. Worksheet Line";
    //     WhseWorksheetLineL: Record "Whse. Worksheet Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     QtyScndL: Decimal;
    //     NewQtyL: Decimal;
    //     RemQtyL: Decimal;
    //     WhseItemTrackingLineL: Record "Whse. Item Tracking Line";
    //     Text001L: Label 'Importing Whse. Worksheet Lines @1@@@@@@@@@@.';
    //     EntryNoL: Integer;
    //     Text002L: Label 'There are no Handheld Scan lines of type "Movement by Item".';
    //     ItemL: Record Item;
    // begin
    //     GroupByOptionL := GroupByOptionL::"By Item/Variant";
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Create);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Movement by Item");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L);

    //     REPEAT
    //         //Get User Batch by User, Type & Location
    //         UserBatchL.GET(USERID, UserBatchL.Type::Movement, HandheldScanL."Location Code");

    //         WhseWorksheetTemplateL.GET(UserBatchL.Template);
    //         WhseWorksheetNameL.GET(UserBatchL.Template, UserBatchL.Batch, UserBatchL."Location Code");

    //         //Check if the line should be grouped
    //         //HandheldTempTableL is used to create item reclassification lines
    //         HandheldTempTableL.RESET();
    //         HandheldTempTableExistsL := FALSE;
    //         IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //             HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //             HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
    //             HandheldTempTableL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
    //             HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
    //         END ELSE BEGIN
    //             HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //             HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //             HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
    //             HandheldTempTableL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
    //             HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
    //         END;

    //         //Check if the line should be grouped
    //         //HandheldTempTableL is used to create Whse. Worksheet Lines
    //         IF HandheldTempTableExistsL THEN BEGIN
    //             HandheldTempTableL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableL.INIT();
    //             HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableL."Location Code" := HandheldScanL."Location Code";
    //             HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
    //             HandheldTempTableL."Bin Code To" := HandheldScanL."Bin Code To";
    //             HandheldTempTableL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.INSERT();
    //         END;

    //         //Check if the line should be grouped again this time by "Serial No.", "Lot No." & "Lot No. To"
    //         //HandheldTempTableResEntryL is used to update the reservation entries
    //         HandheldTempTableResEntryL.RESET();
    //         HandheldTempTableResEntryExistsL := FALSE;
    //         IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
    //             HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
    //             HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableResEntryL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
    //             HandheldTempTableResEntryL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
    //             HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //             HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //             HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //             HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //         END ELSE BEGIN
    //             HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //             HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //             HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
    //             HandheldTempTableResEntryL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
    //             HandheldTempTableResEntryL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
    //             HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //             HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //             HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //             HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
    //         END;

    //         IF HandheldTempTableResEntryExistsL THEN BEGIN
    //             HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableResEntryL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableResEntryL.INIT();
    //             HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableResEntryL."Location Code" := HandheldScanL."Location Code";
    //             HandheldTempTableResEntryL."Bin Code" := HandheldScanL."Bin Code";
    //             HandheldTempTableResEntryL."Bin Code To" := HandheldScanL."Bin Code To";
    //             HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
    //             HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
    //             HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
    //             HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableResEntryL.INSERT();
    //         END;
    //         //Set Handheld Scans as processed
    //         HandheldScanL.Processed := TRUE;
    //         HandheldScanL."Processed By" := USERID;
    //         HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
    //         HandheldScanL.MODIFY(TRUE);
    //     UNTIL HandheldScanL.NEXT() = 0;

    //     //Now that we have the lines from the temp table grouped in two temp tables
    //     //We can start the import process
    //     LineNumberL := 0;
    //     LastWhseWorksheetLineL.SETRANGE("Worksheet Template Name", UserBatchL.Template);
    //     LastWhseWorksheetLineL.SETRANGE(Name, UserBatchL.Batch);
    //     LastWhseWorksheetLineL.SETRANGE("Location Code", UserBatchL."Location Code");
    //     IF LastWhseWorksheetLineL.FINDLAST() THEN
    //         LineNumberL := LastWhseWorksheetLineL."Line No.";

    //     //Loop through Scanned Items and Create Warehouse Worksheet Lines
    //     HandheldTempTableL.RESET();
    //     IF HandheldTempTableL.FINDSET() THEN BEGIN
    //         WinL.OPEN(Text001L);
    //         LineCountL := HandheldTempTableL.COUNT;
    //         REPEAT
    //             WhseWorksheetLineL.SETRANGE("Worksheet Template Name", UserBatchL.Template);
    //             WhseWorksheetLineL.SETRANGE(Name, UserBatchL.Batch);
    //             WhseWorksheetLineL.SETRANGE("Location Code", UserBatchL."Location Code");
    //             WhseWorksheetLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
    //             WhseWorksheetLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
    //             WhseWorksheetLineL.SETRANGE("From Bin Code", HandheldTempTableL."Bin Code");
    //             WhseWorksheetLineL.SETRANGE("To Bin Code", HandheldTempTableL."Bin Code To");
    //             IF WhseWorksheetLineL.FINDFIRST() THEN BEGIN
    //                 WhseWorksheetLineL.VALIDATE("Qty. (Base)", WhseWorksheetLineL."Qty. (Base)" + HandheldTempTableL."Quantity (Base)");
    //                 WhseWorksheetLineL.VALIDATE(Quantity, WhseWorksheetLineL."Qty. (Base)" * WhseWorksheetLineL."Qty. per Unit of Measure");
    //                 //WhseWorksheetLineL.VALIDATE("Qty. to Handle (Base)", WhseWorksheetLineL."Qty. (Base)");
    //                 WhseWorksheetLineL.MODIFY(TRUE);
    //             END ELSE BEGIN
    //                 LineNumberL += 10000;
    //                 CLEAR(WhseWorksheetLineL);
    //                 ItemL.GET(HandheldTempTableL."Item No.");
    //                 WhseWorksheetLineL.INIT();
    //                 WhseWorksheetLineL.VALIDATE("Worksheet Template Name", UserBatchL.Template);
    //                 WhseWorksheetLineL.VALIDATE(Name, UserBatchL.Batch);
    //                 WhseWorksheetLineL.VALIDATE("Location Code", UserBatchL."Location Code");
    //                 WhseWorksheetLineL.VALIDATE("Line No.", LineNumberL);
    //                 WhseWorksheetLineL.INSERT(TRUE);
    //                 WhseWorksheetLineL.VALIDATE("Whse. Document Type", WhseWorksheetLineL."Whse. Document Type"::"Whse. Mov.-Worksheet");
    //                 WhseWorksheetLineL.VALIDATE("Whse. Document No.", WhseWorksheetLineL.Name);
    //                 WhseWorksheetLineL.VALIDATE("Whse. Document Line No.", WhseWorksheetLineL."Line No.");
    //                 WhseWorksheetLineL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
    //                 WhseWorksheetLineL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
    //                 WhseWorksheetLineL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
    //                 WhseWorksheetLineL.VALIDATE("From Bin Code", HandheldTempTableL."Bin Code");
    //                 WhseWorksheetLineL.VALIDATE("To Bin Code", HandheldTempTableL."Bin Code To");
    //                 WhseWorksheetLineL.VALIDATE("Unit of Measure Code", ItemL."Base Unit of Measure");
    //                 WhseWorksheetLineL.VALIDATE("From Unit of Measure Code", ItemL."Base Unit of Measure");
    //                 WhseWorksheetLineL.VALIDATE("Qty. (Base)", HandheldTempTableL."Quantity (Base)");
    //                 WhseWorksheetLineL.VALIDATE(Quantity, WhseWorksheetLineL."Qty. (Base)" * WhseWorksheetLineL."Qty. per Unit of Measure");
    //                 //WhseWorksheetLineL.VALIDATE("Qty. to Handle (Base)", HandheldTempTableL."Quantity (Base)");
    //                 WhseWorksheetLineL.MODIFY(TRUE);
    //             END;
    //             WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //         UNTIL HandheldTempTableL.NEXT = 0;
    //         WinL.CLOSE;
    //     END;

    //     //Create Reservation Entries
    //     HandheldTempTableResEntryL.RESET();
    //     QtyScndL := 0;
    //     WhseWorksheetLineL.RESET;
    //     WhseWorksheetLineL.SETRANGE("Worksheet Template Name", UserBatchL.Template);
    //     WhseWorksheetLineL.SETRANGE(Name, UserBatchL.Batch);
    //     WhseWorksheetLineL.SETRANGE("Location Code", UserBatchL."Location Code");
    //     IF WhseWorksheetLineL.FINDSET THEN BEGIN
    //         REPEAT
    //             QtyScndL := WhseWorksheetLineL."Qty. (Base)";
    //             HandheldTempTableResEntryL.SETRANGE("Item No.", WhseWorksheetLineL."Item No.");
    //             HandheldTempTableResEntryL.SETRANGE("Variant Code", WhseWorksheetLineL."Variant Code");
    //             HandheldTempTableResEntryL.SETRANGE("Location Code", WhseWorksheetLineL."Location Code");
    //             HandheldTempTableResEntryL.SETRANGE("Bin Code", WhseWorksheetLineL."From Bin Code");
    //             HandheldTempTableResEntryL.SETRANGE("Bin Code To", WhseWorksheetLineL."To Bin Code");
    //             HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
    //             IF HandheldTempTableResEntryL.FINDSET(TRUE) THEN BEGIN
    //                 REPEAT
    //                     IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
    //                         NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     QtyScndL := QtyScndL - NewQtyL;

    //                     WhseItemTrackingLineL.SETRANGE("Location Code", WhseWorksheetLineL."Location Code");
    //                     WhseItemTrackingLineL.SETRANGE("Source Type", DATABASE::"Whse. Worksheet Line");
    //                     WhseItemTrackingLineL.SETRANGE("Source ID", WhseWorksheetNameL.Name);
    //                     WhseItemTrackingLineL.SETRANGE("Source Batch Name", WhseWorksheetNameL."Worksheet Template Name");
    //                     WhseItemTrackingLineL.SETRANGE("Source Ref. No.", WhseWorksheetLineL."Line No.");
    //                     WhseItemTrackingLineL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
    //                     WhseItemTrackingLineL.SETRANGE("Variant Code", HandheldTempTableResEntryL."Variant Code");
    //                     WhseItemTrackingLineL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
    //                     WhseItemTrackingLineL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
    //                     WhseItemTrackingLineL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
    //                     IF WhseItemTrackingLineL.FINDFIRST THEN BEGIN
    //                         WhseItemTrackingLineL.VALIDATE("Quantity (Base)", WhseItemTrackingLineL."Quantity (Base)" + NewQtyL);
    //                         WhseItemTrackingLineL.MODIFY;
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END ELSE BEGIN
    //                         WhseItemTrackingLineL.RESET();
    //                         IF WhseItemTrackingLineL.FINDLAST() THEN
    //                             EntryNoL := WhseItemTrackingLineL."Entry No." + 1
    //                         ELSE
    //                             EntryNoL := 1;

    //                         CLEAR(WhseItemTrackingLineL);
    //                         WhseItemTrackingLineL.INIT;
    //                         WhseItemTrackingLineL.VALIDATE("Entry No.", EntryNoL);
    //                         WhseItemTrackingLineL.VALIDATE("Source Type", DATABASE::"Whse. Worksheet Line");
    //                         WhseItemTrackingLineL.VALIDATE("Source ID", WhseWorksheetNameL.Name);
    //                         WhseItemTrackingLineL.VALIDATE("Source Batch Name", WhseWorksheetNameL."Worksheet Template Name");
    //                         WhseItemTrackingLineL.VALIDATE("Source Ref. No.", WhseWorksheetLineL."Line No.");
    //                         WhseItemTrackingLineL.INSERT(TRUE);
    //                         WhseItemTrackingLineL.VALIDATE("Location Code", WhseWorksheetLineL."Location Code");
    //                         WhseItemTrackingLineL.VALIDATE("Item No.", HandheldTempTableResEntryL."Item No.");
    //                         WhseItemTrackingLineL.Description := WhseWorksheetLineL.Description;
    //                         WhseItemTrackingLineL.VALIDATE("Variant Code", WhseWorksheetLineL."Variant Code");
    //                         WhseItemTrackingLineL."Lot No." := HandheldTempTableResEntryL."Lot No.";
    //                         WhseItemTrackingLineL."Serial No." := HandheldTempTableResEntryL."Serial No.";
    //                         WhseItemTrackingLineL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
    //                         WhseItemTrackingLineL.VALIDATE("Quantity (Base)", NewQtyL);
    //                         WhseItemTrackingLineL.VALIDATE("Qty. per Unit of Measure", WhseWorksheetLineL."Qty. per Unit of Measure");
    //                         WhseItemTrackingLineL.MODIFY(TRUE);
    //                         HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
    //                         HandheldTempTableResEntryL.MODIFY;
    //                     END;
    //                 UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
    //             END;
    //         UNTIL (WhseWorksheetLineL.NEXT = 0);
    //     END;
    // end;


    procedure CreateHandheldScanMovementByItem()
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        UserBatchL: Record "Stars HHT User Batch";
        WhseWorksheetTemplateL: Record "Whse. Worksheet Template";
        WhseWorksheetNameL: Record "Whse. Worksheet Name";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableResEntryExistsL: Boolean;
        LastWhseWorksheetLineL: Record "Whse. Worksheet Line";
        WhseWorksheetLineL: Record "Whse. Worksheet Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        QtyScndL: Decimal;
        NewQtyL: Decimal;
        RemQtyL: Decimal;
        WhseItemTrackingLineL: Record "Whse. Item Tracking Line";
        Text001L: Label 'Importing Whse. Worksheet Lines @1@@@@@@@@@@.';
        EntryNoL: Integer;
        Text002L: Label 'There are no Handheld Scan lines of type "Movement by Item".';
        ItemL: Record Item;
        HandheldScanL2: Record "Stars HandHeld Scan";
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Create);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Movement by Item");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L);

        REPEAT
            //Get User Batch by User, Type & Location
            UserBatchL.GET(USERID, UserBatchL.Type::Movement, HandheldScanL."Location Code");

            WhseWorksheetTemplateL.GET(UserBatchL.Template);
            WhseWorksheetNameL.GET(UserBatchL.Template, UserBatchL.Batch, UserBatchL."Location Code");

            //Check if the line should be grouped
            //HandheldTempTableL is used to create item reclassification lines
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END ELSE BEGIN
                HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
                HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            END;

            //Check if the line should be grouped
            //HandheldTempTableL is used to create Whse. Worksheet Lines
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
                HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableL."Bin Code To" := HandheldScanL."Bin Code To";
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL.INSERT();
            END;

            //Check if the line should be grouped again this time by "Serial No.", "Lot No." & "Lot No. To"
            //HandheldTempTableResEntryL is used to update the reservation entries
            HandheldTempTableResEntryL.RESET();
            HandheldTempTableResEntryExistsL := FALSE;
            IF GroupByOptionL = GroupByOptionL::"By Barcode" THEN BEGIN
                HandheldTempTableResEntryL.SETRANGE("Barcode No.", HandheldScanL."Barcode No.");
                HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableResEntryL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableResEntryL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
                HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
            END ELSE BEGIN
                HandheldTempTableResEntryL.SETRANGE("Item No.", HandheldScanL."Item No.");
                HandheldTempTableResEntryL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
                HandheldTempTableResEntryL.SETRANGE("Location Code", HandheldScanL."Location Code");
                HandheldTempTableResEntryL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
                HandheldTempTableResEntryL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To");
                HandheldTempTableResEntryL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
                HandheldTempTableResEntryL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
                HandheldTempTableResEntryL.SETRANGE(Expiry, HandheldScanL.Expiry);
                HandheldTempTableResEntryExistsL := HandheldTempTableResEntryL.FINDFIRST();
            END;

            IF HandheldTempTableResEntryExistsL THEN BEGIN
                HandheldTempTableResEntryL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableResEntryL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableResEntryL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableResEntryL.INIT();
                HandheldTempTableResEntryL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableResEntryL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableResEntryL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableResEntryL."Location Code" := HandheldScanL."Location Code";
                HandheldTempTableResEntryL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableResEntryL."Bin Code To" := HandheldScanL."Bin Code To";
                HandheldTempTableResEntryL."Lot No." := HandheldScanL."Lot No.";
                HandheldTempTableResEntryL."Serial No." := HandheldScanL."Serial No.";
                HandheldTempTableResEntryL.Expiry := HandheldScanL.Expiry;
                HandheldTempTableResEntryL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableResEntryL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableResEntryL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.Processed := TRUE;
            HandheldScanL2."Processed By" := USERID;
            HandheldScanL2."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL2.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //Now that we have the lines from the temp table grouped in two temp tables
        //We can start the import process
        LineNumberL := 0;
        LastWhseWorksheetLineL.SETRANGE("Worksheet Template Name", UserBatchL.Template);
        LastWhseWorksheetLineL.SETRANGE(Name, UserBatchL.Batch);
        LastWhseWorksheetLineL.SETRANGE("Location Code", UserBatchL."Location Code");
        IF LastWhseWorksheetLineL.FINDLAST() THEN
            LineNumberL := LastWhseWorksheetLineL."Line No.";

        //Loop through Scanned Items and Create Warehouse Worksheet Lines
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN
            WinL.OPEN(Text001L);
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                WhseWorksheetLineL.SETRANGE("Worksheet Template Name", UserBatchL.Template);
                WhseWorksheetLineL.SETRANGE(Name, UserBatchL.Batch);
                WhseWorksheetLineL.SETRANGE("Location Code", UserBatchL."Location Code");
                WhseWorksheetLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                WhseWorksheetLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                WhseWorksheetLineL.SETRANGE("From Bin Code", HandheldTempTableL."Bin Code");
                WhseWorksheetLineL.SETRANGE("To Bin Code", HandheldTempTableL."Bin Code To");
                IF WhseWorksheetLineL.FINDFIRST() THEN BEGIN
                    WhseWorksheetLineL.VALIDATE("Qty. (Base)", WhseWorksheetLineL."Qty. (Base)" + HandheldTempTableL."Quantity (Base)");
                    WhseWorksheetLineL.VALIDATE(Quantity, WhseWorksheetLineL."Qty. (Base)" * WhseWorksheetLineL."Qty. per Unit of Measure");
                    //WhseWorksheetLineL.VALIDATE("Qty. to Handle (Base)", WhseWorksheetLineL."Qty. (Base)");
                    WhseWorksheetLineL.MODIFY(TRUE);
                END ELSE BEGIN
                    LineNumberL += 10000;
                    CLEAR(WhseWorksheetLineL);
                    ItemL.GET(HandheldTempTableL."Item No.");
                    WhseWorksheetLineL.INIT();
                    WhseWorksheetLineL.VALIDATE("Worksheet Template Name", UserBatchL.Template);
                    WhseWorksheetLineL.VALIDATE(Name, UserBatchL.Batch);
                    WhseWorksheetLineL.VALIDATE("Location Code", UserBatchL."Location Code");
                    WhseWorksheetLineL.VALIDATE("Line No.", LineNumberL);
                    WhseWorksheetLineL.INSERT(TRUE);
                    WhseWorksheetLineL.VALIDATE("Whse. Document Type", WhseWorksheetLineL."Whse. Document Type"::"Whse. Mov.-Worksheet");
                    WhseWorksheetLineL.VALIDATE("Whse. Document No.", WhseWorksheetLineL.Name);
                    WhseWorksheetLineL.VALIDATE("Whse. Document Line No.", WhseWorksheetLineL."Line No.");
                    WhseWorksheetLineL.VALIDATE("Item No.", HandheldTempTableL."Item No.");
                    WhseWorksheetLineL.VALIDATE("Variant Code", HandheldTempTableL."Variant Code");
                    WhseWorksheetLineL.VALIDATE("Location Code", HandheldTempTableL."Location Code");
                    WhseWorksheetLineL.VALIDATE("From Bin Code", HandheldTempTableL."Bin Code");
                    WhseWorksheetLineL.VALIDATE("To Bin Code", HandheldTempTableL."Bin Code To");
                    WhseWorksheetLineL.VALIDATE("Unit of Measure Code", ItemL."Base Unit of Measure");
                    WhseWorksheetLineL.VALIDATE("From Unit of Measure Code", ItemL."Base Unit of Measure");
                    WhseWorksheetLineL.VALIDATE("Qty. (Base)", HandheldTempTableL."Quantity (Base)");
                    WhseWorksheetLineL.VALIDATE(Quantity, WhseWorksheetLineL."Qty. (Base)" * WhseWorksheetLineL."Qty. per Unit of Measure");
                    //WhseWorksheetLineL.VALIDATE("Qty. to Handle (Base)", HandheldTempTableL."Quantity (Base)");
                    WhseWorksheetLineL.MODIFY(TRUE);
                END;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;

        //Create Reservation Entries
        HandheldTempTableResEntryL.RESET();
        QtyScndL := 0;
        WhseWorksheetLineL.RESET;
        WhseWorksheetLineL.SETRANGE("Worksheet Template Name", UserBatchL.Template);
        WhseWorksheetLineL.SETRANGE(Name, UserBatchL.Batch);
        WhseWorksheetLineL.SETRANGE("Location Code", UserBatchL."Location Code");
        IF WhseWorksheetLineL.FINDSET THEN BEGIN
            REPEAT
                QtyScndL := WhseWorksheetLineL."Qty. (Base)";
                HandheldTempTableResEntryL.SETRANGE("Item No.", WhseWorksheetLineL."Item No.");
                HandheldTempTableResEntryL.SETRANGE("Variant Code", WhseWorksheetLineL."Variant Code");
                HandheldTempTableResEntryL.SETRANGE("Location Code", WhseWorksheetLineL."Location Code");
                HandheldTempTableResEntryL.SETRANGE("Bin Code", WhseWorksheetLineL."From Bin Code");
                HandheldTempTableResEntryL.SETRANGE("Bin Code To", WhseWorksheetLineL."To Bin Code");
                HandheldTempTableResEntryL.SETFILTER("Quantity (Base)", '>%1', 0);
                IF HandheldTempTableResEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        IF QtyScndL > HandheldTempTableResEntryL."Quantity (Base)" THEN
                            NewQtyL := HandheldTempTableResEntryL."Quantity (Base)"
                        ELSE
                            NewQtyL := QtyScndL;
                        QtyScndL := QtyScndL - NewQtyL;

                        WhseItemTrackingLineL.SETRANGE("Location Code", WhseWorksheetLineL."Location Code");
                        WhseItemTrackingLineL.SETRANGE("Source Type", DATABASE::"Whse. Worksheet Line");
                        WhseItemTrackingLineL.SETRANGE("Source ID", WhseWorksheetNameL.Name);
                        WhseItemTrackingLineL.SETRANGE("Source Batch Name", WhseWorksheetNameL."Worksheet Template Name");
                        WhseItemTrackingLineL.SETRANGE("Source Ref. No.", WhseWorksheetLineL."Line No.");
                        WhseItemTrackingLineL.SETRANGE("Item No.", HandheldTempTableResEntryL."Item No.");
                        WhseItemTrackingLineL.SETRANGE("Variant Code", HandheldTempTableResEntryL."Variant Code");
                        WhseItemTrackingLineL.SETRANGE("Lot No.", HandheldTempTableResEntryL."Lot No.");
                        WhseItemTrackingLineL.SETRANGE("Serial No.", HandheldTempTableResEntryL."Serial No.");
                        WhseItemTrackingLineL.SETRANGE("Expiration Date", HandheldTempTableResEntryL.Expiry);
                        IF WhseItemTrackingLineL.FINDFIRST THEN BEGIN
                            WhseItemTrackingLineL.VALIDATE("Quantity (Base)", WhseItemTrackingLineL."Quantity (Base)" + NewQtyL);
                            WhseItemTrackingLineL.MODIFY;
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END ELSE BEGIN
                            WhseItemTrackingLineL.RESET();
                            IF WhseItemTrackingLineL.FINDLAST() THEN
                                EntryNoL := WhseItemTrackingLineL."Entry No." + 1
                            ELSE
                                EntryNoL := 1;

                            CLEAR(WhseItemTrackingLineL);
                            WhseItemTrackingLineL.INIT;
                            WhseItemTrackingLineL.VALIDATE("Entry No.", EntryNoL);
                            WhseItemTrackingLineL.VALIDATE("Source Type", DATABASE::"Whse. Worksheet Line");
                            WhseItemTrackingLineL.VALIDATE("Source ID", WhseWorksheetNameL.Name);
                            WhseItemTrackingLineL.VALIDATE("Source Batch Name", WhseWorksheetNameL."Worksheet Template Name");
                            WhseItemTrackingLineL.VALIDATE("Source Ref. No.", WhseWorksheetLineL."Line No.");
                            WhseItemTrackingLineL.INSERT(TRUE);
                            WhseItemTrackingLineL.VALIDATE("Location Code", WhseWorksheetLineL."Location Code");
                            WhseItemTrackingLineL.VALIDATE("Item No.", HandheldTempTableResEntryL."Item No.");
                            WhseItemTrackingLineL.Description := WhseWorksheetLineL.Description;
                            WhseItemTrackingLineL.VALIDATE("Variant Code", WhseWorksheetLineL."Variant Code");
                            WhseItemTrackingLineL."Lot No." := HandheldTempTableResEntryL."Lot No.";
                            WhseItemTrackingLineL."Serial No." := HandheldTempTableResEntryL."Serial No.";
                            WhseItemTrackingLineL."Expiration Date" := HandheldTempTableResEntryL.Expiry;
                            WhseItemTrackingLineL.VALIDATE("Quantity (Base)", NewQtyL);
                            WhseItemTrackingLineL.VALIDATE("Qty. per Unit of Measure", WhseWorksheetLineL."Qty. per Unit of Measure");
                            WhseItemTrackingLineL.MODIFY(TRUE);
                            HandheldTempTableResEntryL."Quantity (Base)" -= NewQtyL;
                            HandheldTempTableResEntryL.MODIFY;
                        END;
                    UNTIL (HandheldTempTableResEntryL.NEXT = 0) OR (QtyScndL <= 0);
                END;
            UNTIL (WhseWorksheetLineL.NEXT = 0);
        END;
    end;


    //Test Adv-


    // [Scope('OnPrem')]

    //Test Adv+

    // procedure UpdateHandheldScanDirectedPutAways(WarehouseActivityHeaderP: Record "Warehouse Activity Header")
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableExistsL: Boolean;
    //     HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableResEntryExistsL: Boolean;
    //     WarehouseActivityLineL: Record "Warehouse Activity Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     Text001L: Label 'Importing Put-Away Lines @1@@@@@@@@@@.';
    //     Text002L: Label 'There are no Handheld Scan lines for Put-Away %1.';
    //     QtyScndL: Decimal;
    //     NewQtyL: Decimal;
    //     RemQtyL: Decimal;
    //     WarehouseActivityLine2L: Record "Warehouse Activity Line";
    // begin
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Directed Put Away");
    //     HandheldScanL.SETRANGE("Document No.", WarehouseActivityHeaderP."No.");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L, WarehouseActivityHeaderP."No.");

    //     REPEAT
    //         //Check if the line should be grouped
    //         HandheldTempTableL.RESET();
    //         HandheldTempTableExistsL := FALSE;
    //         HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //         HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //         HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
    //         HandheldTempTableL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //         HandheldTempTableL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //         HandheldTempTableL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //         HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();

    //         IF HandheldTempTableExistsL THEN BEGIN
    //             HandheldTempTableL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableL.INIT();
    //             HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
    //             HandheldTempTableL."Lot No." := HandheldScanL."Lot No.";
    //             HandheldTempTableL."Serial No." := HandheldScanL."Serial No.";
    //             HandheldTempTableL.Expiry := HandheldScanL.Expiry;
    //             HandheldTempTableL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.INSERT();
    //         END;
    //         //Set Handheld Scans as processed
    //         HandheldScanL.Processed := TRUE;
    //         HandheldScanL."Processed By" := USERID;
    //         HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
    //         HandheldScanL.MODIFY(TRUE);
    //     UNTIL HandheldScanL.NEXT() = 0;

    //     //We can start the import process

    //     //Zero Put-Away Lines Qty. to Receive
    //     WarehouseActivityLineL.RESET;
    //     WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
    //     WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //     WarehouseActivityLineL.MODIFYALL("Qty. to Handle", 0);

    //     //Loop through Scanned Items and Update Put-Away Lines
    //     WarehouseActivityLineL.RESET;
    //     WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
    //     WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //     WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Place);
    //     HandheldTempTableL.RESET();
    //     IF HandheldTempTableL.FINDSET() THEN BEGIN
    //         WinL.OPEN(Text001L);
    //         LineNumberL := 0;
    //         LineCountL := HandheldTempTableL.COUNT;
    //         REPEAT
    //             QtyScndL := HandheldTempTableL."Quantity (Base)";
    //             WarehouseActivityLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
    //             WarehouseActivityLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
    //             WarehouseActivityLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
    //             WarehouseActivityLineL.SETRANGE("Lot No.", HandheldTempTableL."Lot No.");
    //             WarehouseActivityLineL.SETRANGE("Serial No.", HandheldTempTableL."Serial No.");
    //             WarehouseActivityLineL.SETRANGE("Expiration Date", HandheldTempTableL.Expiry);
    //             IF WarehouseActivityLineL.FINDSET(TRUE) THEN
    //                 REPEAT
    //                     RemQtyL := WarehouseActivityLineL."Qty. (Base)" - WarehouseActivityLineL."Qty. Handled (Base)";
    //                     IF QtyScndL > RemQtyL THEN
    //                         NewQtyL := RemQtyL
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     WarehouseActivityLineL.VALIDATE("Qty. to Handle", NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure");
    //                     WarehouseActivityLineL.MODIFY(TRUE);
    //                     QtyScndL := QtyScndL - NewQtyL;
    //                 UNTIL (WarehouseActivityLineL.NEXT = 0) OR (QtyScndL <= 0);
    //             LineNumberL += 1;
    //             WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //         UNTIL HandheldTempTableL.NEXT = 0;
    //         WinL.CLOSE;
    //     END;

    //     //Modify Take Lines
    //     WarehouseActivityLineL.RESET;
    //     WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
    //     WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //     WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Place);
    //     WarehouseActivityLineL.SETFILTER("Qty. to Handle", '<>0');
    //     IF WarehouseActivityLineL.FINDSET(TRUE) THEN BEGIN
    //         REPEAT
    //             WarehouseActivityLine2L.RESET();
    //             WarehouseActivityLine2L.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
    //             WarehouseActivityLine2L.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //             WarehouseActivityLine2L.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Take);
    //             WarehouseActivityLine2L.SETRANGE("Item No.", WarehouseActivityLineL."Item No.");
    //             WarehouseActivityLine2L.SETRANGE("Variant Code", WarehouseActivityLineL."Variant Code");
    //             WarehouseActivityLine2L.SETRANGE("Unit of Measure Code", WarehouseActivityLineL."Unit of Measure Code");
    //             WarehouseActivityLine2L.SETRANGE("Serial No.", WarehouseActivityLineL."Serial No.");
    //             WarehouseActivityLine2L.SETRANGE("Lot No.", WarehouseActivityLineL."Lot No.");
    //             WarehouseActivityLine2L.SETFILTER("Qty. to Handle", '=0');
    //             IF WarehouseActivityLine2L.FINDFIRST() THEN BEGIN
    //                 WarehouseActivityLine2L.VALIDATE("Qty. to Handle", WarehouseActivityLineL."Qty. to Handle");
    //                 WarehouseActivityLine2L.MODIFY(TRUE);
    //             END;
    //         UNTIL WarehouseActivityLineL.NEXT() = 0;
    //     END;
    // end;



    PROCEDURE UpdateHandheldScanDirectedPutAways(WarehouseActivityHeaderP: Record "Warehouse Activity Header");
    VAR
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        HandheldTempTableResEntryL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableResEntryExistsL: Boolean;
        WarehouseActivityLineL: Record "Warehouse Activity Line";
        WarehouseActivityLineL2: Record "Warehouse Activity Line";
        WarehouseActivityLineTempL: Record "Warehouse Activity Line" temporary;
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Put-Away Lines @1@@@@@@@@@@.';
        Text002L: Label 'There are no Handheld Scan lines for Put-Away %1.';
        QtyScndL: Decimal;
        NewQtyL: Decimal;
        RemQtyL: Decimal;
        HandheldScanL2: Record "Stars HandHeld Scan";
        LineNo: Integer;
    BEGIN
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Directed Put Away");
        HandheldScanL.SETRANGE("Document No.", WarehouseActivityHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, WarehouseActivityHeaderP."No.");
        REPEAT
            //Check if the line should be grouped
            HandheldTempTableL.RESET();
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
            HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
            HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
            HandheldTempTableL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
            HandheldTempTableL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
            HandheldTempTableL.SETRANGE(Expiry, HandheldScanL.Expiry);
            HandheldTempTableL.SETRANGE("Bin Code To", HandheldScanL."Bin Code To"); //Stars04.00
            HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();

            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                HandheldTempTableL.INIT();
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableL."Lot No." := HandheldScanL."Lot No.";
                HandheldTempTableL."Serial No." := HandheldScanL."Serial No.";
                HandheldTempTableL.Expiry := HandheldScanL.Expiry;
                HandheldTempTableL."Bin Code To" := HandheldScanL."Bin Code To"; //Stars04.00
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.Processed := TRUE;
            HandheldScanL2."Processed By" := USERID;
            HandheldScanL2."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL2.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //We can start the import process

        //Zero Put-Away Lines Qty. to Receive
        WarehouseActivityLineL.RESET;
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
        WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
        IF WarehouseActivityLineL.FINDSET THEN
            REPEAT
                WarehouseActivityLineL.VALIDATE("Qty. to Handle", 0);
                WarehouseActivityLineL.MODIFY(TRUE);
            UNTIL WarehouseActivityLineL.NEXT = 0;

        //Loop through Scanned Items and Update Put-Away Lines

        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN
            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                HandheldTempTableL.TESTFIELD("Bin Code To"); //Stars04.00

                QtyScndL := HandheldTempTableL."Quantity (Base)";

                WarehouseActivityLineL.RESET;
                WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
                WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
                WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Place);
                WarehouseActivityLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                WarehouseActivityLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                //Stars04.00    WarehouseActivityLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
                WarehouseActivityLineL.SETRANGE("Lot No.", HandheldTempTableL."Lot No.");
                WarehouseActivityLineL.SETRANGE("Serial No.", HandheldTempTableL."Serial No.");
                WarehouseActivityLineL.SETRANGE("Expiration Date", HandheldTempTableL.Expiry);
                WarehouseActivityLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code To"); //Stars04.00 //same bins
                IF WarehouseActivityLineL.FINDSET(TRUE) THEN
                    REPEAT
                        RemQtyL := WarehouseActivityLineL."Qty. (Base)" - WarehouseActivityLineL."Qty. Handled (Base)" - WarehouseActivityLineL."Qty. to Handle (Base)";
                        IF RemQtyL > 0 THEN BEGIN
                            IF QtyScndL > RemQtyL THEN
                                NewQtyL := RemQtyL
                            ELSE
                                NewQtyL := QtyScndL;

                            IF NewQtyL > 0 THEN BEGIN //Stars04.00

                                WarehouseActivityLineTempL := WarehouseActivityLineL; //Stars04.00

                                WarehouseActivityLineL.VALIDATE(Quantity, ROUND(NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure", 0.00001));
                                WarehouseActivityLineL.VALIDATE("Qty. to Handle", WarehouseActivityLineL.Quantity);
                                WarehouseActivityLineL.MODIFY(TRUE);

                                //Stars04.00+
                                IF WarehouseActivityLineTempL.Quantity <> WarehouseActivityLineL.Quantity THEN BEGIN
                                    WarehouseActivityLineTempL.Quantity := WarehouseActivityLineTempL.Quantity - WarehouseActivityLineL.Quantity;
                                    WarehouseActivityLineTempL."Qty. (Base)" := WarehouseActivityLineTempL."Qty. (Base)" - WarehouseActivityLineL."Qty. (Base)";
                                    WarehouseActivityLineTempL.INSERT;
                                END;
                                //Stars04.00-

                                QtyScndL := QtyScndL - NewQtyL;
                            END  //Stars04.00
                        END
                    UNTIL (WarehouseActivityLineL.NEXT = 0) OR (QtyScndL <= 0);

                //Stars04.002+
                WarehouseActivityLineL.SETRANGE("Bin Code"); //other bins
                IF WarehouseActivityLineL.FINDSET(TRUE) AND (QtyScndL > 0) THEN
                    REPEAT
                        IF WarehouseActivityLineL."Bin Code" = '' THEN BEGIN //empty bin
                            RemQtyL := WarehouseActivityLineL."Qty. (Base)" - WarehouseActivityLineL."Qty. Handled (Base)" - WarehouseActivityLineL."Qty. to Handle (Base)";
                            IF RemQtyL > 0 THEN BEGIN
                                IF QtyScndL > RemQtyL THEN
                                    NewQtyL := RemQtyL
                                ELSE
                                    NewQtyL := QtyScndL;

                                IF NewQtyL > 0 THEN BEGIN

                                    WarehouseActivityLineTempL := WarehouseActivityLineL; //Stars04.00

                                    WarehouseActivityLineL.VALIDATE("Zone Code", '');
                                    WarehouseActivityLineL.VALIDATE("Bin Code", HandheldTempTableL."Bin Code To");
                                    WarehouseActivityLineL.VALIDATE(Quantity, NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure");
                                    WarehouseActivityLineL.VALIDATE("Qty. to Handle", WarehouseActivityLineL.Quantity);
                                    WarehouseActivityLineL.MODIFY(TRUE);

                                    //Stars04.00+
                                    IF WarehouseActivityLineTempL.Quantity <> WarehouseActivityLineL.Quantity THEN BEGIN
                                        WarehouseActivityLineTempL.Quantity := WarehouseActivityLineTempL.Quantity - WarehouseActivityLineL.Quantity;
                                        WarehouseActivityLineTempL."Qty. (Base)" := WarehouseActivityLineTempL."Qty. (Base)" - WarehouseActivityLineL."Qty. (Base)";
                                        WarehouseActivityLineTempL.INSERT;
                                    END;
                                    //Stars04.00-

                                END;

                                QtyScndL := QtyScndL - NewQtyL;
                            END
                        END
                    UNTIL (WarehouseActivityLineL.NEXT = 0) OR (QtyScndL <= 0);

                IF WarehouseActivityLineL.FINDSET(TRUE) AND (QtyScndL > 0) THEN
                    REPEAT
                        IF (WarehouseActivityLineL."Bin Code" <> HandheldTempTableL."Bin Code To") AND
                           (WarehouseActivityLineL."Bin Code" <> '') THEN BEGIN //other bins
                            RemQtyL := WarehouseActivityLineL."Qty. (Base)" - WarehouseActivityLineL."Qty. Handled (Base)" - WarehouseActivityLineL."Qty. to Handle (Base)";
                            IF RemQtyL > 0 THEN BEGIN
                                IF QtyScndL > RemQtyL THEN
                                    NewQtyL := RemQtyL
                                ELSE
                                    NewQtyL := QtyScndL;

                                IF NewQtyL > 0 THEN BEGIN

                                    WarehouseActivityLineTempL := WarehouseActivityLineL; //Stars04.00

                                    WarehouseActivityLineL.VALIDATE("Zone Code", '');
                                    WarehouseActivityLineL.VALIDATE("Bin Code", HandheldTempTableL."Bin Code To");
                                    WarehouseActivityLineL.VALIDATE(Quantity, NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure");
                                    WarehouseActivityLineL.VALIDATE("Qty. to Handle", WarehouseActivityLineL.Quantity);
                                    WarehouseActivityLineL.MODIFY(TRUE);

                                    //Stars04.00+
                                    IF WarehouseActivityLineTempL.Quantity <> WarehouseActivityLineL.Quantity THEN BEGIN
                                        WarehouseActivityLineTempL.Quantity := WarehouseActivityLineTempL.Quantity - WarehouseActivityLineL.Quantity;
                                        WarehouseActivityLineTempL."Qty. (Base)" := WarehouseActivityLineTempL."Qty. (Base)" - WarehouseActivityLineL."Qty. (Base)";
                                        WarehouseActivityLineTempL.INSERT;
                                    END;
                                    //Stars04.00-

                                END;

                                QtyScndL := QtyScndL - NewQtyL;
                            END
                        END
                    UNTIL (WarehouseActivityLineL.NEXT = 0) OR (QtyScndL <= 0);

                //Stars04.00+
                IF WarehouseActivityLineTempL.FINDSET THEN BEGIN
                    REPEAT
                        CLEAR(WarehouseActivityLineL);
                        LineNo := WarehouseActivityLineTempL."Line No.";

                        WHILE WarehouseActivityLineL.GET(WarehouseActivityLineTempL."Activity Type", WarehouseActivityLineTempL."No.", LineNo)
                          DO LineNo := LineNo + 10;

                        CLEAR(WarehouseActivityLineL);
                        WarehouseActivityLineL := WarehouseActivityLineTempL;
                        WarehouseActivityLineL."Line No." := LineNo;
                        WarehouseActivityLineL.VALIDATE("Zone Code", '');
                        WarehouseActivityLineL.VALIDATE("Bin Code", '');
                        WarehouseActivityLineL.VALIDATE("Qty. to Handle", 0);
                        WarehouseActivityLineL.VALIDATE(Quantity, WarehouseActivityLineTempL.Quantity);
                        WarehouseActivityLineL.VALIDATE("Qty. to Handle", 0);
                        WarehouseActivityLineL.INSERT;
                    UNTIL WarehouseActivityLineTempL.NEXT = 0;

                    WarehouseActivityLineTempL.RESET;
                    WarehouseActivityLineTempL.DELETEALL;
                END;
                //Stars04.00-

                IF QtyScndL > 0 THEN
                    ERROR('You have scan more than the outstanding qty');

                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;

        //Modify Take Lines
        WarehouseActivityLineL.RESET;
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
        WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
        WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Place);
        WarehouseActivityLineL.SETFILTER("Qty. to Handle", '<>0');
        IF WarehouseActivityLineL.FINDSET(TRUE) THEN
            REPEAT
                WarehouseActivityLineL2.RESET;
                WarehouseActivityLineL2.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
                WarehouseActivityLineL2.SETRANGE("No.", WarehouseActivityHeaderP."No.");
                WarehouseActivityLineL2.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Take);
                WarehouseActivityLineL2.SETRANGE("Item No.", WarehouseActivityLineL."Item No.");
                WarehouseActivityLineL2.SETRANGE("Variant Code", WarehouseActivityLineL."Variant Code");
                WarehouseActivityLineL2.SETRANGE("Unit of Measure Code", WarehouseActivityLineL."Unit of Measure Code");
                WarehouseActivityLineL2.SETRANGE("Serial No.", WarehouseActivityLineL."Serial No.");
                WarehouseActivityLineL2.SETRANGE("Lot No.", WarehouseActivityLineL."Lot No.");

                //Stars04.00+
                WarehouseActivityLineL2.SETRANGE("Whse. Document Type", WarehouseActivityLineL."Whse. Document Type");
                WarehouseActivityLineL2.SETRANGE("Whse. Document No.", WarehouseActivityLineL."Whse. Document No.");
                WarehouseActivityLineL2.SETRANGE("Whse. Document Line No.", WarehouseActivityLineL."Whse. Document Line No.");
                //Stars04.00-

                IF WarehouseActivityLineL2.FINDFIRST() THEN BEGIN

                    //Stars04.00+
                    //Stars04.00      WarehouseActivityLineTempL := WarehouseActivityLineL2;
                    //Stars04.00      IF NOT WarehouseActivityLineTempL.FIND THEN BEGIN
                    //Stars04.00        WarehouseActivityLineL2.VALIDATE("Qty. to Handle", 0);
                    //Stars04.00

                    //Stars04.00        WarehouseActivityLineTempL := WarehouseActivityLineL2;
                    //Stars04.00        WarehouseActivityLineTempL.INSERT;
                    //Stars04.00      END;

                    //Stars04.00      WarehouseActivityLineL2.VALIDATE("Qty. to Handle", WarehouseActivityLineL."Qty. to Handle");
                    WarehouseActivityLineL2.VALIDATE("Qty. to Handle", WarehouseActivityLineL2."Qty. to Handle" + WarehouseActivityLineL."Qty. to Handle"); //Stars04.00
                    WarehouseActivityLineL2.MODIFY(TRUE);
                END;
            UNTIL WarehouseActivityLineL.NEXT() = 0;
    END;


    //Test Adv-

    //Test Adv+

    // // [Scope('OnPrem')]
    // procedure UpdateHandheldScanDirectedPicks(WarehouseActivityHeaderP: Record "Warehouse Activity Header")
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
    //     HandheldTempTableExistsL: Boolean;
    //     WarehouseActivityLineL: Record "Warehouse Activity Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     Text001L: Label 'Importing Pick Lines @1@@@@@@@@@@.';
    //     Text002L: Label 'There are no Handheld Scan lines for Pick %1.';
    //     QtyScndL: Decimal;
    //     NewQtyL: Decimal;
    //     RemQtyL: Decimal;
    //     WarehouseActivityLine2L: Record "Warehouse Activity Line";
    // begin
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Directed Pick");
    //     HandheldScanL.SETRANGE("Document No.", WarehouseActivityHeaderP."No.");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L, WarehouseActivityHeaderP."No.");

    //     REPEAT
    //         //Check if the line should be grouped
    //         HandheldTempTableL.RESET();
    //         HandheldTempTableExistsL := FALSE;
    //         HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
    //         HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
    //         HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
    //         HandheldTempTableL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
    //         HandheldTempTableL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
    //         HandheldTempTableL.SETRANGE(Expiry, HandheldScanL.Expiry);
    //         HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
    //         IF HandheldTempTableExistsL THEN BEGIN
    //             HandheldTempTableL.Quantity += HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.MODIFY();
    //         END ELSE BEGIN
    //             HandheldTempTableL.INIT();
    //             HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
    //             HandheldTempTableL."Item No." := HandheldScanL."Item No.";
    //             HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
    //             HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
    //             HandheldTempTableL."Lot No." := HandheldScanL."Lot No.";
    //             HandheldTempTableL."Serial No." := HandheldScanL."Serial No.";
    //             HandheldTempTableL.Expiry := HandheldScanL.Expiry;
    //             HandheldTempTableL.Quantity := HandheldScanL.Quantity;
    //             HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
    //             HandheldTempTableL.INSERT();
    //         END;
    //         //Set Handheld Scans as processed
    //         HandheldScanL.Processed := TRUE;
    //         HandheldScanL."Processed By" := USERID;
    //         HandheldScanL."Processed Date/Time" := CURRENTDATETIME;
    //         HandheldScanL.MODIFY(TRUE);
    //     UNTIL HandheldScanL.NEXT() = 0;

    //     //We can start the import process
    //     //Zero Pick Lines Qty. to Receive
    //     WarehouseActivityLineL.RESET;
    //     WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
    //     WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //     WarehouseActivityLineL.MODIFYALL("Qty. to Handle", 0);

    //     //Loop through Scanned Items and Update Pick Lines
    //     WarehouseActivityLineL.RESET;
    //     WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
    //     WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //     WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Take);
    //     HandheldTempTableL.RESET();
    //     IF HandheldTempTableL.FINDSET() THEN BEGIN
    //         WinL.OPEN(Text001L);
    //         LineNumberL := 0;
    //         LineCountL := HandheldTempTableL.COUNT;
    //         REPEAT
    //             QtyScndL := HandheldTempTableL."Quantity (Base)";
    //             WarehouseActivityLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
    //             WarehouseActivityLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
    //             WarehouseActivityLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
    //             WarehouseActivityLineL.SETRANGE("Lot No.", HandheldTempTableL."Lot No.");
    //             WarehouseActivityLineL.SETRANGE("Serial No.", HandheldTempTableL."Serial No.");
    //             WarehouseActivityLineL.SETRANGE("Expiration Date", HandheldTempTableL.Expiry);
    //             IF WarehouseActivityLineL.FINDSET(TRUE) THEN
    //                 REPEAT
    //                     RemQtyL := WarehouseActivityLineL."Qty. (Base)" - WarehouseActivityLineL."Qty. Handled (Base)";
    //                     IF QtyScndL > RemQtyL THEN
    //                         NewQtyL := RemQtyL
    //                     ELSE
    //                         NewQtyL := QtyScndL;
    //                     WarehouseActivityLineL.VALIDATE("Qty. to Handle", NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure");
    //                     WarehouseActivityLineL.MODIFY(TRUE);
    //                     QtyScndL := QtyScndL - NewQtyL;
    //                 UNTIL (WarehouseActivityLineL.NEXT = 0) OR (QtyScndL <= 0);
    //             LineNumberL += 1;
    //             WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //         UNTIL HandheldTempTableL.NEXT = 0;
    //         WinL.CLOSE;
    //     END;

    //     //Modify Place Lines
    //     WarehouseActivityLineL.RESET;
    //     WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
    //     WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //     WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Take);
    //     WarehouseActivityLineL.SETFILTER("Qty. to Handle", '<>0');
    //     IF WarehouseActivityLineL.FINDSET(TRUE) THEN BEGIN
    //         REPEAT
    //             WarehouseActivityLine2L.RESET();
    //             WarehouseActivityLine2L.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
    //             WarehouseActivityLine2L.SETRANGE("No.", WarehouseActivityHeaderP."No.");
    //             WarehouseActivityLine2L.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Place);
    //             WarehouseActivityLine2L.SETRANGE("Item No.", WarehouseActivityLineL."Item No.");
    //             WarehouseActivityLine2L.SETRANGE("Variant Code", WarehouseActivityLineL."Variant Code");
    //             WarehouseActivityLine2L.SETRANGE("Unit of Measure Code", WarehouseActivityLineL."Unit of Measure Code");
    //             WarehouseActivityLine2L.SETRANGE("Serial No.", WarehouseActivityLineL."Serial No.");
    //             WarehouseActivityLine2L.SETRANGE("Lot No.", WarehouseActivityLineL."Lot No.");
    //             WarehouseActivityLine2L.SETFILTER("Qty. to Handle", '=0');
    //             IF WarehouseActivityLine2L.FINDFIRST() THEN BEGIN
    //                 WarehouseActivityLine2L.VALIDATE("Qty. to Handle", WarehouseActivityLineL."Qty. to Handle");
    //                 WarehouseActivityLine2L.MODIFY(TRUE);
    //             END;
    //         UNTIL WarehouseActivityLineL.NEXT() = 0;
    //     END;
    // end;

    procedure UpdateHandheldScanDirectedPicks(WarehouseActivityHeaderP: Record "Warehouse Activity Header")
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        WarehouseActivityLineL: Record "Warehouse Activity Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Pick Lines @1@@@@@@@@@@.';
        Text002L: Label 'There are no Handheld Scan lines for Pick %1.';
        QtyScndL: Decimal;
        NewQtyL: Decimal;
        RemQtyL: Decimal;
        WarehouseActivityLine2L: Record "Warehouse Activity Line";
        i: Integer;
        HandheldScanL2: Record "Stars HandHeld Scan";
        LineNo: Integer;
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Directed Pick");
        HandheldScanL.SETRANGE("Document No.", WarehouseActivityHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, WarehouseActivityHeaderP."No.");

        REPEAT
            //Check if the line should be grouped
            CLEAR(HandheldTempTableL);
            HandheldTempTableExistsL := FALSE;
            HandheldTempTableL.SETRANGE("Item No.", HandheldScanL."Item No.");
            HandheldTempTableL.SETRANGE("Variant Code", HandheldScanL."Variant Code");
            HandheldTempTableL.SETRANGE("Bin Code", HandheldScanL."Bin Code");
            HandheldTempTableL.SETRANGE("Lot No.", HandheldScanL."Lot No.");
            HandheldTempTableL.SETRANGE("Serial No.", HandheldScanL."Serial No.");
            HandheldTempTableL.SETRANGE(Expiry, HandheldScanL.Expiry);
            HandheldTempTableL.SETRANGE("lot No. to", Format(HandheldScanL."Line No."));
            HandheldTempTableExistsL := HandheldTempTableL.FINDFIRST();
            IF HandheldTempTableExistsL THEN BEGIN
                HandheldTempTableL.Quantity += HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" += HandheldScanL."Quantity (Base)";
                HandheldTempTableL.MODIFY();
            END ELSE BEGIN
                CLEAR(HandheldTempTableL);
                HandheldTempTableL."Barcode No." := HandheldScanL."Barcode No.";
                HandheldTempTableL."Item No." := HandheldScanL."Item No.";
                HandheldTempTableL."Variant Code" := HandheldScanL."Variant Code";
                HandheldTempTableL."Bin Code" := HandheldScanL."Bin Code";
                HandheldTempTableL."Lot No." := HandheldScanL."Lot No.";
                HandheldTempTableL."Serial No." := HandheldScanL."Serial No.";
                HandheldTempTableL.Expiry := HandheldScanL.Expiry;
                HandheldTempTableL.Quantity := HandheldScanL.Quantity;
                HandheldTempTableL."Quantity (Base)" := HandheldScanL."Quantity (Base)";
                HandheldTempTableL."lot No. to" := Format(HandheldScanL."Line No.");
                HandheldTempTableL.INSERT();
            END;
            //Set Handheld Scans as processed
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.Processed := TRUE;
            HandheldScanL2."Processed By" := USERID;
            HandheldScanL2."Processed Date/Time" := CURRENTDATETIME;
            HandheldScanL2.MODIFY(TRUE);
        UNTIL HandheldScanL.NEXT() = 0;

        //We can start the import process
        //Zero Pick Lines Qty. to Receive
        WarehouseActivityLineL.RESET;
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
        WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
        IF WarehouseActivityLineL.FIND('-') THEN
            REPEAT
                WarehouseActivityLineL.VALIDATE("Qty. to Handle", 0);
                WarehouseActivityLineL.MODIFY(TRUE);
            UNTIL WarehouseActivityLineL.NEXT = 0;

        //Loop through Scanned Items and Update Pick Lines
        WarehouseActivityLineL.RESET;
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
        WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
        WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Take);
        HandheldTempTableL.RESET();
        IF HandheldTempTableL.FINDSET() THEN BEGIN
            WinL.OPEN(Text001L);
            LineNumberL := 0;
            LineCountL := HandheldTempTableL.COUNT;
            REPEAT
                QtyScndL := HandheldTempTableL."Quantity (Base)";
                WarehouseActivityLineL.SETRANGE("Item No.", HandheldTempTableL."Item No.");
                WarehouseActivityLineL.SETRANGE("Variant Code", HandheldTempTableL."Variant Code");
                WarehouseActivityLineL.SETRANGE("Bin Code", HandheldTempTableL."Bin Code");
                WarehouseActivityLineL.SETRANGE("Lot No.", HandheldTempTableL."Lot No.");
                WarehouseActivityLineL.SETRANGE("Serial No.", HandheldTempTableL."Serial No.");
                WarehouseActivityLineL.SETRANGE("Expiration Date", HandheldTempTableL.Expiry);
                Evaluate(LineNo, HandheldTempTableL."Lot No. To");
                WarehouseActivityLineL.SETRANGE("Line No.", LineNo);
                IF WarehouseActivityLineL.FINDSET(TRUE) THEN
                    REPEAT
                        RemQtyL := WarehouseActivityLineL."Qty. (Base)" - WarehouseActivityLineL."Qty. Handled (Base)";
                        RemQtyL := RemQtyL - WarehouseActivityLineL."Qty. to Handle (Base)"; //Stars03.00
                        IF QtyScndL > RemQtyL THEN
                            NewQtyL := RemQtyL
                        ELSE
                            NewQtyL := QtyScndL;
                        //Stars03.00                  WarehouseActivityLineL.VALIDATE("Qty. to Handle", NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure");
                        WarehouseActivityLineL.VALIDATE("Qty. to Handle", WarehouseActivityLineL."Qty. to Handle" + NewQtyL / WarehouseActivityLineL."Qty. per Unit of Measure"); //Stars03.00
                        WarehouseActivityLineL.MODIFY(TRUE);
                        QtyScndL := QtyScndL - NewQtyL;
                    UNTIL (WarehouseActivityLineL.NEXT = 0) OR (QtyScndL <= 0);
                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;

        //Modify Place Lines
        WarehouseActivityLineL.RESET;
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
        WarehouseActivityLineL.SETRANGE("No.", WarehouseActivityHeaderP."No.");
        WarehouseActivityLineL.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Take);
        WarehouseActivityLineL.SETFILTER("Qty. to Handle", '<>0');
        IF WarehouseActivityLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                WarehouseActivityLine2L.RESET();
                WarehouseActivityLine2L.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
                WarehouseActivityLine2L.SETRANGE("No.", WarehouseActivityHeaderP."No.");
                WarehouseActivityLine2L.SETRANGE("Action Type", WarehouseActivityLineL."Action Type"::Place);
                WarehouseActivityLine2L.SETRANGE("Item No.", WarehouseActivityLineL."Item No.");
                WarehouseActivityLine2L.SETRANGE("Variant Code", WarehouseActivityLineL."Variant Code");
                WarehouseActivityLine2L.SETRANGE("Unit of Measure Code", WarehouseActivityLineL."Unit of Measure Code");
                WarehouseActivityLine2L.SETRANGE("Serial No.", WarehouseActivityLineL."Serial No.");
                WarehouseActivityLine2L.SETRANGE("Lot No.", WarehouseActivityLineL."Lot No.");
                WarehouseActivityLine2L.SETRANGE("Qty. to Handle", 0);
                IF WarehouseActivityLine2L.FINDFIRST() THEN BEGIN
                    WarehouseActivityLine2L.VALIDATE("Qty. to Handle", WarehouseActivityLineL."Qty. to Handle");
                    WarehouseActivityLine2L.MODIFY(TRUE);
                END;
            UNTIL WarehouseActivityLineL.NEXT() = 0;
        END;
    end;

    //Test Adv-

    [Scope('OnPrem')]
    procedure UpdateHandheldScanPhysInventory(ItemJournalLineP: Record "Item Journal Line")
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldTempTableL: Record "Stars HandHeld Temp Table" temporary;
        HandheldTempTableExistsL: Boolean;
        ItemJournalLineL: Record "Item Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Phys. Inventory Lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Phys. Inventory %1 %2.';
    begin
        GroupByOptionL := GroupByOptionL::"By Item/Variant";
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, ItemJournalLineP."Journal Template Name", ItemJournalLineP."Journal Batch Name");

        //Zero phys. inventory lines
        ItemJournalLineL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        ItemJournalLineL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        ItemJournalLineL.MODIFYALL("Qty. (Phys. Inventory)", 0, TRUE);

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
                    ItemJournalLineL.MODIFY(TRUE);
                END;
                LineNumberL += 1;
                WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
            UNTIL HandheldTempTableL.NEXT = 0;
            WinL.CLOSE;
        END;
    end;

    //Test Adv+

    //[Scope('OnPrem')]
    // procedure UpdateHandheldScanPhysInventoryDir(WarehouseJournalLineP: Record "Warehouse Journal Line")
    // var
    //     GroupByOptionL: Option "By Barcode","By Item/Variant";
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     WarehouseJournalLineL: Record "Warehouse Journal Line";
    //     LineCountL: Integer;
    //     LineNumberL: Integer;
    //     WinL: Dialog;
    //     Text001L: Label 'Importing Phys. Inventory lines @1@';
    //     Text002L: Label 'There are no Handheld Scan lines for Phys. Inventory %1 %2.';
    // begin
    //     HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
    //     HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
    //     HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Dir. Phys. Inventory");
    //     HandheldScanL.SETRANGE("Journal Template Name", WarehouseJournalLineP."Journal Template Name");
    //     HandheldScanL.SETRANGE("Journal Batch Name", WarehouseJournalLineP."Journal Batch Name");
    //     HandheldScanL.SETRANGE("Document No.", WarehouseJournalLineP."Whse. Document No.");
    //     HandheldScanL.SETRANGE(Processed, FALSE);
    //     IF NOT HandheldScanL.FINDSET(TRUE) THEN
    //         ERROR(Text002L, WarehouseJournalLineP."Journal Template Name", WarehouseJournalLineP."Journal Batch Name");

    //     //Zero phys. inventory quantities
    //     WarehouseJournalLineL.SETRANGE("Journal Template Name", WarehouseJournalLineP."Journal Template Name");
    //     WarehouseJournalLineL.SETRANGE("Journal Batch Name", WarehouseJournalLineP."Journal Batch Name");
    //     WarehouseJournalLineL.SETRANGE("Location Code", WarehouseJournalLineP."Location Code");
    //     WarehouseJournalLineL.SETRANGE("Whse. Document No.", WarehouseJournalLineP."Whse. Document No.");
    //     WarehouseJournalLineL.MODIFYALL("Qty. (Phys. Inventory)", 0, TRUE);

    //     LineCountL := WarehouseJournalLineL.COUNT();

    //     //Update phys. inventory lines
    //     WinL.OPEN(Text001L);
    //     REPEAT
    //         IF WarehouseJournalLineL.GET(HandheldScanL."Journal Template Name", HandheldScanL."Journal Batch Name", HandheldScanL."Location Code", HandheldScanL."Line No.") THEN BEGIN
    //             WarehouseJournalLineL.VALIDATE("Qty. (Phys. Inventory)", HandheldScanL.Quantity);
    //             WarehouseJournalLineL.MODIFY(TRUE);
    //         END;
    //         HandheldScanL.VALIDATE(Processed, TRUE);
    //         HandheldScanL.VALIDATE("Processed By", USERID);
    //         HandheldScanL.VALIDATE("Processed Date/Time", CURRENTDATETIME);
    //         HandheldScanL.MODIFY(TRUE);
    //         LineNumberL += 1;
    //         WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
    //     UNTIL HandheldScanL.NEXT() = 0;
    //     WinL.CLOSE();
    // end;

    procedure UpdateHandheldScanPhysInventoryDir(WarehouseJournalLineP: Record "Warehouse Journal Line")
    var
        GroupByOptionL: Option "By Barcode","By Item/Variant";
        HandheldScanL: Record "Stars HandHeld Scan";
        WarehouseJournalLineL: Record "Warehouse Journal Line";
        LineCountL: Integer;
        LineNumberL: Integer;
        WinL: Dialog;
        Text001L: Label 'Importing Phys. Inventory lines @1@';
        Text002L: Label 'There are no Handheld Scan lines for Phys. Inventory %1 %2.';
        HandheldScanL2: Record "Stars HandHeld Scan";
    begin
        HandheldScanL.SETCURRENTKEY("Action Type", "Document Type", "Journal Template Name", "Journal Batch Name");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Dir. Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", WarehouseJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", WarehouseJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE("Document No.", WarehouseJournalLineP."Whse. Document No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        IF NOT HandheldScanL.FINDSET(TRUE) THEN
            ERROR(Text002L, WarehouseJournalLineP."Journal Template Name", WarehouseJournalLineP."Journal Batch Name");

        //Zero phys. inventory quantities
        WarehouseJournalLineL.SETRANGE("Journal Template Name", WarehouseJournalLineP."Journal Template Name");
        WarehouseJournalLineL.SETRANGE("Journal Batch Name", WarehouseJournalLineP."Journal Batch Name");
        WarehouseJournalLineL.SETRANGE("Location Code", WarehouseJournalLineP."Location Code");
        WarehouseJournalLineL.SETRANGE("Whse. Document No.", WarehouseJournalLineP."Whse. Document No.");
        WarehouseJournalLineL.MODIFYALL("Qty. (Phys. Inventory)", 0, TRUE);

        LineCountL := WarehouseJournalLineL.COUNT();

        //Update phys. inventory lines
        WinL.OPEN(Text001L);
        REPEAT
            IF WarehouseJournalLineL.GET(HandheldScanL."Journal Template Name", HandheldScanL."Journal Batch Name", HandheldScanL."Location Code", HandheldScanL."Line No.") THEN BEGIN
                WarehouseJournalLineL.VALIDATE("Qty. (Phys. Inventory)", HandheldScanL.Quantity);
                WarehouseJournalLineL.MODIFY(TRUE);
            END;
            HandheldScanL2.GET(HandheldScanL."Entry No.");
            HandheldScanL2.VALIDATE(Processed, TRUE);
            HandheldScanL2.VALIDATE("Processed By", USERID);
            HandheldScanL2.VALIDATE("Processed Date/Time", CURRENTDATETIME);
            HandheldScanL2.MODIFY(TRUE);

            LineNumberL += 1;
            WinL.UPDATE(1, ROUND(LineNumberL / LineCountL * 10000, 1));
        UNTIL HandheldScanL.NEXT() = 0;
        WinL.CLOSE();
    end;

    //Test Adv-

    [Scope('OnPrem')]
    procedure ShowScansDirectedPick(var WarehouseActivityHeaderP: Record "Warehouse Activity Header")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Directed Pick");
        HandheldScanL.SETRANGE("Document No.", WarehouseActivityHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansDirectedPutAway(var WarehouseActivityHeaderP: Record "Warehouse Activity Header")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Directed Put Away");
        HandheldScanL.SETRANGE("Document No.", WarehouseActivityHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansItemReclass()
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Create);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Item Reclassification");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    // [Scope('OnPrem')]
    procedure ShowScansMoveByItem()
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Create);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Movement by Item");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansPhysInventory(var ItemJournalLineP: Record "Item Journal Line")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", ItemJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", ItemJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE("Location Code", ItemJournalLineP."Location Code");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansPhysInventoryDir(var WarehouseJournalLineP: Record "Warehouse Journal Line")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Dir. Phys. Inventory");
        HandheldScanL.SETRANGE("Journal Template Name", WarehouseJournalLineP."Journal Template Name");
        HandheldScanL.SETRANGE("Journal Batch Name", WarehouseJournalLineP."Journal Batch Name");
        HandheldScanL.SETRANGE("Location Code", WarehouseJournalLineP."Location Code");
        HandheldScanL.SETRANGE("Document No.", WarehouseJournalLineP."Whse. Document No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansPurchaseOrder(var PurchaseHeaderP: Record "Purchase Header")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        IF (PurchaseHeaderP."Document Type" = PurchaseHeaderP."Document Type"::"Return Order") THEN
            HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Purchase Return Order")
        ELSE
            HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Purchase Order");
        HandheldScanL.SETRANGE("Document No.", PurchaseHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansTransferOrder(var TransferHeaderP: Record "Transfer Header")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.SETRANGE("Document No.", TransferHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansWarehouseReceipt(var WarehouseReceiptHeaderP: Record "Warehouse Receipt Header")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Warehouse Receipt");
        HandheldScanL.SETRANGE("Document No.", WarehouseReceiptHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;

    [Scope('OnPrem')]
    procedure ShowScansWarehouseShipment(var WarehouseShipmentHeaderP: Record "Warehouse Shipment Header")
    var
        HandheldScanL: Record "Stars HandHeld Scan";
        HandheldScansPageL: Page "Stars Handheld Scans";
    begin
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Update);
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Warehouse Shipment");
        HandheldScanL.SETRANGE("Document No.", WarehouseShipmentHeaderP."No.");
        HandheldScanL.SETRANGE(Processed, FALSE);
        HandheldScansPageL.SETTABLEVIEW(HandheldScanL);
        HandheldScansPageL.RUN();
    end;
}

