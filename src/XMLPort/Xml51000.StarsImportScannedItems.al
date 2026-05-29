// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
xmlport 51000 "Stars Import Scanned Items"
{
    Caption = 'Stars Import Scanned Items';
    Format = VariableText;
    Direction = Import;
    UseRequestPage = false;
    FieldSeparator = '|';
    FieldDelimiter = '<">';
    RecordSeparator = '<<NewLine>>';
    TableSeparator = '<<NewLine><NewLine>>';

    TextEncoding = MSDOS;


    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                UseTemporary = false;
                AutoSave = false;
                AutoReplace = false;
                AutoUpdate = false;
                textelement(BarcodeNo)
                {
                    MinOccurs = Once;
                }
                textelement(ItemNo)
                {
                    MinOccurs = Once;
                }
                textelement(Quantity)
                {
                    MinOccurs = Once;
                }
                textelement(QuantityBase)
                {
                    MinOccurs = Once;
                }
                textelement(LocationCode)
                {
                    MinOccurs = Once;
                }
                trigger OnBeforeInsertRecord()
                var

                begin
                    cnt := cnt + 1;
                    Integer.Number := cnt;
                end;

                trigger OnAfterInsertRecord()
                begin

                    CASE GroupByOption OF
                        GroupByOption::"By Barcode":
                            BEGIN
                                IF NOT TempBarcodes.GET(BarcodeNo) THEN BEGIN
                                    TempBarcodes.INIT;
                                    TempBarcodes."Barcode No." := BarcodeNo;
                                    TempBarcodes.INSERT;
                                END;
                                TempBarcodes."Discount %" := TempBarcodes."Discount %" + TextToDecimal(Quantity);
                                TempBarcodes.MODIFY;
                            END;

                        GroupByOption::"By Item/Variant":
                            BEGIN
                                Barcodes.GET(BarcodeNo);
                                IF NOT TempItemVariant.GET(Barcodes."Item No.", Barcodes."Variant Code") THEN BEGIN
                                    TempItemVariant.INIT;
                                    TempItemVariant."Item No." := Barcodes."Item No.";
                                    TempItemVariant.Code := Barcodes."Variant Code";
                                    TempItemVariant.INSERT;
                                END;
                                TempItemVariant.Length := TempItemVariant.Length + TextToDecimal(QuantityBase);
                                TempItemVariant.MODIFY;
                            END;
                    END;
                end;

                trigger OnAfterInitRecord()
                begin
                    CLEAR(BarcodeNo);
                    CLEAR(ItemNo);
                    CLEAR(Quantity);
                    CLEAR(QuantityBase);
                end;

                trigger OnAfterModifyRecord()
                begin

                end;
            }
        }
    }


    trigger OnPostXmlPort()
    begin

    end;

    trigger OnPreXmlPort()
    begin

    end;


    procedure GetBarcodeTmpTable(VAR TempBarcodes2: Record "LSC Barcodes" TEMPORARY)
    var
        myInt: Integer;
    begin
        CLEAR(TempBarcodes);
        IF TempBarcodes.FIND('-') THEN
            REPEAT
                TempBarcodes2.INIT;
                TempBarcodes2 := TempBarcodes;
                TempBarcodes2.INSERT;
            UNTIL TempBarcodes.NEXT = 0;
    end;

    procedure GetItemVariantTmpTable(VAR TempItemVariant2: Record "Item Unit of Measure" TEMPORARY)
    var
        myInt: Integer;
    begin
        CLEAR(TempItemVariant);
        IF TempItemVariant.FIND('-') THEN
            REPEAT
                TempItemVariant2.INIT;
                TempItemVariant2 := TempItemVariant;
                TempItemVariant2.INSERT;
            UNTIL TempItemVariant.NEXT = 0;
    end;


    procedure fGroupByOption(pGroupbyOption: Integer)
    var
        myInt: Integer;
    begin
        GroupByOption := pGroupbyOption;
    end;

    procedure GetLocationCode(VAR LocCode: Code[20])
    begin
        LocCode := LocationCode;
    end;


    procedure TextToDecimal(var VarText: Text[250]): Decimal
    var
        VarDecimal: Decimal;
    begin
        IF VarText = '' THEN VarText := '0';
        EVALUATE(VarDecimal, VarText);
        EXIT(VarDecimal);

    end;

    var
        Barcodes: Record "LSC Barcodes";
        TempBarcodes: Record "LSC Barcodes" temporary;
        TempItemVariant: Record "Item Unit of Measure" temporary;
        GroupByOption: Option "By Barcode","By Item/Variant";
        //FileName: Text[1024];
        cnt: Integer;
}
