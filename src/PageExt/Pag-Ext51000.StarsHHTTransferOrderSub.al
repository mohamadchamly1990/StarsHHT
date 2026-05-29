//Meg01.00 MC (14-01-25) New columns showing from/to inventory availability on transfer lines. (ALNAJMA-000030)
pageextension 51000 "Stars HHT Transfer Order Sub" extends "Transfer Order Subform"
{
    layout
    {
        modify("Transfer-from Bin Code")
        {
            ApplicationArea = Warehouse;
            ToolTip = 'Specifies the code for the bin that the items are transferred from.';
            Visible = true;
        }
        modify("Transfer-To Bin Code")
        {
            ApplicationArea = Warehouse;
            ToolTip = 'Specifies the code for the bin that the items are transferred to.';
            Visible = false;
        }
        // Add changes to page layout here
        addafter(Description)
        {

            field(FromInvQty; FromInvQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Available Inventory quantity field.', Comment = '%';
                Editable = false;
                caption = 'From Location Available Qty';
            }
            field(ToInvQty; ToInvQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Available Inventory quantity field.', Comment = '%';
                Editable = false;
                Caption = 'To Location Available Qty';
            }


        }
    }

    trigger OnAfterGetRecord()
    var
        ItemVarInvByLocation: Query "LSC Item Inv. VarSerialLot";
        Quantity: Decimal;
        ActualInventory: Decimal;
        BOUtils: Codeunit "LSC BO Utils";
    begin
        FromInvQty := 0;
        ToInvQty := 0;

        FromInvQty := GetavailableQty(True);
        ToInvQty := GetavailableQty(false);
    end;

    trigger OnAfterGetCurrRecord()
    var
        ItemVarInvByLocation: Query "LSC Item Inv. VarSerialLot";
        Quantity: Decimal;
        ActualInventory: Decimal;
        BOUtils: Codeunit "LSC BO Utils";
    begin
        FromInvQty := 0;
        ToInvQty := 0;

        FromInvQty := GetavailableQty(True);
        ToInvQty := GetavailableQty(false);
    end;

    procedure GetavailableQty(Location: Boolean): Decimal
    var
        Item: Record Item;
        TransferHeader: Record "Transfer Header";
        QtySoldNotPst: Decimal;
        BOUtils: Codeunit "LSC BO Utils";
    begin

        TransferHeader.Reset();
        TransferHeader.SetFilter("LSC Retail Status", '<>%1', TransferHeader."LSC Retail Status"::"Closed - ok");
        TransferHeader.SetRange("No.", Rec."Document No.");
        if TransferHeader.FindFirst() then;

        Item.Reset();
        Item.SetRange("No.", Rec."Item No.");
        Item.SetRange("Variant Filter", Rec."Variant Code");

        case Location of
            true:
                begin
                    if TransferHeader."Transfer-from Code" <> '' then begin
                        Item.SetFilter("Location Filter", TransferHeader."Transfer-from Code");
                        If not Item.FindFirst() then
                            exit(0);
                        Item.CalcFields(Inventory);
                        QtySoldNotPst := BOUtils.ReturnQtySoldNotPosted(Rec."Item No.", '', TransferHeader."Transfer-from Code", Rec."Variant Code", '');
                    end;
                end;
            false:
                begin
                    if TransferHeader."Transfer-to Code" <> '' then begin
                        Item.SetFilter("Location Filter", TransferHeader."Transfer-to Code");
                        If not Item.FindFirst() then
                            exit(0);
                        Item.CalcFields(Inventory);
                        QtySoldNotPst := BOUtils.ReturnQtySoldNotPosted(Rec."Item No.", '', TransferHeader."Transfer-To Code", Rec."Variant Code", '');
                    end;
                end;
        end;
        exit(Item.Inventory - (QtySoldNotPst));

    end;

    var
        FromInvQty, TOInvQty : Decimal;
        TransferHeader: Record "Transfer Header";
}