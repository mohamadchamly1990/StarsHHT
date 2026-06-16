// Stars 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
pageextension 51003 "Stars Phys. Inv. Journal Ext." extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Reason Code")
        {
            field("Updated from Handheld"; Rec."Stars Updated from Handheld")
            {
                ApplicationArea = All;
                Caption = 'Updated from Handheld';
            }
            field("Stars Updated without Calculated"; Rec."Stars Updated witht Calculated")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Updated without Calculated field.', Comment = '%';
            }
        }
        modify(CurrentJnlBatchName)
        {
            trigger OnLookup(VAR Text: Text): Boolean
            begin
                CurrentBatchLocation := GetHandheldLocation;
            end;
        }

    }
    actions
    {
        addlast("F&unctions")
        {

            action("View Scans")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                begin
                    HandheldUtilities_l.ShowScansPhysInventory(Rec);
                end;
            }
            action("Handheld Journal Security")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                begin
                    CLEAR(HandheldJournalSecurity);
                    HandheldJournalSecurityRec.SETRANGE("Item Journal Template", Rec."Journal Template Name");
                    HandheldJournalSecurityRec.SETRANGE("Item Journal Batch", Rec."Journal Batch Name");
                    HandheldJournalSecurityRec.CALCFIELDS("Default Location");
                    HandheldJournalSecurityRec.SETRANGE("Default Location", CurrentBatchLocation);
                    HandheldJournalSecurity.SetEditable(TRUE, FALSE, FALSE);
                    HandheldJournalSecurity.SetLocation(CurrentBatchLocation);
                    HandheldJournalSecurity.SETTABLEVIEW(HandheldJournalSecurityRec);
                    HandheldJournalSecurity.RUNMODAL;
                end;
            }
            action("Import From Scans")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                begin
                    HandheldUtilities_l.UpdateHandheldScanPhysInventory(Rec);
                end;
            }
            action("Import From Scans With Bin")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                begin
                    HandheldUtilities_l.UpdateHandheldScanPhysInventoryWithBin(Rec);
                end;
            }
            action("Delete Handheld Sessions")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                    HandheldSessions_l: Page "Stars Handheld Sessions";
                    Sessions: Record "Stars HandHeld Sessions";
                begin
                    CLEAR(HandheldSessions_l);
                    HandheldUtilities_l.GetSessions(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Document No.", USERID, Rec."Location Code", FALSE);
                    Sessions.SETRANGE("User ID", USERID);
                    Sessions.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    Sessions.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    Sessions.SETRANGE("Location Code", Rec."Location Code");
                    HandheldSessions_l.SetScanFilter(0);//Stars04.00
                    HandheldSessions_l.SETTABLEVIEW(Sessions);
                    HandheldSessions_l.RUN;
                end;
            }
            action("Unprocess Handheld Sessions")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                    HandheldSessions_l: Page "Stars Handheld Sessions";
                    Sessions: Record "Stars HandHeld Sessions";
                begin
                    CLEAR(HandheldSessions_l);
                    HandheldUtilities_l.GetSessions(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Document No.", USERID, Rec."Location Code", TRUE);
                    Sessions.SETRANGE("User ID", USERID);
                    Sessions.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    Sessions.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    Sessions.SETRANGE("Location Code", Rec."Location Code");
                    HandheldSessions_l.SetScanFilter(1);
                    HandheldSessions_l.SETTABLEVIEW(Sessions);
                    HandheldSessions_l.RUN;
                end;
            }





        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CurrentBatchLocation := GetHandheldLocation;
    end;

    local procedure GetHandheldLocation(): Code[10]
    var

        ItemJournalTemplate_l: Record "Item Journal Template";
        TemplateName_l: Code[10];
    begin
        ItemJournalTemplate_l.RESET;
        ItemJournalTemplate_l.SETRANGE("Page ID", PAGE::"Phys. Inventory Journal");
        ItemJournalTemplate_l.SETRANGE(Type, ItemJournalTemplate_l.Type::"Phys. Inventory");
        IF ItemJournalTemplate_l.FINDFIRST THEN BEGIN
            TemplateName_l := ItemJournalTemplate_l.Name;
            IF ItemJournalBatch_g.GET(TemplateName_l, CurrentJnlBatchName) THEN
                EXIT(ItemJournalBatch_g."Stars Handheld Location Code");
        END;
    end;

    var
        ItemJournalBatch_g: Record "Item Journal Batch";
        CurrentBatchLocation: Code[10];
        HandheldJournalSecurityRec: Record "Stars Handheld Journl Security";
        HandheldJournalSecurity: Page "Stars Handheld Journl Security";
}
