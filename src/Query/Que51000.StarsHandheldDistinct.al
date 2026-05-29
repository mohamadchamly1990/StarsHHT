// Stars 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
query 51000 "Stars Handheld Distinct"
{
    QueryType = Normal;
    Access = internal;

    elements
    {
        dataitem(DataItemName; "Stars HandHeld Scan")
        {
            column(Phys_Inv_Session; "Phys. Inv. Session")
            {

            }
            column(Journal_Template_Name; "Journal Template Name")
            {

            }
            column(Journal_Batch_Name; "Journal Batch Name")
            {

            }
            column(Processed; Processed)
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(User_ID; "User ID")
            {

            }
            column(Deleted; Deleted)
            {

            }
            column(Count_)
            {
                Method = Count;

            }

        }

    }


    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;

}