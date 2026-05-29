
pageextension 51004 "Stars Inventory Setup Ext." extends "Inventory Setup"
{
    layout
    {
        addafter("Gen. Journal Templates")
        {
            group(Hanheld)
            {

                field("Default Store Pricing"; Rec."Stars Default Store Pricing")
                {
                    ApplicationArea = All;
                    Caption = 'Default Store Pricing';
                }
            }

        }
    }
}
