pageextension 51001 "Stars User Setup" extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Phys. Inv. Unprocess Sessions"; Rec."St Phys.Inv.Unprocess Sessions")
            {
                ApplicationArea = All;
                Caption = 'Phys. Inv. Unprocess Sessions';
            }
            field("Phys. Inv. Delete Sessions"; Rec."Stars Phys.Inv.Delete Sessions")
            {
                ApplicationArea = All;
                Caption = 'Phys. Inv. Delete Sessions';
            }
        }
    }
}