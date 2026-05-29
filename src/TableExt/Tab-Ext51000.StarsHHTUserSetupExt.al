tableextension 51000 "Stars HHT User Setup Ext" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here

        field(51000; "St Phys.Inv.Unprocess Sessions"; Boolean)
        {
            Caption = 'Stars Phys. Inv. Unprocess Sessions';
        }
        field(51001; "Stars Phys.Inv.Delete Sessions"; Boolean)
        {
            Caption = 'Stars Phys. Inv. Delete Sessions';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}