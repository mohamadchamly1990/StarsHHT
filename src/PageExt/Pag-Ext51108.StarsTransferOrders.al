pageextension 51108 "Stars Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Create &Whse. Receipt")
        {
            action("Import Transfer Order Template From Excel")
            {
                Caption = 'Import Transfer Order';
                ApplicationArea = All;
                Image = ImportExcel;

                trigger OnAction()
                var


                begin
                    ImportTransferOrdersFromExcel();
                end;
            }
            action("Export Transfer Order Template To Excel")
            {
                Caption = 'Export Transfer Order Template';
                ApplicationArea = All;
                Image = ExportToExcel;

                trigger OnAction()
                var


                begin
                    ExportTransferOrdersToExcel();
                end;
            }
            action("Inventory movement Template To Excel")
            {
                Caption = 'Inventory movement Template';
                ApplicationArea = All;
                Image = ExportToExcel;

                trigger OnAction()
                var
                    wmsonline: codeunit "Stars WMS Online Functions";
                begin
                    wmsonline.GetRetailPricePerBarcode('8058192141751');
                end;
            }

        }
    }
    // procedure ImportTransferOrdersFromExcel()
    // var
    // ExcelBufferTemp: Record "Excel Buffer" temporary;
    // TempExcelBuffer: Record "Excel Buffer" temporary;
    // InStream: InStream;
    // FromFile: Text;
    // SheetName: Text;
    // RowNo: Integer;
    // RowNo2: Integer;
    // MaxRowNo: Integer;
    // CurrDocNo: Code[20];
    // LastDocNo: Code[20];
    // LineNo: Integer;
    // Qty: Decimal;
    // UnitOfMeasure: Code[10];
    // TransferHeader: Record "Transfer Header";
    // TransferLine: Record "Transfer Line";
    // TransferHeaderTemp: Record "Transfer Header" temporary;
    // CurrFromCode: Code[10];
    // CurrToCode: Code[10];
    // TransTemp: Code[20];
    // begin
    // // Step 1: Upload Excel
    // UploadIntoStream('Select the Excel file to Import', '', '', FromFile, InStream);
    // if FromFile = '' then
    // Error('File not found');

    // ExcelBufferTemp.Reset();
    // ExcelBufferTemp.DeleteAll();

    // SheetName := ExcelBufferTemp.SelectSheetsNameStream(InStream);

    // ExcelBufferTemp.OpenBookStream(InStream, SheetName);
    // ExcelBufferTemp.ReadSheet();

    // ExcelBufferTemp.Reset();
    // if ExcelBufferTemp.FindFirst() then
    // repeat
    //   TempExcelBuffer.Init();
    //   TempExcelBuffer := ExcelBufferTemp;
    //   TempExcelBuffer.Insert();
    // until ExcelBufferTemp.Next() = 0;

    // // Step 2: Determine max row
    // RowNo := 2; // Assuming first row = headers
    // MaxRowNo := 0;
    // ExcelBufferTemp.Reset();
    // if ExcelBufferTemp.FindLast() then
    // MaxRowNo := ExcelBufferTemp."Row No.";

    // LastDocNo := '';
    // LineNo := 0;
    // TransTemp := 'C1';

    // // Step 3: Loop through rows
    // for RowNo := 2 to MaxRowNo do begin
    // // CurrDocNo := GetValueAtCell(ExcelBufferTemp, RowNo, 1); // Column 1 = TransferOrderNo
    // // if CurrDocNo <> LastDocNo then begin
    // // // New header
    // // LastDocNo := CurrDocNo;
    // // CreateTransferHeader(ExcelBufferTemp, RowNo, TransferHeader, CurrDocNo);
    // // LineNo := 0;
    // // end;

    // // // Create lines
    // // CreateTransferLine(ExcelBufferTemp, RowNo, TransferHeader, TransferLine, LineNo);

    // TransferHeaderTemp.Reset();
    // TransferHeaderTemp.SetRange("Transfer-from Code", GetValueAtCell(ExcelBufferTemp, RowNo, 1));
    // TransferHeaderTemp.SetRange("Transfer-to Code", GetValueAtCell(ExcelBufferTemp, RowNo, 2));
    // if (not TransferHeaderTemp.FindFirst()) then begin
    //   TransferHeaderTemp.Init();
    //   TransferHeaderTemp."No." := TransTemp;
    //   TransferHeaderTemp."Transfer-from Code" := GetValueAtCell(ExcelBufferTemp, RowNo, 1);
    //   TransferHeaderTemp."Transfer-to Code" := GetValueAtCell(ExcelBufferTemp, RowNo, 2);
    //   TransferHeaderTemp.Insert();

    //   TransTemp := IncStr(TransTemp);

    //   CreateTransferHeader(TransferHeaderTemp, TransferHeader);

    //   LineNo := 0;

    //   for RowNo2 := 2 to MaxRowNo do begin
    // CurrFromCode := GetValueAtCell(TempExcelBuffer, RowNo2, 1);
    // CurrToCode := GetValueAtCell(TempExcelBuffer, RowNo2, 2);

    // if (CurrFromCode = TransferHeaderTemp."Transfer-from Code") and (CurrToCode = TransferHeaderTemp."Transfer-to Code") then
    // CreateTransferLine(TempExcelBuffer, RowNo2, TransferHeader, TransferLine, LineNo);
    //   end;
    //   TransferHeader.MODIFY;
    //   COMMIT;
    //   Codeunit.Run(Codeunit::"Release Transfer Document", TransferHeader);
    // end;
    // end;
    // end;

    procedure ExportTransferOrdersToExcel()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('From-Store', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('To-Store', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Unit of Measure', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Variant', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Transfer-To Bin Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Transfer-from Bin Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);



        ExcelBuffer.CreateNewBook('Transfer Order Template');
        ExcelBuffer.WriteSheet('Transfer Order Template', CompanyName(), UserId());
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Transfer Order Template');
        ExcelBuffer.OpenExcel();
    end;

    procedure GetValueAtCell(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        ExcelBuffer.SetRange("Row No.", RowNo);
        ExcelBuffer.SetRange("Column No.", ColNo);
        if ExcelBuffer.FindFirst() then
            exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    // procedure CreateTransferHeader(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; var TransferHeader: Record "Transfer Header"; CurrDocNo: Code[20])
    // var
    // PostingDate: Date;
    // begin
    // TransferHeader.Init();

    // // if CurrDocNo = '' then
    // // TransferHeader."No." := TransferHeader.GetNextNo() // Auto-generate
    // // else
    // TransferHeader."No." := CurrDocNo;

    // TransferHeader.Validate("Transfer-from Code", GetValueAtCell(ExcelBuffer, RowNo, 2));
    // TransferHeader.Validate("Transfer-to Code", GetValueAtCell(ExcelBuffer, RowNo, 3));

    // TransferHeader.Validate("Posting Date", Today);
    // TransferHeader.Insert(true);
    // end;


    // procedure CreateTransferLine(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var LineNo: Integer)
    // var
    // Qty: Decimal;
    // Location: Record Location;
    // InventorySetup: Record "Inventory Setup";
    // begin
    // LineNo += 10000; // increment line number
    // InventorySetup.Get();
    // InventorySetup.TestField("Stars Bin Receiving");


    // TransferLine.Init();
    // TransferLine.Validate("Document No.", TransferHeader."No.");
    // TransferLine.Validate("Line No.", LineNo);
    // TransferLine.Insert(true);
    // TransferLine.Validate("Item No.", GetValueAtCell(ExcelBuffer, RowNo, 3));

    // if GetValueAtCell(ExcelBuffer, RowNo, 4) <> '' then
    // Evaluate(Qty, GetValueAtCell(ExcelBuffer, RowNo, 4));

    // TransferLine.Validate("Quantity", Qty);
    // TransferLine.Validate("Unit of Measure Code", GetValueAtCell(ExcelBuffer, RowNo, 5));
    // TransferLine.Validate("Variant Code", GetValueAtCell(ExcelBuffer, RowNo, 6));
    // //TransferLine.Validate("Transfer-To Bin Code", GetValueAtCell(ExcelBuffer, RowNo, 7));
    // //TransferLine.Validate("Transfer-from Bin Code", GetValueAtCell(ExcelBuffer, RowNo, 8));
    // If Location.Get(TransferHeader."Transfer-to Code") then
    // If Location."Bin Mandatory" then
    //   TransferLine.Validate("Transfer-To Bin Code", InventorySetup."Stars Bin Receiving");

    // IF Location.Get(TransferHeader."Transfer-from Code") then
    // If Location."Bin Mandatory" then Begin

    //   GetBestBinForTransferFrom(TransferHeader, TransferLine, Qty);
    //   TransferLine."Transfer-from Bin Code" := InventorySetup."Stars Bin Shipping";
    // End;


    // TransferLine.Modify(true);
    // end;

    // local procedure GetBestBinForTransferFrom(TransferHeader: Record "Transfer Header"; TransferLine: Record "Transfer Line"; var BestQty: Decimal)
    // var
    // BinContent: Record "Bin Content";
    // BestBinCode: Code[20];
    // IntMovHeaderL: Record "Internal Movement Header";
    // IntMovLineL: Record "Internal Movement Line";
    // InventorySetup: Record "Inventory Setup";
    // LineNoL: Integer;
    // CreateInvtPickMovementL: Codeunit "Create Inventory Pick/Movement";
    // WhseRequest: Record "Warehouse Request";
    // begin
    // Clear(BestBinCode);
    // BestQty := 0;
    // InventorySetup.Get();

    // BinContent.Reset();
    // BinContent.SetRange("Location Code", TransferHeader."Transfer-from Code");
    // BinContent.SetRange("Item No.", TransferLine."Item No.");
    // BinContent.SetRange("Variant Code", TransferLine."Variant Code");

    // if TransferLine."Unit of Measure Code" <> '' then
    // BinContent.SetRange("Unit of Measure Code", TransferLine."Unit of Measure Code");

    // if BinContent.FindSet() then
    // repeat
    //   BinContent.CalcFields(Quantity);
    //   if BinContent.Quantity > BestQty then begin
    // BestQty := BinContent.Quantity;
    // BestBinCode := BinContent."Bin Code";
    //   end;
    // until BinContent.Next() = 0;

    // IntMovHeaderL.INIT();
    // IntMovHeaderL.VALIDATE("No.", '');
    // IntMovHeaderL.INSERT(TRUE);
    // IntMovHeaderL.VALIDATE("Location Code", TransferHeader."Transfer-from Code");
    // IntMovHeaderL.MODIFY(TRUE);


    // IntMovLineL.SETRANGE("No.", IntMovHeaderL."No.");
    // IntMovLineL.SETRANGE("Item No.", TransferLine."Item No.");
    // IntMovLineL.SETRANGE("Variant Code", TransferLine."Variant Code");
    // IntMovLineL.SETRANGE("Unit of Measure Code", TransferLine."Unit of Measure Code");
    // IntMovLineL.SETRANGE("From Bin Code", BestBinCode);
    // IntMovLineL.SETRANGE("To Bin Code", InventorySetup."Stars Bin Shipping");
    // IF IntMovLineL.FINDFIRST() THEN BEGIN
    // IntMovLineL.VALIDATE(Quantity, IntMovLineL.Quantity + BestQty);
    // IntMovLineL.MODIFY(TRUE);
    // END ELSE BEGIN
    // CLEAR(IntMovLineL);
    // IntMovLineL.SETRANGE("No.", IntMovHeaderL."No.");
    // IF IntMovLineL.FINDLAST() THEN
    //   LineNoL := IntMovLineL."Line No.";
    // CLEAR(IntMovLineL);
    // IntMovLineL.INIT();
    // IntMovLineL.VALIDATE("No.", IntMovHeaderL."No.");
    // IntMovLineL.VALIDATE("Line No.", LineNoL + 10000);
    // IntMovLineL.VALIDATE("Item No.", TransferLine."Item No.");
    // IntMovLineL.VALIDATE("Variant Code", TransferLine."Variant Code");
    // IntMovLineL.VALIDATE("Unit of Measure Code", TransferLine."Unit of Measure Code");
    // IntMovLineL.VALIDATE("From Bin Code", BestBinCode);
    // IntMovLineL.VALIDATE("To Bin Code", InventorySetup."Stars Bin Shipping");
    // IntMovLineL.VALIDATE(Quantity, TransferLine.Quantity);
    // IntMovLineL.INSERT(TRUE);
    // END;

    // end;

    procedure ImportTransferOrdersFromExcel()
    var
        ExcelBufferTemp: Record "Excel Buffer" temporary;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        InStream: InStream;
        FromFile: Text;
        SheetName: Text;
        RowNo: Integer;
        RowNo2: Integer;
        MaxRowNo: Integer;
        LineNo: Integer;
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferHeaderTemp: Record "Transfer Header" temporary;
        IntMovHeader: Record "Internal Movement Header";
        CurrFromCode: Code[10];
        CurrToCode: Code[10];
        TransTemp: Code[20];
        CreateInvtPickMovementL: Codeunit "Create Inventory Pick/Movement";
        WhseActivityLineL: Record "Warehouse Activity Line";
        WhseRequest: Record "Warehouse Request";
        WMSOnlineFunctions: Codeunit "Stars WMS Online Functions";
    begin

        UploadIntoStream('Select the Excel file to Import', '', '', FromFile, InStream);

        if FromFile = '' then
            Error('File not found.');

        ExcelBufferTemp.Reset();
        ExcelBufferTemp.DeleteAll();

        SheetName := ExcelBufferTemp.SelectSheetsNameStream(InStream);

        ExcelBufferTemp.OpenBookStream(InStream, SheetName);
        ExcelBufferTemp.ReadSheet();


        ExcelBufferTemp.Reset();
        if ExcelBufferTemp.FindSet() then
            repeat
                TempExcelBuffer.Init();
                TempExcelBuffer := ExcelBufferTemp;
                TempExcelBuffer.Insert();
            until ExcelBufferTemp.Next() = 0;

        MaxRowNo := 0;

        ExcelBufferTemp.Reset();
        if ExcelBufferTemp.FindLast() then
            MaxRowNo := ExcelBufferTemp."Row No.";

        TransTemp := 'C1';


        for RowNo := 2 to MaxRowNo do begin

            CurrFromCode := GetValueAtCell(ExcelBufferTemp, RowNo, 1);

            CurrToCode := GetValueAtCell(ExcelBufferTemp, RowNo, 2);


            if (CurrFromCode <> '') and (CurrToCode <> '') then begin

                // Check whether this From/To combination
                // has already been processed
                TransferHeaderTemp.Reset();
                TransferHeaderTemp.SetRange("Transfer-from Code", CurrFromCode);

                TransferHeaderTemp.SetRange("Transfer-to Code", CurrToCode);

                if not TransferHeaderTemp.FindFirst() then begin

                    TransferHeaderTemp.Init();
                    TransferHeaderTemp."No." := TransTemp;
                    TransferHeaderTemp."Transfer-from Code" := CurrFromCode;
                    TransferHeaderTemp."Transfer-to Code" := CurrToCode;
                    TransferHeaderTemp.Insert();

                    TransTemp := IncStr(TransTemp);

                    CreateTransferHeader(TransferHeaderTemp, TransferHeader);


                    Clear(IntMovHeader);

                    CreateInternalMovementHeader(TransferHeader, IntMovHeader);

                    LineNo := 0;

                    for RowNo2 := 2 to MaxRowNo do begin

                        CurrFromCode :=
                        GetValueAtCell(TempExcelBuffer, RowNo2, 1);

                        CurrToCode :=
                        GetValueAtCell(TempExcelBuffer, RowNo2, 2);

                        if (CurrFromCode = TransferHeaderTemp."Transfer-from Code") and (CurrToCode = TransferHeaderTemp."Transfer-to Code") then
                            CreateTransferLine(TempExcelBuffer, RowNo2, TransferHeader, TransferLine, LineNo, IntMovHeader);
                    end;


                    Codeunit.Run(Codeunit::"Release Transfer Document", TransferHeader);
                    WMSOnlineFunctions.TransferZeroQtyToShip(TransferHeader."No.", '');

                    CreateInvtPickMovementL.SetWhseRequest(WhseRequest, True);
                    CreateInvtPickMovementL.CreateInvtMvntWithoutSource(IntMovHeader);

                    Commit();
                end;
            end;
        end;
    end;

    procedure CreateTransferHeader(var TransferHeaderTemp: Record "Transfer Header" temporary; var TransferHeader: Record "Transfer Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Stars RP Transfer No. Series");

        Clear(TransferHeader);
        TransferHeader.Init();
        TransferHeader."No." := NoSeriesMgt.GetNextNo(InventorySetup."Stars RP Transfer No. Series", WorkDate(), true);

        TransferHeader."No. Series" := InventorySetup."Stars RP Transfer No. Series";

        TransferHeader.Insert(true);

        TransferHeader.Validate("Transfer-from Code", TransferHeaderTemp."Transfer-from Code");

        TransferHeader.Validate("Transfer-to Code", TransferHeaderTemp."Transfer-to Code");

        TransferHeader.Validate("Posting Date", Today);

        TransferHeader.Modify(true);
    end;

    local procedure CreateInternalMovementHeader(TransferHeader: Record "Transfer Header"; var IntMovHeader: Record "Internal Movement Header")
    var
        Location: Record Location;
        InventorySetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        Clear(IntMovHeader);

        if not Location.Get(TransferHeader."Transfer-from Code")
        then
            exit;

        if not Location."Bin Mandatory" then
            exit;


        InventorySetup.Get();
        InventorySetup.TestField("stars RP IM No Series");

        IntMovHeader.Init();
        IntMovHeader."No." := NoSeriesMgt.GetNextNo(InventorySetup."stars RP IM No Series", WorkDate(), true);
        IntMovHeader."No. Series" := InventorySetup."stars RP IM No Series";
        IntMovHeader.Validate("Location Code", TransferHeader."Transfer-from Code");
        IntMovHeader.Insert(true);
    end;

    procedure CreateTransferLine(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var LineNo: Integer; var IntMovHeader: Record "Internal Movement Header")
    var
        Qty: Decimal;
        Location: Record Location;
        InventorySetup: Record "Inventory Setup";
        ItemNo: Code[20];
        UnitOfMeasureCode: Code[10];
        VariantCode: Code[10];

    begin
        InventorySetup.Get();

        ItemNo := GetValueAtCell(ExcelBuffer, RowNo, 3);

        UnitOfMeasureCode := GetValueAtCell(ExcelBuffer, RowNo, 5);

        VariantCode := GetValueAtCell(ExcelBuffer, RowNo, 6);

        if ItemNo = '' then
            Error('Item No. is missing on Excel row %1.', RowNo);


        Clear(Qty);

        if GetValueAtCell(ExcelBuffer, RowNo, 4) = ''
        then
            Error('Quantity is missing on Excel row %1.', RowNo);

        if not Evaluate(Qty, GetValueAtCell(ExcelBuffer, RowNo, 4))
        then
            Error('Invalid quantity "%1" on Excel row %2.', GetValueAtCell(ExcelBuffer, RowNo, 4), RowNo);

        if Qty <= 0 then
            Error('Quantity must be greater than zero on Excel row %1.', RowNo);


        LineNo += 10000;

        TransferLine.Init();

        TransferLine.Validate("Document No.", TransferHeader."No.");

        TransferLine.Validate("Line No.", LineNo);

        TransferLine.Insert(true);

        TransferLine.Validate("Item No.", ItemNo);

        if VariantCode <> '' then
            TransferLine.Validate("Variant Code", VariantCode);

        if UnitOfMeasureCode <> '' then
            TransferLine.Validate("Unit of Measure Code", UnitOfMeasureCode);

        TransferLine.Validate(Quantity, Qty);


        if Location.Get(TransferHeader."Transfer-to Code")
        then
            if Location."Bin Mandatory" then begin

                Location.TestField("Receipt Bin Code");

                TransferLine.Validate("Transfer-To Bin Code", InventorySetup."Stars Bin Receiving");
            end;

        if Location.Get(TransferHeader."Transfer-from Code")
        then
            if Location."Bin Mandatory" then begin

                Location.TestField("Shipment Bin Code");

                if IntMovHeader."No." = '' then
                    Error('Internal Movement Header was not created for Location %1.', TransferHeader."Transfer-from Code");

                // Add line to the SAME Internal Movement
                AddInternalMovementLine(IntMovHeader, TransferHeader, TransferLine, Qty);

                // Direct assignment because the item may not
                // physically exist in SHIP bin yet
                TransferLine."Transfer-from Bin Code" := InventorySetup."Stars Bin Shipping";
            end;

        TransferLine.Modify(true);

    end;

    local procedure AddInternalMovementLine(var IntMovHeader: Record "Internal Movement Header"; TransferHeader: Record "Transfer Header"; TransferLine: Record "Transfer Line"; RequestedQty: Decimal)
    var
        BinContent: Record "Bin Content";
        IntMovLine: Record "Internal Movement Line";
        InventorySetup: Record "Inventory Setup";
        BestBinCode: Code[20];
        BestBinQty: Decimal;
        LineNoL: Integer;
    begin

        Clear(BestBinCode);
        Clear(BestBinQty);



        BinContent.Reset();
        BinContent.SetRange("Location Code", TransferHeader."Transfer-from Code");
        BinContent.SetRange("Item No.", TransferLine."Item No.");
        BinContent.SetRange("Variant Code", TransferLine."Variant Code");
        BinContent.SetFilter("Bin Code", '<>%1', InventorySetup."Stars Bin Shipping");
        if TransferLine."Unit of Measure Code" <> '' then
            BinContent.SetRange("Unit of Measure Code", TransferLine."Unit of Measure Code");

        if BinContent.FindSet() then
            repeat
                BinContent.CalcFields(Quantity);

                if BinContent.Quantity > BestBinQty then begin
                    BestBinQty := BinContent.Quantity;

                    BestBinCode := BinContent."Bin Code";
                end

            until BinContent.Next() = 0;

        if BestBinCode = '' then
            Error('No bin with available quantity was found for Item %1, Variant %2, Location %3.', TransferLine."Item No.", TransferLine."Variant Code", TransferHeader."Transfer-from Code");

        if BestBinQty < RequestedQty then
            Error('Bin %1 contains only %2 for Item %3, but requested quantity is %4.', BestBinCode, BestBinQty, TransferLine."Item No.", RequestedQty);

        IntMovLine.Reset();
        IntMovLine.SetRange("No.", IntMovHeader."No.");
        IntMovLine.SetRange("Item No.", TransferLine."Item No.");
        IntMovLine.SetRange("Variant Code", TransferLine."Variant Code");
        IntMovLine.SetRange("Unit of Measure Code", TransferLine."Unit of Measure Code");
        IntMovLine.SetRange("From Bin Code", BestBinCode);
        IntMovLine.SetRange("To Bin Code", InventorySetup."Stars Bin Shipping");
        if IntMovLine.FindFirst() then begin
            // Same Item / Variant / UOM / From Bin
            // Add quantity to existing line
            IntMovLine.Validate(Quantity, IntMovLine.Quantity + RequestedQty);
            IntMovLine.Modify(true);

        end else begin

            Clear(LineNoL);
            IntMovLine.Reset();
            IntMovLine.SetRange("No.", IntMovHeader."No.");
            if IntMovLine.FindLast() then
                LineNoL := IntMovLine."Line No." + 10000
            else
                LineNoL := 10000;

            IntMovLine.Init();
            IntMovLine.Validate("No.", IntMovHeader."No.");
            IntMovLine.Validate("Line No.", LineNoL);
            IntMovLine.Validate("Item No.", TransferLine."Item No.");
            if TransferLine."Variant Code" <> '' then
                IntMovLine.Validate("Variant Code", TransferLine."Variant Code");

            if TransferLine."Unit of Measure Code" <> '' then
                IntMovLine.Validate("Unit of Measure Code", TransferLine."Unit of Measure Code");

            IntMovLine.Validate("From Bin Code", BestBinCode);

            IntMovLine.Validate("To Bin Code", InventorySetup."Stars Bin Shipping");

            IntMovLine.Validate(Quantity, RequestedQty);

            IntMovLine.Insert(true);
        end;

    end;

}