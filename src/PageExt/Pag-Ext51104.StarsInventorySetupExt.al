
pageextension 51104 "Stars Inventory Setup Ext." extends "Inventory Setup"
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
                field("Stars Bin Receiving"; Rec."Stars Bin Receiving")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stars Bin Receiving field.', Comment = '%';
                }
                field("Stars Bin Shipping"; Rec."Stars Bin Shipping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stars Bin Shipping field.', Comment = '%';
                }
                field("stars RP IM No Series"; Rec."stars RP IM No Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stars Replenishment IM No. series field.', Comment = '%';
                }

                field("Stars RP Transfer No. Series"; Rec."Stars RP Transfer No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stars Replenishment TO No. series field.', Comment = '%';
                }
            }

        }
    }
    actions
    {
        addafter("Import Item Pictures")
        {
            action("Price Check")
            {
                Caption = 'TEST Price Check';
                ApplicationArea = All;
                Image = Action;

                trigger OnAction()
                var
                    PriceCheck: Codeunit "Stars WMS Online Functions";
                begin
                    Message(PriceCheck.GetRetailPricePerBarcode('1111'));
                end;
            }
        }
    }
}
