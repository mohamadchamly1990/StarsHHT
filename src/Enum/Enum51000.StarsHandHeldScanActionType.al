// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
enum 51000 "Stars HandHeld Scan Action Type"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0;
    "Create")
    {
        Caption = 'Create';
    }
    value(1; "Update") { Caption = 'Update'; }
    value(2; "Ship") { Caption = 'Ship'; }
    value(3; "Receive") { Caption = 'Receive'; }
    value(4; "Release") { Caption = 'Release'; }
    value(5; "Post") { Caption = 'Post'; }

}