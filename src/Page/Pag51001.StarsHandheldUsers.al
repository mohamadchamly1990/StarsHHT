// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
page 51001 "Stars Handheld Users"
{
    ApplicationArea = All;
    Caption = 'Stars Handheld Users';
    PageType = List;
    SourceTable = "Stars Handheld Users";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Handheld User ID"; Rec."Handheld User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handheld User ID field.';
                }
                field("Handheld Password"; Rec."Handheld Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handheld Password field.';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Handheld Journal Security")
            {
                trigger OnAction()
                var
                    HandheldJournalSecurityRec: Record "Stars Handheld Journl Security";
                    HandheldJournalSecurity: Page "Stars Handheld Journl Security";
                begin
                    CLEAR(HandheldJournalSecurity);
                    HandheldJournalSecurityRec.SETRANGE("Handheld User", Rec."Handheld User ID");
                    HandheldJournalSecurity.SetEditable(FALSE, TRUE, TRUE);
                    HandheldJournalSecurity.SETTABLEVIEW(HandheldJournalSecurityRec);
                    HandheldJournalSecurity.RUNMODAL;
                end;


            }

        }
    }

}
