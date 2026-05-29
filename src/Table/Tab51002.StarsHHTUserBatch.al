// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51002 "Stars HHT User Batch"
{
    Access = internal;
    DataClassification = ToBeClassified;
    Caption = 'Stars HHT User Batch';
    fields
    {
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            NotBlank = true;
            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;

        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = "Item","Transfer","Phys. Inventory","Revaluation","Consumption","Output","Capacity","Prod. Order","Put-away","Pick","Movement","Reclassification";

        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

        }
        field(40; "Template"; Code[10])
        {
            Caption = 'Template';
            TableRelation = IF (Type = FILTER(Item)) "Item Journal Template" WHERE(Type = CONST(Item))
            ELSE
            IF (Type = FILTER(Transfer)) "Item Journal Template" WHERE(Type = CONST(Transfer))
            ELSE
            IF (Type = FILTER("Phys. Inventory")) "Item Journal Template" WHERE(Type = CONST("Phys. Inventory"))
            ELSE
            IF (Type = FILTER("Revaluation")) "Item Journal Template" WHERE(Type = CONST(Revaluation))
            ELSE
            IF (Type = FILTER(Consumption)) "Item Journal Template" WHERE(Type = CONST(Consumption))
            ELSE
            IF (Type = FILTER(Output)) "Item Journal Template" WHERE(Type = CONST(Output))
            ELSE
            IF (Type = FILTER(Capacity)) "Item Journal Template" WHERE(Type = CONST(Capacity))
            ELSE
            IF (Type = FILTER("Prod. Order")) "Item Journal Template" WHERE(Type = CONST("Prod. Order"))
            ELSE
            IF (Type = FILTER("Put-away")) "Whse. Worksheet Template" WHERE(Type = CONST("Put-away"))
            ELSE
            IF (Type = FILTER(Pick)) "Whse. Worksheet Template" WHERE(Type = CONST(Pick))
            ELSE
            IF (Type = FILTER(Movement)) "Whse. Worksheet Template" WHERE(Type = CONST(Movement))
            ELSE
            IF (Type = FILTER(Reclassification)) "Warehouse Journal Template" WHERE(Type = CONST(Reclassification));

        }
        field(50; "Batch"; Code[10])
        {
            Caption = 'Batch';
            TableRelation = IF (Type = FILTER(Item)) "Item Journal Batch".Name WHERE("Template Type" = CONST(Item), "Journal Template Name" = FIELD(Template)) ELSE
            IF
             (Type = FILTER(Transfer)) "Item Journal Batch".Name WHERE("Template Type" = CONST(Transfer), "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER("Phys. Inventory")) "Item Journal Batch".Name WHERE("Template Type" = CONST("Phys. Inventory"),
             "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Revaluation)) "Item Journal Batch".Name WHERE("Template Type" = CONST(Revaluation), "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Consumption)) "Item Journal Batch".Name WHERE("Template Type" = CONST(Consumption), "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Output)) "Item Journal Batch".Name WHERE("Template Type" = CONST(Output), "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Capacity)) "Item Journal Batch".Name WHERE("Template Type" = CONST(Capacity), "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER("Prod. Order")) "Item Journal Batch".Name WHERE("Template Type" = CONST("Prod. Order"), "Journal Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER("Put-away")) "Whse. Worksheet Name".Name WHERE("Template Type" = CONST("Put-away"), "Worksheet Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Pick)) "Whse. Worksheet Name".Name WHERE("Template Type" = CONST(Pick), "Worksheet Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Movement)) "Whse. Worksheet Name".Name WHERE("Template Type" = CONST(Movement), "Worksheet Template Name" = FIELD(Template)) ELSE
            IF (Type = FILTER(Reclassification)) "Warehouse Journal Batch".Name WHERE("Template Type" = CONST(Reclassification), "Journal Template Name" = FIELD(Template));

        }

    }

    keys
    {
        key(Key1; "User ID", Type, "Location Code")
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