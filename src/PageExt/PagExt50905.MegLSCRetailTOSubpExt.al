///<summary>
/// Stars01.00 MN (11-03-24)
///</summary>

pageextension 51005 " LSC Retail TO. Subp. Ext" extends "LSC Retail TO. Subp."
{
    layout
    {
        // Add changes to page layout here
        modify("Variant Code")
        {
            Visible = true;
        }
        addafter("Variant Code")
        {
            field("Stars Barcode No."; Rec."Stars Barcode No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the entered barcode no. that was used to add item number, variant code, and unit of measure code of the corresponding line';
            }
        }
    }
}