// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51003 "Stars Handheld Temp Table"
{
    Access = internal;
    DataClassification = ToBeClassified;
    Caption = 'Stars HandHeld Temp Table';
    fields
    {
        field(10; "Barcode No."; Code[20])
        {
            Caption = 'Barcode No.';

        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';

        }

        field(30; "Variant Code"; Code[20])
        {
            Caption = 'Variant Code';

        }

        field(40; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

        }
        field(50; "Location Code To"; Code[10])
        {
            Caption = 'Location Code To';
            TableRelation = Location;

        }
        field(60; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';

        }

        field(70; "Bin Code To"; Code[20])
        {
            Caption = 'Bin Code To';

        }
        field(80; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';

        }
        field(90; "Lot No. To"; Code[20])
        {
            Caption = 'Lot No. To';

        }
        field(100; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';

        }
        field(110; "Serial No. To"; Code[20])
        {
            Caption = 'Serial No. To';

        }
        field(120; "Expiry"; Date)
        {
            Caption = 'Expiry';

        }
        field(130; "Expiry To"; Date)
        {
            Caption = 'Expiry To';

        }

        field(150; "Quantity"; Decimal)
        {
            Caption = 'Quantity';

        }
        field(160; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';

        }

    }

    keys
    {
        key(Key1; "Barcode No.", "Item No.", "Variant Code", "Location Code", "Location Code To", "Bin Code", "Bin Code To", "Lot No.", "Lot No. To", "Serial No.", "Serial No. To", "Expiry", "Expiry To")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code", "Location Code", "Bin Code", "Lot No.", "Serial No.")
        {
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