// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
page 51004 "Stars Handheld Journl Security"
{
    ApplicationArea = All;
    Caption = 'Stars Handheld Journal Security';
    PageType = List;
    SourceTable = "Stars Handheld Journl Security";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Handheld User"; Rec."Handheld User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handheld User field.';
                    trigger OnValidate()

                    var
                        HandheldLocationSecurity_l: Record "Stars HandHeld Loc Security";
                    begin
                        IF HandheldLocationSecurity_l.GET(Rec."Handheld User", ItemJournalLocation) THEN
                            IF NOT HandheldLocationSecurity_l."Is Default" THEN
                                ERROR(Text001, Rec."Handheld User", ItemJournalLocation);
                    end;
                }
                field("Item Journal Template"; Rec."Item Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Template field.';
                }

                field("Item Journal Batch"; Rec."Item Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Batch field.';
                }
                field("Default Location"; Rec."Default Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Location field.';
                }
            }
        }
    }
    var
        HandheldUserEditable: Boolean;
        HandheldJournalTemplateEditable: Boolean;
        HandheldJournalBatchEditable: Boolean;
        ItemJournalLocation: Code[10];
        Text001: Label 'User %1 is not default on location %2 in Handeld Location Security';

    procedure SetEditable(HandheldUsers_p: Boolean; JournalTemplate_p: Boolean; JournalBatch_p: Boolean)
    begin
        HandheldUserEditable := HandheldUsers_p;
        HandheldJournalTemplateEditable := JournalTemplate_p;
        HandheldJournalBatchEditable := JournalBatch_p;
    end;

    procedure SetLocation(LocatioCode_p: Code[10])

    begin
        ItemJournalLocation := LocatioCode_p;

    end;

}