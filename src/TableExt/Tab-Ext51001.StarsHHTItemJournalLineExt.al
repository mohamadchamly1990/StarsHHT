// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
tableextension 51001 "Stars HHT Item JournalLine Ext" extends "Item Journal Line"
{
    fields
    {
        field(51000; "Stars Updated from Handheld"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            Caption = 'Stars Updated from Handheld';

        }
        field(51001; "Stars Updated witht Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Stars Updated without Calculated';
            Editable = false;
        }

    }

}