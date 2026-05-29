// Stars 01.00 RH (20-09-22): HHT Functionality.(STARS-000012)

codeunit 51001 "Stars WMS Online Functions"
{

    // Access = internal;
    trigger OnRun()
    begin

    end;

    var
        HandheldScanG: Record "Stars HandHeld Scan";
        Text001: Label 'Cannot ship more quantity!';
        Text002: Label 'Item cannot be shipped!';
        Text003: Label 'Cannot receive more quantity!';
        Text004: Label 'Item cannot be received!';
        Text005: Label 'Cannot scan more, document is released';
        Text006: Label 'Transfer Order %1 does not have an assigned Purchase Order';
        Text007: Label 'Item %1 Shipment ID %2 is not equal to assigned Purchase Order %3 Shipment ID %4';


        RetailPriceUtils: Codeunit "LSC Retail Price Utils";
        JsonText: Text;

    internal procedure test1(param: Boolean): Integer
    var
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        P: Record "Purchase Header";
    begin
        P.Get(P."Document Type"::Order, '24PO00546');
        ReleasePurchDoc.PerformManualReopen(P);
        if param then begin
            EXIT(1);
        end
        else begin
            EXIT(0);
        end;
    end;

    internal procedure GetWarehouseActivityHeaders(no: Text[20]; type: integer; locationCode: text[10]): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        JObject: JsonObject;
        JArray: JsonArray;
        NoofLines: Integer;
    begin
        NoOfLines := 0;
        WarehouseActivityHeader.Reset();
        if (no <> '') then begin
            if WarehouseActivityHeader.Get(type, no) then begin
                Clear(JObject);
                JObject.Add('Type', WarehouseActivityHeader.Type);
                JObject.Add('No', WarehouseActivityHeader."No.");
                JObject.Add('LocationCode', WarehouseActivityHeader."Location Code");
                WarehouseActivityLine.Reset();
                WarehouseActivityLine.SetRange("Activity Type", type);
                WarehouseActivityLine.SetRange("No.", no);
                if (type = "Warehouse Activity Type"::"Put-away") then begin
                    WarehouseActivityLine.SetRange("Action Type", "Warehouse Action Type"::Place);
                end;
                if (type = "Warehouse Activity Type"::"Pick") then begin
                    WarehouseActivityLine.SetRange("Action Type", "Warehouse Action Type"::Take);
                    WarehouseActivityLine.SetFilter("Bin Code", '<>%1', '');
                end;
                if WarehouseActivityLine.FindSet() then begin
                    repeat
                        NoOfLines := NoOfLines + 1;
                    Until WarehouseActivityLine.Next() = 0;
                end;
                JObject.Add('NoOfLines', NoOfLines);
            end;
            JObject.WriteTo(JsonText);
            Exit(JsonText);
        end;
        WarehouseActivityHeader.SetRange(Type, type);
        WarehouseActivityHeader.SetRange("Location Code", locationCode);
        if WarehouseActivityHeader.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('Type', WarehouseActivityHeader.Type);
                JObject.Add('No', WarehouseActivityHeader."No.");
                JObject.Add('LocationCode', WarehouseActivityHeader."Location Code");
                WarehouseActivityLine.Reset();
                WarehouseActivityLine.SetRange("Activity Type", type);
                WarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
                if (type = "Warehouse Activity Type"::"Put-away") then begin
                    WarehouseActivityLine.SetRange("Action Type", "Warehouse Action Type"::Place);
                end;
                if (type = "Warehouse Activity Type"::"Pick") then begin
                    WarehouseActivityLine.SetRange("Action Type", "Warehouse Action Type"::Take);
                    WarehouseActivityLine.SetFilter("Bin Code", '<>%1', '');
                end;
                if WarehouseActivityLine.FindSet() then begin
                    repeat
                        NoOfLines := NoOfLines + 1;
                    Until WarehouseActivityLine.Next() = 0;
                end;
                JObject.Add('NoOfLines', NoOfLines);
                if (type = "Warehouse Activity Type"::"Pick") AND (NoOfLines > 0) then begin
                    JArray.Add(JObject);
                end
                else if (type = "Warehouse Activity Type"::"Put-away") then begin
                    JArray.Add(JObject);
                end;
            until WarehouseActivityHeader.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetWarehouseActivityLines(activityType: Integer; actionType: Integer; documentType: Integer; documentNo: text[20]): Text
    var
        Barcodes: Record "LSC Barcodes";
        Location: Record "Location";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        HandheldScan: Record "Stars Handheld Scan";
        JObject: JsonObject;
        JArray: JsonArray;
        Qty: Decimal;
    begin

        WarehouseActivityHeader.Reset();
        if WarehouseActivityHeader.Get(activityType, documentNo) then begin
            WarehouseActivityLine.Reset();
            WarehouseActivityLine.SetRange("Action Type", actionType);
            WarehouseActivityLine.SetRange("activity Type", activityType);
            WarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
            if ("Warehouse Activity Type"::Pick = activityType) then begin
                WarehouseActivityLine.SetRange("Bin Code");
            end;
            WarehouseActivityLine.SetCurrentKey("Bin Code");
            WarehouseActivityLine.SetAscending("Bin Code", false);
            if WarehouseActivityLine.FindSet() then begin
                repeat
                    Qty := 0;
                    Clear(JObject);
                    JObject.Add('DocumentNo', WarehouseActivityLine."No.");
                    JObject.Add('LineNo', WarehouseActivityLine."Line No.");
                    JObject.Add('ItemNo', WarehouseActivityLine."Item No.");
                    JObject.Add('ItemDescription', WarehouseActivityLine.Description);
                    JObject.Add('UnitOfMeasureCode', WarehouseActivityLine."Unit of Measure Code");
                    JObject.Add('VariantCode', WarehouseActivityLine."Variant Code");
                    JObject.Add('BinCode', WarehouseActivityLine."Bin Code");
                    JObject.Add('LotNo', WarehouseActivityLine."Lot No.");
                    JObject.Add('SerialNo', WarehouseActivityLine."Serial No.");
                    JObject.Add('Expiry', WarehouseActivityLine."Expiration Date");
                    JObject.Add('Quantity', WarehouseActivityLine."Quantity");
                    Barcodes.SetRange("Item No.", WarehouseActivityLine."Item No.");
                    Barcodes.SetRange("Variant Code", WarehouseActivityLine."Variant Code");
                    if Barcodes.FindSet() then begin
                        JObject.Add('BarcodeNo', Barcodes."Barcode No.");
                    end
                    else
                        JObject.Add('BarcodeNo', '');
                    if Location.Get(WarehouseActivityLine."Location Code") then begin
                        JObject.Add('CrossDockBinCode', Location."Cross-Dock Bin Code");
                    end
                    else
                        JObject.Add('CrossDockBinCode', '');
                    //JArray.Add(JObject);
                    HandheldScan.Reset();
                    HandheldScan.SetRange("Document No.", WarehouseActivityLine."No.");
                    HandheldScan.SetRange("Line No.", WarehouseActivityLine."Line No.");
                    HandheldScan.SetRange("Item No.", WarehouseActivityLine."Item No.");
                    HandheldScan.SetRange("Variant Code", WarehouseActivityLine."Variant Code");
                    HandheldScan.SetRange("Unit of Measure Code", WarehouseActivityLine."Unit of Measure Code");
                    HandheldScan.SetRange("Serial No.", WarehouseActivityLine."Serial No.");
                    HandheldScan.SetRange("Lot No.", WarehouseActivityLine."Lot No.");
                    HandheldScan.SetRange(Expiry, WarehouseActivityLine."Expiration Date");
                    HandheldScan.SetRange("Bin Code", WarehouseActivityLine."Bin Code");
                    if HandheldScan.FindSet() then begin
                        repeat
                            if (HandheldScan."Action Type" = "Stars Handheld Scan Action Type"::Update) AND (HandheldScan."Document Type" = documentType) then begin
                                Qty := Qty + HandheldScan.Quantity;
                            end;
                        until HandheldScan.Next() = 0;

                    end;
                    JObject.Add('QuantityScanned', Qty);
                    JArray.Add(JObject);
                until WarehouseActivityLine.Next() = 0;
            end;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetCustomers(): Text
    var
        Customer: Record "Customer";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if Customer.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('Name', Customer.Name);
                JObject.Add('No', Customer."No.");
                JArray.Add(JObject);
            until Customer.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure ValidateBin(locationCode: Text[10]; binCode: text[20]): Boolean
    var
        Bin: Record "Bin";
    begin
        Bin.Reset();
        if Bin.Get(locationCode, binCode) then begin
            Exit(True);
        end;
        Exit(False);
    end;

    internal procedure ValidateLot(lotNo: Text[50]): Boolean
    var
        ItemLE: Record "Item Ledger Entry";
    begin
        ItemLE.Reset();
        ItemLE.SetCurrentKey("Lot No.");
        ItemLE.SetRange("Lot No.", lotNo);
        if ItemLE.FindFirst() then begin
            Exit(True);
        end;
        Exit(False);
    end;

    internal procedure AddLocationToJsonObject(var LocationSec: Record "Stars Handheld Loc Security"; var LocationP: Record "Location"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('UserId', LocationSec.ID);
        JObject.Add('Code', LocationSec."Location Code");
        JObject.Add('Name', LocationP."Name");
        if LocationP."Require Pick" then begin
            JObject.Add('Pick', 1);
        end
        else begin
            JObject.Add('Pick', 0);
        end;
        if LocationP."Require Put-away" then begin
            JObject.Add('Put', 1);
        end
        else begin
            JObject.Add('Put', 0);
        end;
        if LocationP."Require Receive" then begin
            JObject.Add('Receive', 1);
        end
        else begin
            JObject.Add('Receive', 0);
        end;
        if LocationP."Require Shipment" then begin
            JObject.Add('Ship', 1);
        end
        else begin
            JObject.Add('Ship', 0);
        end;
        if LocationP."Bin Mandatory" then begin
            JObject.Add('BinMandatory', 1);
        end
        else begin
            JObject.Add('BinMandatory', 0);
        end;
        if LocationSec."Post Sales Shipment" then begin
            JObject.Add('PostSalesShipment', 1);
        end
        else begin
            JObject.Add('PostSalesShipment', 0);
        end;
        if LocationSec."Post Sales Return Receipt" then begin
            JObject.Add('PostSalesReturnReceipt', 1);
        end
        else begin
            JObject.Add('PostSalesReturnReceipt', 0);
        end;
        if LocationSec."Post Purchase Receipt" then begin
            JObject.Add('PostPurchaseReceipt', 1);
        end
        else begin
            JObject.Add('PostPurchaseReceipt', 0);
        end;
        if LocationSec."Post Purchase Return Shipment" then begin
            JObject.Add('PostPurchaseReturnShipment', 1);
        end
        else begin
            JObject.Add('PostPurchaseReturnShipment', 0);
        end;
        if LocationSec."Post Transfer Shipment" then begin
            JObject.Add('PostTransferShipment', 1);
        end
        else begin
            JObject.Add('PostTransferShipment', 0);
        end;
        if LocationSec."Post Transfer Receipt" then begin
            JObject.Add('PostTransferReceipt', 1);
        end
        else begin
            JObject.Add('PostTransferReceipt', 0);
        end;
        if LocationSec."Allow Transfer From Location" then begin
            JObject.Add('AllowTransferFromLocation', 1);
        end
        else begin
            JObject.Add('AllowTransferFromLocation', 0);
        end;
        if LocationSec."Allow Transfer To Location" then begin
            JObject.Add('AllowTransferToLocation', 1);
        end
        else begin
            JObject.Add('AllowTransferToLocation', 0);
        end;
        if LocationSec."Is Default" then begin
            JObject.Add('IsDefault', 1);
        end
        else begin
            JObject.Add('IsDefault', 0);
        end;

        if LocationSec."Allow Transfer Creation" then begin
            JObject.Add('AllowTransferCreation', 1);
        end
        else begin
            JObject.Add('AllowTransferCreation', 0);
        end;
        if LocationSec."Allow Purchase Creation" then begin
            JObject.Add('AllowPurchaseCreation', 1);
        end
        else begin
            JObject.Add('AllowPurchaseCreation', 0);
        end;
        if LocationSec."Allow Sales Creation" then begin
            JObject.Add('AllowSalesCreation', 1);
        end
        else begin
            JObject.Add('AllowSalesCreation', 0);
        end;
        if LocationSec."Allow Direct Transfer Creation" then begin
            JObject.Add('AllowDirectTransferCreation', 1);
        end
        else begin
            JObject.Add('AllowDirectTransferCreation', 0);
        end;
        if LocationSec."Allow Dir. Transfer From Loc." then begin
            JObject.Add('AllowDirectTransferFromLocation', 1);
        end
        else begin
            JObject.Add('AllowDirectTransferFromLocation', 0);
        end;
        if LocationSec."Allow Dir. Transfer To Loc." then begin
            JObject.Add('AllowDirectTransferToLocation', 1);
        end
        else begin
            JObject.Add('AllowDirectTransferToLocation', 0);
        end;
        if LocationSec."Post Direct Transfer Order" then begin
            JObject.Add('PostDirectTransferOrder', 1);
        end
        else begin
            JObject.Add('PostDirectTransferOrder', 0);
        end;
        if LocationSec."Allow Phys. Inv." then begin
            JObject.Add('AllowPhysInv', 1);
        end
        else begin
            JObject.Add('AllowPhysInv', 0);
        end;
        if LocationSec."Allow Item Reclass. Bin To Bin" then begin
            JObject.Add('AllowItemReclassBinToBin', 1);
        end
        else begin
            JObject.Add('AllowItemReclassBinToBin', 0);
        end;
        if LocationSec."Allow Item Recl. Pick To Loc" then begin
            JObject.Add('AllowItemReclassPickToLocation', 1);
        end
        else begin
            JObject.Add('AllowItemReclassPickToLocation', 0);
        end;
        if LocationSec."Allow Item Recl. PA. From Loc" then begin
            JObject.Add('AllowItemRelcassPutAwayFromLocation', 1);
        end
        else begin
            JObject.Add('AllowItemRelcassPutAwayFromLocation', 0);
        end;


        if LocationSec."Allow Put Away Transfer Post" then begin
            JObject.Add('AllowPutAwayTransferPost', 1);
        end
        else begin
            JObject.Add('AllowPutAwayTransferPost', 0);
        end;

        if LocationSec."Allow PutAway Trans. Creation" then begin
            JObject.Add('AllowPutAwayTransferCreation', 1);
        end
        else begin
            JObject.Add('AllowPutAwayTransferCreation', 0);
        end;

        if LocationSec."Allow PutAway Transfer" then begin
            JObject.Add('AllowPutAwayTransfer', 1);
        end
        else begin
            JObject.Add('AllowPutAwayTransfer', 0);
        end;

        if LocationSec."Allow Pick Transfer Post Ship" then begin
            JObject.Add('AllowPickTransferPostShip', 1);
        end
        else begin
            JObject.Add('AllowPickTransferPostShip', 0);
        end;

        if LocationSec."Allow Pick Transfer Creation" then begin
            JObject.Add('AllowPickTransferCreation', 1);
        end
        else begin
            JObject.Add('AllowPickTransferCreation', 0);
        end;

        if LocationSec."Allow Pick Trans. Post Receipt" then begin
            JObject.Add('AllowPickTransferPostReceipt', 1);
        end
        else begin
            JObject.Add('AllowPickTransferPostReceipt', 0);
        end;

        if LocationSec."Allow Ship Transfer Pick" then begin
            JObject.Add('AllowShipTransferPick', 1);
        end
        else begin
            JObject.Add('AllowShipTransferPick', 0);
        end;

        if LocationSec."Allow Receive Transfer Pick" then begin
            JObject.Add('AllowReceiveTransferPick', 1);
        end
        else begin
            JObject.Add('AllowReceiveTransferPick', 0);
        end;
        if LocationSec."Allow Transfer Release" then begin
            JObject.Add('AllowTransferRelease', 1);
        end
        else begin
            JObject.Add('AllowTransferRelease', 0);
        end;

        if LocationSec."Allow Purchase Release" then begin
            JObject.Add('AllowPurchaseRelease', 1);
        end
        else begin
            JObject.Add('AllowPurchaseRelease', 0);
        end;

        if LocationSec."Allow Sales Release" then begin
            JObject.Add('AllowSalesRelease', 1);
        end
        else begin
            JObject.Add('AllowSalesRelease', 0);
        end;

        if LocationSec."Allow Pick Transfer From" then begin
            JObject.Add('AllowPickTransferFrom', 1);
        end
        else begin
            JObject.Add('AllowPickTransferFrom', 0);
        end;
        if LocationSec."Allow Pick Transfer To" then begin
            JObject.Add('AllowPickTransferTo', 1);
        end
        else begin
            JObject.Add('AllowPickTransferTo', 0);
        end;
        if LocationSec."Allow PutAway Transfer From" then begin
            JObject.Add('AllowPutAwayTransferFrom', 1);
        end
        else begin
            JObject.Add('AllowPutAwayTransferFrom', 0);
        end;
        if LocationSec."Allow PutAway Transfer To" then begin
            JObject.Add('AllowPutAwayTransferTo', 1);
        end
        else begin
            JObject.Add('AllowPutAwayTransferTo', 0);
        end;
        if LocationSec."Allow Direct TO" then begin
            JObject.Add('AllowDirectTO', 1);
        end
        else begin
            JObject.Add('AllowDirectTO', 0);
        end;
        if LocationSec."Allow Direct TO Creation" then begin
            JObject.Add('AllowDirectTOCreation', 1);
        end
        else begin
            JObject.Add('AllowDirectTOCreation', 0);
        end;
        if LocationSec."Allow Direct PO Post" then begin
            JObject.Add('AllowDirectPOPost', 1);
        end
        else begin
            JObject.Add('AllowDirectPOPost', 0);
        end;
        if LocationSec."Allow Direct TO Post" then begin
            JObject.Add('AllowDirectTOPost', 1);
        end
        else begin
            JObject.Add('AllowDirectTOPost', 0);
        end;

        if LocationSec."Allow Transfer Receive" then begin
            JObject.Add('AllowTransferReceive', 1);
        end
        else begin
            JObject.Add('AllowTransferReceive', 0);
        end;
        if LocationSec."Allow Transfer Ship" then begin
            JObject.Add('AllowTransferShip', 1);
        end
        else begin
            JObject.Add('AllowTransferShip', 0);
        end;

        EXIT(JObject);
    end;

    internal procedure GetHandheldLocationSecurity(userName: Text[50]): Text
    var
        LocationSec: Record "Stars Handheld Loc Security";
        Location: Record "Location";
        JObject: JsonObject;
        JArray: JsonArray;
        JsonTextL: Text;
    begin
        LocationSec.Reset();
        if (userName <> '') then begin

            LocationSec.SetRange("ID", userName);
            if LocationSec.FindSet() then begin
                repeat
                    Clear(JObject);
                    Location.get(LocationSec."Location Code");
                    JObject := AddLocationToJsonObject(LocationSec, Location);
                    JArray.Add(JObject);
                until LocationSec.Next() = 0;
            end;

            JArray.WriteTo(JsonTextL);
            EXIT(JsonTextL);
        end;

        if LocationSec.FindSet() then begin
            repeat
                Clear(JObject);
                Location.get(LocationSec."Location Code");
                JObject := AddLocationToJsonObject(LocationSec, Location);
                JArray.Add(JObject);
            until LocationSec.Next() = 0;
        end;
        JArray.WriteTo(JsonTextL);
        EXIT(JsonTextL);
    end;

    internal procedure AddWarehouseShipmentToJsonObject(WarehouseSH: Record "Warehouse Shipment Header"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('DocumentStatus', WarehouseSH."Document Status");
        JObject.Add('LocationCode', WarehouseSH."Location Code");
        JObject.Add('No', WarehouseSH."No.");
        JObject.Add('PostingDate', WarehouseSH."Posting Date");
        EXIT(JObject);
    end;

    internal procedure GetJournalBatchSessions(journalBatchName: Text; documentType: Integer): text
    var
        HandheldScan: Record "Stars Handheld Scan";
        SessionsListL: List of [Text];
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if BatchLocationBinMandatory(journalBatchName) then begin
            HandheldScan.SetRange("Document Type", documentType);
            HandheldScan.SetFilter("Journal Batch Name", journalBatchName);
            HandheldScan.setRange(Deleted, false);
            HandheldScan.setRange(Processed, false);
            if HandheldScan.FindSet() then begin
                repeat
                    if HandheldScan."Document Type" = "Stars HandHeld Scan Doc. Type"::"Phys. Inventory" then begin
                        if HandheldScan."Phys. Inv. Session" <> '' then begin
                            if HandheldScan."Bin Code" <> '' then begin
                                if not SessionsListL.Contains(HandheldScan."Phys. Inv. Session") then begin
                                    Clear(JObject);
                                    JObject.Add('Session', HandheldScan."Phys. Inv. Session");
                                    JArray.Add(JObject);
                                    SessionsListL.Add(HandheldScan."Phys. Inv. Session");
                                end;
                            end;
                        end;
                    end
                    else begin
                        if HandheldScan."Phys. Inv. Session" <> '' then begin
                            if not SessionsListL.Contains(HandheldScan."Phys. Inv. Session") then begin
                                Clear(JObject);
                                JObject.Add('Session', HandheldScan."Phys. Inv. Session");
                                JArray.Add(JObject);
                                SessionsListL.Add(HandheldScan."Phys. Inv. Session");
                            end;
                        end;
                    end;
                until HandheldScan.Next() = 0;
            end;
            JArray.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        HandheldScan.SetRange("Document Type", documentType);
        HandheldScan.SetFilter("Journal Batch Name", journalBatchName);
        HandheldScan.setRange(Deleted, false);
        HandheldScan.setRange(Processed, false);
        if HandheldScan.FindSet() then begin
            repeat
                if HandheldScan."Phys. Inv. Session" <> '' then begin
                    if not SessionsListL.Contains(HandheldScan."Phys. Inv. Session") then begin
                        Clear(JObject);
                        JObject.Add('Session', HandheldScan."Phys. Inv. Session");
                        JArray.Add(JObject);
                        SessionsListL.Add(HandheldScan."Phys. Inv. Session");
                    end;
                end;
            until HandheldScan.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetWarehouseJournalBatches(templatetype: Integer): text
    var
        WJB: Record "Warehouse Journal Batch";
        WJT: Record "Warehouse Journal Template";
        JObject: JsonObject;
        JArray: JsonArray;
        t: page "Location Card";
    begin
        if WJB.FindSet() then begin
            repeat
                WJT.Reset();
                WJT.SetRange(Name, WJB."Journal Template Name");
                if WJT.FindSet() then begin
                    repeat
                        if WJT.Type.AsInteger() = templatetype then begin
                            Clear(JObject);
                            JObject.Add('TemplateName', WJB."Journal Template Name");
                            JObject.Add('Name', WJB."Name");
                            JObject.Add('ShowCalculatedQty', WJB."Stars Show Calculated Qty.");
                            JArray.Add(JObject);
                        end;
                    until WJT.Next() = 0;
                end
            until WJB.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetWarehouseShipmentHeaders(no: Text[20]; locationCode: Text[10]; fromDate: Text[50]): Text
    var
        WarehouseSH: Record "Warehouse Shipment Header";
        WarehouseSH2: Record "Warehouse Shipment Header";
        JObject: JsonObject;
        JArray: JsonArray;
        dateFormat: Date;
    begin
        if (no <> '') then begin
            Clear(JObject);
            if WarehouseSH2.Get(no) then begin
                JObject := AddWarehouseShipmentToJsonObject(WarehouseSH2);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        if (locationCode <> '') then begin
            WarehouseSH.SetRange("Location Code", locationCode);
        end;
        if (fromDate <> '') then begin
            EVALUATE(dateFormat, fromDate);
            WarehouseSH.SetFilter("Posting Date", '>=%1', dateFormat);
        end;
        WarehouseSH.SetFilter("Document Status", '%1|%2|%3|%4', WarehouseSH."Document Status"::" ", WarehouseSH."Document Status"::"Partially Picked", WarehouseSH."Document Status"::"Partially Shipped", WarehouseSH."Document Status"::"Completely Picked");
        WarehouseSH.SetCurrentKey("Posting Date");
        WarehouseSH.SetAscending("Posting Date", false);
        if WarehouseSH.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddWarehouseShipmentToJsonObject(WarehouseSH);
                JArray.Add(JObject);
            until WarehouseSH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure AddWarehouseShipmentLineToJsonObject(WarehouseSH: Record "Warehouse Shipment Line"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('ItemNo', WarehouseSH."Item No.");
        JObject.Add('No', WarehouseSH."No.");
        JObject.Add('VariantCode', WarehouseSH."Variant Code");
        JObject.Add('QtyBase', WarehouseSH."Qty. (Base)");
        EXIT(JObject);
    end;

    internal procedure GetWarehouseShipmentLines(docNo: Text[20]; itemNo: text[20]; varirantCode: Text[10]): Text
    var
        WarehouseSH: Record "Warehouse Shipment Line";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        WarehouseSH.Reset();
        if (docNo <> '') then begin
            WarehouseSH.SetRange("No.", docNo);
        end;
        if (itemNo <> '') then begin
            WarehouseSH.SetRange("Item No.", itemNo);
        end;
        if (varirantCode <> '') then begin
            WarehouseSH.SetRange("Variant Code", varirantCode);
        end;
        if WarehouseSH.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddWarehouseShipmentLineToJsonObject(WarehouseSH);
                JArray.Add(JObject);
            until WarehouseSH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure AddWarehouseReceiptLineToJsonObject(WarehouseRL: Record "Warehouse Receipt Line"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('ItemNo', WarehouseRL."Item No.");
        JObject.Add('No', WarehouseRL."No.");
        JObject.Add('VariantCode', WarehouseRL."Variant Code");
        JObject.Add('QtyBase', WarehouseRL."Qty. (Base)");
        EXIT(JObject);
    end;

    internal procedure GetWarehouseReceiptLines(docNo: Text[20]; itemNo: text[20]; varirantCode: Text[10]): Text
    var
        WarehouseRL: Record "Warehouse Receipt Line";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if (docNo <> '') then begin
            WarehouseRL.SetRange("No.", docNo);
        end;
        if (itemNo <> '') then begin
            WarehouseRL.SetRange("Item No.", itemNo);
        end;
        if (varirantCode <> '') then begin
            WarehouseRL.SetRange("Variant Code", varirantCode);
        end;
        if WarehouseRL.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddWarehouseReceiptLineToJsonObject(WarehouseRL);
                JArray.Add(JObject);
            until WarehouseRL.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;


    internal procedure AddWarehouseReceiptToJsonObject(WarehouseRH: Record "Warehouse Receipt Header"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('LocationCode', WarehouseRH."Location Code");
        JObject.Add('No', WarehouseRH."No.");
        JObject.Add('PostingDate', WarehouseRH."Posting Date");
        JObject.Add('DocumentStatus', WarehouseRH."Document Status");
        EXIT(JObject);
    end;

    internal procedure GetWarehouseReceiptHeaders(no: Text[20]; locationCode: Text[10]; fromDate: Text[50]): Text
    var
        WarehouseRH: Record "Warehouse Receipt Header";
        WarehouseRH2: Record "Warehouse Receipt Header";
        JObject: JsonObject;
        JArray: JsonArray;
        dateFormat: Date;
    begin
        if (no <> '') then begin
            Clear(JObject);
            if WarehouseRH2.Get(no) then begin
                JObject := AddWarehouseReceiptToJsonObject(WarehouseRH2);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        if (locationCode <> '') then begin
            WarehouseRH.SetRange("Location Code", locationCode);
        end;
        if (fromDate <> '') then begin
            // EVALUATE(dateFormat, fromDate);
            // WarehouseRH.SETRANGE("Posting Date", dateFormat, 99991231D);
            EVALUATE(dateFormat, fromDate);
            WarehouseRH.SetFilter("Posting Date", '>=%1', dateFormat);
        end;
        WarehouseRH.SetFilter("Document Status", '%1|%2', WarehouseRH."Document Status"::" ", WarehouseRH."Document Status"::"Partially Received");
        WarehouseRH.SetCurrentKey("Posting Date");
        WarehouseRH.SetAscending("Posting Date", false);
        if WarehouseRH.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddWarehouseReceiptToJsonObject(WarehouseRH);
                JArray.Add(JObject);
            until WarehouseRH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure AddTransferToJsonObject(TransferH: Record "Transfer Header"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('No', TransferH."No.");
        JObject.Add('PostingDate', TransferH."Posting Date");
        JObject.Add('ReceiptDate', TransferH."Receipt Date");
        JObject.Add('ShipmentDate', TransferH."Shipment Date");
        JObject.Add('Status', TransferH.Status);
        JObject.Add('TransferFromCode', TransferH."Transfer-from Code");
        JObject.Add('TransferFromName', TransferH."Transfer-from Name");
        JObject.Add('TransferToCode', TransferH."Transfer-to Code");
        JObject.Add('TransferToName', TransferH."Transfer-to Name");
        if TransferH."Direct Transfer" then begin
            JObject.Add('DirectTransfer', 1);
        end
        else
            JObject.Add('DirectTransfer', 0);
        EXIT(JObject);
    end;

    internal procedure GetTransferHeaders(no: text[20]; locationCode: text[10]; status: integer; isDirectTransfer: Integer; isPutAway: Integer; isPick: Integer): Text
    var
        TransferH: Record "Transfer Header";
        TransferH2: Record "Transfer Header";
        JObject: JsonObject;
        JArray: JsonArray;
        isFromLocBinMandtory: Boolean;
        isToLocBinMandtory: Boolean;
    begin
        if (no <> '') then begin
            Clear(JObject);
            if TransferH2.Get(no) then begin
                JObject := AddTransferToJsonObject(TransferH2);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        if (locationCode <> '') then begin
            TransferH.FilterGroup(-1);
            TransferH.SetFilter("Transfer-from Code", locationCode);
            TransferH.SetFilter("Transfer-to Code", locationCode);
            TransferH.FilterGroup(0);
        end;
        if (status <> -1) then begin
            TransferH.SetRange(Status, status);
        end;
        if (isDirectTransfer = 1) then begin
            TransferH.SetRange("Direct Transfer", true);
        end
        else
            TransferH.SetRange("Direct Transfer", false);
        TransferH.SetCurrentKey("Posting Date");
        TransferH.SetAscending("Posting Date", false);
        if TransferH.FindSet() then begin
            repeat
                isFromLocBinMandtory := LocationBinMandatory(TransferH."Transfer-from Code");
                isToLocBinMandtory := LocationBinMandatory(TransferH."Transfer-to Code");
                if ((isPutAway = 1) Or (isDirectTransfer = 1)) then begin
                    if (Not isFromLocBinMandtory) And isToLocBinMandtory then begin
                        Clear(JObject);
                        JObject := AddTransferToJsonObject(TransferH);
                        JArray.Add(JObject);
                    end;
                end;
                if (isPick = 1) then begin
                    if (isFromLocBinMandtory) And (Not isToLocBinMandtory) then begin
                        Clear(JObject);
                        JObject := AddTransferToJsonObject(TransferH);
                        JArray.Add(JObject);
                    end;
                end;
                if ((isPutAway = 0) And (isDirectTransfer = 0) And (isPick = 0)) then begin
                    if (Not isFromLocBinMandtory) And (Not isToLocBinMandtory) then begin
                        Clear(JObject);
                        JObject := AddTransferToJsonObject(TransferH);
                        JArray.Add(JObject);
                    end;
                end;
            until TransferH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure AddSalesToJsonObject(SalesH: Record "Sales Header"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('CustomerName', SalesH."Bill-to Name");
        JObject.Add('CustomerNo', SalesH."Bill-to Customer No.");
        JObject.Add('DocumentType', SalesH."Document Type");
        JObject.Add('LocationCode', SalesH."Location Code");
        JObject.Add('No', SalesH."No.");
        JObject.Add('PostingDate', SalesH."Posting Date");
        JObject.Add('Status', SalesH.Status);
        EXIT(JObject);
    end;

    internal procedure GetSalesHeaders(docType: Integer; locationCode: text[10]; docNo: text[20]; status: integer): Text
    var
        SalesH: Record "Sales Header";
        SalesH2: Record "Sales Header";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if (docType <> -1) then begin
            SalesH.SetRange("Document Type", docType);
        end;
        if (docNo <> '') then begin
            SalesH.SetRange("No.", docNo);
            if SalesH.FindFirst() then begin
                //   if SalesH2.Get(docType, docNo) then begin
                Clear(JObject);
                JObject := AddSalesToJsonObject(SalesH);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        if (locationCode <> '') then begin
            SalesH.SetRange("Location Code", locationCode);
        end;
        if (status <> -1) then begin
            SalesH.SetRange(Status, status);
        end;

        SalesH.SetCurrentKey("Posting Date");
        SalesH.SetAscending("Posting Date", false);
        if SalesH.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddSalesToJsonObject(SalesH);
                JArray.Add(JObject);
            until SalesH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure AddPurchaseToJsonObject(PurchaseH: Record "Purchase Header"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('DocumentType', PurchaseH."Document Type");
        JObject.Add('LocationCode', PurchaseH."Location Code");
        JObject.Add('No', PurchaseH."No.");
        JObject.Add('PostingDate', PurchaseH."Posting Date");
        JObject.Add('Status', PurchaseH.Status);
        JObject.Add('UserId', PurchaseH."Assigned User ID");
        JObject.Add('VendorName', PurchaseH."Buy-from Vendor Name");
        JObject.Add('VendorNo', PurchaseH."Buy-from Vendor No.");
        EXIT(JObject);
    end;

    internal procedure GetPurchaseHeaders(docType: Integer; locationCode: text[10]; docNo: text[20]; status: integer): Text
    var
        PurchaseH: Record "Purchase Header";
        PurchaseH2: Record "Purchase Header";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if (docType <> -1) then begin
            PurchaseH.SetRange("Document Type", docType);
        end;
        if (docNo <> '') then begin
            PurchaseH.SetRange("No.", docNo);
            // if PurchaseH2.Get(docType, docNo) then begin
            if PurchaseH.FindFirst() then begin
                Clear(JObject);
                JObject := AddPurchaseToJsonObject(PurchaseH);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        if (locationCode <> '') then begin
            PurchaseH.SetRange("Location Code", locationCode);
        end;
        if (status <> -1) then begin
            PurchaseH.SetRange(Status, status);
        end;

        PurchaseH.SetCurrentKey("Posting Date");
        PurchaseH.SetAscending("Posting Date", false);
        if PurchaseH.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddPurchaseToJsonObject(PurchaseH);
                JArray.Add(JObject);
            until PurchaseH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetHandheldScan(entryNo: Integer; actionType: Integer; docType: Integer; docNo: Text[20]; itemNo: text[20]; varirantCode: Text[10]): Text
    var
        HandheldScans: Record "Stars Handheld Scan";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if (entryNo <> -1) Then begin
            if HandheldScans.Get(entryNo) then begin
                Clear(JObject);
                JObject := AddHandheldScanToJsonObject(HandheldScans);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        if (docType <> -1) then begin
            HandheldScans.SetRange("Document Type", docType);
        end;
        if (actionType <> -1) then begin
            HandheldScans.SetRange("Action Type", actionType);
        end;
        if (docNo <> '') then begin
            HandheldScans.SetRange("Document No.", docNo);
        end;
        if (itemNo <> '') then begin
            HandheldScans.SetRange("Item No.", itemNo);
        end;
        if (varirantCode <> '') then begin
            HandheldScans.SetRange("Variant Code", varirantCode);
        end;
        HandheldScans.SetRange("Processed", FALSE);
        HandheldScans.SetRange("Deleted", FALSE);
        HandheldScans.SetCurrentKey("Scanned Date/Time");
        HandheldScans.SetAscending("Scanned Date/Time", false);

        if HandheldScans.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddHandheldScanToJsonObject(HandheldScans);
                JArray.Add(JObject);
            until HandheldScans.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure AddHandheldScanToJsonObject(HandheldScans: Record "Stars Handheld Scan"): JsonObject
    var
        JObject: JsonObject;
    begin
        JObject.Add('ActionType', HandheldScans."Action Type");
        JObject.Add('BarcodeNo', HandheldScans."Barcode No.");
        JObject.Add('BaseUnitOfMeasureCode', HandheldScans."Base Unit of Measure Code");
        JObject.Add('BinCode', HandheldScans."Bin Code");
        JObject.Add('BinCodeTo', HandheldScans."Bin Code To");
        JObject.Add('DocumentNo', HandheldScans."Document No.");
        JObject.Add('DocumentType', HandheldScans."Document Type");
        JObject.Add('EntryNo', HandheldScans."Entry No.");
        JObject.Add('Expiry', HandheldScans.Expiry);
        JObject.Add('ExpiryTo', HandheldScans."Expiry To");
        JObject.Add('ItemDescription', HandheldScans."Item Description");
        JObject.Add('ItemNo', HandheldScans."Item No.");
        JObject.Add('JournalBatchName', HandheldScans."Journal Batch Name");
        JObject.Add('JournalTemplateName', HandheldScans."Journal Template Name");
        JObject.Add('LineNo', HandheldScans."Line No.");
        JObject.Add('LocationCode', HandheldScans."Location Code");
        JObject.Add('LocationCodeTo', HandheldScans."Location Code To");
        JObject.Add('LotNo', HandheldScans."Lot No.");
        JObject.Add('LotNoTo', HandheldScans."Lot No. To");
        if (HandheldScans.Processed) then begin
            JObject.Add('Processed', 1);
        end
        else begin
            JObject.Add('Processed', 0);
        end;
        JObject.Add('ProcessedBy', HandheldScans."Processed By");
        JObject.Add('ProcessedDateTime', HandheldScans."Processed Date/Time");
        JObject.Add('QtyPerUnitOfMeasure', HandheldScans."Qty. per Unit of Measure");
        JObject.Add('Quantity', HandheldScans.Quantity);
        JObject.Add('QuantityBase', HandheldScans."Quantity (Base)");
        JObject.Add('ScannedDate', HandheldScans."Scanned Date/Time");
        JObject.Add('SerialNo', HandheldScans."Serial No.");
        JObject.Add('SerialNoTo', HandheldScans."Serial No. To");
        JObject.Add('UnitOfMeasureCode', HandheldScans."Unit of Measure Code");
        JObject.Add('UserId', HandheldScans."User ID");
        JObject.Add('VariantCode', HandheldScans."Variant Code");
        JObject.Add('Session', HandheldScans."Phys. Inv. Session");
        if (HandheldScans.Deleted) then begin
            JObject.Add('Deleted', 1);
        end
        else begin
            JObject.Add('Deleted', 0);
        end;
        JObject.Add('DeletedBy', HandheldScans."Delete By");
        JObject.Add('DeletedDateTime', HandheldScans."Deleted Date/Time");
        EXIT(JObject);
    end;

    internal procedure MaxHandheldScan(): Integer
    var
        HandheldScans: Record "Stars Handheld Scan";
        lastEntryNo: Integer;
    begin
        HandheldScans.SetCurrentKey("Entry No.");
        if HandheldScans.FindLast() then begin
            lastEntryNo := HandheldScans."Entry No.";
        end;
        EXIT(lastEntryNo);
    end;



    internal procedure PostHandheldScan(actionType: Integer; barcodeNo: Text[20]; baseUnitOfMEasureCode: Text[10]; binCode: Text[20]; binCodeTo: Text[20]; documentNo: Text[20]; documentType: Integer;
    entryNo: Integer; expiry: Text[50]; expiryTo: Text[50]; itemDescription: Text[100]; itemNo: Text[20]; journalBatchName: Text[10]; journalTemplateName: Text[10]; lineNo: Integer; locationCode: Text[10];
    locationCodeTo: Text[10]; lotNo: Text[20]; lotNoTo: Text[20]; processed: Text[50]; processedBy: Text[50]; processedDateTime: Text[50]; qtyPerUnitOfMeasure: Text[50]; quantity: Text[50];
    quantityBase: Text[50]; scannedDateTime: Text[50]; serialNo: Text[20]; serialNoTo: Text[20]; unitOfMeasureCode: Text[10]; userId: Text[50]; variantCode: Text[10]; session: Text[50];
    deleted: Text[50]; deletedBy: Text[50]; deletedDateTime: Text[50]): Boolean
    var
        HandheldScans: Record "Stars Handheld Scan";
        dateFormat: Date;
        dateTime: DateTime;
        decimal: Decimal;
    begin
        HandheldScans.INIT();
        HandheldScans.VALIDATE("Entry No.", entryNo);
        HandheldScans.INSERT(TRUE);
        HandheldScans.VALIDATE("Action Type", actionType);
        HandheldScans.VALIDATE("Document Type", documentType);
        HandheldScans.VALIDATE("Document No.", documentNo);
        HandheldScans.VALIDATE("Item No.", itemNo);
        HandheldScans.VALIDATE("Variant Code", variantCode);
        HandheldScans.VALIDATE("Location Code", locationCode);
        HandheldScans.VALIDATE("Location Code To", locationCodeTo);
        HandheldScans.VALIDATE("Bin Code", binCode);
        HandheldScans.VALIDATE("Bin Code To", binCodeTo);
        HandheldScans.VALIDATE("Lot No.", lotNo);
        HandheldScans.VALIDATE("Lot No. To", lotNoTo);
        HandheldScans.VALIDATE("Serial No.", serialNo);
        HandheldScans.VALIDATE("Serial No. To", serialNoTo);

        if (expiry <> '1/1/1753 12:00:00 AM') then begin
            EVALUATE(dateFormat, expiry);
            HandheldScans.VALIDATE("Expiry", dateFormat);
        end;

        if (expiryTo <> '1/1/1753 12:00:00 AM') then begin
            EVALUATE(dateFormat, expiryTo);
            HandheldScans.VALIDATE("Expiry To", dateFormat);
        end;

        HandheldScans.Modify(TRUE);
        HandheldScans.VALIDATE("Barcode No.", barcodeNo);
        HandheldScans.VALIDATE("Base Unit of Measure Code", baseUnitOfMEasureCode);
        HandheldScans.VALIDATE("Item Description", itemDescription);
        HandheldScans.VALIDATE("Journal Batch Name", journalBatchName);
        HandheldScans.VALIDATE("Journal Template Name", journalTemplateName);
        HandheldScans.VALIDATE("Line No.", lineNo);
        if (processed = '1') then begin
            HandheldScans.VALIDATE("Processed", true);
            if (processedDateTime <> '1/1/1753 12:00:00 AM') then begin
                EVALUATE(dateTime, processedDateTime);
                HandheldScans.VALIDATE("Processed Date/Time", dateTime);
            end;
        end
        else begin
            HandheldScans.VALIDATE("Processed", false);
        end;
        HandheldScans.VALIDATE("Processed By", processedBy);
        EVALUATE(decimal, qtyPerUnitOfMeasure);
        HandheldScans.VALIDATE("Qty. per Unit of Measure", decimal);
        EVALUATE(decimal, quantity);
        HandheldScans.VALIDATE("Quantity", decimal);
        EVALUATE(decimal, quantityBase);
        HandheldScans.VALIDATE("Quantity (Base)", decimal);
        EVALUATE(dateTime, scannedDateTime);
        HandheldScans.VALIDATE("Scanned Date/Time", CurrentDateTime());
        HandheldScans.VALIDATE("Unit of Measure Code", unitOfMeasureCode);
        HandheldScans.VALIDATE("User ID", userId);
        HandheldScans.VALIDATE("Phys. Inv. Session", session);
        if (deleted = '1') then begin
            HandheldScans.VALIDATE("Deleted", true);
            if (deletedDateTime <> '1/1/1753 12:00:00 AM') then begin
                EVALUATE(dateTime, deletedDateTime);
                HandheldScans.VALIDATE("Deleted Date/Time", dateTime);
            end;
        end
        else begin
            HandheldScans.VALIDATE("Deleted", false);
        end;
        HandheldScans.VALIDATE("Delete By", deletedBy);
        HandheldScans.MODIFY(TRUE);
        EXIT(TRUE);
    end;


    internal procedure HandheldScanSearch(actionType: Integer; docType: Integer; docNo: Text[20]; journalBatchName: text[10]; journalTemplateName: Text[10]; session: Text[50]): Text
    var
        HandheldScans: Record "Stars Handheld Scan";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        HandheldScans.Reset();
        HandheldScans.SetRange("Action Type", actionType);
        HandheldScans.SetRange("Document Type", docType);
        HandheldScans.SetRange("Deleted", FALSE);
        If (docNo <> '') then begin
            HandheldScans.SetRange("Document No.", docNo);
        end;
        If (journalBatchName <> '') then begin
            HandheldScans.SetRange("Journal Batch Name", journalBatchName);
        end;
        If (journalTemplateName <> '') then begin
            HandheldScans.SetRange("Journal Template Name", journalTemplateName);
        end;
        If (session <> '') then begin
            HandheldScans.SetRange("Phys. Inv. Session", session);
        end;
        HandheldScans.SetCurrentKey("Scanned Date/Time");
        HandheldScans.SetAscending("Scanned Date/Time", false);
        If HandheldScans.FindSet() then begin
            repeat
                Clear(JObject);
                JObject := AddHandheldScanToJsonObject(HandheldScans);
                JArray.Add(JObject);
            until HandheldScans.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;


    internal procedure DeleteHandheldScan(journalTemplateName: text[10]; journalBatchName: Text[10]; session: Text[50]): Integer
    var
        HandheldScans: Record "Stars Handheld Scan";
    begin
        HandheldScans.Reset();
        HandheldScans.SetRange("Journal Template Name", journalTemplateName);
        HandheldScans.SetRange("Journal Batch Name", journalBatchName);
        HandheldScans.SetRange("Phys. Inv. Session", session);
        HandheldScans.SetRange(Processed, false);
        if HandheldScans.FindLast() then begin
            HandheldScans.delete;
            EXIT(1);
        end
        else begin
            EXIT(0);
        end;
    end;

    internal procedure DeleteHandheldScanSession(journalTemplateName: text[10]; journalBatchName: Text[10]; session: Text[50]): Integer
    var
        HandheldScans: Record "Stars Handheld Scan";
    begin
        HandheldScans.Reset();
        HandheldScans.SetRange("Journal Template Name", journalTemplateName);
        HandheldScans.SetRange("Journal Batch Name", journalBatchName);
        HandheldScans.SetRange("Phys. Inv. Session", session);
        HandheldScans.SetRange(Processed, false);
        if HandheldScans.FindSet() then begin
            Repeat
                HandheldScans.delete;
            until HandheldScans.next() = 0;
            EXIT(1);
        end else
            EXIT(0);
    end;

    internal procedure DeleteHandheldSession(journalTemplateName: text[10]; journalBatchName: Text[10]; session: Text[50]): Integer
    var
        handheldSession: Record "Stars Handheld Sessions";
    begin
        handheldSession.Reset();
        handheldSession.SetRange("Journal Template Name", journalTemplateName);
        handheldSession.SetRange("Journal Batch Name", journalBatchName);
        handheldSession.SetRange("Phys. Inv. Session", session);
        if handheldSession.FindFirst() then Begin
            handheldSession.delete(True);
            EXIT(1);
        End
        else
            EXIT(0);
    end;

    internal procedure DeleteHandheldScanWithBin(journalTemplateName: text[10]; journalBatchName: Text[10]; session: Text[50]): Integer
    var
        HandheldScans: Record "Stars Handheld Scan";
    begin
        HandheldScans.Reset();
        HandheldScans.SetRange("Journal Template Name", journalTemplateName);
        HandheldScans.SetRange("Journal Batch Name", journalBatchName);
        HandheldScans.SetRange("Phys. Inv. Session", session);
        HandheldScans.SetFilter("Bin Code", '<>%1', '');
        HandheldScans.SetRange(Processed, false);
        if HandheldScans.FindLast() then begin
            HandheldScans.delete;
            EXIT(1);
        end
        else begin
            EXIT(0);
        end;
    end;

    internal procedure GetVendors(): Text
    var
        Vendor: Record "Vendor";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if Vendor.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('Name', Vendor.Name);
                JObject.Add('No', Vendor."No.");
                JArray.Add(JObject);
            until Vendor.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetSalesHeaders(): Text
    var
        SalesH: Record "Sales Header";
        JObject: JsonObject;
        JArray: JsonArray;
    begin

        if SalesH.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('CustomerName', SalesH."Bill-to Name");
                JObject.Add('CustomerNo', SalesH."Bill-to Customer No.");
                JObject.Add('DocumentType', SalesH."Document Type");
                JObject.Add('LocationCode', SalesH."Location Code");
                JObject.Add('No', SalesH."No.");
                JObject.Add('PostingDate', SalesH."Posting Date");
                JObject.Add('Status', SalesH.Status);
                JObject.Add('UserId', SalesH."Assigned User ID");
                JArray.Add(JObject);
            until SalesH.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetPhysInvQtyScannedBase(actionType: Integer; documentType: Integer; JournalTemplateName: Text[10]; JournalBatchName: Text[10]; LocationCode: Text[10]; ItemNo: Text[20]; VariantCode: Text[10]; Session: Text[50]; binCode: text[20]; binCodeTo: text[20]): text
    var
        HandheldScans: Record "Stars Handheld Scan";
        result: Text;
        decimalResult: decimal;
    begin
        decimalResult := 0.0;
        HandheldScans.Reset();
        HandheldScans.SetCurrentKey("Action Type", "Document Type", "Location Code", "Item No.", "Variant Code", "Journal Template Name", "Journal Batch Name", "Phys. Inv. Session", Processed, Deleted);
        HandheldScans.SetRange("Action Type", actionType);
        HandheldScans.SetRange("Document Type", documentType);
        HandheldScans.SetRange("Location Code", LocationCode);
        HandheldScans.SetRange("Item No.", ItemNo);
        HandheldScans.SetRange("Variant Code", VariantCode);
        HandheldScans.SetRange("Journal Template Name", journalTemplateName);
        HandheldScans.SetRange("Journal Batch Name", journalBatchName);
        HandheldScans.SetRange("Phys. Inv. Session", session);
        HandheldScans.SetRange(Processed, false);
        HandheldScans.SetRange(Deleted, false);
        HandheldScans.SetRange("Bin Code", binCode);
        HandheldScans.SetRange("Bin Code To", binCodeTo);
        HandheldScans.CalcSums("Quantity (Base)");
        exit(Format(HandheldScans."Quantity (Base)"));

    end;

    internal procedure GetPhysInvQtyCalculated(JournalTemplateName: Text[10]; JournalBatchName: Text[10]; LocationCode: Text[10]; ItemNo: Text[20]; VariantCode: Text[10]): text
    var
        ItemJournalLine: Record "Item Journal Line";
        result: Text;
        decimalResult: decimal;
    begin
        //decimalResult := 0.0;

        ItemJournalLine.Reset();
        ItemJournalLine.SetCurrentKey("Entry Type", "Item No.", "Variant Code", "Location Code", "Bin Code", "Posting Date");
        ItemJournalLine.SetRange("Location Code", LocationCode);
        ItemJournalLine.SetRange("Item No.", ItemNo);
        ItemJournalLine.SetRange("Variant Code", VariantCode);
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.CalcSums("Qty. (Calculated)");
        exit(Format(ItemJournalLine."Qty. (Calculated)"));
    end;

    internal procedure CreateInfoHandheldScan(ActionTypeP: Option; DocumentTypeP: Option; DocumentNoP: Code[20]; LocationCodeP: Code[10]; DescriptionP: Text[100]; UserIdP: Code[50])
    var
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", ActionTypeP);
        HandheldScanL.VALIDATE("Document Type", DocumentTypeP);
        HandheldScanL.VALIDATE("Document No.", DocumentNoP);
        HandheldScanL.INSERT(TRUE);
        HandheldScanL.VALIDATE("Location Code", LocationCodeP);
        HandheldScanL.VALIDATE("Item Description", DescriptionP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.VALIDATE(Processed, TRUE);
        HandheldScanL.MODIFY(TRUE);
    end;

    internal procedure CreateInfoHandheldScan2(ActionTypeP: Option; DocumentTypeP: Option; DocumentNoP: Code[20]; FromLocationCodeP: Code[10]; ToLocationCodeP: Code[10]; DescriptionP: Text[100]; UserIdP: Code[50])
    var
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", ActionTypeP);
        HandheldScanL.VALIDATE("Document Type", DocumentTypeP);
        HandheldScanL.VALIDATE("Document No.", DocumentNoP);
        HandheldScanL.INSERT(TRUE);
        HandheldScanL.VALIDATE("Location Code", FromLocationCodeP);
        HandheldScanL.VALIDATE("Location Code To", ToLocationCodeP);
        HandheldScanL.VALIDATE("Item Description", DescriptionP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.VALIDATE(Processed, TRUE);
        HandheldScanL.MODIFY(TRUE);
    end;

    internal procedure GetDiscountedPrice(SalesPriceP: Decimal; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]): Decimal
    var
        "PriceListLine:": Record "Price List Line";
        SalesDiscPercentageL: Decimal;
        SalesDiscAmountL: Decimal;
    begin
        IF (SalesPriceP = 0) THEN
            EXIT(SalesPriceP);

        SalesDiscPercentageL := 0;
        "PriceListLine:".SETRANGE("Source Type", "PriceListLine:"."Source Type"::"All Customers");
        "PriceListLine:".SETRANGE("Asset Type", "PriceListLine:"."Asset Type"::Item);
        "PriceListLine:".SETRANGE("Asset No.", ItemNoP);
        "PriceListLine:".SETRANGE("Currency Code", '');
        "PriceListLine:".SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        "PriceListLine:".SETRANGE("Variant Code", VariantCodeP);
        "PriceListLine:".SETRANGE("Minimum Quantity", 1);
        "PriceListLine:".SETRANGE("Starting Date", 0D, TODAY);
        "PriceListLine:".SETFILTER("Ending Date", '%1|>=%2', 0D, TODAY);
        IF "PriceListLine:".FINDLAST() THEN
            SalesDiscPercentageL := "PriceListLine:"."Line Discount %";

        IF (SalesDiscPercentageL = 0) THEN
            EXIT(SalesPriceP);

        SalesDiscAmountL := SalesPriceP * SalesDiscPercentageL;
        SalesDiscAmountL /= 100;

        EXIT(ROUND(SalesPriceP - SalesDiscAmountL, 0.01));
    end;


    internal procedure GetRetailPrice(pItemNo: Code[20]; pVariantCode: Code[10]; pUnitOfMeasure: Code[10]; pLocationCode: Code[10]): Text
    var
        StoreRec: Record "LSC Store";
        StaffRec: Record "LSC Staff";
        POSTerminalRec: Record "LSC POS Terminal";
        POSTransactionRec: Record "LSC POS Transaction";
        POSTransLineRec: Record "LSC POS Trans. Line";
        ItemRec: Record Item;
        NewPOSTransLineRec: Record "LSC POS Trans. Line";
        InventorySetupRec: Record "Inventory Setup";
        DivisionRec: Record "LSC Division";
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        POSSessionCU: Codeunit "LSC POS Session";
        POSFunctionsCU: Codeunit "LSC POS Functions";
        JSONManagementCU: Codeunit "JSON Management";
        ReceiptNoC20: Code[20];
        QuantityD, PriceInBarcodeD, CalcQtyD : Decimal;
        ResultJO: JsonObject;
        ReturnJsonT, ResultT : Text;
    begin
        ItemRec.Get(pItemNo);
        if not DivisionRec.Get(ItemRec."LSC Division Code") then
            Clear(DivisionRec);

        StoreRec.SetRange("Location Code", pLocationCode);
        if not StoreRec.FindFirst() then begin
            Clear(StoreRec);
            InventorySetupRec.Get;
            StoreRec.Get(InventorySetupRec."Stars Default Store Pricing");
        end;

        GeneralLedgerSetupRec.Get();

        StaffRec.SetRange("Store No.", StoreRec."No.");
        if not StaffRec.FindFirst() then begin
            StaffRec.SetRange("Store No.", '');
            StaffRec.FindFirst();
        end;

        POSTerminalRec.SetRange("Store No.", StoreRec."No.");
        POSTerminalRec.FindFirst();

        POSSessionCU.SetStore(StoreRec."No.");
        POSSessionCU.SetTerminal(POSTerminalRec."No.");

        if (pItemNo = '') then exit;

        POSTransactionRec.SetRange("Receipt No.", 'XXX00000V', 'XXX99999V');
        if not POSTransactionRec.FindLast then
            ReceiptNoC20 := 'XXX00000V'
        else
            ReceiptNoC20 := IncStr(POSTransactionRec."Receipt No.");

        Clear(POSTransactionRec);
        Clear(POSTransLineRec);
        QuantityD := 0;

        POSTransactionRec."Staff ID" := StaffRec.ID;
        POSTransactionRec."Receipt No." := ReceiptNoC20;
        POSTransactionRec."Store No." := StoreRec."No.";
        POSTransactionRec."POS Terminal No." := POSTerminalRec."No.";
        POSTransactionRec.Insert;

        POSTransactionRec."VAT Bus.Posting Group" := StoreRec."Store VAT Bus. Post. Gr.";
        POSTransactionRec."Transaction Type" := POSTransactionRec."Transaction Type"::Sales;
        POSTransactionRec."Trans. Date" := Today;
        POSTransactionRec."Original Date" := POSTransactionRec."Trans. Date";
        POSTransactionRec."Trans Time" := Time;
        POSTransactionRec."Trans. Currency Code" := StoreRec."Currency Code";
        POSTransactionRec.Modify;

        POSTransactionRec.SetRange("Receipt No.", ReceiptNoC20);

        POSFunctionsCU.LoadOfferTables(true);
        POSFunctionsCU.PosTransDiscLoad(ReceiptNoC20);

        Clear(NewPOSTransLineRec);
        NewPOSTransLineRec."Receipt No." := ReceiptNoC20;
        NewPOSTransLineRec."Store No." := POSTransactionRec."Store No.";
        NewPOSTransLineRec."POS Terminal No." := POSTransactionRec."POS Terminal No.";
        NewPOSTransLineRec."Entry Type" := NewPOSTransLineRec."Entry Type"::Item;
        POSFunctionsCU.LoadItem(NewPOSTransLineRec);
        NewPOSTransLineRec.Number := ItemRec."No.";
        NewPOSTransLineRec."Barcode No." := ItemRec."No.";
        NewPOSTransLineRec.Validate(NewPOSTransLineRec.Number, NewPOSTransLineRec.Number);
        NewPOSTransLineRec."Variant Code" := pVariantCode;
        if pUnitOfMeasure <> '' then
            NewPOSTransLineRec."Unit of Measure" := pUnitOfMeasure;
        if NewPOSTransLineRec."Price in Barcode" then begin
            PriceInBarcodeD := NewPOSTransLineRec.Amount;
            NewPOSTransLineRec.Validate(NewPOSTransLineRec.Amount, PriceInBarcodeD);
            CalcQtyD := NewPOSTransLineRec.Quantity;
            QuantityD := CalcQtyD;
        end
        else
            if NewPOSTransLineRec."Quantity in Barcode" then
                QuantityD := NewPOSTransLineRec.Quantity
            else
                if QuantityD = 0 then
                    QuantityD := 1;
        POSTransactionRec."VAT Bus.Posting Group" := StoreRec."Store VAT Bus. Post. Gr.";

        POSTransLineRec.Copy(NewPOSTransLineRec);

        POSTransLineRec.Validate(Number, POSTransLineRec.Number);
        POSTransLineRec.InsertLine;

        POSTransLineRec.Get(POSTransLineRec."Receipt No.", POSTransLineRec."Line No.");

        if ItemRec."LSC Qty. Becomes Negative" then begin
            POSTransLineRec."Item/Dept. Negative" := true;
            POSTransLineRec.Validate(POSTransLineRec.Quantity, -QuantityD)
        end else
            POSTransLineRec.Validate(POSTransLineRec.Quantity, QuantityD);

        if POSTransLineRec."Price in Barcode" and (QuantityD = CalcQtyD) then
            POSTransLineRec.Validate(POSTransLineRec.Amount, PriceInBarcodeD);

        POSFunctionsCU.PosTransDiscFlush;
        POSFunctionsCU.ChangeVATBusOnLine(POSTransactionRec);
        POSFunctionsCU.RecalcSlip(POSTransactionRec);

        QuantityD := 0;

        JSONManagementCU.InitializeEmptyObject();
        ResultJO.Add('price', POSTransLineRec.Price);
        ResultJO.Add('discountAmount', POSTransLineRec."Discount Amount");
        ResultJO.Add('discountPcnt', POSTransLineRec."Discount %");
        ResultJO.Add('discountedPrice', POSTransLineRec.Amount);
        if StoreRec."Currency Code" = '' then
            ResultJO.Add('currency', GeneralLedgerSetupRec."LCY Code")
        else
            ResultJO.Add('currency', StoreRec."Currency Code");
        // POSTransactionRec.Delete;
        // POSTransLineRec.Delete;
        POSTransactionRec.Delete(true);
        ResultJO.WriteTo(ReturnJsonT);
        exit(ReturnJsonT);
    end;

    internal procedure GetRetailPricePerBarcode(BarcodeNoP: code[25]): Text
    var
        BarcodeL: Record "LSC Barcodes";
        ItemNoL: Code[20];
        VariantCodeL: code[20];
        RetailSetupL: Record "LSC Retail Setup";
        StoreL: Record "LSC Store";
        StaffL: Record "LSC Staff";
        POSTerminalL: Record "LSC POS Terminal";
        GlobalsCUL: Codeunit "LSC POS Session";
        POSTransactionL: Record "LSC POS Transaction";
        TransLineL: Record "LSC POS Trans. Line";
        ReceiptNoL: Code[20];
        QuantityL: Decimal;
        PosFuncCUL: Codeunit "LSC POS Functions";
        ItemL: Record Item;
        PriceInBarcodeL: Decimal;
        CalcQtyL: Decimal;
        VatSetupL: Record "VAT Posting Setup";
        ItemUOML: Record "Item Unit of Measure";
        NewLineL: Record "LSC POS Trans. Line";
        JSONMgtCUL: Codeunit "JSON Management";
        JResultL: JsonObject;
        InventorySetup: Record "Inventory Setup";
        DivisionL: Record "LSC Division";
        CurrencyL: Record Currency;
        GLSetup: Record "General Ledger Setup";
        test: Text;
        ReturnJSON: Text;
        Text005: Label 'Item Not Found';
    begin
        IF (BarcodeNoP = '') THEN EXIT;
        If BarcodeL.Get(BarcodeNoP) then begin
            ItemNoL := BarcodeL."Item No.";
            VariantCodeL := BarcodeL."Variant Code";
        end;
        //Exit(GetRetailPrice(ItemNoL, VariantCodeL));

        InventorySetup.GET;
        If not ItemL.GET(ItemNoL) then
            Error(Text005);
        IF NOT DivisionL.GET(ItemL."LSC Division Code") THEN
            CLEAR(DivisionL);
        StoreL.GET(InventorySetup."Stars Default Store Pricing");
        StaffL.SETRANGE("Store No.", StoreL."No.");
        StaffL.FINDFIRST();

        POSTerminalL.SETRANGE("Store No.", StoreL."No.");
        POSTerminalL.FINDFIRST();

        GlobalsCUL.SetStore(StoreL."No.");
        GlobalsCUL.SetTerminal(POSTerminalL."No.");

        IF (ItemNoL = '') THEN EXIT;

        POSTransactionL.SETRANGE("Receipt No.", 'XXX00000V', 'XXX99999V');
        IF NOT POSTransactionL.FINDLAST THEN
            ReceiptNoL := 'XXX00000V'
        ELSE
            ReceiptNoL := INCSTR(POSTransactionL."Receipt No.");

        CLEAR(POSTransactionL);
        CLEAR(TransLineL);
        QuantityL := 0;

        POSTransactionL."Staff ID" := StaffL.ID;
        POSTransactionL."Receipt No." := ReceiptNoL;
        POSTransactionL."Store No." := StoreL."No.";
        POSTransactionL."POS Terminal No." := POSTerminalL."No.";
        POSTransactionL.INSERT;

        POSTransactionL."VAT Bus.Posting Group" := StoreL."Store VAT Bus. Post. Gr.";
        POSTransactionL."Transaction Type" := POSTransactionL."Transaction Type"::Sales;
        POSTransactionL."Trans. Date" := TODAY;
        POSTransactionL."Original Date" := POSTransactionL."Trans. Date";
        POSTransactionL."Trans Time" := TIME;
        POSTransactionL."Trans. Currency Code" := StoreL."Currency Code";
        POSTransactionL.MODIFY;

        POSTransactionL.SETRANGE("Receipt No.", ReceiptNoL);

        PosFuncCUL.LoadOfferTables(TRUE);
        PosFuncCUL.PosTransDiscLoad(ReceiptNoL);

        CLEAR(NewLineL);
        NewLineL."Receipt No." := ReceiptNoL;
        NewLineL."Store No." := POSTransactionL."Store No.";
        NewLineL."POS Terminal No." := POSTransactionL."POS Terminal No.";
        NewLineL."Entry Type" := NewLineL."Entry Type"::Item;
        PosFuncCUL.LoadItem(NewLineL);
        NewLineL.Number := ItemL."No.";
        NewLineL."Barcode No." := ItemL."No.";
        NewLineL.VALIDATE(NewLineL.Number, NewLineL.Number);
        NewLineL."Variant Code" := VariantCodeL;
        IF NewLineL."Price in Barcode" THEN BEGIN
            PriceInBarcodeL := NewLineL.Amount;
            NewLineL.VALIDATE(NewLineL.Amount, PriceInBarcodeL);
            CalcQtyL := NewLineL.Quantity;
            QuantityL := CalcQtyL;
        END
        ELSE
            IF NewLineL."Quantity in Barcode" THEN
                QuantityL := NewLineL.Quantity
            ELSE
                IF QuantityL = 0 THEN
                    QuantityL := 1;
        POSTransactionL."VAT Bus.Posting Group" := StoreL."Store VAT Bus. Post. Gr.";

        TransLineL.COPY(NewLineL);

        TransLineL.VALIDATE(Number, TransLineL.Number);
        TransLineL.InsertLine;

        TransLineL.GET(TransLineL."Receipt No.", TransLineL."Line No.");

        IF ItemL."LSC Qty. Becomes Negative" THEN BEGIN
            TransLineL."Item/Dept. Negative" := TRUE;
            TransLineL.VALIDATE(TransLineL.Quantity, -QuantityL)
        END ELSE
            TransLineL.VALIDATE(TransLineL.Quantity, QuantityL);

        IF TransLineL."Price in Barcode" AND (QuantityL = CalcQtyL) THEN
            TransLineL.VALIDATE(TransLineL.Amount, PriceInBarcodeL);

        PosFuncCUL.PosTransDiscFlush;
        PosFuncCUL.ChangeVATBusOnLine(POSTransactionL);
        PosFuncCUL.RecalcSlip(POSTransactionL);

        QuantityL := 0;

        JSONMgtCUL.InitializeEmptyObject();
        JResultL.Add('price', TransLineL.Price);
        JResultL.Add('Description', TransLineL.Description);
        JResultL.Add('discountAmount', TransLineL."Discount Amount");
        JResultL.Add('discountPcnt', TransLineL."Discount %");
        JResultL.Add('discountedPrice', TransLineL.Amount);
        JResultL.Add('currency', GLSetup."Local Currency Symbol");

        POSTransactionL.DELETE;
        TransLineL.DELETE;
        JResultL.WriteTo(ReturnJSON);
        EXIT(ReturnJSON);
    end;

    internal procedure GetSalesAndDiscountedPrices(ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; var SalesPriceP: Decimal; var DiscountedPriceP: Decimal)
    begin
        SalesPriceP := GetSalesPrice(ItemNoP, VariantCodeP, UnitOfMeasureCodeP);
        DiscountedPriceP := GetDiscountedPrice(SalesPriceP, ItemNoP, VariantCodeP, UnitOfMeasureCodeP);
    end;

    internal procedure GetSalesPrice(ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]): Decimal
    var
        PriceListLineL: Record "Price List Line";
    begin
        PriceListLineL.SETRANGE("Source Type", PriceListLineL."Source Type"::"All Customers");
        PriceListLineL.SETRANGE("Asset Type", PriceListLineL."Asset Type"::Item);
        PriceListLineL.SETRANGE("Asset No.", ItemNoP);
        PriceListLineL.SETRANGE("Currency Code", '');
        PriceListLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        PriceListLineL.SETRANGE("Variant Code", VariantCodeP);
        PriceListLineL.SETRANGE("Minimum Quantity", 1);
        PriceListLineL.SETRANGE("Starting Date", 0D, TODAY);
        PriceListLineL.SETFILTER("Ending Date", '%1|>=%2', 0D, TODAY);
        IF PriceListLineL.FINDLAST() THEN
            EXIT(PriceListLineL."Unit Price")
        ELSE
            EXIT(0);
    end;


    internal procedure DirectedPickUpdate(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseActivityHeaderL: Record "Warehouse Activity Header";
        WMSUtilsCUL: Codeunit "Stars WMS Utils";
    begin
        WarehouseActivityHeaderL.GET(WarehouseActivityHeaderL.Type::Pick, DocumentNoP);
        WMSUtilsCUL.UpdateHandheldScanDirectedPicks(WarehouseActivityHeaderL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Directed Pick",
          DocumentNoP, WarehouseActivityHeaderL."Location Code", 'Directed Pick Update', UserIdP);
    end;


    internal procedure DirectedPickRegister(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseActivityLineL: Record "Warehouse Activity Line";
        WhseActivityRegisterCUL: Codeunit "Whse.-Activity-Register";
    begin
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::Pick);
        WarehouseActivityLineL.SETRANGE("No.", DocumentNoP);
        WarehouseActivityLineL.FINDFIRST();
        WhseActivityRegisterCUL.RUN(WarehouseActivityLineL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Directed Pick",
          DocumentNoP, WarehouseActivityLineL."Location Code", 'Directed Pick Register', UserIdP);
    end;


    internal procedure DirectedPutAwayUpdate(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseActivityHeaderL: Record "Warehouse Activity Header";
        WMSUtilsCUL: Codeunit "Stars WMS Utils";
    begin
        WarehouseActivityHeaderL.GET(WarehouseActivityHeaderL.Type::"Put-away", DocumentNoP);
        WMSUtilsCUL.UpdateHandheldScanDirectedPutAways(WarehouseActivityHeaderL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Directed Put Away",
          DocumentNoP, WarehouseActivityHeaderL."Location Code", 'Directed Put-Away Update', UserIdP);
    end;


    internal procedure DirectedPutAwayRegister(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseActivityLineL: Record "Warehouse Activity Line";
        WhseActivityRegisterCUL: Codeunit "Whse.-Activity-Register";
    begin
        WarehouseActivityLineL.SETRANGE("Activity Type", WarehouseActivityLineL."Activity Type"::"Put-away");
        WarehouseActivityLineL.SETRANGE("No.", DocumentNoP);
        WarehouseActivityLineL.FINDFIRST();
        WhseActivityRegisterCUL.RUN(WarehouseActivityLineL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Directed Put Away",
          DocumentNoP, WarehouseActivityLineL."Location Code", 'Directed Put-Away Register', UserIdP);
    end;


    internal procedure PurchaseHeaderCreate(DocumentTypeP: Option; VendorNoP: Code[20]; LocationCodeP: Code[10]; UserIdP: Code[50]): Code[20]
    var
        PurchaseHeaderL: Record "Purchase Header";
    begin
        PurchaseHeaderL.INIT();
        PurchaseHeaderL.VALIDATE("Document Type", DocumentTypeP);
        PurchaseHeaderL.VALIDATE("No.", '');
        PurchaseHeaderL.INSERT(TRUE);
        PurchaseHeaderL.VALIDATE("Buy-from Vendor No.", VendorNoP);
        PurchaseHeaderL.VALIDATE("Location Code", LocationCodeP);
        PurchaseHeaderL.MODIFY(TRUE);

        IF (DocumentTypeP = PurchaseHeaderL."Document Type"::"Return Order") THEN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Create, HandheldScanG."Document Type"::"Purchase Return Order",
              PurchaseHeaderL."No.", LocationCodeP, 'Purchase Return Order Create', UserIdP)
        ELSE
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Create, HandheldScanG."Document Type"::"Purchase Order",
              PurchaseHeaderL."No.", LocationCodeP, 'Purchase Order Create', UserIdP);

        EXIT(ToJsonString(PurchaseHeaderL."No."));
    end;


    internal procedure PurchaseHeaderPost(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        PurchaseHeaderL: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        IF PurchaseHeaderL.GET(DocumentTypeP, DocumentNoP) THEN BEGIN
            IF (PurchaseHeaderL."Document Type" = PurchaseHeaderL."Document Type"::Order) THEN
                PurchaseHeaderL.Receive := TRUE
            ELSE
                IF (PurchaseHeaderL."Document Type" = PurchaseHeaderL."Document Type"::"Return Order") THEN
                    PurchaseHeaderL.Ship := TRUE;

            CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PurchaseHeaderL);
            //PurchPost.SetSuppressCommit(true);
            //PurchPost.Run(PurchaseHeaderL);

            IF (DocumentTypeP = PurchaseHeaderL."Document Type"::"Return Order") THEN
                CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Purchase Return Order",
                  DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Return Order Post', UserIdP)
            ELSE
                CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Purchase Order",
                  DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Order Post', UserIdP);

            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    internal procedure PurchaseHeaderRelease(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        PurchaseHeaderL: Record "Purchase Header";
        ReleasePurchDocumentCUL: Codeunit "Release Purchase Document";
    begin
        IF NOT PurchaseHeaderL.GET(DocumentTypeP, DocumentNoP) THEN EXIT(FALSE);
        ReleasePurchDocumentCUL.PerformManualRelease(PurchaseHeaderL);
        IF NOT PurchaseHeaderL.GET(DocumentTypeP, DocumentNoP) OR (PurchaseHeaderL.Status <> PurchaseHeaderL.Status::Released) THEN EXIT(FALSE);

        IF (DocumentTypeP = PurchaseHeaderL."Document Type"::"Return Order") THEN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Purchase Return Order",
              DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Return Order Release', UserIdP)
        ELSE
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Purchase Order",
              DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Order Release', UserIdP);

        EXIT(TRUE);
    end;


    internal procedure PurchaseLineCreateUpdate(DocumentTypeP: Option; DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50])
    var
        PurchaseLineL: Record "Purchase Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        PurchaseHeaderL: Record "Purchase Header";
    begin
        PurchaseHeaderL.Get(DocumentTypeP, DocumentNoP);
        if PurchaseHeaderL.Status = PurchaseHeaderL.Status::Released then
            Error(Text005);

        PurchaseLineL.Reset();
        PurchaseLineL.SETRANGE("Document Type", DocumentTypeP);
        PurchaseLineL.SETRANGE("Document No.", DocumentNoP);
        PurchaseLineL.SETRANGE(Type, PurchaseLineL.Type::Item);
        PurchaseLineL.SETRANGE("No.", ItemNoP);
        PurchaseLineL.SETRANGE("Variant Code", VariantCodeP);
        PurchaseLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        IF PurchaseLineL.FINDFIRST() THEN BEGIN
            PurchaseLineL.VALIDATE(Quantity, PurchaseLineL.Quantity + QuantityP);
            PurchaseLineL.MODIFY(TRUE);
        END ELSE BEGIN
            PurchaseLineL.Reset();
            PurchaseLineL.SETRANGE("Document Type", DocumentTypeP);
            PurchaseLineL.SETRANGE("Document No.", DocumentNoP);
            IF PurchaseLineL.FINDLAST() THEN
                LineNoL := PurchaseLineL."Line No.";

            CLEAR(PurchaseLineL);
            PurchaseLineL.INIT();
            PurchaseLineL.VALIDATE("Document Type", DocumentTypeP);
            PurchaseLineL.VALIDATE("Document No.", DocumentNoP);
            PurchaseLineL.VALIDATE("Line No.", LineNoL + 10000);
            PurchaseLineL.INSERT(TRUE);
            PurchaseLineL.VALIDATE(Type, PurchaseLineL.Type::Item);
            PurchaseLineL.VALIDATE("No.", ItemNoP);
            PurchaseLineL.VALIDATE("Variant Code", VariantCodeP);
            PurchaseLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
            PurchaseLineL.VALIDATE(Quantity, QuantityP);
            PurchaseLineL.MODIFY(TRUE);
        END;

        PurchaseResEntryCreateUpdate(PurchaseLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

        Clear(HandheldScanL);
        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Create);
        IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::Order) THEN
            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Purchase Order")
        ELSE
            IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::"Return Order") THEN
                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Purchase Return Order");
        HandheldScanL.VALIDATE("Document No.", PurchaseLineL."Document No.");
        HandheldScanL.VALIDATE("Location Code", PurchaseLineL."Location Code");
        HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
        HandheldScanL.VALIDATE("Item No.", ItemNoP);
        HandheldScanL.VALIDATE("Variant Code", PurchaseLineL."Variant Code");
        HandheldScanL.VALIDATE("Unit of Measure Code", PurchaseLineL."Unit of Measure Code");
        HandheldScanL.VALIDATE(Quantity, QuantityP);
        HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * PurchaseLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Qty. per Unit of Measure", PurchaseLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Serial No.", SerialNoP);
        HandheldScanL.VALIDATE("Lot No.", LotNoP);
        HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.INSERT(TRUE);
    end;


    internal procedure PurchaseLineReceive(DocumentTypeP: Option; DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50])
    var
        PurchaseLineL: Record "Purchase Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToRec: Decimal;
        AllReceived: Boolean;
        ValidQtyToRec: Decimal;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        PurchaseHeader_l: Record "Purchase Header";
    begin
        //Stars04.00+
        //SF++
        PurchaseLineL.RESET;
        PurchaseLineL.SETCURRENTKEY("Document Type", "Document No.", Type, "No.", "Variant Code", "Unit of Measure Code", Quantity);
        //SF--
        PurchaseLineL.SETRANGE("Document Type", DocumentTypeP);
        PurchaseLineL.SETRANGE("Document No.", DocumentNoP);
        PurchaseLineL.SETRANGE(Type, PurchaseLineL.Type::Item);
        PurchaseLineL.SETRANGE("No.", ItemNoP);
        PurchaseLineL.SETRANGE("Variant Code", VariantCodeP);
        PurchaseLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        PurchaseLineL.SETFILTER(Quantity, '>%1', (PurchaseLineL."Quantity Received" + PurchaseLineL."Qty. to Receive"));
        IF PurchaseLineL.FIND('-') THEN BEGIN
            CLEAR(SumOfQty);
            CLEAR(SumOfQtyToRec);
            REPEAT
                SumOfQty := SumOfQty + (PurchaseLineL.Quantity - PurchaseLineL."Quantity Received");
                SumOfQtyToRec := SumOfQtyToRec + PurchaseLineL."Qty. to Receive";
            UNTIL PurchaseLineL.NEXT = 0;
            IF (SumOfQty) >= (SumOfQtyToRec + QuantityP) THEN BEGIN
                AllReceived := FALSE;
                PurchaseLineL.RESET;
                //Stars04.00-

                //SF++
                PurchaseLineL.SETCURRENTKEY("Document Type", "Document No.", Type, "No.", "Variant Code", "Unit of Measure Code", Quantity);
                //SF--
                PurchaseLineL.SETRANGE("Document Type", DocumentTypeP);
                PurchaseLineL.SETRANGE("Document No.", DocumentNoP);
                PurchaseLineL.SETRANGE(Type, PurchaseLineL.Type::Item);
                PurchaseLineL.SETRANGE("No.", ItemNoP);
                PurchaseLineL.SETRANGE("Variant Code", VariantCodeP);
                PurchaseLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
                PurchaseLineL.SETFILTER(Quantity, '>%1', (PurchaseLineL."Quantity Received" + PurchaseLineL."Qty. to Receive"));
                IF PurchaseLineL.FIND('-') THEN BEGIN
                    REPEAT
                        ValidQtyToRec := PurchaseLineL.Quantity - PurchaseLineL."Quantity Received" - PurchaseLineL."Qty. to Receive";
                        IF ValidQtyToRec >= QuantityP THEN BEGIN
                            AllReceived := TRUE;

                            IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::Order) THEN
                                PurchaseLineL.VALIDATE("Qty. to Receive", PurchaseLineL."Qty. to Receive" + QuantityP)
                            ELSE
                                IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::"Return Order") THEN
                                    PurchaseLineL.VALIDATE("Return Qty. to Ship", PurchaseLineL."Return Qty. to Ship" + QuantityP);

                            PurchaseHeader_l.GET(PurchaseLineL."Document Type", PurchaseLineL."Document No.");
                            //Stars07.00
                            // IF PurchaseHeader_l.Status = PurchaseHeader_l.Status::Released THEN
                            //ReleasePurchDoc.PerformManualReopen(PurchaseHeader_l);
                            PurchaseLineL.MODIFY(TRUE);
                            //Stars07.00
                            //IF PurchaseHeader_l.Status = PurchaseHeader_l.Status::Open THEN
                            //ReleasePurchDoc.PerformManualRelease(PurchaseHeader_l);

                            //PurchaseResEntryReceive(PurchaseLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);
                            PurchaseResEntryCreateUpdate(PurchaseLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::Order) THEN BEGIN
                                HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Purchase Order");
                            END ELSE
                                IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::"Return Order") THEN BEGIN
                                    HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                                    HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Purchase Return Order");
                                END;
                            HandheldScanL.VALIDATE("Document No.", PurchaseLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", PurchaseLineL."Location Code");

                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", ItemNoP);
                            HandheldScanL.VALIDATE("Variant Code", PurchaseLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", PurchaseLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, QuantityP);
                            HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * PurchaseLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", PurchaseLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);
                            //Stars04.00+
                        END ELSE BEGIN
                            IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::Order) THEN
                                PurchaseLineL.VALIDATE("Qty. to Receive", PurchaseLineL."Qty. to Receive" + ValidQtyToRec)
                            ELSE
                                IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::"Return Order") THEN
                                    PurchaseLineL.VALIDATE("Return Qty. to Ship", PurchaseLineL."Return Qty. to Ship" + ValidQtyToRec);

                            PurchaseHeader_l.GET(PurchaseLineL."Document Type", PurchaseLineL."Document No.");
                            // IF PurchaseHeader_l.Status = PurchaseHeader_l.Status::Released THEN
                            //   ReleasePurchDoc.PerformManualReopen(PurchaseHeader_l);
                            PurchaseLineL.MODIFY(TRUE);
                            //IF PurchaseHeader_l.Status = PurchaseHeader_l.Status::Open THEN
                            //  ReleasePurchDoc.PerformManualRelease(PurchaseHeader_l);

                            //PurchaseResEntryReceive(PurchaseLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);
                            PurchaseResEntryCreateUpdate(PurchaseLineL, ValidQtyToRec, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::Order) THEN BEGIN
                                HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Purchase Order");
                            END ELSE
                                IF (PurchaseLineL."Document Type" = PurchaseLineL."Document Type"::"Return Order") THEN BEGIN
                                    HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                                    HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Purchase Return Order");
                                END;
                            HandheldScanL.VALIDATE("Document No.", PurchaseLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", PurchaseLineL."Location Code");

                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", ItemNoP);
                            HandheldScanL.VALIDATE("Variant Code", PurchaseLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", PurchaseLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, ValidQtyToRec);
                            HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToRec * PurchaseLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", PurchaseLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);
                            QuantityP := QuantityP - ValidQtyToRec;
                        END;
                    UNTIL (PurchaseLineL.NEXT = 0) OR (AllReceived);
                END;
            END ELSE
                ERROR(Text003);
        END ELSE
            ERROR(Text004);
        //Stars04.00-
    end;

    internal procedure PurchaseResEntryCreateUpdate(PurchaseLineP: Record "Purchase Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Document type must be purchase order or purchase return order.';
        IsPositiveL: Boolean;
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        IsPositiveL := PurchaseResEntryIsPositive(PurchaseLineP);
        IF NOT IsPositiveL THEN
            QuantityP := -QuantityP;

        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, IsPositiveL);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Purchase Line");
        ReservationEntryL.SETRANGE("Source Subtype", PurchaseLineP."Document Type");
        ReservationEntryL.SETRANGE("Source ID", PurchaseLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", PurchaseLineP."Line No.");
        ReservationEntryL.SETRANGE("Item No.", PurchaseLineP."No.");
        ReservationEntryL.SETRANGE("Variant Code", PurchaseLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);
        IF ReservationEntryL.FINDFIRST() THEN BEGIN
            ReservationEntryL.VALIDATE("Quantity (Base)", ReservationEntryL."Quantity (Base)" + (QuantityP * PurchaseLineP."Qty. per Unit of Measure"));
            PurchaseResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END ELSE BEGIN
            ItemL.GET(PurchaseLineP."No.");
            IF (ItemL."Item Tracking Code" = '') THEN EXIT;
            ItemTrackingCodeL.GET(ItemL."Item Tracking Code");

            CLEAR(ReservationEntryL);
            IF ReservationEntryL.FINDLAST() THEN
                EntryNoL := ReservationEntryL."Entry No.";

            CLEAR(ReservationEntryL);
            ReservationEntryL.INIT;
            ReservationEntryL.VALIDATE("Entry No.", EntryNoL + 1);
            ReservationEntryL.VALIDATE(Positive, IsPositiveL);
            ReservationEntryL.VALIDATE("Reservation Status", ReservationEntryL."Reservation Status"::Surplus);
            ReservationEntryL.VALIDATE("Source Type", DATABASE::"Purchase Line");
            ReservationEntryL.VALIDATE("Source Subtype", PurchaseLineP."Document Type");
            ReservationEntryL.VALIDATE("Source ID", PurchaseLineP."Document No.");
            ReservationEntryL.VALIDATE("Source Ref. No.", PurchaseLineP."Line No.");
            ReservationEntryL.INSERT(TRUE);

            IF (ItemTrackingCodeL."Lot Specific Tracking" AND ItemTrackingCodeL."SN Specific Tracking") THEN
                ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot and Serial No.")
            ELSE
                IF (ItemTrackingCodeL."Lot Specific Tracking") THEN
                    ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot No.")
                ELSE
                    IF (ItemTrackingCodeL."SN Specific Tracking") THEN
                        ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Serial No.");

            ReservationEntryL.VALIDATE("Item No.", PurchaseLineP."No.");
            ReservationEntryL.Description := ItemL.Description;
            ReservationEntryL.VALIDATE("Variant Code", PurchaseLineP."Variant Code");
            ReservationEntryL.VALIDATE("Location Code", PurchaseLineP."Location Code");
            ReservationEntryL.VALIDATE("Expected Receipt Date", PurchaseLineP."Expected Receipt Date");
            ReservationEntryL.VALIDATE("Qty. per Unit of Measure", PurchaseLineP."Qty. per Unit of Measure");

            IF (LotNoP <> '') THEN
                ReservationEntryL.VALIDATE("Lot No.", LotNoP);
            IF (SerialNoP <> '') THEN
                ReservationEntryL.VALIDATE("Serial No.", SerialNoP);
            IF (ExpiryDateP <> 0D) THEN
                ReservationEntryL.VALIDATE("Expiration Date", ExpiryDateP);

            ReservationEntryL.VALIDATE("Quantity (Base)", QuantityP * PurchaseLineP."Qty. per Unit of Measure");
            ReservationEntryL."Creation Date" := WORKDATE;
            ReservationEntryL."Created By" := USERID;
            PurchaseResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END;
    end;

    internal procedure PurchaseResEntryReceive(PurchaseLineP: Record "Purchase Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Qty. to handle will be greater than %1.';
        IsPositiveL: Boolean;
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        IsPositiveL := PurchaseResEntryIsPositive(PurchaseLineP);
        IF NOT IsPositiveL THEN
            QuantityP := -QuantityP;

        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, IsPositiveL);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Purchase Line");
        ReservationEntryL.SETRANGE("Source Subtype", PurchaseLineP."Document Type");
        ReservationEntryL.SETRANGE("Source ID", PurchaseLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", PurchaseLineP."Line No.");
        ReservationEntryL.SETRANGE("Item No.", PurchaseLineP."No.");
        ReservationEntryL.SETRANGE("Variant Code", PurchaseLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);

        ReservationEntryL.FINDFIRST();
        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", ReservationEntryL."Qty. to Handle (Base)" + (QuantityP * PurchaseLineP."Qty. per Unit of Measure"));
        IF (ABS(ReservationEntryL."Qty. to Handle (Base)") > ABS(ReservationEntryL."Quantity (Base)")) THEN ERROR(Text001L, ReservationEntryL."Quantity (Base)");
        ReservationEntryL.MODIFY(TRUE);
    end;

    internal procedure PurchaseResEntryValidate(var ReservationEntryP: Record "Reservation Entry")
    var
        ReservationEntryL: Record "Reservation Entry";
        Text001L: Label '%1 must be -1, 0 or 1 when %2 is stated.';
        Text002L: Label 'Tracking specification with Serial No. %1 already exists.';
    begin
        IF (ReservationEntryP."Serial No." <> '') THEN BEGIN
            IF NOT (ReservationEntryP."Quantity (Base)" IN [-1, 0, 1]) THEN
                ERROR(Text001L, ReservationEntryP.FIELDCAPTION("Quantity (Base)"), ReservationEntryP.FIELDCAPTION("Serial No."));

            ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                            "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
            ReservationEntryL.SETRANGE(Positive, ReservationEntryP.Positive);
            ReservationEntryL.SETRANGE("Source Type", ReservationEntryP."Source Type");
            ReservationEntryL.SETRANGE("Source Subtype", ReservationEntryP."Source Subtype");
            ReservationEntryL.SETRANGE("Source ID", ReservationEntryP."Source ID");
            ReservationEntryL.SETRANGE("Source Ref. No.", ReservationEntryP."Source Ref. No.");
            ReservationEntryL.SETRANGE("Item No.", ReservationEntryP."Item No.");
            ReservationEntryL.SETRANGE("Variant Code", ReservationEntryP."Variant Code");
            ReservationEntryL.SETRANGE("Serial No.", ReservationEntryP."Serial No.");
            IF ReservationEntryL.FINDFIRST() THEN
                ERROR(Text002L, ReservationEntryP."Serial No.");
        END;
    end;

    internal procedure PurchaseResEntryIsPositive(var PurchaseLineP: Record "Purchase Line"): Boolean
    begin
        IF (PurchaseLineP."Document Type" = PurchaseLineP."Document Type"::Order) THEN
            EXIT(TRUE)
        ELSE
            IF (PurchaseLineP."Document Type" = PurchaseLineP."Document Type"::"Return Order") THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
    end;


    internal procedure PurchaseZeroQtyToReceiveShip(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        PurchaseHeaderL: Record "Purchase Header";
        PurchHeaderExistsL: Boolean;
        Text001L: Label 'The %1 %2 doesn''t exits.';
        Text002L: Label 'The %1 must be released.';
        PurchaseLineL: Record "Purchase Line";
        ReservationEntryL: Record "Reservation Entry";
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        PurchHeaderExistsL := PurchaseHeaderL.GET(DocumentTypeP, DocumentNoP);

        IF NOT PurchHeaderExistsL THEN
            ERROR(Text001L, DocumentTypeP, DocumentNoP);

        IF (PurchaseHeaderL.Status = PurchaseHeaderL.Status::Open) THEN
            ERROR(Text002L, FORMAT(PurchaseHeaderL."Document Type"));

        PurchaseLineL.SETRANGE("Document Type", PurchaseHeaderL."Document Type");
        PurchaseLineL.SETRANGE("Document No.", PurchaseHeaderL."No.");
        IF PurchaseLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                PurchaseLineL.VALIDATE("Qty. to Receive", 0);
                PurchaseLineL.VALIDATE("Return Qty. to Ship", 0);
                PurchaseLineL.MODIFY(TRUE);

                ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                                "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                ReservationEntryL.SETRANGE("Source Type", DATABASE::"Purchase Line");
                ReservationEntryL.SETRANGE("Source Subtype", PurchaseLineL."Document Type");
                ReservationEntryL.SETRANGE("Source ID", PurchaseLineL."Document No.");
                ReservationEntryL.SETRANGE("Source Ref. No.", PurchaseLineL."Line No.");
                IF ReservationEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", 0);
                        ReservationEntryL.MODIFY(TRUE);
                    UNTIL ReservationEntryL.NEXT() = 0;
                END;
            UNTIL PurchaseLineL.NEXT() = 0;
        END;

        IF (DocumentTypeP = PurchaseHeaderL."Document Type"::"Return Order") THEN BEGIN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Purchase Return Order",
              DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Return Order Zeroed Quantities', UserIdP);
            //Stars05.00+
            PurchaseLineL.RESET;
            PurchaseLineL.SETRANGE("Document Type", PurchaseHeaderL."Document Type");
            PurchaseLineL.SETRANGE("Document No.", PurchaseHeaderL."No.");
            PurchaseLineL.SETFILTER("Return Qty. Shipped", '>%1', 0);
            IF NOT PurchaseLineL.FINDFIRST THEN BEGIN
                HandheldScanL.SETRANGE("Document No.", PurchaseHeaderL."No.");
                HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Purchase Return Order");
                HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
                HandheldScanL.MODIFYALL("Delete By", USERID);
                HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
                HandheldScanL.MODIFYALL(Deleted, TRUE);
            END;
            //Stars05.00-
        END;

        IF (DocumentTypeP = PurchaseHeaderL."Document Type"::Order) THEN BEGIN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Purchase Order",
              DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Order Zeroed Quantities', UserIdP);
            //Stars05.00+
            PurchaseLineL.RESET;
            PurchaseLineL.SETRANGE("Document Type", PurchaseHeaderL."Document Type");
            PurchaseLineL.SETRANGE("Document No.", PurchaseHeaderL."No.");
            PurchaseLineL.SETFILTER("Quantity Received", '>%1', 0);
            IF NOT PurchaseLineL.FINDFIRST THEN BEGIN
                HandheldScanL.SETRANGE("Document No.", PurchaseHeaderL."No.");
                HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Purchase Order");
                HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Receive);
                HandheldScanL.MODIFYALL("Delete By", USERID);
                HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
                HandheldScanL.MODIFYALL(Deleted, TRUE);
            END;
            //Stars05.00-
        END;

        EXIT(TRUE);
    end;


    internal procedure TransferHeaderCreate(TransferFromCodeP: Code[10]; TransferToCodeP: Code[10]; UserIdP: Code[50]): Code[20]
    var
        TransferHeaderL: Record "Transfer Header";
        StoreL: Record "LSC Store";
    begin
        TransferHeaderL.INIT();
        TransferHeaderL.VALIDATE("No.", '');
        TransferHeaderL.INSERT(TRUE);
        TransferHeaderL.VALIDATE("Transfer-from Code", TransferFromCodeP);
        TransferHeaderL.VALIDATE("Transfer-to Code", TransferToCodeP);
        //Stars02.00+
        StoreL.SETCURRENTKEY("Location Code");
        IF StoreL.GET(TransferHeaderL."Transfer-from Code") THEN
            TransferHeaderL."LSC Store-from" := StoreL."No.";

        IF StoreL.GET(TransferHeaderL."Transfer-to Code") THEN
            TransferHeaderL."LSC Store-to" := StoreL."No.";
        //Stars02.00-
        TransferHeaderL.MODIFY(TRUE);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Create, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Transfer Order Create', UserIdP);

        EXIT(ToJsonString(TransferHeaderL."No."));
    end;


    internal procedure TransferHeaderRelease(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        ReleaseTransferDocCUL: Codeunit "Release Transfer Document";
    begin
        TransferHeaderL.GET(DocumentNoP);
        ReleaseTransferDocCUL.RUN(TransferHeaderL);
        TransferHeaderL.GET(DocumentNoP);
        IF (TransferHeaderL.Status <> TransferHeaderL.Status::Released) THEN EXIT(FALSE);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Transfer Order Release', UserIdP);

        EXIT(TRUE);
    end;


    internal procedure TransferHeaderPostReceipt(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        HandheldScan: Record "Stars HandHeld Scan";
        TransferLineL: Record "Transfer Line";
        TransferLine2L: Record "Transfer Line";
        ReservationEntryL: Record "Reservation Entry";
        InventorySetup: Record "Inventory Setup";
    begin
        TransferHeaderL.GET(DocumentNoP);

        //Stars09.00 ++
        HandheldScan.SETRANGE("Action Type", HandheldScan."Action Type"::Receive);
        HandheldScan.SETRANGE("Document Type", HandheldScan."Document Type"::"Transfer Order");
        HandheldScan.SETRANGE("Document No.", DocumentNoP);

        IF NOT HandheldScan.FIND('-') THEN
            ERROR('Cannot post - Must scan items before');
        //Stars09.00 --

        CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt", TransferHeaderL);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Transfer Order Post Receipt', UserIdP);

        InventorySetup.Get();
        if InventorySetup."Reset Qty After Tran Rec Post" then begin
            TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
            TransferLineL.SETRANGE("Derived From Line No.", 0);
            IF TransferLineL.FINDSET(TRUE) THEN BEGIN
                REPEAT
                    TransferLineL.VALIDATE("Qty. to Receive", 0);
                    TransferLineL.MODIFY(TRUE);

                    TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                    TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                    IF TransferLine2L.FINDSET(FALSE) THEN BEGIN
                        REPEAT
                            ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                                            "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                            ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
                            ReservationEntryL.SETRANGE("Source Subtype", 1);
                            ReservationEntryL.SETRANGE("Source ID", TransferLine2L."Document No.");
                            ReservationEntryL.SETRANGE("Source Ref. No.", TransferLine2L."Line No.");
                            IF ReservationEntryL.FINDSET(TRUE) THEN BEGIN
                                REPEAT
                                    ReservationEntryL.VALIDATE("Qty. to Handle (Base)", 0);
                                    ReservationEntryL.MODIFY(TRUE);
                                UNTIL ReservationEntryL.NEXT() = 0;
                            END;
                        UNTIL TransferLine2L.NEXT() = 0;
                    END;
                UNTIL TransferLineL.NEXT() = 0;
            end;
        end;

        EXIT(TRUE);
    end;


    internal procedure TransferHeaderPostShipment(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
    begin
        TransferHeaderL.GET(DocumentNoP);
        CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Shipment", TransferHeaderL);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Transfer Order Post Shipment', UserIdP);

        EXIT(TRUE);
    end;


    internal procedure TransferLineCreateUpdate(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50])
    var
        TransferLineL: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        TransferHeaderL: Record "Transfer Header";
    begin
        TransferHeaderL.Get(DocumentNoP);
        if TransferHeaderL.Status = TransferHeaderL.Status::Released then
            Error(Text005);
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        IF TransferLineL.FINDFIRST() THEN BEGIN
            TransferLineL.VALIDATE(Quantity, TransferLineL.Quantity + QuantityP);
            TransferLineL.MODIFY(TRUE);
        END ELSE BEGIN
            CLEAR(TransferLineL);
            TransferLineL.SETRANGE("Document No.", DocumentNoP);
            IF TransferLineL.FINDLAST() THEN
                LineNoL := TransferLineL."Line No.";

            CLEAR(TransferLineL);
            TransferLineL.INIT();
            TransferLineL.VALIDATE("Document No.", DocumentNoP);
            TransferLineL.VALIDATE("Line No.", LineNoL + 10000);
            TransferLineL.INSERT(TRUE);
            TransferLineL.VALIDATE("Item No.", ItemNoP);
            TransferLineL.VALIDATE("Variant Code", VariantCodeP);
            TransferLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
            TransferLineL.VALIDATE(Quantity, QuantityP);
            TransferLineL."Stars Barcode No." := BarcodeNoP; //Stars03.00
            TransferLineL.MODIFY(TRUE);
        END;

        TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Create);
        HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
        HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
        HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
        HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
        HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
        HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
        HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
        HandheldScanL.VALIDATE(Quantity, QuantityP);
        HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Serial No.", SerialNoP);
        HandheldScanL.VALIDATE("Lot No.", LotNoP);
        HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.INSERT(TRUE);
    end;


    internal procedure TransferLineReceive(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]): Boolean
    var
        TransferLineL: Record "Transfer Line";
        TransferLine2L: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToRec: Decimal;
        AllReceived: Boolean;
        ValidQtyToRec: Decimal;
    begin
        //Stars04.00+
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        TransferLineL.SETFILTER(Quantity, '>%1', TransferLineL."Qty. to Receive");
        IF TransferLineL.FINDFIRST THEN BEGIN
            CLEAR(SumOfQty);
            CLEAR(SumOfQtyToRec);
            REPEAT
                SumOfQty := SumOfQty + TransferLineL.Quantity;
                SumOfQtyToRec := SumOfQtyToRec + TransferLineL."Qty. to Receive";
            UNTIL TransferLineL.NEXT = 0;

            IF (SumOfQty) >= (SumOfQtyToRec + QuantityP) THEN BEGIN
                AllReceived := FALSE;
                TransferLineL.RESET;
                //Stars04.00-
                TransferLineL.SETRANGE("Document No.", DocumentNoP);
                TransferLineL.SETRANGE("Item No.", ItemNoP);
                TransferLineL.SETRANGE("Variant Code", VariantCodeP);
                TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
                IF TransferLineL.FINDFIRST THEN BEGIN
                    //Stars04.00+
                    REPEAT
                        ValidQtyToRec := TransferLineL.Quantity - TransferLineL."Qty. to Receive";
                        IF ValidQtyToRec >= QuantityP THEN BEGIN
                            AllReceived := TRUE;
                            //Stars04.00-
                            TransferLineL.VALIDATE("Qty. to Receive", TransferLineL."Qty. to Receive" + QuantityP);
                            TransferLineL.MODIFY(TRUE);

                            TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                            TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                            TransferLine2L.FINDFIRST();
                            TransferResEntryReceive(TransferLine2L, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, QuantityP);
                            HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);
                            //Stars04.00+
                        END ELSE BEGIN
                            TransferLineL.VALIDATE("Qty. to Receive", TransferLineL."Qty. to Receive" + ValidQtyToRec);
                            TransferLineL.MODIFY(TRUE);

                            TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                            TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                            TransferLine2L.FINDFIRST();
                            TransferResEntryReceive(TransferLine2L, ValidQtyToRec, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, ValidQtyToRec);
                            HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToRec * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);

                            QuantityP := QuantityP - ValidQtyToRec;
                        END;
                    UNTIL (TransferLineL.NEXT = 0) OR (AllReceived);
                    EXIT(TRUE);
                END;
            END ELSE
                ERROR(Text003);
        END ELSE
            ERROR(Text004);
        //Stars04.00-
    end;


    internal procedure TransferLineShip(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]): Boolean
    var
        TransferLineL: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToShip: Decimal;
        AllShipped: Boolean;
        ValidQtyToShip: Decimal;
    begin
        //Stars04.00+
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        TransferLineL.SETFILTER(Quantity, '>%1', TransferLineL."Qty. to Ship");
        IF TransferLineL.FINDFIRST THEN BEGIN
            CLEAR(SumOfQty);
            CLEAR(SumOfQtyToShip);
            REPEAT
                SumOfQty := SumOfQty + TransferLineL.Quantity;
                SumOfQtyToShip := SumOfQtyToShip + TransferLineL."Qty. to Ship";
            UNTIL TransferLineL.NEXT = 0;

            IF (SumOfQty) >= (SumOfQtyToShip + QuantityP) THEN BEGIN
                AllShipped := FALSE;
                TransferLineL.RESET;
                //Stars04.00-
                TransferLineL.SETRANGE("Document No.", DocumentNoP);
                TransferLineL.SETRANGE("Item No.", ItemNoP);
                TransferLineL.SETRANGE("Variant Code", VariantCodeP);
                TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
                TransferLineL.SETFILTER(Quantity, '>%1', TransferLineL."Qty. to Ship");
                IF TransferLineL.FINDFIRST THEN BEGIN
                    //Stars04.00+
                    REPEAT
                        ValidQtyToShip := TransferLineL.Quantity - TransferLineL."Qty. to Ship";
                        IF ValidQtyToShip >= QuantityP THEN BEGIN
                            AllShipped := TRUE;
                            //Stars04.00-
                            TransferLineL.VALIDATE("Qty. to Ship", TransferLineL."Qty. to Ship" + QuantityP);
                            TransferLineL.MODIFY(TRUE);

                            TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, QuantityP);
                            HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);
                            //Stars04.00+
                        END ELSE BEGIN
                            TransferLineL.VALIDATE("Qty. to Ship", TransferLineL."Qty. to Ship" + ValidQtyToShip);
                            TransferLineL.MODIFY(TRUE);

                            TransferResEntryCreateUpdate(TransferLineL, ValidQtyToShip, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, ValidQtyToShip);
                            HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToShip * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);

                            QuantityP := QuantityP - ValidQtyToShip;
                        END;
                    UNTIL (TransferLineL.NEXT = 0) OR (AllShipped);
                    EXIT(TRUE);
                END;
            END ELSE
                ERROR(Text001);
        END ELSE
            ERROR(Text002);
        //Stars04.00-
    end;

    internal procedure TransferResEntryCreateUpdate(TransferLineP: Record "Transfer Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Document type must be purchase order or purchase return order.';
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, FALSE);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
        ReservationEntryL.SETRANGE("Source Subtype", 0);
        ReservationEntryL.SETRANGE("Source ID", TransferLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", TransferLineP."Line No.");
        ReservationEntryL.SETRANGE("Location Code", TransferLineP."Transfer-from Code");
        ReservationEntryL.SETRANGE("Item No.", TransferLineP."Item No.");
        ReservationEntryL.SETRANGE("Variant Code", TransferLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);
        IF ReservationEntryL.FINDFIRST() THEN BEGIN
            ReservationEntryL.VALIDATE("Quantity (Base)", ReservationEntryL."Quantity (Base)" + (-QuantityP * TransferLineP."Qty. per Unit of Measure"));
            TransferResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END ELSE BEGIN
            ItemL.GET(TransferLineP."Item No.");
            IF (ItemL."Item Tracking Code" = '') THEN EXIT;
            ItemTrackingCodeL.GET(ItemL."Item Tracking Code");

            CLEAR(ReservationEntryL);
            IF ReservationEntryL.FINDLAST() THEN
                EntryNoL := ReservationEntryL."Entry No.";

            CLEAR(ReservationEntryL);
            ReservationEntryL.INIT;
            ReservationEntryL.VALIDATE("Entry No.", EntryNoL + 1);
            ReservationEntryL.VALIDATE(Positive, FALSE);
            ReservationEntryL.VALIDATE("Reservation Status", ReservationEntryL."Reservation Status"::Surplus);
            ReservationEntryL.VALIDATE("Source Type", DATABASE::"Transfer Line");
            ReservationEntryL.VALIDATE("Source Subtype", 0);
            ReservationEntryL.VALIDATE("Source ID", TransferLineP."Document No.");
            ReservationEntryL.VALIDATE("Source Ref. No.", TransferLineP."Line No.");
            ReservationEntryL.INSERT(TRUE);

            IF (ItemTrackingCodeL."Lot Specific Tracking" AND ItemTrackingCodeL."SN Specific Tracking") THEN
                ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot and Serial No.")
            ELSE
                IF (ItemTrackingCodeL."Lot Specific Tracking") THEN
                    ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot No.")
                ELSE
                    IF (ItemTrackingCodeL."SN Specific Tracking") THEN
                        ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Serial No.");

            ReservationEntryL.VALIDATE("Item No.", TransferLineP."Item No.");
            ReservationEntryL.Description := ItemL.Description;
            ReservationEntryL.VALIDATE("Variant Code", TransferLineP."Variant Code");
            ReservationEntryL.VALIDATE("Location Code", TransferLineP."Transfer-from Code");
            ReservationEntryL.VALIDATE("Shipment Date", TransferLineP."Shipment Date");
            ReservationEntryL.VALIDATE("Qty. per Unit of Measure", TransferLineP."Qty. per Unit of Measure");

            IF (LotNoP <> '') THEN
                ReservationEntryL.VALIDATE("Lot No.", LotNoP);
            IF (SerialNoP <> '') THEN
                ReservationEntryL.VALIDATE("Serial No.", SerialNoP);
            IF (ExpiryDateP <> 0D) THEN
                ReservationEntryL.VALIDATE("Expiration Date", ExpiryDateP);

            ReservationEntryL.VALIDATE("Quantity (Base)", -QuantityP * TransferLineP."Qty. per Unit of Measure");
            ReservationEntryL."Creation Date" := WORKDATE;
            ReservationEntryL."Created By" := USERID;
            TransferResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END;

        CLEAR(ReservationEntryL);
        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, TRUE);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
        ReservationEntryL.SETRANGE("Source Subtype", 1);
        ReservationEntryL.SETRANGE("Source ID", TransferLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", TransferLineP."Line No.");
        ReservationEntryL.SETRANGE("Location Code", TransferLineP."Transfer-to Code");
        ReservationEntryL.SETRANGE("Item No.", TransferLineP."Item No.");
        ReservationEntryL.SETRANGE("Variant Code", TransferLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);
        IF ReservationEntryL.FINDFIRST() THEN BEGIN
            ReservationEntryL.VALIDATE("Quantity (Base)", ReservationEntryL."Quantity (Base)" + (QuantityP * TransferLineP."Qty. per Unit of Measure"));
            TransferResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END ELSE BEGIN
            ItemL.GET(TransferLineP."Item No.");
            IF (ItemL."Item Tracking Code" = '') THEN EXIT;
            ItemTrackingCodeL.GET(ItemL."Item Tracking Code");

            CLEAR(ReservationEntryL);
            IF ReservationEntryL.FINDLAST() THEN
                EntryNoL := ReservationEntryL."Entry No.";

            CLEAR(ReservationEntryL);
            ReservationEntryL.INIT;
            ReservationEntryL.VALIDATE("Entry No.", EntryNoL + 1);
            ReservationEntryL.VALIDATE(Positive, TRUE);
            ReservationEntryL.VALIDATE("Reservation Status", ReservationEntryL."Reservation Status"::Surplus);
            ReservationEntryL.VALIDATE("Source Type", DATABASE::"Transfer Line");
            ReservationEntryL.VALIDATE("Source Subtype", 1);
            ReservationEntryL.VALIDATE("Source ID", TransferLineP."Document No.");
            ReservationEntryL.VALIDATE("Source Ref. No.", TransferLineP."Line No.");
            ReservationEntryL.INSERT(TRUE);

            IF (ItemTrackingCodeL."Lot Specific Tracking" AND ItemTrackingCodeL."SN Specific Tracking") THEN
                ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot and Serial No.")
            ELSE
                IF (ItemTrackingCodeL."Lot Specific Tracking") THEN
                    ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot No.")
                ELSE
                    IF (ItemTrackingCodeL."SN Specific Tracking") THEN
                        ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Serial No.");

            ReservationEntryL.VALIDATE("Item No.", TransferLineP."Item No.");
            ReservationEntryL.Description := ItemL.Description;
            ReservationEntryL.VALIDATE("Variant Code", TransferLineP."Variant Code");
            ReservationEntryL.VALIDATE("Location Code", TransferLineP."Transfer-to Code");
            ReservationEntryL.VALIDATE("Expected Receipt Date", TransferLineP."Receipt Date");
            ReservationEntryL.VALIDATE("Qty. per Unit of Measure", TransferLineP."Qty. per Unit of Measure");

            IF (LotNoP <> '') THEN
                ReservationEntryL.VALIDATE("Lot No.", LotNoP);
            IF (SerialNoP <> '') THEN
                ReservationEntryL.VALIDATE("Serial No.", SerialNoP);
            IF (ExpiryDateP <> 0D) THEN
                ReservationEntryL.VALIDATE("Expiration Date", ExpiryDateP);

            ReservationEntryL.VALIDATE("Quantity (Base)", QuantityP * TransferLineP."Qty. per Unit of Measure");
            ReservationEntryL."Creation Date" := WORKDATE;
            ReservationEntryL."Created By" := USERID;
            TransferResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END;
    end;

    internal procedure TransferResEntryReceive(TransferLineP: Record "Transfer Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Qty. to handle will be greater than %1.';
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, TRUE);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
        ReservationEntryL.SETRANGE("Source Subtype", 1);
        ReservationEntryL.SETRANGE("Source ID", TransferLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", TransferLineP."Line No.");
        ReservationEntryL.SETRANGE("Item No.", TransferLineP."Item No.");
        ReservationEntryL.SETRANGE("Variant Code", TransferLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);

        ReservationEntryL.FINDFIRST();
        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", ReservationEntryL."Qty. to Handle (Base)" + (QuantityP * TransferLineP."Qty. per Unit of Measure"));
        IF (ReservationEntryL."Qty. to Handle (Base)" > ReservationEntryL."Quantity (Base)") THEN ERROR(Text001L, ReservationEntryL."Quantity (Base)");
        ReservationEntryL.MODIFY(TRUE);
    end;

    internal procedure TransferResEntryShip(TransferLineP: Record "Transfer Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Qty. to handle will be greater than %1.';
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, FALSE);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
        ReservationEntryL.SETRANGE("Source Subtype", 0);
        ReservationEntryL.SETRANGE("Source ID", TransferLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", TransferLineP."Line No.");
        ReservationEntryL.SETRANGE("Item No.", TransferLineP."Item No.");
        ReservationEntryL.SETRANGE("Variant Code", TransferLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);

        ReservationEntryL.FINDFIRST();
        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", ReservationEntryL."Qty. to Handle (Base)" + (-QuantityP * TransferLineP."Qty. per Unit of Measure"));
        IF (ReservationEntryL."Qty. to Handle (Base)" < ReservationEntryL."Quantity (Base)") THEN ERROR(Text001L, ReservationEntryL."Quantity (Base)");
        ReservationEntryL.MODIFY(TRUE);
    end;

    internal procedure TransferResEntryValidate(var ReservationEntryP: Record "Reservation Entry")
    var
        ReservationEntryL: Record "Reservation Entry";
        Text001L: Label '%1 must be -1, 0 or 1 when %2 is stated.';
        Text002L: Label 'Tracking specification with Serial No. %1 already exists.';
    begin
        IF (ReservationEntryP."Serial No." <> '') THEN BEGIN
            IF NOT (ReservationEntryP."Quantity (Base)" IN [-1, 0, 1]) THEN
                ERROR(Text001L, ReservationEntryP.FIELDCAPTION("Quantity (Base)"), ReservationEntryP.FIELDCAPTION("Serial No."));

            ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                            "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
            ReservationEntryL.SETRANGE(Positive, ReservationEntryP.Positive);
            ReservationEntryL.SETRANGE("Source Type", ReservationEntryP."Source Type");
            ReservationEntryL.SETRANGE("Source Subtype", ReservationEntryP."Source Subtype");
            ReservationEntryL.SETRANGE("Source ID", ReservationEntryP."Source ID");
            ReservationEntryL.SETRANGE("Source Ref. No.", ReservationEntryP."Source Ref. No.");
            ReservationEntryL.SETRANGE("Item No.", ReservationEntryP."Item No.");
            ReservationEntryL.SETRANGE("Variant Code", ReservationEntryP."Variant Code");
            ReservationEntryL.SETRANGE("Serial No.", ReservationEntryP."Serial No.");
            IF ReservationEntryL.FINDFIRST() THEN
                ERROR(Text002L, ReservationEntryL."Serial No.");
        END;
    end;


    internal procedure TransferZeroQtyToShip(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        Text001L: Label 'The transfer order must be released.';
        TransferLineL: Record "Transfer Line";
        ReservationEntryL: Record "Reservation Entry";
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        TransferHeaderL.GET(DocumentNoP);

        IF (TransferHeaderL.Status = TransferHeaderL.Status::Open) THEN
            ERROR(Text001L);

        TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);
        IF TransferLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                TransferLineL.VALIDATE("Qty. to Ship", 0);
                TransferLineL.MODIFY(TRUE);

                ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                                "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
                ReservationEntryL.SETRANGE("Source Subtype", 0);
                ReservationEntryL.SETRANGE("Source ID", TransferLineL."Document No.");
                ReservationEntryL.SETRANGE("Source Ref. No.", TransferLineL."Line No.");
                IF ReservationEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", 0);
                        ReservationEntryL.MODIFY(TRUE);
                    UNTIL ReservationEntryL.NEXT() = 0;
                END;
            UNTIL TransferLineL.NEXT() = 0;
        END;

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Transfer Order Zeroed Shipment Quantities', UserIdP);

        //Stars05.00+
        TransferLineL.RESET;
        TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);
        TransferLineL.SETFILTER("Quantity Shipped", '>%1', 0);
        IF NOT TransferLineL.FINDFIRST THEN BEGIN
            HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
            HandheldScanL.SETRANGE("Document No.", TransferHeaderL."No.");
            HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
            HandheldScanL.MODIFYALL("Delete By", USERID);
            HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
            HandheldScanL.MODIFYALL(Deleted, TRUE);
        END;
        //Stars05.00-

        //Stars06.00 ++
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.SETRANGE("Document No.", TransferHeaderL."No.");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
        HandheldScanL.SETRANGE(Deleted, FALSE);

        //HandheldScanL.MODIFYALL("Reset All By",USERID);
        //HandheldScanL.MODIFYALL("Reset All Date/Time",CURRENTDATETIME);
        //HandheldScanL.MODIFYALL("Reset All",TRUE);
        //Stars06.00--

        EXIT(TRUE);
    end;


    internal procedure TransferZeroQtyToReceive(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        Text001L: Label 'The transfer order must be released.';
        TransferLineL: Record "Transfer Line";
        TransferLine2L: Record "Transfer Line";
        ReservationEntryL: Record "Reservation Entry";
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        TransferHeaderL.GET(DocumentNoP);

        IF (TransferHeaderL.Status = TransferHeaderL.Status::Open) THEN
            ERROR(Text001L);

        TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);
        IF TransferLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                TransferLineL.VALIDATE("Qty. to Receive", 0);
                TransferLineL.MODIFY(TRUE);

                TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                IF TransferLine2L.FINDSET(FALSE) THEN BEGIN
                    REPEAT
                        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
                        ReservationEntryL.SETRANGE("Source Subtype", 1);
                        ReservationEntryL.SETRANGE("Source ID", TransferLine2L."Document No.");
                        ReservationEntryL.SETRANGE("Source Ref. No.", TransferLine2L."Line No.");
                        IF ReservationEntryL.FINDSET(TRUE) THEN BEGIN
                            REPEAT
                                ReservationEntryL.VALIDATE("Qty. to Handle (Base)", 0);
                                ReservationEntryL.MODIFY(TRUE);
                            UNTIL ReservationEntryL.NEXT() = 0;
                        END;
                    UNTIL TransferLine2L.NEXT() = 0;
                END;
            UNTIL TransferLineL.NEXT() = 0;
        END;

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Transfer Order Zeroed Receipt Quantities', UserIdP);

        //Stars05.00+
        TransferLineL.RESET;
        TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);
        TransferLineL.SETFILTER("Quantity Received", '>%1', 0);
        IF NOT TransferLineL.FINDFIRST THEN BEGIN
            HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
            HandheldScanL.SETRANGE("Document No.", TransferHeaderL."No.");
            HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Receive);
            HandheldScanL.MODIFYALL("Delete By", USERID);
            HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
            HandheldScanL.MODIFYALL(Deleted, TRUE);
        END;
        //Stars05.00-

        //Stars06.00 ++
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.SETRANGE("Document No.", TransferHeaderL."No.");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
        HandheldScanL.SETRANGE(Deleted, FALSE);

        /*
        HandheldScanL.MODIFYALL("Reset All By",USERID);
        HandheldScanL.MODIFYALL("Reset All Date/Time",CURRENTDATETIME);
        HandheldScanL.MODIFYALL("Reset All",TRUE);
        */
        //Stars06.00--

        EXIT(TRUE);

    end;


    internal procedure WarehouseReceiptUpdate(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseReceiptHeaderL: Record "Warehouse Receipt Header";
        WMSUtilsCUL: Codeunit "Stars WMS Utils";
    begin
        WarehouseReceiptHeaderL.GET(DocumentNoP);
        WMSUtilsCUL.UpdateHandheldScanWarehouseReceipt(WarehouseReceiptHeaderL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Warehouse Receipt",
          DocumentNoP, WarehouseReceiptHeaderL."Location Code", 'Warehouse Receipt Update', UserIdP);
    end;


    internal procedure WarehouseReceiptPost(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseReceiptLineL: Record "Warehouse Receipt Line";
        WhsePostReceiptCUL: Codeunit "Whse.-Post Receipt";
    begin
        WarehouseReceiptLineL.SETRANGE("No.", DocumentNoP);
        WarehouseReceiptLineL.FINDFIRST();
        WhsePostReceiptCUL.RUN(WarehouseReceiptLineL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Warehouse Receipt",
          DocumentNoP, WarehouseReceiptLineL."Location Code", 'Warehouse Receipt Post', UserIdP);
    end;


    internal procedure WarehouseShipmentUpdate(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseShipmentHeaderL: Record "Warehouse Shipment Header";
        WMSUtilsCUL: Codeunit "Stars WMS Utils";
    begin
        WarehouseShipmentHeaderL.GET(DocumentNoP);
        WMSUtilsCUL.UpdateHandheldScanWarehouseShipment(WarehouseShipmentHeaderL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Warehouse Shipment",
          DocumentNoP, WarehouseShipmentHeaderL."Location Code", 'Warehouse Shipment Update', UserIdP);
    end;


    internal procedure WarehouseShipmentPost(DocumentNoP: Code[20]; UserIdP: Code[50])
    var
        WarehouseShipmentLineL: Record "Warehouse Shipment Line";
        WhsePostShipmentCUL: Codeunit "Whse.-Post Shipment";
    begin
        WarehouseShipmentLineL.SETRANGE("No.", DocumentNoP);
        WarehouseShipmentLineL.FINDFIRST();
        WhsePostShipmentCUL.SetPostingSettings(FALSE);
        WhsePostShipmentCUL.RUN(WarehouseShipmentLineL);
        CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Warehouse Shipment",
          DocumentNoP, WarehouseShipmentLineL."Location Code", 'Warehouse Shipment Post', UserIdP);
    end;

    internal procedure ToJsonString(TextP: Text): Text
    begin
        EXIT('"' + TextP + '"');
    end;


    internal procedure SalesLineCreateUpdate(DocumentTypeP: Option; DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50])
    var
        SalesLineL: Record "Sales Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SalesHeaderL: Record "Sales Header";
    begin
        SalesHeaderL.Get(DocumentTypeP, DocumentNoP);
        if SalesHeaderL.Status = SalesHeaderL.Status::Released then
            Error(Text005);
        SalesLineL.SETRANGE("Document Type", DocumentTypeP);
        SalesLineL.SETRANGE("Document No.", DocumentNoP);
        SalesLineL.SETRANGE(Type, SalesLineL.Type::Item);
        SalesLineL.SETRANGE("No.", ItemNoP);
        SalesLineL.SETRANGE("Variant Code", VariantCodeP);
        SalesLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        IF SalesLineL.FINDFIRST() THEN BEGIN
            SalesLineL.VALIDATE(Quantity, SalesLineL.Quantity + QuantityP);
            SalesLineL.MODIFY(TRUE);
        END ELSE BEGIN
            CLEAR(SalesLineL);
            SalesLineL.SETRANGE("Document Type", DocumentTypeP);
            SalesLineL.SETRANGE("Document No.", DocumentNoP);
            IF SalesLineL.FINDLAST() THEN
                LineNoL := SalesLineL."Line No.";

            CLEAR(SalesLineL);
            SalesLineL.INIT();
            SalesLineL.VALIDATE("Document Type", DocumentTypeP);
            SalesLineL.VALIDATE("Document No.", DocumentNoP);
            SalesLineL.VALIDATE("Line No.", LineNoL + 10000);
            SalesLineL.INSERT(TRUE);
            SalesLineL.VALIDATE(Type, SalesLineL.Type::Item);
            SalesLineL.VALIDATE("No.", ItemNoP);
            SalesLineL.VALIDATE("Variant Code", VariantCodeP);
            SalesLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
            SalesLineL.VALIDATE(Quantity, QuantityP);
            SalesLineL.MODIFY(TRUE);
        END;

        SalesResEntryCreateUpdate(SalesLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Create);
        IF (SalesLineL."Document Type" = SalesLineL."Document Type"::Order) THEN
            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Sales Order")
        ELSE
            IF (SalesLineL."Document Type" = SalesLineL."Document Type"::"Return Order") THEN
                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Sales Return Order");
        HandheldScanL.VALIDATE("Document No.", SalesLineL."Document No.");
        HandheldScanL.VALIDATE("Location Code", SalesLineL."Location Code");
        HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
        HandheldScanL.VALIDATE("Item No.", ItemNoP);
        HandheldScanL.VALIDATE("Variant Code", SalesLineL."Variant Code");
        HandheldScanL.VALIDATE("Unit of Measure Code", SalesLineL."Unit of Measure Code");
        HandheldScanL.VALIDATE(Quantity, QuantityP);
        HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * SalesLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Qty. per Unit of Measure", SalesLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Serial No.", SerialNoP);
        HandheldScanL.VALIDATE("Lot No.", LotNoP);
        HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.INSERT(TRUE);
    end;

    internal procedure SalesResEntryCreateUpdate(SalesLineP: Record "Sales Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Document type must be sales order or sales return order.';
        IsPositiveL: Boolean;
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        IsPositiveL := SalesResEntryIsPositive(SalesLineP);
        IF NOT IsPositiveL THEN
            QuantityP := -QuantityP;




        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, IsPositiveL);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntryL.SETRANGE("Source Subtype", SalesLineP."Document Type");
        ReservationEntryL.SETRANGE("Source ID", SalesLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", SalesLineP."Line No.");
        ReservationEntryL.SETRANGE("Item No.", SalesLineP."No.");
        ReservationEntryL.SETRANGE("Variant Code", SalesLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);
        IF ReservationEntryL.FINDFIRST() THEN BEGIN
            ReservationEntryL.VALIDATE("Quantity (Base)", ReservationEntryL."Quantity (Base)" + (QuantityP * SalesLineP."Qty. per Unit of Measure"));
            PurchaseResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END ELSE BEGIN
            ItemL.GET(SalesLineP."No.");
            IF (ItemL."Item Tracking Code" = '') THEN EXIT;
            ItemTrackingCodeL.GET(ItemL."Item Tracking Code");

            CLEAR(ReservationEntryL);
            IF ReservationEntryL.FINDLAST() THEN
                EntryNoL := ReservationEntryL."Entry No.";

            CLEAR(ReservationEntryL);
            ReservationEntryL.INIT;
            ReservationEntryL.VALIDATE("Entry No.", EntryNoL + 1);
            ReservationEntryL.VALIDATE(Positive, IsPositiveL);
            ReservationEntryL.VALIDATE("Reservation Status", ReservationEntryL."Reservation Status"::Surplus);
            ReservationEntryL.VALIDATE("Source Type", DATABASE::"Sales Line");
            ReservationEntryL.VALIDATE("Source Subtype", SalesLineP."Document Type");
            ReservationEntryL.VALIDATE("Source ID", SalesLineP."Document No.");
            ReservationEntryL.VALIDATE("Source Ref. No.", SalesLineP."Line No.");
            ReservationEntryL.INSERT(TRUE);

            IF (ItemTrackingCodeL."Lot Specific Tracking" AND ItemTrackingCodeL."SN Specific Tracking") THEN
                ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot and Serial No.")
            ELSE
                IF (ItemTrackingCodeL."Lot Specific Tracking") THEN
                    ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Lot No.")
                ELSE
                    IF (ItemTrackingCodeL."SN Specific Tracking") THEN
                        ReservationEntryL.VALIDATE("Item Tracking", ReservationEntryL."Item Tracking"::"Serial No.");

            ReservationEntryL.VALIDATE("Item No.", SalesLineP."No.");
            ReservationEntryL.Description := ItemL.Description;
            ReservationEntryL.VALIDATE("Variant Code", SalesLineP."Variant Code");
            ReservationEntryL.VALIDATE("Location Code", SalesLineP."Location Code");
            //ReservationEntryL.VALIDATE("Expected Receipt Date", SalesLineP."Estimated Delivery Date"); to be checked
            ReservationEntryL.VALIDATE("Qty. per Unit of Measure", SalesLineP."Qty. per Unit of Measure");

            IF (LotNoP <> '') THEN
                ReservationEntryL.VALIDATE("Lot No.", LotNoP);
            IF (SerialNoP <> '') THEN
                ReservationEntryL.VALIDATE("Serial No.", SerialNoP);
            IF (ExpiryDateP <> 0D) THEN
                ReservationEntryL.VALIDATE("Expiration Date", ExpiryDateP);

            ReservationEntryL.VALIDATE("Quantity (Base)", QuantityP * SalesLineP."Qty. per Unit of Measure");
            ReservationEntryL."Creation Date" := WORKDATE;
            ReservationEntryL."Created By" := USERID;
            PurchaseResEntryValidate(ReservationEntryL);
            ReservationEntryL.MODIFY(TRUE);
        END;
    end;

    internal procedure SalesResEntryIsPositive(var SalesLineP: Record "Sales Line"): Boolean
    begin
        IF (SalesLineP."Document Type" = SalesLineP."Document Type"::Order) THEN
            EXIT(TRUE)
        ELSE
            IF (SalesLineP."Document Type" = SalesLineP."Document Type"::"Return Order") THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
    end;


    internal procedure SalesLineShip(DocumentTypeP: Option; DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50])
    var
        SalesLineL: Record "Sales Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToShip: Decimal;
        AllShipped: Boolean;
        ValidQtyToShip: Decimal;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SalesHeader_l: Record "Sales Header";
    begin
        //Stars04.00+
        SalesLineL.SETRANGE("Document Type", DocumentTypeP);
        SalesLineL.SETRANGE("Document No.", DocumentNoP);
        SalesLineL.SETRANGE(Type, SalesLineL.Type::Item);
        SalesLineL.SETRANGE("No.", ItemNoP);
        SalesLineL.SETRANGE("Variant Code", VariantCodeP);
        SalesLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        SalesLineL.SETFILTER(Quantity, '>%1', SalesLineL."Qty. to Ship");
        IF SalesLineL.FINDFIRST THEN BEGIN
            CLEAR(SumOfQty);
            CLEAR(SumOfQtyToShip);
            REPEAT
                SumOfQty := SumOfQty + SalesLineL.Quantity;
                SumOfQtyToShip := SumOfQtyToShip + SalesLineL."Qty. to Ship";
            UNTIL SalesLineL.NEXT = 0;

            IF (SumOfQty) >= (SumOfQtyToShip + QuantityP) THEN BEGIN
                AllShipped := FALSE;
                SalesLineL.RESET;
                //Stars04.00-
                SalesLineL.SETRANGE("Document Type", DocumentTypeP);
                SalesLineL.SETRANGE("Document No.", DocumentNoP);
                SalesLineL.SETRANGE(Type, SalesLineL.Type::Item);
                SalesLineL.SETRANGE("No.", ItemNoP);
                SalesLineL.SETRANGE("Variant Code", VariantCodeP);
                SalesLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
                IF SalesLineL.FINDFIRST THEN BEGIN
                    //Stars04.00+
                    REPEAT
                        ValidQtyToShip := SalesLineL.Quantity - SalesLineL."Qty. to Ship";
                        IF ValidQtyToShip >= QuantityP THEN BEGIN
                            AllShipped := TRUE;
                            //Stars04.00-
                            IF (SalesLineL."Document Type" = SalesLineL."Document Type"::Order) THEN
                                SalesLineL.VALIDATE(SalesLineL."Qty. to Ship", SalesLineL."Qty. to Ship" + QuantityP)
                            ELSE
                                IF (SalesLineL."Document Type" = SalesLineL."Document Type"::"Return Order") THEN
                                    SalesLineL.VALIDATE("Return Qty. to Receive", SalesLineL."Return Qty. to Receive" + QuantityP);

                            SalesHeader_l.GET(SalesLineL."Document Type", SalesLineL."Document No.");
                            IF SalesHeader_l.Status = SalesHeader_l.Status::Released THEN
                                ReleaseSalesDoc.PerformManualReopen(SalesHeader_l);
                            SalesLineL.MODIFY(TRUE);
                            IF SalesHeader_l.Status = SalesHeader_l.Status::Open THEN
                                ReleaseSalesDoc.PerformManualRelease(SalesHeader_l);

                            SalesResEntryShip(SalesLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            IF (SalesLineL."Document Type" = SalesLineL."Document Type"::Order) THEN BEGIN
                                HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Sales Order");
                            END ELSE
                                IF (SalesLineL."Document Type" = SalesLineL."Document Type"::"Return Order") THEN BEGIN
                                    HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                                    HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Sales Return Order");
                                END;
                            HandheldScanL.VALIDATE("Document No.", SalesLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", SalesLineL."Location Code");

                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", ItemNoP);
                            HandheldScanL.VALIDATE("Variant Code", SalesLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", SalesLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, QuantityP);
                            HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * SalesLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", SalesLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);
                            //Stars04.00+
                        END ELSE BEGIN
                            IF (SalesLineL."Document Type" = SalesLineL."Document Type"::Order) THEN
                                SalesLineL.VALIDATE(SalesLineL."Qty. to Ship", SalesLineL."Qty. to Ship" + ValidQtyToShip)
                            ELSE
                                IF (SalesLineL."Document Type" = SalesLineL."Document Type"::"Return Order") THEN
                                    SalesLineL.VALIDATE("Return Qty. to Receive", SalesLineL."Return Qty. to Receive" + ValidQtyToShip);

                            SalesHeader_l.GET(SalesLineL."Document Type", SalesLineL."Document No.");
                            IF SalesHeader_l.Status = SalesHeader_l.Status::Released THEN
                                ReleaseSalesDoc.PerformManualReopen(SalesHeader_l);
                            SalesLineL.MODIFY(TRUE);
                            IF SalesHeader_l.Status = SalesHeader_l.Status::Open THEN
                                ReleaseSalesDoc.PerformManualRelease(SalesHeader_l);

                            SalesResEntryShip(SalesLineL, ValidQtyToShip, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            IF (SalesLineL."Document Type" = SalesLineL."Document Type"::Order) THEN BEGIN
                                HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Sales Order");
                            END ELSE
                                IF (SalesLineL."Document Type" = SalesLineL."Document Type"::"Return Order") THEN BEGIN
                                    HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                                    HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Sales Return Order");
                                END;
                            HandheldScanL.VALIDATE("Document No.", SalesLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", SalesLineL."Location Code");

                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", ItemNoP);
                            HandheldScanL.VALIDATE("Variant Code", SalesLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", SalesLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, ValidQtyToShip);
                            HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToShip * SalesLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", SalesLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);

                            QuantityP := QuantityP - ValidQtyToShip;
                        END;
                    UNTIL (SalesLineL.NEXT = 0) OR (AllShipped);
                END;
            END ELSE
                ERROR(Text001);
        END ELSE
            ERROR(Text002);
        //Stars04.00-
    end;

    internal procedure SalesResEntryShip(SalesLineP: Record "Sales Line"; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date)
    var
        ReservationEntryL: Record "Reservation Entry";
        EntryNoL: Integer;
        ItemL: Record Item;
        ItemTrackingCodeL: Record "Item Tracking Code";
        Text001L: Label 'Qty. to handle will be greater than %1.';
        IsPositiveL: Boolean;
    begin
        IF (LotNoP = '') AND (SerialNoP = '') AND (ExpiryDateP = 0D) THEN EXIT;

        IsPositiveL := SalesResEntryIsPositive(SalesLineP);
        IF NOT IsPositiveL THEN
            QuantityP := -QuantityP;

        ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                        "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntryL.SETRANGE(Positive, IsPositiveL);
        ReservationEntryL.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntryL.SETRANGE("Source Subtype", SalesLineP."Document Type");
        ReservationEntryL.SETRANGE("Source ID", SalesLineP."Document No.");
        ReservationEntryL.SETRANGE("Source Ref. No.", SalesLineP."Line No.");
        ReservationEntryL.SETRANGE("Item No.", SalesLineP."No.");
        ReservationEntryL.SETRANGE("Variant Code", SalesLineP."Variant Code");
        IF (LotNoP <> '') THEN
            ReservationEntryL.SETRANGE("Lot No.", LotNoP);
        IF (SerialNoP <> '') THEN
            ReservationEntryL.SETRANGE("Serial No.", SerialNoP);
        IF (ExpiryDateP <> 0D) THEN
            ReservationEntryL.SETRANGE("Expiration Date", ExpiryDateP);

        ReservationEntryL.FINDFIRST();
        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", ReservationEntryL."Qty. to Handle (Base)" + (QuantityP * SalesLineP."Qty. per Unit of Measure"));
        IF (ABS(ReservationEntryL."Qty. to Handle (Base)") > ABS(ReservationEntryL."Quantity (Base)")) THEN ERROR(Text001L, ReservationEntryL."Quantity (Base)");
        ReservationEntryL.MODIFY(TRUE);
    end;


    internal procedure SalesHeaderCreate(DocumentTypeP: Option; CustomerNoP: Code[20]; LocationCodeP: Code[10]; UserIdP: Code[50]): Code[20]
    var
        SalesHeaderL: Record "Sales Header";
    begin
        SalesHeaderL.INIT();
        SalesHeaderL.VALIDATE("Document Type", DocumentTypeP);
        SalesHeaderL.VALIDATE("No.", '');
        SalesHeaderL.INSERT(TRUE);
        SalesHeaderL.VALIDATE("Sell-to Customer No.", CustomerNoP);
        SalesHeaderL.VALIDATE("Location Code", LocationCodeP);
        SalesHeaderL.MODIFY(TRUE);

        IF (DocumentTypeP = SalesHeaderL."Document Type"::"Return Order") THEN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Create, HandheldScanG."Document Type"::"Sales Return Order",
              SalesHeaderL."No.", LocationCodeP, 'Sales Return Order Create', UserIdP)
        ELSE
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Create, HandheldScanG."Document Type"::"Sales Order",
              SalesHeaderL."No.", LocationCodeP, 'Sales Order Create', UserIdP);

        EXIT(ToJsonString(SalesHeaderL."No."));
    end;


    internal procedure SalesHeaderPost(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        SalesHeaderL: Record "Sales Header";
    begin
        IF SalesHeaderL.GET(DocumentTypeP, DocumentNoP) THEN BEGIN
            IF (SalesHeaderL."Document Type" = SalesHeaderL."Document Type"::Order) THEN
                SalesHeaderL.Ship := TRUE
            ELSE
                IF (SalesHeaderL."Document Type" = SalesHeaderL."Document Type"::"Return Order") THEN
                    SalesHeaderL.Receive := TRUE;

            CODEUNIT.RUN(CODEUNIT::"Sales-Post", SalesHeaderL);

            IF (DocumentTypeP = SalesHeaderL."Document Type"::"Return Order") THEN
                CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Sales Return Order",
                  DocumentNoP, SalesHeaderL."Location Code", 'Sales Return Order Post', UserIdP)
            ELSE
                CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Sales Order",
                  DocumentNoP, SalesHeaderL."Location Code", 'Sales Order Post', UserIdP);

            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    internal procedure SalesHeaderRelease(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        SalesHeaderL: Record "Sales Header";
        ReleaseSalesDocumentCUL: Codeunit "Release Sales Document";
    begin
        IF NOT SalesHeaderL.GET(DocumentTypeP, DocumentNoP) THEN EXIT(FALSE);
        ReleaseSalesDocumentCUL.PerformManualRelease(SalesHeaderL);
        IF NOT SalesHeaderL.GET(DocumentTypeP, DocumentNoP) OR (SalesHeaderL.Status <> SalesHeaderL.Status::Released) THEN EXIT(FALSE);

        IF (DocumentTypeP = SalesHeaderL."Document Type"::"Return Order") THEN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Sales Return Order",
              DocumentNoP, SalesHeaderL."Location Code", 'Sales Return Order Release', UserIdP)
        ELSE
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Sales Order",
              DocumentNoP, SalesHeaderL."Location Code", 'Sales Order Release', UserIdP);

        EXIT(TRUE);
    end;


    internal procedure SalesZeroQtyToShipReceive(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        SalesHeaderL: Record "Sales Header";
        SalesHeaderExistsL: Boolean;
        Text001L: Label 'The %1 %2 doesn''t exits.';
        Text002L: Label 'The %1 must be released.';
        SalesLineL: Record "Sales Line";
        ReservationEntryL: Record "Reservation Entry";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SalesHeader_l: Record "Sales Header";
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        SalesHeaderExistsL := SalesHeaderL.GET(DocumentTypeP, DocumentNoP);

        IF NOT SalesHeaderExistsL THEN
            ERROR(Text001L, DocumentTypeP, DocumentNoP);

        IF (SalesHeaderL.Status = SalesHeaderL.Status::Open) THEN
            ERROR(Text002L, FORMAT(SalesHeaderL."Document Type"));

        SalesLineL.SETRANGE("Document Type", SalesHeaderL."Document Type");
        SalesLineL.SETRANGE("Document No.", SalesHeaderL."No.");
        IF SalesLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                SalesLineL.VALIDATE("Qty. to Ship", 0);
                SalesLineL.VALIDATE("Return Qty. to Receive", 0);
                //Stars04.00+
                SalesHeader_l.GET(SalesLineL."Document Type", SalesLineL."Document No.");
                IF SalesHeader_l.Status = SalesHeader_l.Status::Released THEN
                    ReleaseSalesDoc.PerformManualReopen(SalesHeader_l);
                //Stars04.00-
                SalesLineL.MODIFY(TRUE);
                //Stars04.00+
                IF SalesHeader_l.Status = SalesHeader_l.Status::Open THEN
                    ReleaseSalesDoc.PerformManualRelease(SalesHeader_l);
                //Stars04.00-
                ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                                "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                ReservationEntryL.SETRANGE("Source Type", DATABASE::"Purchase Line");
                ReservationEntryL.SETRANGE("Source Subtype", SalesLineL."Document Type");
                ReservationEntryL.SETRANGE("Source ID", SalesLineL."Document No.");
                ReservationEntryL.SETRANGE("Source Ref. No.", SalesLineL."Line No.");
                IF ReservationEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", 0);
                        ReservationEntryL.MODIFY(TRUE);
                    UNTIL ReservationEntryL.NEXT() = 0;
                END;
            UNTIL SalesLineL.NEXT() = 0;
        END;

        IF (DocumentTypeP = SalesHeaderL."Document Type"::"Return Order") THEN BEGIN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Sales Return Order",
              DocumentNoP, SalesHeaderL."Location Code", 'Sales Return Order Zeroed Quantities', UserIdP);
            //Stars05.00+
            SalesLineL.RESET;
            SalesLineL.SETRANGE("Document Type", SalesHeaderL."Document Type"::"Return Order");
            SalesLineL.SETRANGE("Document No.", SalesHeaderL."No.");
            SalesLineL.SETFILTER("Return Qty. Received", '>%1', 0);
            IF NOT SalesLineL.FINDFIRST THEN BEGIN
                HandheldScanL.SETRANGE("Document No.", SalesHeaderL."No.");
                HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Sales Return Order");
                HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Receive);
                HandheldScanL.MODIFYALL("Delete By", USERID);
                HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
                HandheldScanL.MODIFYALL(Deleted, TRUE);
            END;
            //Stars05.00-
        END;

        IF (DocumentTypeP = SalesHeaderL."Document Type"::Order) THEN BEGIN
            CreateInfoHandheldScan(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Sales Order",
              DocumentNoP, SalesHeaderL."Location Code", 'Sales Order Zeroed Quantities', UserIdP);
            //Stars05.00+
            SalesLineL.RESET;
            SalesLineL.SETRANGE("Document Type", SalesHeaderL."Document Type"::Order);
            SalesLineL.SETRANGE("Document No.", SalesHeaderL."No.");
            SalesLineL.SETFILTER("Quantity Shipped", '>%1', 0);
            IF NOT SalesLineL.FINDFIRST THEN BEGIN
                HandheldScanL.SETRANGE("Document No.", SalesHeaderL."No.");
                HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Sales Order");
                HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
                HandheldScanL.MODIFYALL("Delete By", USERID);
                HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
                HandheldScanL.MODIFYALL(Deleted, TRUE);
            END;
            //Stars05.00-
        END;

        EXIT(TRUE);
    end;


    internal procedure GetItemInfoFromQRCode(BarcodeNo: Code[20]; ModelNo: Integer): Text
    var
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        Barcodes: Record "LSC Barcodes";
        CountryRegion: Record "Country/Region";
        SalesPrice: Record "Salesperson/Purchaser";
        CurrExchRate: Record "Currency Exchange Rate";
        ItemUnitPriceWithVAT: Decimal;
        ACYUnitPriceVAT: Decimal;
        MaxShelfDesc: Integer;
        c: Integer;
        ItemVariant: Record "Item Variant";
        RetailSetupL: Record "LSC Retail Setup";
        StoreL: Record "LSC Store";
        StaffL: Record "LSC Staff";
        POSTerminalL: Record "LSC POS Terminal";
        GlobalsCUL: Codeunit "LSC POS Session";
        POSTransactionL: Record "LSC POS Transaction";
        TransLineL: Record "LSC POS Trans. Line";
        ReceiptNoL: Code[20];
        QuantityL: Decimal;
        PosFuncCUL: Codeunit "LSC POS Functions";
        ItemL: Record Item;
        PriceInBarcodeL: Decimal;
        CalcQtyL: Decimal;
        VatSetupL: Record "VAT Posting Setup";
        ItemUOML: Record "Item Unit of Measure";
        NewLineL: Record "LSC POS Trans. Line";
        JSONMgtCUL: Codeunit "JSON Management";

        InventorySetup: Record "Inventory Setup";
        VariantDimension1: Text;
        VariantDimension2: Text;
        ItemVariantRegistration: Record "LSC Item Variant Registration";
        ExtendedVariantValues: Record "LSC Extd. Variant Values";
        Text001: Label 'Barcode not found!';
        POSFunctionalityProfile: Record "LSC POS Func. Profile";
        DivisionL: Record "LSC Division";
        CurrencyL: Record Currency;
        OfferPosCalculation: Record "LSC Offer Pos Calculation";
        POSMixMatchEntry: Record "LSC POS Mix & Match Entry";
        POSTransPeriodicDisc: Record "LSC POS Trans. Per. Disc. Type";
        JObject: JsonObject;
    begin
        //Stars08.00++


        IF NOT Barcodes.GET(BarcodeNo) THEN
            ERROR(Text001);

        CASE ModelNo OF
            1:
                MaxShelfDesc := 5;
            2:
                MaxShelfDesc := 10;
        END;

        c := 0;

        Item.GET(Barcodes."Item No.");
        ItemVariant.GET(Barcodes."Item No.", Barcodes."Variant Code");


        VariantDimension1 := '';
        VariantDimension2 := '';
        IF Item."LSC Variant Framework Code" <> '' THEN BEGIN
            ItemVariantRegistration.SETRANGE("Item No.", Item."No.");
            ItemVariantRegistration.SETRANGE(Variant, ItemVariant.Code);
            IF ItemVariantRegistration.FINDFIRST THEN BEGIN
                ExtendedVariantValues.SETRANGE("Framework Code", Item."LSC Variant Framework Code");
                ExtendedVariantValues.SETRANGE(Dimension, 1);
                ExtendedVariantValues.SETRANGE(Value, ItemVariantRegistration."Variant Dimension 1");
                IF ExtendedVariantValues.FINDFIRST THEN
                    VariantDimension1 := ExtendedVariantValues."Value Description";
                ExtendedVariantValues.SETRANGE(Dimension, 2);
                ExtendedVariantValues.SETRANGE(Value, ItemVariantRegistration."Variant Dimension 2");
                IF ExtendedVariantValues.FINDFIRST THEN
                    VariantDimension2 := ExtendedVariantValues."Value Description";
            END;
        END;
        //Stars10.0++
        IF NOT DivisionL.GET(Item."LSC Division Code") THEN
            CLEAR(DivisionL);
        //Stars10.0--
        JObject.Add('FamilyCode', Item."LSC Item Family Code");
        JObject.Add('ItemDescription', ItemVariant.Description);
        JObject.Add('ItemNo', ItemVariant."Item No.");
        JObject.Add('VariantNo', ItemVariant.Code);
        JObject.Add('Color', VariantDimension1);
        JObject.Add('Size', VariantDimension2);
        InventorySetup.GET;
        InventorySetup.TESTFIELD(InventorySetup."Stars Price Check Store No.");

        //Stars10.0++
        // IF DivisionL."Stars QR Currency" <> '' THEN BEGIN
        //     CurrencyL.GET(DivisionL."Stars QR Currency");

        //     JObject.Add('currency', CurrencyL."Stars Currency Caption");
        //     InventorySetup.TESTFIELD(InventorySetup."USD Store");
        //     StoreL.GET(InventorySetup."USD Store");
        // END ELSE BEGIN
        //     GLSetup.GET;
        //     JObject.Add('currency', GLSetup."Local Currency Symbol");
        //     InventorySetup.TESTFIELD(InventorySetup."LBP Store");
        //     StoreL.GET(InventorySetup."LBP Store");
        // END;
        StoreL.GET(InventorySetup."Stars Default Store Pricing");
        //Stars10.0--
        //InventorySetup.TESTFIELD(InventorySetup."Price Check Store No.");
        //StoreL.GET(InventorySetup."Price Check Store No.");



        StaffL.SETRANGE("Store No.", StoreL."No.");
        StaffL.FINDFIRST();

        POSTerminalL.SETRANGE("Store No.", StoreL."No.");
        POSTerminalL.FINDFIRST();

        GlobalsCUL.SetStore(StoreL."No.");
        GlobalsCUL.SetTerminal(POSTerminalL."No.");

        IF (Barcodes."Item No." = '') THEN EXIT;
        ItemL.GET(Barcodes."Item No.");

        POSTransactionL.SETRANGE("Receipt No.", 'XXX00000V', 'XXX99999V');
        IF NOT POSTransactionL.FINDLAST THEN
            ReceiptNoL := 'XXX00000V'
        ELSE
            ReceiptNoL := INCSTR(POSTransactionL."Receipt No.");

        CLEAR(POSTransactionL);
        CLEAR(TransLineL);
        QuantityL := 0;

        POSTransactionL."Staff ID" := StaffL.ID;
        POSTransactionL."Receipt No." := ReceiptNoL;
        POSTransactionL."Store No." := StoreL."No.";
        POSTransactionL."POS Terminal No." := POSTerminalL."No.";
        POSTransactionL.INSERT;

        POSTransactionL."VAT Bus.Posting Group" := StoreL."Store VAT Bus. Post. Gr.";
        POSTransactionL."Transaction Type" := POSTransactionL."Transaction Type"::Sales;
        POSTransactionL."Trans. Date" := TODAY;
        POSTransactionL."Original Date" := POSTransactionL."Trans. Date";
        POSTransactionL."Trans Time" := TIME;
        POSTransactionL."Trans. Currency Code" := StoreL."Currency Code";
        POSTransactionL.MODIFY;

        POSTransactionL.SETRANGE("Receipt No.", ReceiptNoL);

        PosFuncCUL.LoadOfferTables(TRUE);
        PosFuncCUL.PosTransDiscLoad(ReceiptNoL);

        CLEAR(NewLineL);
        NewLineL."Receipt No." := ReceiptNoL;
        NewLineL."Store No." := POSTransactionL."Store No.";
        NewLineL."POS Terminal No." := POSTransactionL."POS Terminal No.";
        NewLineL."Entry Type" := NewLineL."Entry Type"::Item;
        PosFuncCUL.LoadItem(NewLineL);
        NewLineL.Number := ItemL."No.";
        NewLineL."Barcode No." := ItemL."No.";
        NewLineL.VALIDATE(NewLineL.Number, NewLineL.Number);
        NewLineL."Variant Code" := ItemVariant.Code;
        IF NewLineL."Price in Barcode" THEN BEGIN
            PriceInBarcodeL := NewLineL.Amount;
            NewLineL.VALIDATE(NewLineL.Amount, PriceInBarcodeL);
            CalcQtyL := NewLineL.Quantity;
            QuantityL := CalcQtyL;
        END
        ELSE
            IF NewLineL."Quantity in Barcode" THEN
                QuantityL := NewLineL.Quantity
            ELSE
                IF QuantityL = 0 THEN
                    QuantityL := 1;
        POSTransactionL."VAT Bus.Posting Group" := StoreL."Store VAT Bus. Post. Gr.";

        TransLineL.COPY(NewLineL);

        TransLineL.VALIDATE(Number, TransLineL.Number);
        TransLineL.InsertLine;

        TransLineL.GET(TransLineL."Receipt No.", TransLineL."Line No.");

        IF ItemL."LSC Qty. Becomes Negative" THEN BEGIN
            TransLineL."Item/Dept. Negative" := TRUE;
            TransLineL.VALIDATE(TransLineL.Quantity, -QuantityL)
        END ELSE
            TransLineL.VALIDATE(TransLineL.Quantity, QuantityL);

        IF TransLineL."Price in Barcode" AND (QuantityL = CalcQtyL) THEN
            TransLineL.VALIDATE(TransLineL.Amount, PriceInBarcodeL);

        PosFuncCUL.PosTransDiscFlush;
        PosFuncCUL.ChangeVATBusOnLine(POSTransactionL);
        PosFuncCUL.RecalcSlip(POSTransactionL);

        QuantityL := 0;

        //FS200622+
        IF POSTerminalL."Functionality Profile" <> '' THEN
            POSFunctionalityProfile.GET(POSTerminalL."Functionality Profile")
        ELSE
            IF StoreL."Functionality Profile" <> '' THEN
                POSFunctionalityProfile.GET(StoreL."Functionality Profile")
            ELSE
                POSFunctionalityProfile.GET('##DEFAULT');

        IF POSFunctionalityProfile."Amount Rounding to" <> 0 THEN
            TransLineL.Price := ROUND(TransLineL.Price, POSFunctionalityProfile."Amount Rounding to");
        //FS220622-

        JObject.Add('Barcode', BarcodeNo);
        JObject.Add('price', FORMAT(TransLineL.Price));
        JObject.Add('discountAmount', FORMAT(TransLineL."Discount Amount"));
        JObject.Add('discountPcnt', FORMAT(TransLineL."Discount %"));
        JObject.Add('discountedPrice', FORMAT(TransLineL.Amount));
        POSTransactionL.DELETE;
        TransLineL.DELETE;

        //FS010922+
        POSTransPeriodicDisc.SETRANGE("Receipt No.", POSTransactionL."Receipt No.");
        POSTransPeriodicDisc.DELETEALL;

        POSMixMatchEntry.SETRANGE("Receipt No.", POSTransactionL."Receipt No.");
        POSMixMatchEntry.DELETEALL;

        OfferPosCalculation.SETRANGE("Receipt No.", POSTransactionL."Receipt No.");
        OfferPosCalculation.DELETEALL;
        //FS010922-
        JObject.WriteTo(JsonText);
        EXIT(JsonText);
        //Stars08.00--
    end;

    internal procedure GetBarcodeQuery(BarcodeNo: Code[20]): Text
    var
        Barcodes: Record "LSC Barcodes";
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ItemTrackingCode: Record "Item Tracking Code";
        BarcodeMask: Record "LSC Barcode Mask";
        BarcodeMaskSegment: Record "LSC Barcode Mask Segment";
        JObject: JsonObject;
    begin
        if Barcodes.Get(BarcodeNo) then begin
            JObject.Add('BarcodeNo', Barcodes."Barcode No.");
            JObject.Add('ItemNo', Barcodes."Item No.");
            JObject.Add('VariantCode', Barcodes."Variant Code");
            Item.Get(Barcodes."Item No.");
            if Barcodes."Unit of Measure Code" = '' then begin
                //Item.Get(Barcodes."Item No.");
                JObject.Add('UnitOfMeasureCode', Item."Base Unit of Measure");
            end else begin
                JObject.Add('UnitOfMeasureCode', Barcodes."Unit of Measure Code");
            end;
            if Barcodes.Description <> '' then
                JObject.Add('Description', Barcodes.Description)
            else
                JObject.Add('Description', Item.Description);
            JObject.Add('BaseUnitOfMeasureCode', Item."Base Unit of Measure");

            if ItemUnitOfMeasure.Get(Barcodes."Item No.", Barcodes."Unit of Measure Code") then
                JObject.Add('QtyPerUnitOfMeasure', ItemUnitOfMeasure."Qty. per Unit of Measure")
            else
                JObject.Add('QtyPerUnitOfMeasure', 1);
            if ItemTrackingCode.Get(Item."Item Tracking Code") then begin
                JObject.Add('HasSerial', ItemTrackingCode."SN Specific Tracking");
                JObject.Add('HasLot', ItemTrackingCode."Lot Specific Tracking");
                JObject.Add('HasExpiry', ItemTrackingCode."Man. Expir. Date Entry Reqd.");
            end else begin
                JObject.Add('HasSerial', false);
                JObject.Add('HasLot', false);
                JObject.Add('HasExpiry', false);
            end;
            JObject.Add('Mask', Item."LSC Barcode Mask");
            if Item."LSC Barcode Mask" = '' then begin
                JObject.Add('MaskQtyDecimals', 0);
            end else begin
                BarcodeMask.SETCURRENTKEY(Mask);
                if BarcodeMask.Get(Item."LSC Barcode Mask") then begin
                    BarcodeMaskSegment.SetRange(Char, 'Q');
                    BarcodeMaskSegment.SetRange("Mask Entry No.", BarcodeMask."Entry No.");
                    if BarcodeMaskSegment.FindFirst() then
                        JObject.Add('MaskQtyDecimals', BarcodeMaskSegment.Decimals)
                    else
                        JObject.Add('MaskQtyDecimals', 0);
                end else
                    JObject.Add('MaskQtyDecimals', 0);
            end;
            JObject.WriteTo(JsonText);
            EXIT(JsonText);
        end;
        EXIT(JsonText);
    end;

    internal procedure GetUsers(): Text
    var
        HandheldUsers: Record "Stars Handheld Users";
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        if HandheldUsers.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('UserName', HandheldUsers."Handheld User ID");
                JObject.Add('IsAdmin', true);
                JArray.Add(JObject);
            until HandheldUsers.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);

    end;

    internal procedure Login(username: Code[50]; password: Text[50]): Boolean
    var
        StarsHandHeldUsers: Record "Stars Handheld Users";
        HandheldLocSec: Record "Stars Handheld Loc Security";
    begin
        if (StarsHandHeldUsers.Get(username)) then begin
            if (StarsHandHeldUsers."Handheld Password" = password) then begin
                exit(true)
            end
        end else begin
            exit(false);
        end;
    end;

    internal procedure GetItemJournalBatches(templateType: Integer; username: Code[50]): Text
    var
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalTemplate: Record "Item Journal Template";
        StarsHandheldJournalSecurity: Record "Stars Handheld Journl Security";
        StarsHandheldLocationSecurity: Record "Stars Handheld Loc Security";
        JObject: JsonObject;
        JArray: JsonArray;

    begin
        ItemJournalTemplate.SetRange(Type, templateType);
        if ItemJournalTemplate.FindSet() then
            repeat
            begin
                ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);
                if ItemJournalBatch.FindSet() then begin
                    repeat
                        if StarsHandheldJournalSecurity.Get(username, ItemJournalBatch."Journal Template Name", ItemJournalBatch.Name) then begin
                            //StarsHandheldLocationSecurity.SetRange("Is Default", true);
                            //StarsHandheldLocationSecurity.SetRange("Location Code", ItemJournalBatch."Stars Handheld Location Code");
                            //StarsHandheldLocationSecurity.SetRange(ID, username);
                            if StarsHandheldLocationSecurity.Get(username, ItemJournalBatch."Stars Handheld Location Code") then begin


                                //if StarsHandheldJournalSecurity.FindSet() then
                                // repeat
                                if StarsHandheldLocationSecurity."Is Default" = true then begin
                                    Clear(JObject);
                                    JObject.Add('TemplateName', ItemJournalBatch."Journal Template Name");
                                    JObject.Add('Name', ItemJournalBatch.Name);
                                    JObject.Add('ShowCalculatedQty', ItemJournalBatch."Stars Show Calculated Qty.");
                                    JObject.Add('Pick', ItemJournalBatch."Stars Pick");
                                    JObject.Add('PutAway', ItemJournalBatch."Stars Put-Away");
                                    JObject.Add('BinToBin', ItemJournalBatch."Stars Bin To Bin");
                                    JArray.Add(JObject);
                                end;
                            end;
                            // until StarsHandheldJournalSecurity.Next() = 0;
                        end;
                    until ItemJournalBatch.Next() = 0;
                end;
            end;
            until ItemJournalTemplate.Next() = 0;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetItemQtyOnHand(itemNo: Text[20]; variantCode: Text[10]; locationCode: Text[10]; binCode: Text[20]; lotCode: Text[20]; username: Text[50]): Text
    var
        //569956789
        ItemLE: Record "Item Ledger Entry";
        ItemVR: Record "LSC Item Variant Registration";
        Item: Record Item;
        Location: Record Location;
        JObject: JsonObject;
        JArray: JsonArray;
        QueryItemOnHand: Query "Item Qty. By Location Query";
        HandheldLocationSec: Record "Stars Handheld Loc Security";
    begin
        HandheldLocationSec.Reset();
        if (itemNo <> '') then begin
            QueryItemOnHand.SetRange(ItmLdg_Item_No, itemNo);
        end;
        //if (locationCode <> '') then begin
        // QueryItemOnHand.SetRange(ItmLdg_Location_Code, locationCode);
        //end;
        if (variantCode <> '') then begin
            QueryItemOnHand.SetRange(Variant, variantCode);
        end;
        //QueryItemOnHand.Open();
        HandheldLocationSec.SetRange(ID, username);
        if HandheldLocationSec.FindSet() then begin
            repeat
                QueryItemOnHand.SetRange(ItmLdg_Location_Code, HandheldLocationSec."Location Code");
                QueryItemOnHand.Open();
                while QueryItemOnHand.Read() do begin
                    //if HandheldLocationSec."Location Code" = QueryItemOnHand.ItmLdg_Location_Code then begin
                    Clear(JObject);
                    JObject.Add('ItemNo', QueryItemOnHand.ItmLdg_Item_No);
                    JObject.Add('LocationCode', QueryItemOnHand.ItmLdg_Location_Code);
                    JObject.Add('LocationName', QueryItemOnHand.Loc_Name);
                    JObject.Add('QtyBaseOnHand', QueryItemOnHand.ItmLdg_Sum_Remaining_Quantity);
                    JObject.Add('Size', QueryItemOnHand.Variant_Dimension_1);
                    JObject.Add('Color', QueryItemOnHand.Variant_Dimension_2);
                    JArray.Add(JObject);
                    //end;
                end;
                QueryItemOnHand.Close();
            until HandheldLocationSec.Next() = 0;
        end;
        QueryItemOnHand.Close();
        JArray.WriteTo(JsonText);
        EXIT(JsonText);

    end;

    internal procedure GetItemQtyOnHandAdv(itemNo: Text[20]; variantCode: Text[10]; locationCode: Text[10]): Text
    var
        WE: Record "Warehouse Entry";
        Item: Record Item;
        JObject: JsonObject;
        JArray: JsonArray;
        Description: Text[100];
    begin
        Item.Reset();
        Description := '';
        if Item.Get(itemNo) then begin
            Description := Item.Description;
        end;
        WE.Reset();
        WE.SetRange("Item No.", itemNo);
        WE.SetRange("Location Code", locationCode);
        WE.SetRange("Variant Code", variantCode);
        if WE.FindSet() then begin
            repeat
                JObject.Add('ItemNo', WE."Item No.");
                JObject.Add('Description', Description);
                JObject.Add('QtyBaseOnHand', WE."Qty. (Base)");
                JObject.Add('BinCode', WE."Bin Code");
                JObject.Add('LotNo', WE."Lot No.");
                JObject.Add('ExpirationDate', WE."Expiration Date");
                JObject.Add('UnitOfMeasure', WE."Unit of Measure Code");
                JArray.Add(JObject);
                Clear(JObject);
            Until WE.Next() = 0;
        end
        else if Description <> '' then begin
            JObject.Add('Description', Description);
            JArray.Add(JObject);
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetBinQtyOnHand(binCode: Text[20]; locationCode: Text[10]): Text
    var
        WE: Record "Warehouse Entry";
        Item: Record Item;
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        WE.Reset();
        WE.SetRange("Location Code", locationCode);
        WE.SetRange("Bin Code", binCode);
        if WE.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('BinCode', WE."Bin Code");
                JObject.Add('ItemNo', WE."Item No.");
                Item.Reset();
                if Item.Get(WE."Item No.") then begin
                    JObject.Add('Description', Item.Description);
                end;
                JObject.Add('QtyBaseOnHand', WE."Qty. (Base)");
                JObject.Add('LotNo', WE."Lot No.");
                JArray.Add(JObject);
            Until WE.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure GetLotQtyOnHand(lotNo: Text[20]; locationCode: Text[10]): Text
    var
        WE: Record "Warehouse Entry";
        Item: Record Item;
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        WE.Reset();
        WE.SetRange("Location Code", locationCode);
        WE.SetRange("Lot No.", lotNo);
        if WE.FindSet() then begin
            repeat
                Clear(JObject);
                JObject.Add('LotNo', WE."Lot No.");
                JObject.Add('ItemNo', WE."Item No.");
                Item.Reset();
                if Item.Get(WE."Item No.") then begin
                    JObject.Add('Description', Item.Description);
                end;
                JObject.Add('QtyBaseOnHand', WE."Qty. (Base)");
                JObject.Add('BinCode', WE."Bin Code");
                JArray.Add(JObject);
            Until WE.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure ValidateMoveByItem(locationCode: text[10]; itemNo: text[20]; variantCode: Text[10]; binCode: Text[20]; lotNo: Text[20]; serialNo: Text[20]; expiry: Text[30]): decimal
    var
        Qty: decimal;
        WarehouseEntry: Record "Warehouse Entry";
        dateFormat: Date;
    begin
        Qty := 0;
        WarehouseEntry.Reset();
        WarehouseEntry.SetRange("Location Code", locationCode);
        WarehouseEntry.SetRange("Item No.", itemNo);
        WarehouseEntry.SetRange("Variant Code", variantCode);
        WarehouseEntry.SetRange("Bin Code", binCode);
        WarehouseEntry.SetRange("Lot No.", lotNo);
        if serialNo <> '' then
            WarehouseEntry.SetRange("Serial No.", serialNo);
        if (expiry <> '1/1/1753 12:00:00 AM') then begin
            EVALUATE(dateFormat, expiry);
            WarehouseEntry.SetRange("Expiration Date", dateFormat);
        end;
        if WarehouseEntry.FindSet() then begin
            repeat
                Qty := Qty + WarehouseEntry."Qty. (Base)";
            Until WarehouseEntry.Next() = 0;
        end;
        Exit(Qty);

    end;

    internal procedure ValidateUniqueSerialRequest(actionType: Integer; documentType: integer; documentNo: Text[20]; barcodeNo: Text[20]; serialNo: Text[20]): Boolean
    var
        HandheldScan: Record "Stars Handheld Scan";
    begin
        HandheldScan.Reset();
        HandheldScan.SetRange("Action Type", actionType);
        HandheldScan.SetRange("Document Type", documentType);
        HandheldScan.SetRange("Document No.", documentNo);
        HandheldScan.SetRange("Item No.", barcodeNo);
        HandheldScan.SetRange("Serial No.", serialNo);
        if HandheldScan.FindFirst() then
            Exit(true);
        Exit(False);
    end;

    internal procedure GetDirectedPhysInventoryLines(journalTemplateName: Text[10]; journalBatchName: Text[10]; locationCode: Text[10]; documentNo: Text[20]): Text
    var
        HandheldScan: Record "Stars Handheld Scan";
        HandheldScan2: Record "Stars Handheld Scan";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        JObject: JsonObject;
        JArray: JsonArray;
        Qty: decimal;
    begin
        Qty := 0;
        WarehouseJournalLine.Reset();
        WarehouseJournalLine.SetRange("Journal Batch Name", journalBatchName);
        WarehouseJournalLine.SetRange("Journal Template Name", journalTemplateName);
        WarehouseJournalLine.SetRange("Location Code", locationCode);
        if documentNo <> '' then
            WarehouseJournalLine.SetRange("Whse. Document No.", documentNo);
        if WarehouseJournalLine.FindSet() then begin
            repeat
                HandheldScan.Reset();
                HandheldScan.SetRange("Action Type", "Stars HandHeld Scan Action Type"::Update);
                HandheldScan.SetRange("Document Type", "Stars HandHeld Scan Doc. Type"::"Dir. Phys. Inventory");
                HandheldScan.SetRange("Journal Batch Name", WarehouseJournalLine."Journal Batch Name");
                HandheldScan.SetRange("Journal Template Name", WarehouseJournalLine."Journal Template Name");
                HandheldScan.SetRange("Location Code", WarehouseJournalLine."Location Code");
                HandheldScan.SetRange("Document No.", WarehouseJournalLine."Whse. Document No.");
                if HandheldScan.FindSet() then begin
                    if WarehouseJournalLine."Line No." <> HandheldScan."Line No." then
                        WarehouseJournalLine.SetRange("Line No.", HandheldScan."Line No.");
                end;
                Clear(JObject);
                JObject.Add('JournalTemplateName', WarehouseJournalLine."Journal Template Name");
                JObject.Add('JournalBatchName', WarehouseJournalLine."Journal Batch Name");
                JObject.Add('LocationCode', WarehouseJournalLine."Location Code");
                JObject.Add('LineNo', WarehouseJournalLine."Line No.");
                JObject.Add('DocumentNo', WarehouseJournalLine."Whse. Document No.");
                JObject.Add('ItemNo', WarehouseJournalLine."Item No.");
                JObject.Add('ItemDescription', WarehouseJournalLine."Description");
                JObject.Add('UnitOfMeasureCode', WarehouseJournalLine."Unit of Measure Code");
                JObject.Add('VariantCode', WarehouseJournalLine."Variant Code");
                JObject.Add('BinCode', WarehouseJournalLine."Bin Code");
                JObject.Add('LotNo', WarehouseJournalLine."Lot No.");
                JObject.Add('SerialNo', WarehouseJournalLine."Serial No.");
                JObject.Add('Expiry', WarehouseJournalLine."Expiration Date");
                JObject.Add('QtyCalculated', WarehouseJournalLine."Qty. (Calculated)");
                HandheldScan2.Reset();
                HandheldScan2.SetRange("Line No.", WarehouseJournalLine."Line No.");
                HandheldScan2.SetRange("Journal Batch Name", WarehouseJournalLine."Journal Batch Name");
                HandheldScan2.SetRange("Journal Template Name", WarehouseJournalLine."Journal Template Name");
                HandheldScan2.SetRange("Location Code", WarehouseJournalLine."Location Code");
                HandheldScan2.SetRange("Document No.", WarehouseJournalLine."Whse. Document No.");
                if HandheldScan2.FindSet() then
                    repeat
                        if (HandheldScan2."Action Type" = "Stars Handheld Scan Action Type"::Update) AND (HandheldScan2."Document Type" = "Stars HandHeld Scan Doc. Type"::"Dir. Phys. Inventory") then
                            Qty += HandheldScan2.Quantity;
                    until HandheldScan2.Next() = 0;
                JObject.Add('QuantityScanned', Qty);
                JArray.Add(JObject);
            until WarehouseJournalLine.Next() = 0;
        end;
        JArray.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure BatchLocationBinMandatory(journalBatchName: Code[10]): Boolean
    var
        ItemJournalBatch: Record "Item Journal Batch";
        IsBinMandatory: Boolean;
        Locations: Record Location;
    begin
        IsBinMandatory := false;
        if ItemJournalBatch.Get('PHYS. INVE', journalBatchName) then
            if Locations.Get(ItemJournalBatch."Stars Handheld Location Code") then
                IsBinMandatory := Locations.BinMandatory(ItemJournalBatch."Stars Handheld Location Code");
        Exit(IsBinMandatory);
    end;

    internal procedure LocationBinMandatory(locationCode: Code[10]): Boolean
    var
        Locations: Record Location;
        IsBinMandatory: Boolean;
    begin
        IsBinMandatory := Locations.BinMandatory(locationCode);
        Exit(IsBinMandatory);
    end;

    internal procedure DirectTransferHeaderCreate(TransferFromCodeP: Code[10]; TransferToCodeP: Code[10]; UserIdP: Code[50]): Code[20]
    var
        TransferHeaderL: Record "Transfer Header";
        StoreL: Record "LSC Store";
    begin
        TransferHeaderL.INIT();
        TransferHeaderL.VALIDATE("No.", '');
        TransferHeaderL.INSERT(TRUE);
        TransferHeaderL.VALIDATE("Transfer-from Code", TransferFromCodeP);
        TransferHeaderL.VALIDATE("Transfer-to Code", TransferToCodeP);
        TransferHeaderL.VAlidate("Direct Transfer", true);
        //Stars02.00+
        StoreL.SETCURRENTKEY("Location Code");
        IF StoreL.GET(TransferHeaderL."Transfer-from Code") THEN
            TransferHeaderL."LSC Store-from" := StoreL."No.";

        IF StoreL.GET(TransferHeaderL."Transfer-to Code") THEN
            TransferHeaderL."LSC Store-to" := StoreL."No.";
        //Stars02.00-
        TransferHeaderL.MODIFY(TRUE);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Create, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Direct Transfer Order Create', UserIdP);

        EXIT(ToJsonString(TransferHeaderL."No."));
    end;

    internal procedure DirectTransferHeaderRelease(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        ReleaseTransferDocCUL: Codeunit "Release Transfer Document";
    begin
        TransferHeaderL.GET(DocumentNoP);
        ReleaseTransferDocCUL.RUN(TransferHeaderL);
        TransferHeaderL.GET(DocumentNoP);
        IF (TransferHeaderL.Status <> TransferHeaderL.Status::Released) THEN EXIT(FALSE);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Release, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Direct Transfer Order Release', UserIdP);

        EXIT(TRUE);
    end;

    internal procedure DirectTransferZeroQtyToShip(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        Text001L: Label 'The direct transfer order must be released.';
        TransferLineL: Record "Transfer Line";
        ReservationEntryL: Record "Reservation Entry";
        HandheldScanL: Record "Stars HandHeld Scan";
    begin
        TransferHeaderL.GET(DocumentNoP);

        IF (TransferHeaderL.Status = TransferHeaderL.Status::Open) THEN
            ERROR(Text001L);

        TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);
        IF TransferLineL.FINDSET(TRUE) THEN BEGIN
            REPEAT
                TransferLineL.VALIDATE("Qty. to Ship", 0);
                TransferLineL.MODIFY(TRUE);

                ReservationEntryL.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
                                                "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                ReservationEntryL.SETRANGE("Source Type", DATABASE::"Transfer Line");
                ReservationEntryL.SETRANGE("Source Subtype", 0);
                ReservationEntryL.SETRANGE("Source ID", TransferLineL."Document No.");
                ReservationEntryL.SETRANGE("Source Ref. No.", TransferLineL."Line No.");
                IF ReservationEntryL.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ReservationEntryL.VALIDATE("Qty. to Handle (Base)", 0);
                        ReservationEntryL.MODIFY(TRUE);
                    UNTIL ReservationEntryL.NEXT() = 0;
                END;
            UNTIL TransferLineL.NEXT() = 0;
        END;

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Update, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Direct Transfer Order Zeroed Shipment Quantities', UserIdP);

        //Stars05.00+
        TransferLineL.RESET;
        TransferLineL.SETRANGE("Document No.", TransferHeaderL."No.");
        TransferLineL.SETRANGE("Derived From Line No.", 0);
        TransferLineL.SETFILTER("Quantity Shipped", '>%1', 0);
        IF NOT TransferLineL.FINDFIRST THEN BEGIN
            HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
            HandheldScanL.SETRANGE("Document No.", TransferHeaderL."No.");
            HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
            HandheldScanL.MODIFYALL("Delete By", USERID);
            HandheldScanL.MODIFYALL("Deleted Date/Time", CURRENTDATETIME);
            HandheldScanL.MODIFYALL(Deleted, TRUE);
        END;
        //Stars05.00-

        //Stars06.00 ++
        HandheldScanL.SETRANGE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.SETRANGE("Document No.", TransferHeaderL."No.");
        HandheldScanL.SETRANGE("Action Type", HandheldScanL."Action Type"::Ship);
        HandheldScanL.SETRANGE(Deleted, FALSE);



        EXIT(TRUE);
    end;

    internal procedure DirectTransferHeaderPostShipment(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
    begin
        TransferHeaderL.GET(DocumentNoP);
        //CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Shipment", TransferHeaderL);
        CODEUNIT.Run(CODEUNIT::"TransferOrder-Post (Yes/No)", TransferHeaderL);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Direct Transfer Order Post', UserIdP);

        EXIT(TRUE);
    end;

    internal procedure DirectTransferLineCreateUpdate(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]; BinCodeP: Code[20])
    var
        TransferLineL: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        TransferHeaderL: Record "Transfer Header";
    begin
        TransferHeaderL.Get(DocumentNoP);
        if TransferHeaderL.Status = TransferHeaderL.Status::Released then
            Error(Text005);
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);

        TransferLineL.SetRange("Transfer-To Bin Code", BinCodeP);

        IF TransferLineL.FINDFIRST() THEN BEGIN
            TransferLineL.VALIDATE(Quantity, TransferLineL.Quantity + QuantityP);
            TransferLineL.MODIFY(TRUE);
        END ELSE BEGIN
            CLEAR(TransferLineL);
            TransferLineL.SETRANGE("Document No.", DocumentNoP);
            IF TransferLineL.FINDLAST() THEN
                LineNoL := TransferLineL."Line No.";

            CLEAR(TransferLineL);
            TransferLineL.INIT();
            TransferLineL.VALIDATE("Document No.", DocumentNoP);
            TransferLineL.VALIDATE("Line No.", LineNoL + 10000);
            TransferLineL.INSERT(TRUE);
            TransferLineL.VALIDATE("Item No.", ItemNoP);
            TransferLineL.VALIDATE("Variant Code", VariantCodeP);
            TransferLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
            TransferLineL.VALIDATE(Quantity, QuantityP);
            TransferLineL."Stars Barcode No." := BarcodeNoP; //Stars03.00
            TransferLineL.Validate("Transfer-To Bin Code", BinCodeP);
            TransferLineL.MODIFY(TRUE);
        END;

        TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Create);
        HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
        HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
        HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
        HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
        HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
        HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
        HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
        HandheldScanL.VALIDATE(Quantity, QuantityP);
        HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Serial No.", SerialNoP);
        HandheldScanL.VALIDATE("Lot No.", LotNoP);
        HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.Validate("Bin Code To", BinCodeP);
        HandheldScanL.INSERT(TRUE);
    end;

    internal procedure DirectTransferLineShip(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]; BinCodeP: Code[20]): Boolean
    var
        TransferLineL: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToShip: Decimal;
        AllShipped: Boolean;
        ValidQtyToShip: Decimal;
    begin
        //Stars04.00+
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        TransferLineL.SETFILTER(Quantity, '>%1', TransferLineL."Qty. to Ship");
        TransferLineL.SetRange("Transfer-To Bin Code", BinCodeP);
        IF TransferLineL.FINDFIRST THEN BEGIN
            CLEAR(SumOfQty);
            CLEAR(SumOfQtyToShip);
            REPEAT
                SumOfQty := SumOfQty + TransferLineL.Quantity;
                SumOfQtyToShip := SumOfQtyToShip + TransferLineL."Qty. to Ship";
            UNTIL TransferLineL.NEXT = 0;

            IF (SumOfQty) >= (SumOfQtyToShip + QuantityP) THEN BEGIN
                AllShipped := FALSE;
                TransferLineL.RESET;
                //Stars04.00-
                TransferLineL.SETRANGE("Document No.", DocumentNoP);
                TransferLineL.SETRANGE("Item No.", ItemNoP);
                TransferLineL.SETRANGE("Variant Code", VariantCodeP);
                TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
                TransferLineL.SETFILTER(Quantity, '>%1', TransferLineL."Qty. to Ship");
                TransferLineL.SetRange("Transfer-To Bin Code", BinCodeP);
                IF TransferLineL.FINDFIRST THEN BEGIN
                    //Stars04.00+
                    REPEAT
                        ValidQtyToShip := TransferLineL.Quantity - TransferLineL."Qty. to Ship";
                        IF ValidQtyToShip >= QuantityP THEN BEGIN
                            AllShipped := TRUE;
                            //Stars04.00-
                            TransferLineL.VALIDATE("Qty. to Ship", TransferLineL."Qty. to Ship" + QuantityP);
                            TransferLineL.MODIFY(TRUE);

                            TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, QuantityP);
                            HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.Validate("Bin Code To", BinCodeP);
                            HandheldScanL.INSERT(TRUE);
                            //Stars04.00+
                        END ELSE BEGIN
                            TransferLineL.VALIDATE("Qty. to Ship", TransferLineL."Qty. to Ship" + ValidQtyToShip);
                            TransferLineL.MODIFY(TRUE);

                            TransferResEntryCreateUpdate(TransferLineL, ValidQtyToShip, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, ValidQtyToShip);
                            HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToShip * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.Validate("Bin Code To", BinCodeP);
                            HandheldScanL.INSERT(TRUE);

                            QuantityP := QuantityP - ValidQtyToShip;
                        END;
                    UNTIL (TransferLineL.NEXT = 0) OR (AllShipped);
                    EXIT(TRUE);
                END;
            END ELSE
                ERROR(Text001);
        END ELSE
            ERROR(Text002);
        //Stars04.00-
    end;

    internal procedure PutAwayTransferLineCreateUpdate(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]; BinCodeP: Code[20])
    var
        TransferLineL: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        TransferHeaderL: Record "Transfer Header";
    begin
        TransferHeaderL.Get(DocumentNoP);
        if TransferHeaderL.Status = TransferHeaderL.Status::Released then
            Error(Text005);
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);

        TransferLineL.SetRange("Transfer-To Bin Code", BinCodeP);

        IF TransferLineL.FINDFIRST() THEN BEGIN
            TransferLineL.VALIDATE(Quantity, TransferLineL.Quantity + QuantityP);
            TransferLineL.MODIFY(TRUE);
        END ELSE BEGIN
            CLEAR(TransferLineL);
            TransferLineL.SETRANGE("Document No.", DocumentNoP);
            IF TransferLineL.FINDLAST() THEN
                LineNoL := TransferLineL."Line No.";

            CLEAR(TransferLineL);
            TransferLineL.INIT();
            TransferLineL.VALIDATE("Document No.", DocumentNoP);
            TransferLineL.VALIDATE("Line No.", LineNoL + 10000);
            TransferLineL.INSERT(TRUE);
            TransferLineL.VALIDATE("Item No.", ItemNoP);
            TransferLineL.VALIDATE("Variant Code", VariantCodeP);
            TransferLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
            TransferLineL.VALIDATE(Quantity, QuantityP);
            TransferLineL."Stars Barcode No." := BarcodeNoP; //Stars03.00
            TransferLineL.Validate("Transfer-To Bin Code", BinCodeP);
            TransferLineL.MODIFY(TRUE);
        END;

        TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
        HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
        HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
        HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
        HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
        HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
        HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
        HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
        HandheldScanL.VALIDATE(Quantity, QuantityP);
        HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Serial No.", SerialNoP);
        HandheldScanL.VALIDATE("Lot No.", LotNoP);
        HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.Validate("Bin Code To", BinCodeP);
        HandheldScanL.INSERT(TRUE);
    end;

    internal procedure PutAwayTransferLineReceive(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]; BinCodeP: Code[20]): Boolean
    var
        TransferLineL: Record "Transfer Line";
        TransferLine2L: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToRec: Decimal;
        AllReceived: Boolean;
        ValidQtyToRec: Decimal;
    begin
        //Stars04.00+
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        TransferLineL.SETFILTER(Quantity, '>%1', TransferLineL."Qty. to Receive");
        TransferLineL.SETRANGE("Transfer-To Bin Code", BinCodeP);
        IF TransferLineL.FINDFIRST THEN BEGIN
            CLEAR(SumOfQty);
            CLEAR(SumOfQtyToRec);
            REPEAT
                SumOfQty := SumOfQty + TransferLineL.Quantity;
                SumOfQtyToRec := SumOfQtyToRec + TransferLineL."Qty. to Receive";
            UNTIL TransferLineL.NEXT = 0;

            IF (SumOfQty) >= (SumOfQtyToRec + QuantityP) THEN BEGIN
                AllReceived := FALSE;
                TransferLineL.RESET;
                //Stars04.00-
                TransferLineL.SETRANGE("Document No.", DocumentNoP);
                TransferLineL.SETRANGE("Item No.", ItemNoP);
                TransferLineL.SETRANGE("Variant Code", VariantCodeP);
                TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
                TransferLineL.SETRANGE("Transfer-To Bin Code", BinCodeP);
                IF TransferLineL.FINDFIRST THEN BEGIN
                    //Stars04.00+
                    REPEAT
                        ValidQtyToRec := TransferLineL.Quantity - TransferLineL."Qty. to Receive";
                        IF ValidQtyToRec >= QuantityP THEN BEGIN
                            AllReceived := TRUE;
                            //Stars04.00-
                            TransferLineL.VALIDATE("Qty. to Receive", TransferLineL."Qty. to Receive" + QuantityP);
                            TransferLineL.MODIFY(TRUE);

                            TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                            TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                            TransferLine2L.FINDFIRST();
                            TransferResEntryReceive(TransferLine2L, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, QuantityP);
                            HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.VALIDATE("Bin Code To", BinCodeP);
                            HandheldScanL.INSERT(TRUE);
                            //Stars04.00+
                        END ELSE BEGIN
                            TransferLineL.VALIDATE("Qty. to Receive", TransferLineL."Qty. to Receive" + ValidQtyToRec);
                            TransferLineL.MODIFY(TRUE);

                            TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                            TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                            TransferLine2L.FINDFIRST();
                            TransferResEntryReceive(TransferLine2L, ValidQtyToRec, LotNoP, SerialNoP, ExpiryDateP);

                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, ValidQtyToRec);
                            HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToRec * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.VALIDATE("Bin Code To", BinCodeP);
                            HandheldScanL.INSERT(TRUE);

                            QuantityP := QuantityP - ValidQtyToRec;
                        END;
                    UNTIL (TransferLineL.NEXT = 0) OR (AllReceived);
                    EXIT(TRUE);
                END;
            END ELSE
                ERROR(Text003);
        END ELSE
            ERROR(Text004);
        //Stars04.00-
    end;

    internal procedure PutAwayTransferHeaderPostReceipt(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        HandheldScan: Record "Stars HandHeld Scan";
    begin
        TransferHeaderL.GET(DocumentNoP);

        CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt", TransferHeaderL);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Put Away Transfer Order Post Receipt', UserIdP);

        EXIT(TRUE);
    end;

    internal procedure ReopenTransferOrder(documentNoP: Code[20]): Boolean
    var
        ReleaseTransferDoc: Codeunit "Release Transfer Document";
        TransferHeader: Record "Transfer Header";
    begin
        if TransferHeader.get(documentNoP) then begin
            ReleaseTransferDoc.Reopen(TransferHeader);
            Exit(true);
        end;
        Exit(false);

    end;

    internal procedure DeleteTransferOrder(documentNoP: Code[20]): Boolean
    var
        TransferLine: Record "Transfer Line";
        TransferHeader: Record "Transfer Header";
    begin
        If TransferHeader.Get(documentNoP) then begin
            // Check header status
            if TransferHeader.Status <> TransferHeader.Status::Open then
                Error('Transfer Order must be Open to delete.');

            // Check lines
            TransferLine.Reset();
            TransferLine.SetRange("Document No.", TransferHeader."No.");
            if TransferLine.FindSet() then
                repeat
                    if (TransferLine."Quantity Shipped" <> 0) or
                       (TransferLine."Quantity Received" <> 0) then
                        Error(
                          'Transfer Order %1 cannot be deleted because one or more lines are already shipped or received.',
                          TransferHeader."No.");
                until TransferLine.Next() = 0;

            // Delete lines first
            TransferLine.Reset();
            TransferLine.SetRange("Document No.", TransferHeader."No.");
            if not TransferLine.IsEmpty() then
                TransferLine.DeleteAll(true);

            // Delete header
            TransferHeader.Delete(true);

            Exit(true);
        end;
        Exit(false);
    end;


    internal procedure PickTransferLineCreateUpdate(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]; BinCodeP: Code[20])
    var
        TransferLineL: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        TransferHeaderL: Record "Transfer Header";
    begin
        TransferHeaderL.Get(DocumentNoP);
        if TransferHeaderL.Status = TransferHeaderL.Status::Released then
            Error(Text005);
        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);

        TransferLineL.SetRange("Transfer-From Bin Code", BinCodeP);

        IF TransferLineL.FINDFIRST() THEN BEGIN
            TransferLineL.VALIDATE(Quantity, TransferLineL.Quantity + QuantityP);
            TransferLineL.MODIFY(TRUE);
        END ELSE BEGIN
            CLEAR(TransferLineL);
            TransferLineL.SETRANGE("Document No.", DocumentNoP);
            IF TransferLineL.FINDLAST() THEN
                LineNoL := TransferLineL."Line No.";

            CLEAR(TransferLineL);
            TransferLineL.INIT();
            TransferLineL.VALIDATE("Document No.", DocumentNoP);
            TransferLineL.VALIDATE("Line No.", LineNoL + 10000);
            TransferLineL.INSERT(TRUE);
            TransferLineL.VALIDATE("Item No.", ItemNoP);
            TransferLineL.VALIDATE("Variant Code", VariantCodeP);
            TransferLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
            TransferLineL.VALIDATE(Quantity, QuantityP);
            TransferLineL."Stars Barcode No." := BarcodeNoP; //Stars03.00
            TransferLineL.Validate("Transfer-From Bin Code", BinCodeP);
            TransferLineL.MODIFY(TRUE);
        END;

        TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

        HandheldScanL.INIT();
        HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
        HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
        HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
        HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
        HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
        HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
        HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
        HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
        HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
        HandheldScanL.VALIDATE(Quantity, QuantityP);
        HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
        HandheldScanL.VALIDATE("Serial No.", SerialNoP);
        HandheldScanL.VALIDATE("Lot No.", LotNoP);
        HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
        HandheldScanL.VALIDATE("User ID", UserIdP);
        HandheldScanL.Validate("Bin Code", BinCodeP);
        HandheldScanL.INSERT(TRUE);
    end;

    internal procedure PickTransferHeaderPostReceipt(DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        TransferHeaderL: Record "Transfer Header";
        HandheldScan: Record "Stars HandHeld Scan";
    begin
        TransferHeaderL.GET(DocumentNoP);

        CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post Receipt", TransferHeaderL);

        CreateInfoHandheldScan2(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Transfer Order",
          TransferHeaderL."No.", TransferHeaderL."Transfer-from Code", TransferHeaderL."Transfer-to Code",
          'Pick Transfer Order Post Receipt', UserIdP);

        EXIT(TRUE);
    end;

    internal procedure PostHandheldScanPhysInv(actionType: Integer; barcodeNo: Text[20]; baseUnitOfMEasureCode: Text[10]; documentType: Integer;
                expiry: Text[50]; itemNo: Text[20]; binCode: Text[20]; journalBatchName: Text[10]; journalTemplateName: Text[10]; locationCode: Text[10];
                lotNo: Text[20]; qtyPerUnitOfMeasure: Text[50]; quantity: Text[50];
                quantityBase: Text[50]; scannedDateTime: Text[50]; serialNo: Text[20];
                unitOfMeasureCode: Text[10]; userId: Text[50]; variantCode: Text[10]; session: Text[50]): Text
    var
        HandheldScans: Record "Stars Handheld Scan";
        dateFormat: Date;
        dateTime: DateTime;
        decimal: Decimal;
        calc: text;
        scanned: text;
        result: text;
        JObject: JsonObject;
        Barcodes: Record "LSC Barcodes";
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ItemTrackingCode: Record "Item Tracking Code";
        BarcodeMask: Record "LSC Barcode Mask";
        BarcodeMaskSegment: Record "LSC Barcode Mask Segment";
    begin

        Barcodes.Get(BarcodeNo);
        Item.Get(Barcodes."Item No.");
        HandheldScans.INIT();
        HandheldScans.VALIDATE("Entry No.", 0);
        HandheldScans.VALIDATE("Action Type", actionType);
        HandheldScans.VALIDATE("Document Type", documentType);
        HandheldScans.VALIDATE("Item No.", itemNo);
        HandheldScans.VALIDATE("Variant Code", variantCode);
        HandheldScans.VALIDATE("Location Code", locationCode);
        HandheldScans.VALIDATE("Bin Code", binCode);
        HandheldScans.VALIDATE("Lot No.", lotNo);
        HandheldScans.VALIDATE("Serial No.", serialNo);
        if (expiry <> '1/1/1753 12:00:00 AM') then begin
            EVALUATE(dateFormat, expiry);
            HandheldScans.VALIDATE("Expiry", dateFormat);
        end;
        HandheldScans.VALIDATE("Barcode No.", barcodeNo);
        HandheldScans.VALIDATE("Base Unit of Measure Code", baseUnitOfMEasureCode);
        HandheldScans.VALIDATE("Item Description", Item.Description);
        HandheldScans.VALIDATE("Journal Batch Name", journalBatchName);
        HandheldScans.VALIDATE("Journal Template Name", journalTemplateName);
        EVALUATE(decimal, qtyPerUnitOfMeasure);
        HandheldScans.VALIDATE("Qty. per Unit of Measure", decimal);
        EVALUATE(decimal, quantity);
        HandheldScans.VALIDATE("Quantity", decimal);
        EVALUATE(decimal, quantityBase);
        HandheldScans.VALIDATE("Quantity (Base)", decimal);
        EVALUATE(dateTime, scannedDateTime);
        HandheldScans.VALIDATE("Scanned Date/Time", CurrentDateTime());
        HandheldScans.VALIDATE("Unit of Measure Code", unitOfMeasureCode);
        HandheldScans.VALIDATE("User ID", userId);
        HandheldScans.VALIDATE("Phys. Inv. Session", session);
        HandheldScans.INSERT(TRUE);
        JObject.Add('QtyCalculated', 0);
        JObject.Add('QtyScanned', GetPhysInvQtyScannedBase(actionType, documentType, journalTemplateName, journalBatchName, locationCode, itemNo, variantCode, session, binCode, ''));
        JObject.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure Ping(): Text
    begin
        Exit('Pong');
    end;



    internal procedure ValidateBinOptimized(locationCode: Text[10]; binCode: Text[20]): Text
    begin
        if ValidateBin(locationCode, binCode) then begin
            Exit(GetBinQtyOnHand(binCode, locationCode));
        end;
        Exit('');
    end;

    internal procedure ValidateLotNoOptimized(locationCode: Text[10]; LotNo: Text[20]): Text
    begin
        if ValidateLot(LotNo) then begin
            Exit(GetLotQtyOnHand(LotNo, locationCode));
        end;
        Exit('');
    end;

    internal procedure PostHandheldScanBinToBin(actionType: Integer; barcodeNo: Text[20]; baseUnitOfMEasureCode: Text[10]; documentType: Integer;
                expiry: Text[50]; itemNo: Text[20]; binCode: Text[20]; binCodeTo: Text[20]; journalBatchName: Text[10]; journalTemplateName: Text[10]; locationCode: Text[10];
                lotNo: Text[20]; qtyPerUnitOfMeasure: Text[50]; quantity: Text[50];
                quantityBase: Text[50]; scannedDateTime: Text[50]; serialNo: Text[20];
                unitOfMeasureCode: Text[10]; userId: Text[50]; variantCode: Text[10]; session: Text[50]): Text
    var
        HandheldScans: Record "Stars Handheld Scan";
        dateFormat: Date;
        dateTime: DateTime;
        decimal: Decimal;
        calc: text;
        scanned: text;
        result: text;
        JObject: JsonObject;
        Barcodes: Record "LSC Barcodes";
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ItemTrackingCode: Record "Item Tracking Code";
        BarcodeMask: Record "LSC Barcode Mask";
        BarcodeMaskSegment: Record "LSC Barcode Mask Segment";
    begin

        Barcodes.Get(BarcodeNo);
        Item.Get(Barcodes."Item No.");
        HandheldScans.INIT();
        HandheldScans.VALIDATE("Entry No.", 0);
        HandheldScans.VALIDATE("Action Type", actionType);
        HandheldScans.VALIDATE("Document Type", documentType);
        HandheldScans.VALIDATE("Item No.", itemNo);
        HandheldScans.VALIDATE("Variant Code", variantCode);
        HandheldScans.VALIDATE("Location Code", locationCode);
        HandheldScans.VALIDATE("Bin Code", binCode);
        HandheldScans.VALIDATE("Bin Code To", binCodeTo);
        HandheldScans.VALIDATE("Lot No.", lotNo);
        HandheldScans.VALIDATE("Serial No.", serialNo);
        if (expiry <> '1/1/1753 12:00:00 AM') then begin
            EVALUATE(dateFormat, expiry);
            HandheldScans.VALIDATE("Expiry", dateFormat);
        end;
        HandheldScans.VALIDATE("Barcode No.", barcodeNo);
        HandheldScans.VALIDATE("Base Unit of Measure Code", baseUnitOfMEasureCode);
        HandheldScans.VALIDATE("Item Description", Item.Description);
        HandheldScans.VALIDATE("Journal Batch Name", journalBatchName);
        HandheldScans.VALIDATE("Journal Template Name", journalTemplateName);
        EVALUATE(decimal, qtyPerUnitOfMeasure);
        HandheldScans.VALIDATE("Qty. per Unit of Measure", decimal);
        EVALUATE(decimal, quantity);
        HandheldScans.VALIDATE("Quantity", decimal);
        EVALUATE(decimal, quantityBase);
        HandheldScans.VALIDATE("Quantity (Base)", decimal);
        EVALUATE(dateTime, scannedDateTime);
        HandheldScans.VALIDATE("Scanned Date/Time", CurrentDateTime());
        HandheldScans.VALIDATE("Unit of Measure Code", unitOfMeasureCode);
        HandheldScans.VALIDATE("User ID", userId);
        HandheldScans.VALIDATE("Phys. Inv. Session", session);
        HandheldScans.INSERT(TRUE);
        JObject.Add('QtyCalculated', 0);
        JObject.Add('QtyScanned', GetPhysInvQtyScannedBase(actionType, documentType, journalTemplateName, journalBatchName, locationCode, itemNo, variantCode, session, binCode, ''));
        JObject.WriteTo(JsonText);
        EXIT(JsonText);
    end;

    internal procedure PickTransferLineReceive(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]): Boolean
    var
        TransferLineL: Record "Transfer Line";
        TransferLine2L: Record "Transfer Line";
        TransferLine3L: Record "Transfer Line";
        LineNoL: Integer;
        HandheldScanL: Record "Stars HandHeld Scan";
        SumOfQty: Decimal;
        SumOfQtyToRec: Decimal;
        ValidQtyToRec: Decimal;
        counter: integer;
        RemainingQty: Decimal;
    begin
        TransferLine3L.SETRANGE("Document No.", DocumentNoP);
        TransferLine3L.SETRANGE("Item No.", ItemNoP);
        TransferLine3L.SETRANGE("Variant Code", VariantCodeP);
        TransferLine3L.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        IF TransferLine3L.FindFirst() THEN BEGIN
            REPEAT
                if TransferLine3L."Quantity Received" < TransferLine3L.Quantity then begin
                    SumOfQty := SumOfQty + TransferLine3L.Quantity;
                    SumOfQtyToRec := SumOfQtyToRec + TransferLine3L."Qty. to Receive";
                end;
            UNTIL TransferLine3L.NEXT = 0;
        End;

        TransferLineL.SETRANGE("Document No.", DocumentNoP);
        TransferLineL.SETRANGE("Item No.", ItemNoP);
        TransferLineL.SETRANGE("Variant Code", VariantCodeP);
        TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
        IF TransferLineL.FindFirst() THEN BEGIN
            counter := 0;
            RemainingQty := QuantityP;
            repeat
                if TransferLineL."Quantity Received" < TransferLineL.Quantity then
                    IF ((SumOfQty) >= (SumOfQtyToRec + QuantityP)) And (RemainingQty <> 0) Then Begin
                        ValidQtyToRec := TransferLineL.Quantity - TransferLineL."Qty. to Receive";
                        IF (ValidQtyToRec >= RemainingQty) THEN BEGIN
                            TransferLineL.VALIDATE("Qty. to Receive", TransferLineL."Qty. to Receive" + RemainingQty);
                            TransferLineL.MODIFY(TRUE);

                            TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                            TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                            TransferLine2L.FINDFIRST();
                            TransferResEntryReceive(TransferLine2L, RemainingQty, LotNoP, SerialNoP, ExpiryDateP);

                            Clear(HandheldScanL);
                            HandheldScanL.INIT();
                            HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                            HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                            HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                            HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                            HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                            HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                            HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                            HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                            HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                            HandheldScanL.VALIDATE(Quantity, RemainingQty);
                            HandheldScanL.VALIDATE("Quantity (Base)", RemainingQty * TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                            HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                            HandheldScanL.VALIDATE("Lot No.", LotNoP);
                            HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                            HandheldScanL.VALIDATE("User ID", UserIdP);
                            HandheldScanL.INSERT(TRUE);
                            counter := counter + 1;
                            RemainingQty := 0;
                        END ELSE BEGIN
                            if ValidQtyToRec <> 0 then begin
                                TransferLineL.VALIDATE("Qty. to Receive", TransferLineL."Qty. to Receive" + ValidQtyToRec);
                                TransferLineL.MODIFY(TRUE);

                                TransferLine2L.SETRANGE("Document No.", TransferLineL."Document No.");
                                TransferLine2L.SETRANGE("Derived From Line No.", TransferLineL."Line No.");
                                TransferLine2L.FINDFIRST();
                                TransferResEntryReceive(TransferLine2L, ValidQtyToRec, LotNoP, SerialNoP, ExpiryDateP);

                                Clear(HandheldScanL);
                                HandheldScanL.INIT();
                                HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Receive);
                                HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
                                HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
                                HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
                                HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
                                HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
                                HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
                                HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
                                HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                                HandheldScanL.VALIDATE(Quantity, ValidQtyToRec);
                                HandheldScanL.VALIDATE("Quantity (Base)", ValidQtyToRec * TransferLineL."Qty. per Unit of Measure");
                                HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
                                HandheldScanL.VALIDATE("Serial No.", SerialNoP);
                                HandheldScanL.VALIDATE("Lot No.", LotNoP);
                                HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
                                HandheldScanL.VALIDATE("User ID", UserIdP);
                                HandheldScanL.INSERT(TRUE);
                                RemainingQty := RemainingQty - ValidQtyToRec;
                            end;
                        END;
                    END
            until TransferLineL.NEXT = 0;
            if counter = 0 then
                Error(Text003);
            Exit(true);
        END ELSE
            ERROR(Text004);
    end;

    internal procedure SelectPOForDirectTO(documentNoPOP: code[20]; documentNoTOP: code[20])
    var
        PurchaseHeaderL: Record "Purchase Header";
        TransferHeaderL: Record "Transfer Header";
        Text001L: Label 'Purchase Order cannot be found.';
        Text002L: Label 'Transfer Order cannot be found.';
    begin
        if not PurchaseHeaderL.Get(PurchaseHeaderL."Document Type"::Order, documentNoPOP) then
            Error(Text001L);

        if not TransferHeaderL.Get(documentNoTOP) then
            Error(Text002L);

        TransferHeaderL."Stars HHT Assigned PO" := PurchaseHeaderL."No.";
        TransferHeaderL.Modify(true);
    end;

    internal procedure GetDirectPurchaseOrderInfo(documentNoP: code[20]): Text
    var
        PurchaseHeaderL: Record "Purchase Header";
        TransferHeaderL: Record "Transfer Header";
        JObject: JsonObject;
        Text001L: Label 'Transfer Order cannot be found.';
        Text002L: Label 'Purchase Order cannot be found.';
    begin
        if not TransferHeaderL.Get(documentNoP) then
            Exit(Text001L);

        if TransferHeaderL."Stars HHT Assigned PO" = '' then
            Exit('');

        if not PurchaseHeaderL.Get(PurchaseHeaderL."Document Type"::Order, TransferHeaderL."Stars HHT Assigned PO") then
            Error(Text002L);

        JObject.Add('PurchaseOrderNo', PurchaseHeaderL."No.");
        JObject.Add('VendorNo', PurchaseHeaderL."Buy-from Vendor No.");
        JObject.Add('VendorName', PurchaseHeaderL."Buy-from Vendor Name");
        //JObject.Add('ShipmentID', PurchaseHeaderL."Stars Shipment ID");

        JObject.WriteTo(JsonText);
        Exit(JsonText);
    end;

    // internal procedure UpdateAndPostPO(documentNoTOP: Code[20])
    // var
    //     TransferHeaderL: Record "Transfer Header";
    //     PurchaseHeaderL: Record "Purchase Header";
    //     HandheldScansL: Record "Stars Handheld Scan";
    //     HandheldScans2L: Record "Stars Handheld Scan";
    //     ReleasePurchDoc: Codeunit "Release Purchase Document";
    //     UserID: Code[50];
    //     IsBinMandatory: Boolean;
    //     Text001L: Label 'Transfer Order cannot be found.';
    //     Text002L: Label 'Transfer Order assigned PO is empty, select a Purchase Order first.';
    //     Text003L: Label 'Purchase Order cannot be found.';
    //     Text004L: Label 'Action is already under process in another session, please try again later';
    //     Text005L: Label 'No Handheld scans for this Transfer Order.';
    // begin
    //     if not TransferHeaderL.Get(documentNoTOP) then
    //         Error(Text001L);

    //     if TransferHeaderL."Stars HHT Assigned PO" = '' then
    //         Error(Text002L);

    //     if not PurchaseHeaderL.Get(PurchaseHeaderL."Document Type"::Order, TransferHeaderL."Stars HHT Assigned PO") then
    //         Error(Text003L);

    //     // if PurchaseHeaderL."Stars HHT Processing Direct TO" then
    //     //     Error(Text004L);

    //     // if PurchaseHeaderL."Stars HHT Processing Direct TO" then begin
    //     //     if PurchaseHeaderL."Stars HHT Processing Time" < (PurchaseHeaderL."Stars HHT Processing Time" + 10 * 60000) then
    //     //         Error(Text004L)
    //     //     else begin
    //     //         PurchaseHeaderL."Stars HHT Processing Direct TO" := false;
    //     //         PurchaseHeaderL.Modify(true);
    //     //     end;
    //     // end
    //     if PurchaseHeaderL."Stars HHT Processing Direct TO" then begin
    //         if CurrentDateTime < (PurchaseHeaderL."Stars HHT Processing Time" + 10 * 60000) then
    //             Error(Text004L)
    //         else begin
    //             PurchaseHeaderL."Stars HHT Processing Direct TO" := false;
    //             PurchaseHeaderL.Modify(true);
    //         end;
    //     end
    //     else begin
    //         PurchaseHeaderL."Stars HHT Processing Time" := CurrentDateTime();
    //         PurchaseHeaderL.Modify(true);
    //     end;

    //     if PurchaseHeaderL.Status = PurchaseHeaderL.Status::Released then
    //         ReleasePurchDoc.PerformManualReopen(PurchaseHeaderL);

    //     IsBinMandatory := LocationBinMandatory(TransferHeaderL."Transfer-to Code");

    //     HandheldScansL.SetRange("Document Type", HandheldScansL."Document Type"::"Transfer Order");
    //     if not IsBinMandatory then
    //         HandheldScansL.SetRange("Action Type", HandheldScansL."Action Type"::Create)
    //     else
    //         HandheldScansL.SetRange("Action Type", HandheldScansL."Action Type"::Ship);
    //     HandheldScansL.SetRange("Document No.", documentNoTOP);
    //     HandheldScansL.SetRange(Processed, false);
    //     HandheldScansL.SetRange(Deleted, false);
    //     HandheldScansL.SetFilter("Item No.", '<>%1', '');
    //     HandheldScansL.SetRange("Stars Processed Direct TO", false);
    //     if IsBinMandatory then
    //         HandheldScansL.SetFilter("Bin Code To", '<>%1', '');
    //     if not HandheldScansL.FindSet() then
    //         Error(Text005L);

    //     UserID := HandheldScansL."User ID";

    //     if PurchaseHeaderL.get(PurchaseHeaderL."Document Type"::Order, TransferHeaderL."Stars HHT Assigned PO") then begin
    //         PurchaseHeaderL."Stars HHT Processing Direct TO" := true;
    //         PurchaseHeaderL.Modify(true);
    //     end;

    //     repeat
    //         // PurchaseLineCreateUpdate
    //         PurchaseLineCreateUpdate(PurchaseHeaderL."Document Type"::Order, PurchaseHeaderL."No.", HandheldScansL."Barcode No.", HandheldScansL."Item No.", HandheldScansL."Variant Code", HandheldScansL."Unit of Measure Code", HandheldScansL.Quantity, HandheldScansL."Lot No.", HandheldScansL."Serial No.", HandheldScansL.Expiry, HandheldScansL."User ID");

    //         HandheldScansL."Stars Direct TO Asssigned PO" := PurchaseHeaderL."No.";
    //         HandheldScansL."Stars Processed Direct TO" := true;
    //         HandheldScansL.Modify(true);

    //     until HandheldScansL.next() = 0;

    //     // PurchaseHeaderPost
    //     DirectTransferPurchaseHeaderPost(PurchaseHeaderL."Document Type"::Order, PurchaseHeaderL."No.", UserID);

    //     // PurchaseReopen
    //     if PurchaseHeaderL.get(PurchaseHeaderL."Document Type"::Order, TransferHeaderL."Stars HHT Assigned PO") then
    //         ReleasePurchDoc.PerformManualReopen(PurchaseHeaderL);

    //     PurchaseHeaderL.Reset();
    //     PurchaseHeaderL.SetRange("Document Type", PurchaseHeaderL."Document Type"::Order);
    //     PurchaseHeaderL.SetRange("No.", TransferHeaderL."Stars HHT Assigned PO");
    //     PurchaseHeaderL.ModifyAll("Stars HHT Processing Direct TO", false, true);

    //     TransferHeaderL.Reset();
    //     TransferHeaderL.SetRange("No.", documentNoTOP);
    //     TransferHeaderL.ModifyAll("Stars HHT PO Updated And Posted", true, true);
    // end;

    internal procedure ResetPorcessingDirectTOField(documentNoP: Code[20])
    var
        PurchaseHeaderL: Record "Purchase Header";
        TransferHeaderL: Record "Transfer Header";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        if TransferHeaderL.Get(documentNoP) then begin
            if PurchaseHeaderL.Get(PurchaseHeaderL."Document Type", TransferHeaderL."Stars HHT Assigned PO") then begin
                if PurchaseHeaderL.Status = PurchaseHeaderL.Status::Released then
                    ReleasePurchDoc.PerformManualReopen(PurchaseHeaderL);
                PurchaseHeaderL."Stars HHT Processing Direct TO" := false;
                PurchaseHeaderL.Modify(true);
            end;
        end;
    end;

    internal procedure IsDirectTOPOUpdatedAndPosted(documentNoP: Code[20]): Boolean
    var
        PurchaseHeaderL: Record "Purchase Header";
        TransferHeaderL: Record "Transfer Header";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        if TransferHeaderL.Get(documentNoP) then begin
            if TransferHeaderL."Stars HHT PO Updated & Posted" then
                Exit(true)
            else
                Exit(false);
        end;
        Exit(false);
    end;

    internal procedure DirectTransferPurchaseHeaderPost(DocumentTypeP: Option; DocumentNoP: Code[20]; UserIdP: Code[50]): Boolean
    var
        PurchaseHeaderL: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        IF PurchaseHeaderL.GET(DocumentTypeP, DocumentNoP) THEN BEGIN
            IF (PurchaseHeaderL."Document Type" = PurchaseHeaderL."Document Type"::Order) THEN
                PurchaseHeaderL.Receive := TRUE
            ELSE
                IF (PurchaseHeaderL."Document Type" = PurchaseHeaderL."Document Type"::"Return Order") THEN
                    PurchaseHeaderL.Ship := TRUE;

            //CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PurchaseHeaderL);
            PurchPost.SetSuppressCommit(true);
            PurchPost.Run(PurchaseHeaderL);

            IF (DocumentTypeP = PurchaseHeaderL."Document Type"::"Return Order") THEN
                CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Purchase Return Order",
                  DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Return Order Post', UserIdP)
            ELSE
                CreateInfoHandheldScan(HandheldScanG."Action Type"::Post, HandheldScanG."Document Type"::"Purchase Order",
                  DocumentNoP, PurchaseHeaderL."Location Code", 'Purchase Order Post', UserIdP);

            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;

    // internal procedure DirPutAwayTransferLineCreateUpdate(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50]; BinCodeP: Code[20])
    // var
    //     Item: Record Item;
    //     PurchaseHeader: Record "Purchase Header";
    //     TransferLineL: Record "Transfer Line";
    //     LineNoL: Integer;
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     TransferHeaderL: Record "Transfer Header";
    // begin
    //     TransferHeaderL.Get(DocumentNoP);
    //     if TransferHeaderL.Status = TransferHeaderL.Status::Released then
    //         Error(Text005);

    //     if TransferHeaderL."Stars HHT Assigned PO" = '' then
    //         Error(Text006, TransferHeaderL."No.");

    //     Item.Get(ItemNoP);
    //     PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, TransferHeaderL."Stars HHT Assigned PO");
    //     if Item."Stars Shipment ID" <> PurchaseHeader."Stars Shipment ID" then
    //         Error(Text007, Item."No.", Item."Stars Shipment ID", PurchaseHeader."No.", PurchaseHeader."Stars Shipment ID");

    //     TransferLineL.SETRANGE("Document No.", DocumentNoP);
    //     TransferLineL.SETRANGE("Item No.", ItemNoP);
    //     TransferLineL.SETRANGE("Variant Code", VariantCodeP);
    //     TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);

    //     TransferLineL.SetRange("Transfer-To Bin Code", BinCodeP);

    //     IF TransferLineL.FINDFIRST() THEN BEGIN
    //         TransferLineL.VALIDATE(Quantity, TransferLineL.Quantity + QuantityP);
    //         TransferLineL.MODIFY(TRUE);
    //     END ELSE BEGIN
    //         CLEAR(TransferLineL);
    //         TransferLineL.SETRANGE("Document No.", DocumentNoP);
    //         IF TransferLineL.FINDLAST() THEN
    //             LineNoL := TransferLineL."Line No.";

    //         CLEAR(TransferLineL);
    //         TransferLineL.INIT();
    //         TransferLineL.VALIDATE("Document No.", DocumentNoP);
    //         TransferLineL.VALIDATE("Line No.", LineNoL + 10000);
    //         TransferLineL.INSERT(TRUE);
    //         TransferLineL.VALIDATE("Item No.", ItemNoP);
    //         TransferLineL.VALIDATE("Variant Code", VariantCodeP);
    //         TransferLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
    //         TransferLineL.VALIDATE(Quantity, QuantityP);
    //         TransferLineL."Stars Barcode No." := BarcodeNoP; //Stars03.00
    //         TransferLineL.Validate("Transfer-To Bin Code", BinCodeP);
    //         TransferLineL.MODIFY(TRUE);
    //     END;

    //     TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

    //     HandheldScanL.INIT();
    //     HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Ship);
    //     HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
    //     HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
    //     HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
    //     HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
    //     HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
    //     HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
    //     HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
    //     HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
    //     HandheldScanL.VALIDATE(Quantity, QuantityP);
    //     HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
    //     HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
    //     HandheldScanL.VALIDATE("Serial No.", SerialNoP);
    //     HandheldScanL.VALIDATE("Lot No.", LotNoP);
    //     HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
    //     HandheldScanL.VALIDATE("User ID", UserIdP);
    //     HandheldScanL.Validate("Bin Code To", BinCodeP);
    //     HandheldScanL.INSERT(TRUE);
    // end;

    // internal procedure DirTransferLineCreateUpdate(DocumentNoP: Code[20]; BarcodeNoP: Code[20]; ItemNoP: Code[20]; VariantCodeP: Code[10]; UnitOfMeasureCodeP: Code[10]; QuantityP: Decimal; LotNoP: Code[20]; SerialNoP: Code[20]; ExpiryDateP: Date; UserIdP: Code[50])
    // var
    //     Item: Record Item;
    //     PurchaseHeader: Record "Purchase Header";
    //     TransferLineL: Record "Transfer Line";
    //     LineNoL: Integer;
    //     HandheldScanL: Record "Stars HandHeld Scan";
    //     TransferHeaderL: Record "Transfer Header";
    // begin
    //     TransferHeaderL.Get(DocumentNoP);
    //     if TransferHeaderL.Status = TransferHeaderL.Status::Released then
    //         Error(Text005);

    //     if TransferHeaderL."Stars HHT Assigned PO" = '' then
    //         Error(Text006, TransferHeaderL."No.");

    //     Item.Get(ItemNoP);
    //     PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, TransferHeaderL."Stars HHT Assigned PO");
    //     if Item."Stars Shipment ID" <> PurchaseHeader."Stars Shipment ID" then
    //         Error(Text007, Item."No.", Item."Stars Shipment ID", PurchaseHeader."No.", PurchaseHeader."Stars Shipment ID");

    //     TransferLineL.SETRANGE("Document No.", DocumentNoP);
    //     TransferLineL.SETRANGE("Item No.", ItemNoP);
    //     TransferLineL.SETRANGE("Variant Code", VariantCodeP);
    //     TransferLineL.SETRANGE("Unit of Measure Code", UnitOfMeasureCodeP);
    //     IF TransferLineL.FINDFIRST() THEN BEGIN
    //         TransferLineL.VALIDATE(Quantity, TransferLineL.Quantity + QuantityP);
    //         TransferLineL.MODIFY(TRUE);
    //     END ELSE BEGIN
    //         CLEAR(TransferLineL);
    //         TransferLineL.SETRANGE("Document No.", DocumentNoP);
    //         IF TransferLineL.FINDLAST() THEN
    //             LineNoL := TransferLineL."Line No.";

    //         CLEAR(TransferLineL);
    //         TransferLineL.INIT();
    //         TransferLineL.VALIDATE("Document No.", DocumentNoP);
    //         TransferLineL.VALIDATE("Line No.", LineNoL + 10000);
    //         TransferLineL.INSERT(TRUE);
    //         TransferLineL.VALIDATE("Item No.", ItemNoP);
    //         TransferLineL.VALIDATE("Variant Code", VariantCodeP);
    //         TransferLineL.VALIDATE("Unit of Measure Code", UnitOfMeasureCodeP);
    //         TransferLineL.VALIDATE(Quantity, QuantityP);
    //         TransferLineL."Stars Barcode No." := BarcodeNoP; //Stars03.00
    //         TransferLineL.MODIFY(TRUE);
    //     END;

    //     TransferResEntryCreateUpdate(TransferLineL, QuantityP, LotNoP, SerialNoP, ExpiryDateP);

    //     HandheldScanL.INIT();
    //     HandheldScanL.VALIDATE("Action Type", HandheldScanL."Action Type"::Create);
    //     HandheldScanL.VALIDATE("Document Type", HandheldScanL."Document Type"::"Transfer Order");
    //     HandheldScanL.VALIDATE("Document No.", TransferLineL."Document No.");
    //     HandheldScanL.VALIDATE("Location Code", TransferLineL."Transfer-from Code");
    //     HandheldScanL.VALIDATE("Location Code To", TransferLineL."Transfer-to Code");
    //     HandheldScanL.VALIDATE("Barcode No.", BarcodeNoP);
    //     HandheldScanL.VALIDATE("Item No.", TransferLineL."Item No.");
    //     HandheldScanL.VALIDATE("Variant Code", TransferLineL."Variant Code");
    //     HandheldScanL.VALIDATE("Unit of Measure Code", TransferLineL."Unit of Measure Code");
    //     HandheldScanL.VALIDATE(Quantity, QuantityP);
    //     HandheldScanL.VALIDATE("Quantity (Base)", QuantityP * TransferLineL."Qty. per Unit of Measure");
    //     HandheldScanL.VALIDATE("Qty. per Unit of Measure", TransferLineL."Qty. per Unit of Measure");
    //     HandheldScanL.VALIDATE("Serial No.", SerialNoP);
    //     HandheldScanL.VALIDATE("Lot No.", LotNoP);
    //     HandheldScanL.VALIDATE(Expiry, ExpiryDateP);
    //     HandheldScanL.VALIDATE("User ID", UserIdP);
    //     HandheldScanL.INSERT(TRUE);
    // end;

    // //Stars17.00++
    internal procedure DeleteAnyHandheldScan(pEntryNo: Integer): Boolean
    var
        TransferLineRec: Record "Transfer Line";
        TransferHeaderRec: Record "Transfer Header";
        HandheldScanRec: Record "Stars Handheld Scan";
        NewQty: Decimal;
        Text001: Label 'Cannot delete. Quantity (%1) would be less than Qty. Shipped (%2).';
        Text002: Label 'Cannot delete. Quantity (%1) would be less than Qty. Received (%2).';
        Text003: Label 'Cannot delete Transfer Line because it has shipped or received quantities.';
    begin
        if not HandheldScanRec.Get(pEntryNo) then
            exit(false);

        if HandheldScanRec."Action Type" <> HandheldScanRec."Action Type"::Create then
            if HandheldScanRec."Action Type" <> HandheldScanRec."Action Type"::Ship then
                exit(false);

        if (HandheldScanRec."Document Type" <> HandheldScanRec."Document Type"::"Transfer Order") then
            if (HandheldScanRec."Document Type" <> HandheldScanRec."Document Type"::"Direct Transfer Order") then
                exit(false);

        if not TransferHeaderRec.Get(HandheldScanRec."Document No.") then begin
            exit(false);
        end;

        TransferHeaderRec.TestField(Status, TransferHeaderRec.Status::Open);

        TransferLineRec.SetRange("Document No.", TransferHeaderRec."No.");
        TransferLineRec.SetRange("Derived From Line No.", 0);
        TransferLineRec.SetRange("Item No.", HandheldScanRec."Item No.");
        TransferLineRec.SetRange("Variant Code", HandheldScanRec."Variant Code");
        TransferLineRec.SetRange("Unit of Measure Code", HandheldScanRec."Unit of Measure Code");

        if not TransferLineRec.FindFirst() then
            exit(false);

        NewQty := TransferLineRec.Quantity - HandheldScanRec.Quantity;

        if NewQty < TransferLineRec."Quantity Shipped" then
            Error(Text001, NewQty, TransferLineRec."Quantity Shipped");

        if NewQty < TransferLineRec."Quantity Received" then
            Error(Text002, NewQty, TransferLineRec."Quantity Received");

        if NewQty <= 0 then begin
            if (TransferLineRec."Quantity Shipped" <> 0) or (TransferLineRec."Quantity Received" <> 0) then
                Error(Text003);
            TransferLineRec.Delete(true);
        end else begin
            TransferLineRec.Validate(Quantity, NewQty);
            TransferLineRec.Modify(true);
        end;

        HandheldScanRec.Deleted := true;
        HandheldScanRec."Delete By" := UserId;
        HandheldScanRec."Deleted Date/Time" := CurrentDateTime;
        HandheldScanRec.Modify();
        exit(true);
    end;

    internal procedure GetLastEntryNo(): Integer
    var
        HandheldScan: Record "Stars Handheld Scan";
    Begin
        HandheldScan.Reset();
        If HandheldScan.Findlast() then
            exit(HandheldScan."Entry No.");
    End;
}