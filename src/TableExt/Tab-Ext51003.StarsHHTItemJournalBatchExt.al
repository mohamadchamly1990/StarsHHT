// Stars 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
tableextension 51003 "Stars HHT ItemJournalBatch Ext" extends "Item Journal Batch"
{
    fields
    {
        field(51000; "Stars Show Calculated Qty."; Boolean)
        {
            Caption = 'Stars Show Calculated Qty.';
        }
        field(51001; "Stars Handheld Location Code"; Code[10])
        {
            TableRelation = Location.Code;
            trigger OnValidate()
            var
                ItemJournal_l: Record "Item Journal Line";
                HandheldJournalSecurity_l: Record "Stars Handheld Journl Security";
            begin
                ItemJournal_l.RESET;
                ItemJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                ItemJnlLine.SETRANGE("Journal Batch Name", Name);
                IF ItemJnlLine.FINDFIRST THEN
                    ERROR(Text002, "Journal Template Name", Name);

                HandheldJournalSecurity_l.RESET;
                HandheldJournalSecurity_l.SETRANGE("Item Journal Template", "Journal Template Name");
                HandheldJournalSecurity_l.SETRANGE("Item Journal Batch", Name);
                HandheldJournalSecurity_l.CALCFIELDS("Default Location");
                HandheldJournalSecurity_l.SETRANGE("Default Location", xRec."Stars Handheld Location Code");
                IF HandheldJournalSecurity_l.FINDFIRST THEN
                    ERROR(Text003, "Journal Template Name", Name);

            end;


        }

        field(50002; "Stars Bin To Bin"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Stars Bin To Bin" then begin
                    "Stars Put-Away" := false;
                    "Stars Pick" := false;
                end;
            end;
        }
        field(50003; "Stars Pick"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Stars Pick" then begin
                    "Stars Bin To Bin" := false;
                    "Stars Put-Away" := false;
                end;
            end;
        }
        field(50004; "Stars Put-Away"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Stars Put-Away" then begin
                    "Stars Bin To Bin" := false;
                    "Stars Pick" := false;
                end;
            end;
        }

    }
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        Text003: Label 'One or more user have access to Journal Template %1, Journal Batch %2 on Handheld Journal Security';
        Text002: Label 'Item journal lines must be empty on Journal Template %1, Journal Batch %2.';

}
