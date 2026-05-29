// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
page 51002 "Stars User Batch List"
{
    ApplicationArea = All;
    Caption = 'User Batch List';
    PageType = List;
    SourceTable = "Stars HHT User Batch";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Template"; Rec."Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Template field.';
                }
                field("Batch"; Rec."Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch field.';
                }

            }
        }
    }

}
