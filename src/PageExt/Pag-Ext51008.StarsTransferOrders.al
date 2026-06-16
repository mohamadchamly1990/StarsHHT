pageextension 51008 "Stars Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Create &Whse. Receipt")
        {
            action("Import Transfer Order Template From Excel")
            {
                Caption = 'Import Transfer Order';
                ApplicationArea = All;
                Image = ImportExcel;

                trigger OnAction()
                var
                    Functions: Codeunit "Stars Functions";

                begin
                    Functions.ImportTransferOrdersFromExcel();
                end;
            }
            action("Export Transfer Order Template To Excel")
            {
                Caption = 'Export Transfer Order Template';
                ApplicationArea = All;
                Image = ExportToExcel;

                trigger OnAction()
                var
                    Functions: Codeunit "Stars Functions";

                begin
                    Functions.ExportTransferOrdersToExcel();
                end;
            }
        }
    }

    var
        myInt: Integer;
}