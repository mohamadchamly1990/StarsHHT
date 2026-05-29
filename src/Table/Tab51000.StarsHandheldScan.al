// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51000 "Stars Handheld Scan"
{
    Caption = 'HandHeld Scan';
    // DataCaptionFields = "Code", Description;
    DrillDownPageID = "Stars Handheld Scans";
    //LookupPageID = "LSC Seasons";
    Access = internal;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            NotBlank = true;
            AutoIncrement = true;
        }
        field(20; "Action Type"; Enum "Stars HandHeld Scan Action Type")
        {
            Caption = 'Action Type';
        }
        field(30; "Document Type"; Enum "Stars HandHeld Scan Doc. Type")
        {
            Caption = 'Document Type';
        }
        field(40; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(50; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(60; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(70; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(80; "Barcode No."; Code[20])
        {
            Caption = 'Barcode No.';
            TableRelation = "LSC Barcodes"."Barcode No.";
            trigger OnValidate()
            begin

                ItemCrossReferenceG.SETRANGE("Reference Type", ItemCrossReferenceG."Reference Type"::"Bar Code");
                ItemCrossReferenceG.SETRANGE("Reference No.", "Barcode No.");
                IF ItemCrossReferenceG.FINDFIRST() THEN BEGIN
                    VALIDATE("Item No.", ItemCrossReferenceG."Item No.");
                    IF ItemG.GET(ItemCrossReferenceG."Item No.") THEN BEGIN
                        VALIDATE("Base Unit of Measure Code", ItemG."Base Unit of Measure");
                        "Item Description" := ItemG.Description;
                    END;

                    VALIDATE("Variant Code", ItemCrossReferenceG."Variant Code");

                    IF ItemCrossReferenceG."Unit of Measure" = '' THEN BEGIN
                        VALIDATE("Unit of Measure Code", ItemG."Base Unit of Measure");
                    END ELSE BEGIN
                        VALIDATE("Unit of Measure Code", ItemCrossReferenceG."Unit of Measure");
                    END;

                    IF (ItemCrossReferenceG.Description <> '') THEN
                        "Item Description" := ItemCrossReferenceG.Description;
                END;
            end;
        }
        field(90; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            trigger OnValidate()
            begin
                IF NOT ItemG.GET("Item No.") THEN EXIT;

                IF ("Item Description" = '') THEN
                    "Item Description" := ItemG.Description;

            end;
        }
        field(100; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(110; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            trigger OnValidate()
            begin
                Rec.CalcFields("Variant Description", "Variant Description 2");
                "Meg Variant Description" := Rec."Variant Description";
                "Meg Variant Description 2" := Rec."Variant Description 2"
            end;
        }
        field(120; "Unit of Measure Code"; Code[10])
        {

            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            trigger OnValidate()
            begin
                IF ItemUnitOfMeasureG.GET("Item No.", "Unit of Measure Code") THEN BEGIN
                    "Qty. per Unit of Measure" := ItemUnitOfMeasureG."Qty. per Unit of Measure";
                END;
            end;
        }
        field(130; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(140; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(150; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(160; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(170; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(180; "Location Code To"; Code[10])
        {
            Caption = 'Location Code To';
            TableRelation = Location;
        }
        field(190; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code;
        }
        field(200; "Bin Code To"; Code[20])
        {
            Caption = 'Bin Code To';
            TableRelation = Bin.Code;
        }
        field(210; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(220; "Lot No. To"; Code[20])
        {
            Caption = 'Lot No. To';
        }

        field(230; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
        }
        field(240; "Serial No. To"; Code[20])
        {
            Caption = 'Serial No. To';
        }
        field(250; "Expiry"; Date)
        {
            Caption = 'Expiry';
        }
        field(260; "Expiry To"; Date)
        {
            Caption = 'Expiry To';
        }
        field(270; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = "Stars Handheld Users"."Handheld User ID";
            ValidateTableRelation = false;


        }
        field(280; "Scanned Date/Time"; DateTime)
        {
            Caption = 'Scanned Date/Time';

        }
        field(290; "Processed"; Boolean)
        {
            Caption = 'Processed';

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                IF Processed = FALSE THEN
                    IF NOT UserSetup."ST Phys.Inv.Unprocess Sessions" THEN
                        ERROR(Text002);
            end;
        }
        field(300; "Processed By"; Code[50])
        {
            Caption = 'Processed By';

            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(310; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date/Time';

        }
        field(320; "Deleted"; Boolean)
        {
            Caption = 'Deleted';

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                IF Deleted = TRUE THEN
                    IF NOT UserSetup."Stars Phys.Inv.Delete Sessions" THEN
                        ERROR(Text001);
            end;
        }

        field(330; "Phys. Inv. Session"; Text[50])
        {
            Caption = 'Phys. Inv. Session';

        }
        field(340; "Delete By"; Code[50])
        {
            Caption = 'Delete By';

        }
        field(350; "Deleted Date/Time"; DateTime)
        {
            Caption = 'Deleted Date/Time';

        }
        field(360; "Variant Description"; Text[100])
        {
            Caption = 'Variant Description';
            CalcFormula = lookup("Item Variant".Description where("Item No." = field("Item No."), Code = field("Variant Code")));
            FieldClass = FlowField;

        }
        field(370; "Variant Description 2"; Text[50])
        {

            Caption = 'Variant Description 2';
            CalcFormula = lookup("Item Variant"."Description 2" where("Item No." = field("Item No."), Code = field("Variant Code")));
            FieldClass = FlowField;
        }
        field(380; "Meg Variant Description"; Text[100])
        {
            Caption = 'Meg Variant Description';
        }
        field(390; "Meg Variant Description 2"; Text[50])
        {
            Caption = 'Meg Variant Description 2';
        }
        field(400; "Meg Processed Direct TO"; Boolean)
        {
            Caption = 'Processed Direct TO';
        }
        field(4100; "Meg Direct TO Asssigned PO"; Code[20])
        {
            Caption = 'Direct TO Asssigned PO';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Action Type", "Document Type", "Document No.", "Item No.", "Variant Code", "Location Code", "Location Code To", "Bin Code", "Bin Code To", "Lot No.", "Lot No. To", "Serial No.", "Serial No. To", "Expiry", "Expiry To")
        {
        }
        key(Key3; "Action Type", "Document Type", "Document No.", "Item No.", "Variant Code", "Location Code", "Bin Code", "Lot No.", "Serial No.", "Expiry")
        {
        }
        key(Key4; "Action Type", "Document Type", "Document No.")
        {
        }
        key(Key5; "Action Type", "Document Type", "Document No.", "Barcode No.")
        {
        }
        key(Key6; "Action Type", "Document Type", "Document No.", "Item No.", "Variant Code")
        {
        }

        key(Key7; "Action Type", "Document Type", "Document No.", "Bin Code To", "Lot No. To")
        {
        }
        key(Key8; "Action Type", "Document Type", "Journal Template Name", "Journal Batch Name")
        {
        }
    }
    trigger OnInsert()
    begin
        // EntryNoG := 0;
        // IF HandheldScanG.FINDLAST() THEN BEGIN
        //     EntryNoG := HandheldScanG."Entry No.";
        // END;
        // EntryNoG += 1;

        // VALIDATE("Entry No.", EntryNoG);

        "Scanned Date/Time" := CURRENTDATETIME;


    end;

    var
        HandheldScanG: Record "Stars HandHeld Scan";
        EntryNoG: Integer;
        ItemG: Record Item;
        ItemUnitOfMeasureG: Record "Item Unit of Measure";
        ItemCrossReferenceG: Record "Item Reference";
        UserSetup: Record "User Setup";
        Text001: Label 'Your are not allowed to delete sessions!';
        Text002: Label 'Your are not allowed to unprocess sessions!';

}
