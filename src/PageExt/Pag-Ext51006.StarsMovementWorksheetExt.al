pageextension 51006 "Stars Movement Worksheet Ext" extends "Movement Worksheet"
{
    actions
    {
        addlast("F&unctions")
        {
            action("Import From Handheld Scans")
            {
                ApplicationArea = All;
                Caption = 'Import From Handheld Scans';
                Image = Import;
                trigger OnAction()
                var
                    WMSUTILS: Codeunit "Stars WMS Utils";
                begin
                    WMSUTILS.CreateHandheldScanMovementByItem();
                end;
            }
            action("View Scans")
            {
                ApplicationArea = All;
                Caption = 'View Scans';
                Image = ShowList;
                trigger OnAction()
                var
                    WMSUTILS: Codeunit "Stars WMS Utils";
                begin
                    WMSUTILS.ShowScansMoveByItem();
                end;
            }
        }
    }
}