// Meg 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)
enum 51001 "Stars HandHeld Scan Doc. Type"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "Directed Pick") { Caption = 'Directed Pick'; }
    value(1; "Directed Put Away") { Caption = 'Directed Put Away'; }
    value(2; "Item Reclassification") { Caption = 'Item Reclassification'; }
    value(3; "Movement by Item") { Caption = 'Movement by Item'; }
    value(4; "Pick") { Caption = 'Pick'; }
    value(5; "Purchase Order") { Caption = 'Purchase Order'; }
    value(6; "Purchase Return Order") { Caption = 'Purchase Return Order'; }
    value(7; "Put Away") { Caption = 'Put Away'; }
    value(8; "Sales Order") { Caption = 'Sales Order'; }
    value(9; "Sales Return Order") { Caption = 'Sales Return Order'; }
    value(10; "Transfer Order") { Caption = 'Transfer Order'; }
    value(11; "Warehouse Receipt") { Caption = 'Warehouse Receipt'; }
    value(12; "Warehouse Shipment") { Caption = 'Warehouse Shipment'; }
    value(13; "Phys. Inventory") { Caption = 'Phys. Inventory'; }
    value(14; "Dir. Phys. Inventory") { Caption = 'Dir. Phys. Inventory'; }
    value(15; "Item Reclassification Bin To Bin") { Caption = 'Item Reclassification Bin To Bin'; }
    value(16; "Item Reclass. Pick") { Caption = 'Item Reclass. Pick'; }
    value(17; "Item Reclass. PutAway") { Caption = 'Item Reclass. PutAway'; }

    value(97; "Direct Transfer Order") { Caption = 'Direct Transfer Order'; }
    value(98; "PutAway Transfer Order") { Caption = 'PutAway Transfer Order'; }
    value(99; "Pick Transfer Order") { Caption = 'Pick Transfer Order'; }
    value(100; "Price Check") { Caption = 'Price Check'; }
    value(101; "Item Qty On Hand") { Caption = 'Item Qty On Hand'; }

}