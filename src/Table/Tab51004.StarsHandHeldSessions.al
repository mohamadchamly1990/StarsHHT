// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51004 "Stars HandHeld Sessions"
{
    DataClassification = ToBeClassified;
    Caption = 'Stars HandHeld Sessions';
    Access = internal;
    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            Editable = false;

        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            Editable = false;


        }
        field(30; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;

        }
        field(40; "Phys. Inv. Session"; Text[50])
        {
            Caption = 'Phys. Inv. Session';
            Editable = false;

        }
        field(50; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;

        }
        field(60; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location.Code;

        }
        field(70; "Scanned By"; Code[50])
        {
            Caption = 'Scanned By';
            Editable = false;

        }
        field(80; "Line Count"; Integer)
        {
            Caption = 'Line Count';
            Editable = false;

        }

        field(90; "Mark Session"; Boolean)
        {
            Caption = 'Mark Session';

        }


    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Document No.", "Phys. Inv. Session", "User ID", "Location Code", "Scanned By")
        {
            Clustered = true;
        }
    }


    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}