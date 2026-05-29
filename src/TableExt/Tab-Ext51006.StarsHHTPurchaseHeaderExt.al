tableextension 51006 "Stars HHT Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(51000; "Stars HHT Processing Direct TO"; Boolean)
        {
            Caption = 'Stars Processing Direct TO';
        }
        field(51001; "Stars HHT Processing Time"; DateTime)
        {
            Caption = 'Stars HHT Processing Time';
        }
    }
}