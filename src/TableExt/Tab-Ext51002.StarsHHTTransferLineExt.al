// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
tableextension 51002 "Stars HHT Transfer Line Ext" extends "Transfer Line"
{
    fields
    {
        field(51000; "Stars Barcode No."; Code[20])
        {
            Caption = 'Stars Barcode No.';

            trigger OnValidate()
            var
                Barcode: Record "LSC Barcodes";
            begin
                Barcode.Get("Stars Barcode No.");
                Validate("Item No.", Barcode."Item No.");
                Validate("Variant Code", Barcode."Variant Code");
                Validate("Unit of Measure Code", Barcode."Unit of Measure Code");
            end;
        }
    }
}