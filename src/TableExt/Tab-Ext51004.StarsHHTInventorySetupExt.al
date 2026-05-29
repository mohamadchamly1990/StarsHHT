/// Meg01.00 PAS (11-08-22): Add field "Variant Posting Restriction". (STARS-000011)
// Meg 02.00 RH (20-09-22): HHT Functionality.(STARS-000012)
// Meg 03.00 MC (18-10-22): Add Field "Limit Varient value 5"  
tableextension 51004 "Stars HHT Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {

        field(51000; "Stars Default Store Pricing"; Code[10])
        {
            Caption = 'Stars Default Store Pricing';
            TableRelation = "LSC Store"."No.";
        }

        field(51001; "Stars Price Check Store No."; Code[10])
        {
            Caption = 'Stars Price Check Store No.';
            TableRelation = "LSC Store"."No.";
        }
        field(51002; "Reset Qty After Tran Rec Post"; boolean)
        {
            Caption = 'Reset Qty After Tran Rec Post';
        }

    }
}