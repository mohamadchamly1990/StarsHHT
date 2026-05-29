pageextension 51002 "Stars Item Journal Batches Ext" extends "Item Journal Batches"
{
    layout
    {
        addafter("Reason Code")
        {
            field("Handheld Location Code"; Rec."Stars Handheld Location Code")
            {
                ApplicationArea = All;
                Caption = 'Handheld Location Code';
            }
            field("Pick"; Rec."Stars Pick")
            {
                ApplicationArea = All;
                Caption = 'Pick';
            }
            field("Bin To Bin"; Rec."Stars Bin To Bin")
            {
                ApplicationArea = All;
                Caption = 'Bin To Bin';
            }
            field("Put-Away"; Rec."Stars Put-Away")
            {
                ApplicationArea = All;
                Caption = 'Put-Away';
            }
        }
    }
}