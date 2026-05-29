page 51006 "Stars Handheld User Sec Card"
{

    Caption = 'Stars Handheld User Security Card';
    PageType = Card;
    SourceTable = "Stars Handheld Loc Security";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Is Default"; Rec."Is Default")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Default By field.';
                }
            }
            group(Purchase)
            {
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
                field("Purchase Order Creation"; Rec."Allow Purchase Creation")
                {
                    ToolTip = 'Specifies the value of the Allow Transfer To Location field.', Comment = '%';
                }
                field("Purchase Order Release"; Rec."Allow Purchase Release")
                {
                    ToolTip = 'Specifies the value of the Allow Purchase Release';
                }
            }
            group(Transfer)
            {
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
                field("Transfer Order Creation"; Rec."Allow Transfer Creation")
                {
                    ToolTip = 'Specifies the value of the Allow Transfer order creation.', Comment = '%';
                }
                field("Allow Transfer Receive"; Rec."Allow Transfer Receive")
                {
                    ToolTip = 'Specifies the value of Allow Transfer Receive';
                }
                field("Allow Transfer Ship"; Rec."Allow Transfer Ship")
                {
                    ToolTip = 'Specifies the value of Allow Transfer Ship';
                }
                field("Transfer Order Release"; Rec."Allow Transfer Release")
                {
                    ToolTip = 'Specifies the value of the Allow Transfer Order Release';
                }
            }
            // group("Direct Transfer")
            // {
            //     field("Allow Direct Transfer Creation"; Rec."Allow Direct Transfer Creation")
            //     {
            //         ToolTip = 'Specifies the value of the Allow Direct Transfer To Location field.', Comment = '%';
            //     }
            //     field("Allow Dir. Transfer From Loc."; Rec."Allow Dir. Transfer From Loc.")
            //     {
            //         ApplicationArea = All;
            //         ToolTip = 'Specifies the value of the Allow Direct Transfer From Location By field.';
            //     }
            //     field("Allow Dir. Transfer To Loc."; Rec."Allow Dir. Transfer To Loc.")
            //     {
            //         ApplicationArea = All;
            //         ToolTip = 'Specifies the value of the Allow Direct Transfer From Location By field.';
            //     }

            //     field("Post Direct Transfer Order"; Rec."Post Direct Transfer Order")
            //     {
            //         ApplicationArea = All;
            //         ToolTip = 'Specifies the value of the post Direct Transfer order.';
            //     }
            // }
            group(Sales)
            {
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
                field("Sales Order Creation"; Rec."Allow Sales Creation")
                {
                    ToolTip = 'Specifies the value of the Allow Sales order creation.', Comment = '%';
                }
                field("Sales Order Release"; Rec."Allow Sales Release")
                {
                    ToolTip = 'Specifies the value of the Allow Sales Release field';
                }
            }
            group("Item Reclassification")
            {
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
            }
            group("Physical Inventory")
            {
                field("Allow Phys. Inv."; Rec."Allow Phys. Inv.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Phys. Inv.';
                }
            }

            group("Put Away Transfer")
            {
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
                field("Allow PutAway Transfer"; Rec."Allow PutAway Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow PutAway Transfer';
                }
                field("Allow PutAway Transfer From"; Rec."Allow PutAway Transfer From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow PutAway Transfer From';
                }
                field("Allow PutAway Transfer To"; Rec."Allow PutAway Transfer To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow PutAway Transfer To';
                }
            }
            group("Pick Transfer")
            {
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
                field("Allow Pick Transfer From"; Rec."Allow Pick Transfer From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Pick Transfer From';
                }
                field("Allow Pick Transfer To"; Rec."Allow Pick Transfer To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Pick Transfer To';
                }
            }
        }
    }
}
