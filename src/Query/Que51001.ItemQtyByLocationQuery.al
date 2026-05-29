query 51001 "Item Qty. By Location Query"
{

    Caption = 'itemsByLocation', Locked = true;
    Access = internal;

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            column(Variant; "Variant Code")
            {
            }
            column(ItmLdg_Item_No; "Item No.")
            {
            }
            column(ItmLdg_Location_Code; "Location Code")
            {
            }
            column(ItmLdg_Sum_Remaining_Quantity; "Remaining Quantity")
            {
                Method = Sum;
            }
            column(ItmLdg_Open; Open)
            {
                ColumnFilter = ItmLdg_Open = CONST(true);
            }
            column(ItmLdg_Positive; Positive)
            {
                ColumnFilter = ItmLdg_Positive = CONST(true);
            }

            dataitem(Item; Item)
            {
                DataItemLink = "No." = Item_Ledger_Entry."Item No.";
                SqlJoinType = InnerJoin;

                column(Itm_Description; Description)
                {
                }
                column(Itm_Unit_Price; "Unit Price")
                {
                }
                column(Total_Inventory; "Inventory")
                {
                }

                dataitem(Location; Location)
                {
                    DataItemLink = Code = Item_Ledger_Entry."Location Code";
                    SqlJoinType = InnerJoin;

                    column(Loc_Address; Address)
                    {
                    }
                    column(Loc_City; City)
                    {
                    }
                    column(Loc_Name; Name)
                    {
                    }

                    dataitem(LSC_Item_Variant_Registration; "LSC Item Variant Registration")
                    {
                        DataItemLink = "Item No." = Item."No.",
                            "Variant" = Item_Ledger_Entry."Variant Code";
                        SqlJoinType = LeftOuterJoin;


                        column(Variant_Dimension_1; "Variant Dimension 1")
                        {

                        }
                        column(Variant_Dimension_2; "Variant Dimension 2")
                        {

                        }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}