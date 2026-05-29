// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51005 "Stars Handheld Journl Security"
{
    DataClassification = ToBeClassified;
    Caption = 'Stars Handheld Journal Security';
    Access = internal;
    fields
    {
        field(10; "Handheld User"; Code[50])
        {
            Caption = 'Handheld User';
            TableRelation = "Stars Handheld Users"."Handheld User ID";
        }
        field(20; "Item Journal Template"; Code[10])
        {
            Caption = 'Item Journal Template';
            TableRelation = "Item Journal Template".Name;
        }
        field(30; "Item Journal Batch"; Code[10])
        {
            Caption = 'Item Journal Batch';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Item Journal Template"));
        }
        field(40; "Default Location"; Code[10])
        {
            Editable = false;
            Caption = 'Default Location';
            FieldClass = FlowField;
            CalcFormula = Lookup("Stars Handheld Loc Security"."Location Code" WHERE(ID = FIELD("Handheld User"), "Is Default" = CONST(true)));

        }

    }

    keys
    {
        key(Key1; "Handheld User", "Item Journal Template", "Item Journal Batch")
        {
            Clustered = true;
        }
    }



}
