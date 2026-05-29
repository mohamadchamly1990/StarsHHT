// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51006 "Stars Handheld Loc Security"
{
    DataClassification = ToBeClassified;
    Caption = 'Stars Handheld Location Security';
    Access = internal;
    fields
    {
        field(10; "ID"; Code[50])
        {
            Caption = 'ID';
            NotBlank = true;
            TableRelation = "Stars Handheld Users"."Handheld User ID";
            trigger OnValidate();
            begin
                IF ID <> '' THEN BEGIN
                    HandheldUsers.SETCURRENTKEY("Handheld User ID");
                    HandheldUsers.SETRANGE("Handheld User ID", ID);
                    IF NOT HandheldUsers.FINDFIRST THEN BEGIN
                        HandheldUsers.RESET;
                        IF NOT HandheldUsers.ISEMPTY THEN
                            ERROR(Text000, ID);
                    END;
                END;
            end;

            trigger OnLookup()
            begin
                HandheldUsers.RESET;
                HandheldUsers.SETCURRENTKEY("Handheld User ID");
                HandheldUsers."Handheld User ID" := ID;
                IF HandheldUsers.FIND('=><') THEN;
                //IF PAGE.RUNMODAL(50008, HandheldUsers) = ACTION::LookupOK THEN BEGIN
                IF PAGE.RUNMODAL(51001, HandheldUsers) = ACTION::LookupOK THEN BEGIN
                    ID := HandheldUsers."Handheld User ID";
                END;
            end;
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            NotBlank = true;
            TableRelation = Location;
        }
        field(30; "Post Sales Shipment"; Boolean)
        {
            Caption = 'Post Sales Shipment';
        }
        field(40; "Post Sales Return Receipt"; Boolean)
        {
            Caption = 'Post Sales Return Receipt';
        }
        field(50; "Post Purchase Receipt"; Boolean)
        {
            Caption = 'Post Purchase Receipt';
        }
        field(60; "Post Purchase Return Shipment"; Boolean)
        {
            Caption = 'Post Purchase Return Shipment';
        }
        field(70; "Post Transfer Shipment"; Boolean)
        {
            Caption = 'Post Transfer Shipment';
        }
        field(80; "Post Transfer Receipt"; Boolean)
        {
            Caption = 'Post Transfer Receipt';
        }
        field(90; "Allow Transfer From Location"; Boolean)
        {
            Caption = 'Allow Transfer From Location';
        }
        field(100; "Allow Transfer To Location"; Boolean)
        {
            Caption = 'Allow Transfer To Location';
        }
        field(110; "Is Default"; Boolean)
        {
            Caption = 'Is Default';
            trigger OnValidate()
            var
                HandheldLocationSecurityL: Record "Stars Handheld Loc Security";

            begin

                HandheldLocationSecurityL.RESET;
                HandheldLocationSecurityL.SETRANGE(ID, ID);
                HandheldLocationSecurityL.SETFILTER("Location Code", '<>%1', "Location Code");
                IF HandheldLocationSecurityL.FINDSET THEN
                    REPEAT
                        IF HandheldLocationSecurityL."Is Default" THEN
                            HandheldLocationSecurityL.TESTFIELD(HandheldLocationSecurityL."Is Default", FALSE);
                    UNTIL HandheldLocationSecurityL.NEXT = 0;
            end;

        }
        field(120; "Allow Transfer Creation"; Boolean)
        {
            Caption = 'Allow Transfer Creation';
        }
        field(130; "Allow Purchase Creation"; Boolean)
        {
            Caption = 'Allow Purchase Creation';
        }
        field(140; "Allow Sales Creation"; Boolean)
        {
            Caption = 'Allow Sales Creation';
        }
        field(150; "Allow Direct Transfer Creation"; Boolean)
        {
            Caption = 'Allow Direct Transfer Creation';
        }
        field(160; "Allow Dir. Transfer From Loc."; Boolean)
        {
            Caption = 'Allow Direct Transfer From Location';
        }
        field(170; "Allow Dir. Transfer To Loc."; Boolean)
        {
            Caption = 'Allow Direct Transfer To Location';
        }
        field(180; "Post Direct Transfer Order"; Boolean)
        {
            Caption = 'Post Direct Transfer Order';
        }
        field(190; "Allow Phys. Inv."; Boolean)
        {
            Caption = 'Allow Phys. Inv.';
        }
        field(200; "Allow Item Reclass. Bin To Bin"; Boolean)
        {
            Caption = 'Allow Item Reclass. Bin To Bin';
        }
        field(210; "Allow Item Recl. Pick To Loc"; Boolean)
        {
            Caption = 'Allow Item Reclass. Pick To Location';
        }
        field(220; "Allow Item Recl. PA. From Loc"; Boolean)
        {
            Caption = 'Allow Item Reclass. PutAway From Location';
        }
        field(230; "Allow Put Away Transfer Post"; Boolean)
        {
            Caption = 'Allow Put Away Transfer Post';
        }
        field(240; "Allow PutAway Trans. Creation"; Boolean)
        {
            Caption = 'Allow Put Away Transfer Creation';
        }
        field(250; "Allow Pick Transfer Post Ship"; Boolean)
        {
            Caption = 'Allow Pick Transfer Post Ship';
        }
        field(260; "Allow Pick Transfer Creation"; Boolean)
        {
            Caption = 'Allow Pick Transfer Creation';
        }
        field(270; "Allow Pick Trans. Post Receipt"; Boolean)
        {
            Caption = 'Allow Pick Transfer Post Receipt';
        }
        field(280; "Allow PutAway Transfer"; Boolean)
        {
            Caption = 'Allow PutAway Transfer';
        }
        field(290; "Allow Ship Transfer Pick"; Boolean)
        {
            Caption = 'Allow Ship Transfer Pick';
        }
        field(300; "Allow Receive Transfer Pick"; Boolean)
        {
            Caption = 'Allow Receive Transfer Pick';
        }
        field(310; "Allow Transfer Release"; Boolean)
        {
            Caption = 'Allow Transfer Release';
        }
        field(320; "Allow Purchase Release"; Boolean)
        {
            Caption = 'Allow Purchase Release';
        }
        field(330; "Allow Sales Release"; Boolean)
        {
            Caption = 'Allow Sales Release';
        }
        field(340; "Allow Pick Transfer From"; Boolean)
        {
            Caption = 'Allow Pick Transfer From';
        }
        field(350; "Allow Pick Transfer To"; Boolean)
        {
            Caption = 'Allow Pick Transfer To';
        }
        field(360; "Allow PutAway Transfer From"; Boolean)
        {
            Caption = 'Allow PutAway Transfer From';
        }
        field(370; "Allow PutAway Transfer To"; Boolean)
        {
            Caption = 'Allow PutAway Transfer To';
        }

        field(380; "Allow Direct TO"; Boolean)
        {
            Caption = 'Allow Direct Transfer Order';
        }
        field(390; "Allow Direct TO Creation"; Boolean)
        {
            Caption = 'Allow Direct Transfer Order Creation';
        }
        field(400; "Allow Direct PO Post"; Boolean)
        {
            Caption = 'Allow Direct PO Post';
        }
        field(410; "Allow Direct TO Post"; Boolean)
        {
            Caption = 'Allow Direct TO Post';
        }

        field(420; "Allow Transfer Receive"; Boolean)
        {
            Caption = 'Allow Transfer Receive';
        }
        field(430; "Allow Transfer Ship"; Boolean)
        {
            Caption = 'Allow Transfer Ship';
        }
    }

    keys
    {
        key(Key1; "ID", "Location Code")
        {
            Clustered = true;
        }
    }
    var
        HandheldUsers: Record "Stars Handheld Users";
        Text000: Label 'The user name %1 does not exist.';



}