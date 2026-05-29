// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
page 51003 "Stars Handheld Sessions"
{
    ApplicationArea = All;
    Caption = 'Stars Handheld Sessions';
    PageType = List;
    SourceTable = "Stars HandHeld Sessions";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Phys. Inv. Session"; Rec."Phys. Inv. Session")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phys. Inv. Session field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Line Count"; Rec."Line Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Count field.';
                }
                field("Scanned By"; Rec."Scanned By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scanned By field.';
                }
                field("Mark Session"; Rec."Mark Session")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mark Session field.';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("View Scans")
            {
                trigger OnAction()
                var
                    HandheldScansPageL: Page "Stars Handheld Scans";
                begin
                    CLEAR(HandheldScansPageL);
                    HandheldScanG.SETRANGE("Action Type", HandheldScanG."Action Type"::Update);
                    HandheldScanG.SETRANGE("Document Type", HandheldScanG."Document Type"::"Phys. Inventory");
                    HandheldScanG.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    HandheldScanG.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    HandheldScanG.SETRANGE("Location Code", Rec."Location Code");
                    HandheldScanG.SETRANGE("User ID", Rec."Scanned By");
                    HandheldScanG.SETRANGE("Phys. Inv. Session", Rec."Phys. Inv. Session");
                    HandheldScanG.SETRANGE(Deleted, FALSE);//Meg02.00
                    HandheldScansPageL.SETTABLEVIEW(HandheldScanG);
                    HandheldScansPageL.RUNMODAL;
                end;


            }

            action("Delete Marked Sessions")
            {
                trigger OnAction()
                var
                    HandheldScansPageL: Page "Stars Handheld Scans";
                begin
                    IF HandheldUtilities.DeleteSessions THEN
                        CurrPage.CLOSE;

                end;


            }
            action("Unprocess Marked Sessions")
            {
                trigger OnAction()
                var
                    HandheldScansPageL: Page "Stars Handheld Scans";
                begin
                    IF HandheldUtilities.UnprocessSessions THEN
                        CurrPage.CLOSE;

                end;


            }

            action("Mark/Unmark All")
            {
                trigger OnAction()
                var
                    HandheldScansPageL: Page "Stars Handheld Scans";
                begin
                    IF Rec."Mark Session" = FALSE THEN
                        Rec.MODIFYALL("Mark Session", TRUE)
                    ELSE
                        Rec.MODIFYALL("Mark Session", FALSE);

                end;


            }


        }
    }
    var
        HandheldUtilities: Codeunit "Stars Handheld Utilities";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        DocumentNo: Code[20];
        HandheldScanG: Record "Stars Handheld Scan";
        DeleteMS: Boolean;
        UnprocessMs: Boolean;

    procedure SetScanFilter(Action: Option "Delete","Unprocess")
    var
        myInt: Integer;
    begin
        CASE Action OF
            Action::Delete:
                BEGIN
                    HandheldScanG.SETRANGE(Processed, FALSE);
                    DeleteMS := TRUE;
                END;
            Action::Unprocess:
                BEGIN
                    HandheldScanG.SETRANGE(Processed, TRUE);
                    UnprocessMs := TRUE;
                END;
        END;
    end;

}
