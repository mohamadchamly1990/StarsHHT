pageextension 51109 "Stars Blanket Purch. Subform" extends "Blanket Purchase Order Subform"
{
    actions
    {
        addlast(Processing)
        {
            action(ImportLinesFromExcel)
            {
                ApplicationArea = All;
                Caption = 'Import Lines from Excel';
                ToolTip = 'Import blanket purchase order lines from Excel.';
                Image = ImportExcel;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    GetCurrentPurchaseHeader(PurchaseHeader);

                    PurchaseHeader.TestField("Buy-from Vendor No.");
                    PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);

                    ImportBlanketPurchaseLines(PurchaseHeader);

                    CurrPage.Update(false);
                end;
            }
            action(ExportExcelTemplate)
            {
                ApplicationArea = All;
                Caption = 'Export Excel Template';
                ToolTip = 'Download the Excel template used to import blanket purchase order lines.';
                Image = ExportToExcel;

                trigger OnAction()
                begin
                    ExportBlanketPurchaseTemplate();
                end;
            }
        }
    }

    local procedure GetCurrentPurchaseHeader(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLineFilter: Record "Purchase Line";
        DocumentNo: Code[20];
    begin
        DocumentNo := Rec."Document No.";

        // When the Blanket Order has no lines yet,
        // get the document number from the page filter.
        if DocumentNo = '' then begin
            PurchaseLineFilter.Copy(Rec);

            if PurchaseLineFilter.GetFilter("Document No.") = '' then
                Error('The Blanket Purchase Order No. could not be determined.');

            DocumentNo := PurchaseLineFilter.GetRangeMin("Document No.");
        end;

        if not PurchaseHeader.Get(PurchaseHeader."Document Type"::"Blanket Order", DocumentNo)
        then
            Error('Blanket Purchase Order %1 was not found.', DocumentNo);
    end;

    local procedure ImportBlanketPurchaseLines(PurchaseHeader: Record "Purchase Header")
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        PurchaseLine: Record "Purchase Line";
        FileInStream: InStream;
        FileName: Text;
        SheetName: Text;
        RowNo: Integer;
        MaxRowNo: Integer;
        NextLineNo: Integer;
        ImportedLines: Integer;
    begin
        UploadIntoStream('Select Excel File', '', 'Excel Files (*.xlsx)|*.xlsx', FileName, FileInStream);

        if FileName = '' then
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();

        SheetName :=
            ExcelBuffer.SelectSheetsNameStream(FileInStream);

        if SheetName = '' then
            Error('No Excel sheet was selected.');

        ExcelBuffer.OpenBookStream(FileInStream, SheetName);

        ExcelBuffer.ReadSheet();

        MaxRowNo := GetMaximumRowNo(ExcelBuffer);

        if MaxRowNo < 2 then
            Error('The Excel sheet does not contain any data rows.');

        NextLineNo :=
            GetNextPurchaseLineNo(PurchaseHeader);

        // Row 1 contains column headers
        for RowNo := 2 to MaxRowNo do begin
            if GetCellText(ExcelBuffer, RowNo, 1) <> '' then begin
                CreateBlanketPurchaseLine(
                    ExcelBuffer,
                    RowNo,
                    PurchaseHeader,
                    PurchaseLine,
                    NextLineNo);

                ImportedLines += 1;
                NextLineNo += 10000;
            end;
        end;

        if ImportedLines = 0 then
            Error('No valid lines were found in the Excel file.');

        Message('%1 line(s) imported successfully into Blanket Purchase Order %2.', ImportedLines, PurchaseHeader."No.");
    end;

    local procedure CreateBlanketPurchaseLine(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; LineNo: Integer)
    var
        Location: Record Location;
        ItemNo: Code[20];
        VariantCode: Code[10];
        LocationCode: Code[10];
        BinCode: Code[20];
        UnitOfMeasureCode: Code[10];
        Quantity: Decimal;
        DirectUnitCost: Decimal;
    begin
        ReadExcelRow(ExcelBuffer, RowNo, ItemNo, VariantCode, LocationCode, BinCode, UnitOfMeasureCode, Quantity, DirectUnitCost);

        if not Location.Get(LocationCode) then
            Error('Location %1 does not exist. Excel row: %2.', LocationCode, RowNo);

        if Location."Bin Mandatory" and (BinCode = '') then
            Error('Bin Code is required for Location %1. Excel row: %2.', LocationCode, RowNo);

        Clear(PurchaseLine);
        PurchaseLine.Init();

        PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");

        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");

        PurchaseLine.Validate("Line No.", LineNo);

        PurchaseLine.Insert(true);

        PurchaseLine.Validate(Type, PurchaseLine.Type::Item);

        PurchaseLine.Validate("No.", ItemNo);

        if VariantCode <> '' then
            PurchaseLine.Validate("Variant Code", VariantCode);

        PurchaseLine.Validate("Location Code", LocationCode);

        if BinCode <> '' then
            PurchaseLine.Validate("Bin Code", BinCode);

        PurchaseLine.Validate("Unit of Measure Code", UnitOfMeasureCode);

        PurchaseLine.Validate(Quantity, Quantity);

        // Purchase documents use Direct Unit Cost
        PurchaseLine.Validate("Direct Unit Cost", DirectUnitCost);

        PurchaseLine.Modify(true);
    end;

    local procedure ReadExcelRow(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; var ItemNo: Code[20]; var VariantCode: Code[10]; var LocationCode: Code[10]; var BinCode: Code[20]; var UnitOfMeasureCode: Code[10]; var Quantity: Decimal; var DirectUnitCost: Decimal)
    var
        QuantityText: Text;
        DirectUnitCostText: Text;
    begin
        ItemNo := CopyStr(
            GetCellText(ExcelBuffer, RowNo, 1),
            1,
            MaxStrLen(ItemNo));

        VariantCode := CopyStr(
            GetCellText(ExcelBuffer, RowNo, 2),
            1,
            MaxStrLen(VariantCode));

        LocationCode := CopyStr(
            GetCellText(ExcelBuffer, RowNo, 3),
            1,
            MaxStrLen(LocationCode));

        BinCode := CopyStr(
            GetCellText(ExcelBuffer, RowNo, 4),
            1,
            MaxStrLen(BinCode));

        UnitOfMeasureCode := CopyStr(
            GetCellText(ExcelBuffer, RowNo, 5),
            1,
            MaxStrLen(UnitOfMeasureCode));

        QuantityText :=
            GetCellText(ExcelBuffer, RowNo, 6);

        DirectUnitCostText :=
            GetCellText(ExcelBuffer, RowNo, 7);

        if ItemNo = '' then
            Error(
                'Item No. is missing on Excel row %1.',
                RowNo);

        if LocationCode = '' then
            Error(
                'Location Code is missing on Excel row %1.',
                RowNo);

        if UnitOfMeasureCode = '' then
            Error(
                'Unit of Measure Code is missing on Excel row %1.',
                RowNo);

        if QuantityText = '' then
            Error(
                'Quantity is missing on Excel row %1.',
                RowNo);

        if not Evaluate(Quantity, QuantityText) then
            Error(
                'Invalid Quantity "%1" on Excel row %2.',
                QuantityText,
                RowNo);

        if Quantity <= 0 then
            Error(
                'Quantity must be greater than zero on Excel row %1.',
                RowNo);

        if DirectUnitCostText = '' then
            Error(
                'Direct Unit Cost is missing on Excel row %1.',
                RowNo);

        if not Evaluate(
            DirectUnitCost,
            DirectUnitCostText)
        then
            Error(
                'Invalid Direct Unit Cost "%1" on Excel row %2.',
                DirectUnitCostText,
                RowNo);

        if DirectUnitCost < 0 then
            Error(
                'Direct Unit Cost cannot be negative on Excel row %1.',
                RowNo);
    end;

    local procedure GetNextPurchaseLineNo(
        PurchaseHeader: Record "Purchase Header"): Integer
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();

        PurchaseLine.SetRange(
            "Document Type",
            PurchaseHeader."Document Type");

        PurchaseLine.SetRange(
            "Document No.",
            PurchaseHeader."No.");

        if PurchaseLine.FindLast() then
            exit(PurchaseLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetMaximumRowNo(
        var ExcelBuffer: Record "Excel Buffer" temporary): Integer
    begin
        ExcelBuffer.Reset();

        if ExcelBuffer.FindLast() then
            exit(ExcelBuffer."Row No.");

        exit(0);
    end;

    local procedure GetCellText(
        var ExcelBuffer: Record "Excel Buffer" temporary;
        RowNo: Integer;
        ColumnNo: Integer): Text
    begin
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange(
            "Row No.",
            RowNo);

        ExcelBuffer.SetRange(
            "Column No.",
            ColumnNo);

        if ExcelBuffer.FindFirst() then
            exit(
                DelChr(
                    ExcelBuffer."Cell Value as Text",
                    '<>',
                    ' '));

        exit('');
    end;



    local procedure ExportBlanketPurchaseTemplate()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetNameLbl: Label 'Blanket Purchase Lines';
        FileNameLbl: Label 'Blanket Purchase Order Import Template';
    begin
        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();

        // Excel headers
        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn(
            'Item No.',
            false,
            '',
            true,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'Variant Code',
            false,
            '',
            true,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'Location Code',
            false,
            '',
            true,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'Bin Code',
            false,
            '',
            true,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'Unit of Measure Code',
            false,
            '',
            true,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'Quantity',
            false,
            '',
            true,
            false,
            false,
            '0.00',
            ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(
            'Direct Unit Cost',
            false,
            '',
            true,
            false,
            false,
            '0.00',
            ExcelBuffer."Cell Type"::Number);

        // Optional example row
        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn(
            'ITEM001',
            false,
            '',
            false,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            '',
            false,
            '',
            false,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'MAIN',
            false,
            '',
            false,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'RECEIVE',
            false,
            '',
            false,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            'PCS',
            false,
            '',
            false,
            false,
            false,
            '',
            ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(
            100,
            false,
            '',
            false,
            false,
            false,
            '0.00',
            ExcelBuffer."Cell Type"::Number);

        ExcelBuffer.AddColumn(
            5.50,
            false,
            '',
            false,
            false,
            false,
            '0.00',
            ExcelBuffer."Cell Type"::Number);

        // Generate and download Excel
        ExcelBuffer.CreateNewBook(SheetNameLbl);

        ExcelBuffer.WriteSheet(
            SheetNameLbl,
            CompanyName,
            UserId);

        ExcelBuffer.CloseBook();

        ExcelBuffer.SetFriendlyFilename(FileNameLbl);

        ExcelBuffer.OpenExcel();
    end;

}