// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
page 51005 "Stars Handheld User Security"
{
    ApplicationArea = All;
    Caption = 'Stars Handheld User Security';
    PageType = List;
    SourceTable = "Stars HandHeld Loc Security";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Post Sales Shipment"; Rec."Post Sales Shipment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Sales Shipment By field.';
                }
                field("Post Sales Return Receipt"; Rec."Post Sales Return Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Sales Return Receipt field.';
                }
                field("Post Purchase Receipt"; Rec."Post Purchase Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Purchase Receipt field.';
                }
                field("Post Purchase Return Shipment"; Rec."Post Purchase Return Shipment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Purchase Return Shipment By field.';
                }
                field("Post Transfer Shipment"; Rec."Post Transfer Shipment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Transfer Shipment By field.';
                }
                field("Post Transfer Receipt"; Rec."Post Transfer Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Transfer Receipt By field.';
                }
                field("Allow Transfer From Location"; Rec."Allow Transfer From Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Transfer From Location By field.';
                }
                field("Allow Transfer To Location"; Rec."Allow Transfer To Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Transfer To Location By field.';
                }
                field("Purchase Order Creation"; Rec."Allow Purchase Creation")
                {
                    ToolTip = 'Specifies the value of the Allow Transfer To Location field.', Comment = '%';
                }
                field("Sales Order Creation"; Rec."Allow Sales Creation")
                {
                    ToolTip = 'Specifies the value of the Allow Transfer To Location field.', Comment = '%';
                }

                // field("Allow Direct Transfer Creation"; Rec."Allow Direct Transfer Creation")
                // {
                //     ToolTip = 'Specifies the value of the Allow Direct Transfer To Location field.', Comment = '%';
                // }
                // field("Allow Dir. Transfer From Loc."; Rec."Allow Dir. Transfer From Loc.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Allow Direct Transfer From Location By field.';
                // }
                // field("Allow Dir. Transfer To Loc."; Rec."Allow Dir. Transfer To Loc.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Allow Direct Transfer From Location By field.';
                // }

                // field("Post Direct Transfer Order"; Rec."Post Direct Transfer Order")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the post Direct Transfer order.';
                // }

                field("Allow Phys. Inv."; Rec."Allow Phys. Inv.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Phys. Inv..';
                }
                field("Allow Item Reclass. Bin To Bin"; Rec."Allow Item Reclass. Bin To Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Item Reclass. Journal.';
                }
                // field("Allow Item Reclass. Pick To Location"; Rec."Allow Item Reclass. Pick To Location")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Allow Item Reclass. Pick. To Location';
                // }
                // field("Allow Item Reclass. PutAway From Location"; Rec."Allow Item Reclass. PutAway From Location")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Allow Item Reclass. PutAway. From Location';
                // }
                field("Allow Put Away Transfer Post"; Rec."Allow Put Away Transfer Post")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Put Away Transfer Post';
                }
                field("Allow Put Away Transfer Creation"; Rec."Allow PutAway Trans. Creation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Put Away Transfer Creation';
                }
                field("Allow Pick Transfer Post Ship"; Rec."Allow Pick Transfer Post Ship")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Pick Transfer Post Ship';
                }
                field("Allow Pick Transfer Creation"; Rec."Allow Pick Transfer Creation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Pick Transfer Creation';
                }
                field("Allow Pick Transfer Post Receipt"; Rec."Allow Pick Trans. Post Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Pick Transfer Post Receipt';
                }
                field("Allow PutAway Transfer"; Rec."Allow PutAway Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow PutAway Transfer';
                }
                field("Allow Ship Transfer Pick"; Rec."Allow Ship Transfer Pick")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Ship Transfer Pick';
                }
                field("Allow Receive Transfer Pick"; Rec."Allow Receive Transfer Pick")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Receive Transfer Pick';
                }
                field("Allow Transfer Release"; Rec."Allow Transfer Release")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Transfer Release By field.';
                }
                field("Allow Purchase Release"; Rec."Allow Purchase Release")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Purchase Release By field.';
                }
                field("Allow Transfer Sales Release"; Rec."Allow Sales Release")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Transfer Sales Release By field.';
                }
                field("Allow Pick Transfer From"; Rec."Allow Pick Transfer From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Pick Transfer From';
                }
                field("Allow Pick Transfer To"; Rec."Allow Pick Transfer To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Pick Transfer To';
                }
                field("Allow PutAway Transfer From"; Rec."Allow PutAway Transfer From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow PutAway Transfer From';
                }
                field("Allow PutAway Transfer To"; Rec."Allow PutAway Transfer To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow PutAway Transfer To';
                }

                field("Allow Direct TO"; Rec."Allow Direct TO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Direct TO';
                }
                field("Allow Direct TO Creation"; Rec."Allow Direct TO Creation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Direct TO Creation';
                }
                field("Allow Direct PO Post"; Rec."Allow Direct PO Post")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Direct PO Post';
                }
                field("Allow Direct TO Post"; Rec."Allow Direct TO Post")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Direct TO Post';
                }

                field("Transfer Order Creation"; Rec."Allow Transfer Creation")
                {
                    ToolTip = 'Specifies the value of the Allow Transfer To Location field.', Comment = '%';
                }
                field("Allow Transfer Receive"; Rec."Allow Transfer Receive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Transfer Receive';
                }
                field("Allow Transfer Ship"; Rec."Allow Transfer Ship")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow Transfer Ship';
                }

                field("Is Default"; Rec."Is Default")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Default By field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("User Card")
            {
                ApplicationArea = all;
                Image = User;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'User Card';
                RunObject = page "Stars Handheld User Sec Card";
                RunPageLink = ID = field(ID), "Location Code" = field("Location Code");
            }
        }
    }
}
