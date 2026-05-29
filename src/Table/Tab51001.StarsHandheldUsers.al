// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
table 51001 "Stars Handheld Users"
{
    Access = internal;
    Caption = 'Stars Handheld Users';
    fields
    {
        field(10; "Handheld User ID"; Code[50])
        {
            Caption = 'Handheld User ID';
            NotBlank = true;
        }
        field(20; "Handheld Password"; Text[50])
        {
            Caption = 'Handheld Password';
            NotBlank = true;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(Key1; "Handheld User ID")
        {
            Clustered = true;
        }
    }



}
