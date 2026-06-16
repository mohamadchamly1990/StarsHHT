pageextension 51007 "Stars Item Reclass Journal Ext" extends "Item Reclass. Journal"
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
        }

    }
    actions
    {
        addlast("F&unctions")
        {
            action("Import From Scans")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                    ItemJournalBatch: Record "Item Journal Batch";
                    ItemJournalTemplate: Record "Item Journal Template";
                begin
                    ItemJournalBatch.Reset();
                    if ItemJournalBatch.Get(ItemJournalTemplate.Type::Transfer, Rec.GetRangeMax("Journal Batch Name")) then begin
                        if ItemJournalBatch."Stars Bin To Bin" then
                            HandheldUtilities_l.UpdateHandheldScanItemReclassBinToBin(Rec);
                        if ItemJournalBatch."Stars Pick" then
                            HandheldUtilities_l.UpdateHandheldScanItemReclassPick(Rec);
                        if ItemJournalBatch."Stars Put-Away" then
                            HandheldUtilities_l.UpdateHandheldScanItemReclassPutAway(Rec);
                    end;
                end;
            }
            action("View Scans")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    HandheldUtilities_l: Codeunit "Stars Handheld Utilities";
                    ItemJournalBatch: Record "Item Journal Batch";
                    ItemJournalTemplate: Record "Item Journal Template";
                begin
                    ItemJournalBatch.Reset();
                    if ItemJournalBatch.Get(ItemJournalTemplate.Type::Transfer, Rec.GetRangeMax("Journal Batch Name")) then begin
                        if ItemJournalBatch."Stars Bin To Bin" then
                            HandheldUtilities_l.ShowScansItemReclassBinToBin(Rec);
                        if ItemJournalBatch."Stars Pick" then
                            HandheldUtilities_l.ShowScansItemReclassPick(Rec);
                        if ItemJournalBatch."Stars Put-Away" then
                            HandheldUtilities_l.ShowScansItemReclassPutAway(Rec);
                    end;
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
    begin
        CurrentBatchLocation := GetHandheldLocation;
    end;

    local procedure GetHandheldLocation(): Code[10]
    var
        ItemJournalTemplate_l: Record "Item Journal Template";
        TemplateName_l: Code[10];
    begin
        ItemJournalTemplate_l.RESET;
        ItemJournalTemplate_l.SETRANGE("Page ID", PAGE::"Item Reclass. Journal");
        ItemJournalTemplate_l.SETRANGE(Type, ItemJournalTemplate_l.Type::Transfer);
        IF ItemJournalTemplate_l.FINDFIRST THEN BEGIN
            TemplateName_l := ItemJournalTemplate_l.Name;
            IF ItemJournalBatch_g.Get(ItemJournalTemplate_l.Name, Rec.GetRangeMax("Journal Batch Name")) THEN
                Exit(ItemJournalBatch_g."Stars Handheld Location Code");
        END;
    end;

    var
        ItemJournalBatch_g: Record "Item Journal Batch";
        CurrentBatchLocation: Code[10];
        HandheldJournalSecurityRec: Record "Stars Handheld Journl Security";
        HandheldJournalSecurity: Page "Stars Handheld Journl Security";
}
