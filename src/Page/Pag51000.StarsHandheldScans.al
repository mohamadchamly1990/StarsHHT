// Meg 01.00 MC (11-02-24): HHT Functionality.(STARS-000012)
page 51000 "Stars Handheld Scans"
{
    ApplicationArea = All;
    Caption = 'Stars Handheld Scans';
    PageType = List;
    SourceTable = "Stars Handheld Scan";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Barcode No."; Rec."Barcode No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Barcode No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Variant Description"; Rec."Variant Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Variant Description Code field.';
                }
                field("Variant Description 2"; Rec."Variant Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Variant Description 2 Code field.';
                }
                field("Meg Variant Description"; Rec."Meg Variant Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Variant Description Code field.';
                }
                field("Meg Variant Description 2"; Rec."Meg Variant Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Variant Description 2 Code field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Base Unit of Measure Code"; Rec."Base Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base Unit of Measure Code field.';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity (Base) field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Location Code To"; Rec."Location Code To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code To field.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bin Code To field.';
                }
                field("Bin Code To"; Rec."Bin Code To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bin Code To field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. To field.';
                }
                field("Lot No. To"; Rec."Lot No. To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. To To field.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("Serial No. To"; Rec."Serial No. To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. To field.';
                }
                field("Expiry"; Rec."Expiry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiry field.';
                }
                field("Expiry To"; Rec."Expiry To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiry To field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Scanned Date/Time"; Rec."Scanned Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scanned Date/Time field.';
                }
                field("Processed"; Rec."Processed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field("Processed By"; Rec."Processed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processed By field.';
                }
                field("Processed Date/Time"; Rec."Processed Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processed Date/Time field.';
                }
                field("Phys. Inv. Session"; Rec."Phys. Inv. Session")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phys. Inv. Session field.';
                }
                field("Delete By"; Rec."Delete By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delete By field.';
                }
                field("Deleted Date/Time"; Rec."Deleted Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deleted Date/Time field.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action Type.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type.';
                }
                field("Processed Direct TO"; Rec."Meg Processed Direct TO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Processed Direct TO';
                }
                field("Direct TO Asssigned PO"; Rec."Meg Direct TO Asssigned PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Direct TO Asssigned PO';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("View Processed")
            {
                trigger OnAction()
                var

                begin
                    Rec.SETRANGE(Processed, TRUE);
                end;


            }
            action("View Unprocessed")
            {
                trigger OnAction()
                var

                begin
                    Rec.SETRANGE(Processed, FALSE);
                end;


            }
            action("Delete Handheld Sessions")
            {
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
                    HandheldSessions_l.SetScanFilter(0);//Meg04.00
                    HandheldSessions_l.SETTABLEVIEW(Sessions);
                    HandheldSessions_l.RUN;
                end;


            }
            action("Unprocess Handheld Sessions")
            {
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

}
