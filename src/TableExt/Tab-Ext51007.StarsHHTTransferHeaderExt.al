tableextension 51007 "Stars HHT Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        field(51000; "Stars HHT Assigned PO"; Code[20])
        {
            Caption = 'Stars HHT Assigned PO';
        }
        field(51001; "Stars HHT PO Updated & Posted"; Boolean)
        {
            Caption = 'Stars HHT PO Updated And Posted';
        }
    }
}