pageextension 51008 "Stars Transfer Orders" extends "Transfer Orders"
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
        }
    }
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
        CurrDocNo: Code[20];
        LastDocNo: Code[20];
        LineNo: Integer;
        Qty: Decimal;
        UnitOfMeasure: Code[10];
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferHeaderTemp: Record "Transfer Header" temporary;
        CurrFromCode: Code[10];
        CurrToCode: Code[10];
        TransTemp: Code[20];
    begin
        // Step 1: Upload Excel
        UploadIntoStream('Select the Excel file to Import', '', '', FromFile, InStream);
        if FromFile = '' then
            Error('File not found');

        ExcelBufferTemp.Reset();
        ExcelBufferTemp.DeleteAll();

        SheetName := ExcelBufferTemp.SelectSheetsNameStream(InStream);

        ExcelBufferTemp.OpenBookStream(InStream, SheetName);
        ExcelBufferTemp.ReadSheet();

        ExcelBufferTemp.Reset();
        if ExcelBufferTemp.FindFirst() then
            repeat
                TempExcelBuffer.Init();
                TempExcelBuffer := ExcelBufferTemp;
                TempExcelBuffer.Insert();
            until ExcelBufferTemp.Next() = 0;

        // Step 2: Determine max row
        RowNo := 2; // Assuming first row = headers
        MaxRowNo := 0;
        ExcelBufferTemp.Reset();
        if ExcelBufferTemp.FindLast() then
            MaxRowNo := ExcelBufferTemp."Row No.";

        LastDocNo := '';
        LineNo := 0;
        TransTemp := 'C1';

        // Step 3: Loop through rows
        for RowNo := 2 to MaxRowNo do begin
            // CurrDocNo := GetValueAtCell(ExcelBufferTemp, RowNo, 1); // Column 1 = TransferOrderNo
            // if CurrDocNo <> LastDocNo then begin
            //     // New header
            //     LastDocNo := CurrDocNo;
            //     CreateTransferHeader(ExcelBufferTemp, RowNo, TransferHeader, CurrDocNo);
            //     LineNo := 0;
            // end;

            // // Create lines
            // CreateTransferLine(ExcelBufferTemp, RowNo, TransferHeader, TransferLine, LineNo);

            TransferHeaderTemp.Reset();
            TransferHeaderTemp.SetRange("Transfer-from Code", GetValueAtCell(ExcelBufferTemp, RowNo, 1));
            TransferHeaderTemp.SetRange("Transfer-to Code", GetValueAtCell(ExcelBufferTemp, RowNo, 2));
            if (not TransferHeaderTemp.FindFirst()) then begin
                TransferHeaderTemp.Init();
                TransferHeaderTemp."No." := TransTemp;
                TransferHeaderTemp."Transfer-from Code" := GetValueAtCell(ExcelBufferTemp, RowNo, 1);
                TransferHeaderTemp."Transfer-to Code" := GetValueAtCell(ExcelBufferTemp, RowNo, 2);
                TransferHeaderTemp.Insert();

                TransTemp := IncStr(TransTemp);

                CreateTransferHeader(TransferHeaderTemp, TransferHeader);

                LineNo := 0;

                for RowNo2 := 2 to MaxRowNo do begin
                    CurrFromCode := GetValueAtCell(TempExcelBuffer, RowNo2, 1);
                    CurrToCode := GetValueAtCell(TempExcelBuffer, RowNo2, 2);

                    if (CurrFromCode = TransferHeaderTemp."Transfer-from Code") and (CurrToCode = TransferHeaderTemp."Transfer-to Code") then
                        CreateTransferLine(TempExcelBuffer, RowNo2, TransferHeader, TransferLine, LineNo);
                end;

                //                TransferHeader.DeleteTransferOrderLines(TRUE);
                //              TransferHeader.ValidateTOOriginalQuantity;                
                TransferHeader.MODIFY;
                COMMIT;
            end;
        end;
    end;

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
    //     PostingDate: Date;
    // begin
    //     TransferHeader.Init();

    //     // if CurrDocNo = '' then
    //     //     TransferHeader."No." := TransferHeader.GetNextNo() // Auto-generate
    //     // else
    //     TransferHeader."No." := CurrDocNo;

    //     TransferHeader.Validate("Transfer-from Code", GetValueAtCell(ExcelBuffer, RowNo, 2));
    //     TransferHeader.Validate("Transfer-to Code", GetValueAtCell(ExcelBuffer, RowNo, 3));

    //     TransferHeader.Validate("Posting Date", Today);
    //     TransferHeader.Insert(true);
    // end;

    procedure CreateTransferHeader(var TransferHeaderTemp: Record "Transfer Header" temporary; var TransferHeader: Record "Transfer Header")
    var
        PostingDate: Date;
        InventorySetup: Record "Inventory Setup";
    begin
        Clear(TransferHeader);
        InventorySetup.Get();

        TransferHeader.Init();
        TransferHeader.Insert(true);

        //TransferHeader.Validate("LSC Store-from", TransferHeaderTemp."Transfer-from Code");
        TransferHeader.Validate("Transfer-from Code", TransferHeaderTemp."Transfer-from Code");

        //TransferHeader.Validate("LSC Store-to", TransferHeaderTemp."Transfer-to Code");
        TransferHeader.Validate("Transfer-to Code", TransferHeaderTemp."Transfer-to Code");

        // TransferHeader.Validate("In-Transit Code", InventorySetup."Meg Default Intransit Code");

        TransferHeader.Validate("Posting Date", Today);
        TransferHeader.Modify(true);
    end;

    procedure CreateTransferLine(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var LineNo: Integer)
    var
        Qty: Decimal;
    begin
        LineNo += 10000; // increment line number

        TransferLine.Init();
        TransferLine.Validate("Document No.", TransferHeader."No.");
        TransferLine.Validate("Line No.", LineNo);
        TransferLine.Insert(true);
        TransferLine.Validate("Item No.", GetValueAtCell(ExcelBuffer, RowNo, 3));

        if GetValueAtCell(ExcelBuffer, RowNo, 4) <> '' then
            Evaluate(Qty, GetValueAtCell(ExcelBuffer, RowNo, 4));

        TransferLine.Validate("Quantity", Qty);
        TransferLine.Validate("Unit of Measure Code", GetValueAtCell(ExcelBuffer, RowNo, 5));
        TransferLine.Validate("Variant Code", GetValueAtCell(ExcelBuffer, RowNo, 6));
        TransferLine.Validate("Transfer-To Bin Code", GetValueAtCell(ExcelBuffer, RowNo, 7));
        TransferLine.Validate("Transfer-from Bin Code", GetValueAtCell(ExcelBuffer, RowNo, 8));


        TransferLine.Modify(true);
    end;

}