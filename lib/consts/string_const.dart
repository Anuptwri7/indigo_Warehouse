  class StringConst {
    /*HomePage*/
      // static String name = " SOORI";
      static String name = " CUBIX";
      static String account = " Account";
    static const String poIn = "Receive";
    static const String poOut = "Pick up";
    static const String locationShifting = "Location Shifting";
    static const String dropDepartment = "Drop";
    static const String department = "Department";
    static const String pickDepartment = "Pick";
    static const String receiveDepartment = "Receive";
    static const String sale = "Sale";
    static const String info = "Info";
    static const String chalan = "Chalan";
    static const String chalanreturn = "Chalan Return";
    static const String chalanReturndrop = "Chalan Return Drop";
    static const String salereturn = "Sale Return";
    static const String salereturndrop = "Sale Return Drop";
    static const String saleRePackaging = "Sale RePack";
    static const String dropRepacket = "Drop";
    static const String RePacketing = "Packetting";
    static const String chalanRePackaging = "Chalan RePack";
    static const String transferReapckaging = "Transfer RePack";
    static const String bulkDrop = "Bulk Drop";
    static const String singleDrop = "Single Drop";
    static const String getPackInfo = "Pack Info";
    static const String serialInfo = "Serial Info";
    static const String poDrop = "Drop";
    static const String poAudit = "Audit";
    static const String openingStock = "Open Stock";
    static const String transfer = "Transfer order";
    static const String repackage = "Packaging";
    static const String ppb = "Pre-Process";
    static const String appName = "Indigo Paints";

    /*Login Page*/
    static String loginWelcome = "Welcome !";
    static String loginText = " Login To Continue";
    static String rememberMe = "Remember Me";
    static String userName = 'Username';
    static String password = 'Password';
    static String subDomain = 'subDomain';

    /*Network */
    static String mainUrl = '';
    static String branchUrl = 'https://api-demo.sooritechnology.com.np/api/v1/branches';
    // static String branchUrl = 'https://api-demo.ybs.com.np/api/v1/branches?limit=0';
    // static String protocol = 'http://';
    static String protocol = 'https://';
    // static String branchUrl = 'http://192.168.101.8:8082/api/v1/branches';
    // static String branchUrl =
    //     'https://api.sooritechnology.com.np/api/v1/branches';
    // static String branchUrl =
    //     'https://api-soori-ims-staging.dipendranath.com.np/api/v1/branches';
    // static String baseUrl = 'https://api-soori-ims-staging.dipendranath.com.np';
    static String openingStockDetailFromMaster = '/api/v1/purchase-app/purchase-detail?purchase=';
    static const String refreshToken = "user-app/login/refresh";
    static const String logout = "user-app/logout";
    static String baseUrl = "https://api.sooritechnology.com.np";
    static String availableCodes= '/api/v1/asset-app/packing-type-detail-code-list?limit=50&item_id=';
    /*http://192.168.101.13:8000/api/v1/branches*/
    static String urlMidPoint = '/api/v1/user-app/';
    static String customerList = "/api/v1/chalan-app/customer-list?limit=0";
    static String getPackCodes =
        "/api/v1/customer-order-app/batch-save-pickup-order";
    static String pickupVerify =
        '/api/v1/customer-order-app/verify-pickup-customer-order';
    static const String allNotification =
        "api/v1/notification-app/user-notification?limit=0&ordering=-created_date_ad";
    static const String notificationCount =
        "api/v1/notification-app/user-notification/count";
    static const String notificationReceive =
        "api/v1/notification-app/user-notification/receive";
    static String openingStockMaster = '/api/v1/opening-stock-app/opening-stock?offset=0&limit=10&ordering=-id&';
    static const String readAllNotification = "api/v1/notification-app/user-notification/read-all";
    static String pendingPurchaseSummary = "/api/v1/purchase-app/";
    static String chalanReturnDrop =
        '/api/v1/chalan-app/chalan-master-returned?offset=0&limit=0&return_dropped=false';
    static String chalanReturn =
        '/api/v1/chalan-app/chalan-master-returned?search=&offset=0&limit=0';
    static String chalanReturnView =
        '/api/v1/chalan-app/chalan-detail?chalan_master=';
    static String chalanReturnDropUpdate =
        '/api/v1/chalan-app/chalan-return-drop';
    static String chalanReturnAddChalanNo =
        '/api/v1/chalan-app/chalan-master-chalan?';
    static String chalanReturnDropScanNow =
        '/api/v1/chalan-app/chalan-return-info?limit=0&chalan_master=';
    static String chalanReturnDropScanService =
        '/api/v1/chalan-app/chalan-return-drop';
    static String saleReturn = '/api/v1/sale-app/sale-master-return';
    static String saleReturnView =
        '/api/v1/sale-app/sale-detail?limit=0&sale_master=';
    static String saleReturnDrop =
        '/api/v1/sale-app/sale-master-return?offset=0&limit=0&return_dropped=false';
    static String urlPurchaseApp = '/api/v1/purchase-app/';
    static String urlPurchaseAppList = '/api/v1/purchase-app/get-orders';
    static String urlPurchasePendingAppList = '/api/v1/purchase-app/get-orders/pending';
    static String bulkDropApi = '/api/v1/purchase-app/location-bulk-purchase-order-details';
    static String receivePurchaseOrder = '/api/v1/purchase-app/receive-purchase-order';
    static String urlAuditApp = '/api/v1/audit-app/';
    static String urlCustomerOrderApp = '/api/v1/customer-order-app/';
    static String rePackagingList = '/api/v1/sale-app/get-sale-repackage-detail-info';
    static String getChalanDetailInfo = '/api/v1/chalan-app/get-chalan-repackage-detail-info';
    static String rePackageListings = '/api/v1/sale-app/sale-repackages-list';
    static String rePackageListingsChalan = '/api/v1/chalan-app/chalan-repackages-list';
    static String generateRePack = '/api/v1/item-serialization-app/save-re-packet-pack-code';
    static String dropRePack = '/api/v1/item-serialization-app/drop-re-packet-pack-code';
    static String rePackList = '/api/v1/sale-app/sale-master-sale';
    static String postRePackaging = '/api/v1/sale-app/repackage-sale';
    static String postChalanRePackaging = '/api/v1/chalan-app/repackage-chalan';
    static String bulkSaveRepackages = '/api/v1/item-serialization-app/bulk-save-repackages';
    static String addRePackaging = '/api/v1/sale-app/add-repackage-sale';
    static String addChalanRePackaging = '/api/v1/chalan-app/add-repackage-chalan';
    static String removeRePackaging = '/api/v1/sale-app/remove-repackage-sale';
    static String removeChalanRePackaging = '/api/v1/chalan-app/remove-repackage-chalan';
    static String rePackListChalan = '/api/v1/chalan-app/chalan-master-chalan';
    static String urlOpeningStockApp = '/api/v1/opening-stock-app/';
    static String urlOpeningStockAppPost = '/api/v1/opening-stock-app/location-bulk-purchase-details';
    static String locationShiftingApi =
        '/api/v1/item-serialization-app/update-pack-location';
    static String locationShiftingGetId =
        '/api/v1/item-serialization-app/pack-code-location/';
    static String packInfoGetData = '/api/v1/item-serialization-app/pack-code-info/';
    static String rePacketInfoGetData = '/api/v1/item-serialization-app/pack-code-info/';
    static String serialInfoGetData = '/api/v1/item-serialization-app/serial-no-info/';
    static String transferMaster= "/api/v1/transfer-app/";
    static String pickupDetail= "/api/v1/transfer-app/pack-type?purchase_detail=";
    static String getSerialCode= "/api/v1/transfer-app/pack-type-detail?";
    static String postPickupTransfer= "/api/v1/transfer-app/pickup-transfer";
    static String taskMaster= '/api/v1/ppb-app/task-main?offset=0&limit=0&ordering=-id';
    static String taskDetail= '/api/v1/ppb-app/task-lot?offset=0&limit=0&ordering=-id&task_main=';
    static String lotOutputMaster= '/api/v1/ppb-app/task-output-purchase-master?ordering=-id&';
    static String lotOutputDetail= '/api/v1/ppb-app/location-task-output-purchase-details?limit=0&purchase=';
    static String updateLocationlot= '/api/v1/ppb-app/location-task-output-purchase-details';
    static String bulkUpdateLocationlot= '/api/v1/ppb-app/location-task-output-bulk-purchase-details';
    static String updateWeightLot= '/api/v1/ppb-app/weight-task-output-purchase-details';
    static String taskPickLotDetail= '/api/v1/ppb-app/task-lot-detail?lot_main=';
    static String taskPickupScan= '/api/v1/ppb-app/packing-type-code-list?limit=10&purchase_detail=';
    static String pickupTask= '/api/v1/ppb-app/pickup-task-lot';
    static String lotPickupReturn= '/api/v1/ppb-app/pickup-return-task-lot';
      static String packTypeDropDown = '/api/v1/purchase-app/pending-purchase-order-summary/';

    ///transfer Repackage
    static String transferMasterList= '/api/v1/department-transfer-app/department-transfer-no-list';
    static String transferMasterListSecond= '/api/v1/department-transfer-app/department-transfer-master-from';
    static String transferRepackageListings= '/api/v1/department-transfer-app/department-transfer-repackages-list';
    static String transferRepackageListGetInfo= '/api/v1/department-transfer-app/get-department-transfer-repackage-detail-info';
    static String postRepackAll= '/api/v1/department-transfer-app/repackage-department-transfer';
    static String addRepackage= '/api/v1/department-transfer-app/add-repackage-department-transfer';
    static String removeRepackaging= '/api/v1/department-transfer-app/remove-repackage-department-transfer';


    /// split rp
        static String splitNonSerializable= '/api/v1/item-serialization-app/split-re-packet-pack-code-non-serializable';
           static String splitSerializable= '/api/v1/item-serialization-app/split-re-packet-pack-code-serializable';



           static String item= '/api/v1/item-app/item-list?limit=0';
           static String getPackingType= '/api/v1/item-app/packing-type-list?limit=0';
           static String createPackingType= '/api/v1/item-app/packing-type-detail';
           static String createPackingTypeUnit= '/api/v1/item-app/packing-type';


    ///department-transfer
              ///drop
    static String dropDetail ="/api/v1/department-transfer-app/department-transfer-received-detail";
    static String dropLocation ="/api/v1/department-transfer-app/location-department-receive-details";
    static String dropMasterListings ="/api/v1/department-transfer-app/department-transfer-received-master";
    static String dropPost ="/api/v1/department-transfer-app/location-bulk-department-receive-details";
                ///pick
    static String pickupMasterListings ="/api/v1/department-transfer-app/department-transfer-master-from";
    static String pickupDetails ="/api/v1/department-transfer-app/department-transfer-detail";
    static String savePickup ="/api/v1/department-transfer-app/pickup-department-transfer";
                ///receive
    static String receiveMaster ="/api/v1/department-transfer-app/department-transfer-master-to";
    static String receiveDetail ="/api/v1/department-transfer-app/department-transfer-summary/";
    static String getPackCodesFromRP ="/api/v1/department-transfer-app/department-transfer-repackages-list";
    static String saveDepartmentReceive ="/api/v1/department-transfer-app/receive-department-transfer";

    /*For Headers*/
    static const contentType = 'application/json; charset=UTF-8';
    static const xRequestedWith = 'XMLHttpRequest';
    static String bearerAuthToken = 'BearerAuthToken';

    /*Others*/
    static String pendingOrders = 'Pending Orders';
    static String purchaseOrdersDetail = 'Purchase Order Details';
    static String selectBranch = 'Select Branch';

    static var somethingWrongMsg = '';
    static String loading = 'Loading...';

    static String updateSerialNumber = 'Update Serial Numbers';

    static String pQty = 'purchaseQty';
    static String pItem = 'purchaseItem';
    static String pPackingType = 'purchasePackingType';
    static String pPackingTypeDetail = 'purchaseTypeDetail';
    static String pRefPurchaseOrderDetail = 'purchaseRefPurchaseOrderDetail';
    static String pTotalUnitBoxes = 'totalUnitBoxes';

    static String pSerialNo = "purchaseSerialNo";

    static String packSerialNo = "Serial No";

    static String saveButton = 'SAVE';
    static String rePackageAll = 'REPACK ALL';
    static String rePackageDelete = 'REMOVE';

    static String updateButton = 'UPDATE';
    static String packingType = 'Packing Type';

    static String noDataAvailable = 'No Data Available';

    static String serverErrorMsg = 'We ran into problem, Please Try Again';

  /*Drop Items*/
    static String dropOrders = 'Drop Received Orders';
    static String bulkdropOrders = 'Bulk Drop Received Orders';
    static String dropDepartmentTransfer = 'Drop Department Transfer';
    static String dropDepartmentTransferDetails = 'Drop Details';
    static String dropOrdersDetail = 'Drop Order Details';
    static String bulkdropOrdersDetail = 'Bulk Drop Order Details';
    static String dropOrderID = 'dropID';

    /*PickUp*/
    static String pickOrders = 'Pickup Orders';
    static String pickUpOrderID = 'pickUpOrderID';
    static String pickUpOrdersDetail = 'Pickup Details';
    static String pickUpSavedPackCodesID = 'pickUpSavedPackCodesID';
    static String pickUpsSavedItemID = 'pickUpsSavedItemID';
    static String pickUpsScannedIndex = 'pickUpsScannedIndex';

    /*Opening Stock*/
    static String openingStocks = 'Opening Stocks ';
    static String openingStockDetail = 'Opening Stock Details';
    static String openingStockOrderID = 'openStockID';

  // static String dropReceivedOrderUrl  = 'http://192.168.101.13:8000/api/v1/purchase-app/get-orders/received';

  }
