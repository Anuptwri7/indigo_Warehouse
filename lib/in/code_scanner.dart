import 'dart:convert';
import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indigo_paints/consts/buttons_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/data/model/get_pending_orders.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../data/network/network_helper.dart';
import 'modelPackType.dart';




class CodeScanner extends StatefulWidget {
  List<PurchaseOrderDetail> _purchaseOrderDetails = [];
  int index;
  int purchaseId;
  final VoidCallback onPressed;

  CodeScanner(this.purchaseId,this._purchaseOrderDetails, this.index, this.onPressed);

  @override
  _CodeScannerState createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  String _serialNo = "waiting...";
  String _source = "waiting...";
  final _scannerFormKey = GlobalKey<FormState>();
  TextEditingController? qtyController;
  http.Response? response;
  int totalUnitBoxes = 0;
  int totalUnitsInBoxes = 0;
  int count = 0, packageCount = 0;
  int totalQuantity = 0;
  String packQtyDrop = '';

  String _packingUnitType = '';
  String orderQty = '';
  var packingType = StringConst.packingType;

  List<String> packingTypeValue = [];
  List<String> packingTypeValueString = [];
  List<String> packingTypeValueUnits = [];
  List<String> dataArray = [];

  List<List<String>> serialNoList = [];
  String packingTypeId ='';

  String packingBranchId='';
  String packingBranchDetail='';

  /*Sharedprefs List*/
  List<String> _qty = [];
  List<String> _totalUnitBoxes = [];
  List<String> _serialNos = [];
  List<String> _packingType = [];
  List<String> _packingTypeDetail = [];
  String dropdownvalueUser = 'Select Packing Type';

  List items =[];


  Future savePurchaseOrders() async {
    // pd.show(max: 100, msg: 'Updating Serial No...');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String finalUrl = prefs.getString(StringConst.subDomain).toString();

      // Getting Data from  Shared Prefs
      List<String> purchaseQty = prefs.getStringList(StringConst.pQty)!;

      List<String> purchaseBoxes =
      prefs.getStringList(StringConst.pTotalUnitBoxes)!;

      List<String> pPackingType =
      prefs.getStringList(StringConst.pPackingType)!;
      List<String> pPackingTypeDetail =
      prefs.getStringList(StringConst.pPackingTypeDetail)!;
      List<String> purchaseSerialNo =
          prefs.getStringList(StringConst.pSerialNo) ?? [];

      clearPrefs(prefs);
      /*Clear Preference*/


      /*Load Serial Numbers*/
      if (purchaseBoxes != null) {
        List _currentSerialNo = [];
        List _allPackTypeCodes = [];
        List _pd = [];


        for (var item in  purchaseSerialNo) {
          /*Converting String into List*/
          var itemSplit = json.decode(item);

          int itemNoCount = 0;

          /*Submitting the POrder with Codes*/
          if(itemSplit.length>0)
          {
            log("executing this");
            for (List newItem in itemSplit) {
              for (var finalItem in newItem) {
                _currentSerialNo.add({'code': finalItem.toString()},);
              }
              _allPackTypeCodes.add({
                'pack_no': itemNoCount,
                'pack_type_detail_codes': _currentSerialNo.toList()
              });
              itemNoCount++;
              _currentSerialNo.clear();
            }
          }
          /*Submitting without scanned Codes*/
          else {
            for (int i = 0; i < 1; i++) {
              log(int.parse(purchaseBoxes[i]).toString());
              for (int j = 0; j < int.parse(purchaseBoxes[i]); j++) {
                // codes.add(int.parse(purchaseBoxes[i]));
                _allPackTypeCodes
                    .add({'pack_no': j, 'pack_type_detail_codes': []});
              }

            }
          }

        }

        for (int i = 0; i < 1; i++) {
          _pd.add({
            'ref_purchase_order_detail': widget._purchaseOrderDetails[i].id,
            'item': widget._purchaseOrderDetails[i].item,
            'qty': double.parse(purchaseQty[i]).toInt(),
            'packing_type': double.parse(pPackingType[i]).toInt(),
            'packing_type_detail': double.parse(pPackingTypeDetail[i])
                .toInt(),
            'po_pack_type_codes': _allPackTypeCodes
          });
        }

        response = await NetworkHelper(
            'https://$finalUrl${StringConst.receivePurchaseOrder}')
            .userPurchaseOrder(refPurchaseOrder: widget.purchaseId, purchaseDetails: _pd);

        // pd.close();
        log('Sending data+${_pd}');

        var jsonData = jsonDecode(response!.body.toString());
        if (response!.statusCode >= 200 && response!.statusCode < 300) {
          /**/
          displayToast(msg: 'Data is successfully Added');
        } else {
          displayToast(msg: 'Error : ${jsonData['message']}');
        }
      } else {
        // pd.close();
        displayToast(msg: 'No Item Saved, Please Save and Try Again');
      }
    } catch (e) {
      print("Current Error: ${e.toString()}");
      displayToast(msg: StringConst.serverErrorMsg);
      // pd.close();
    }
  }
  clearPrefs(prefs) async {
    prefs.remove(StringConst.pQty);
    prefs.remove(StringConst.pPackingType);
    prefs.remove(StringConst.pPackingTypeDetail);
    prefs.remove(StringConst.pSerialNo);
    prefs.remove(StringConst.pTotalUnitBoxes);
    print('Prefs Cleared: ');
  }
  Future fetchPackType() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    // log(sharedPreferences.getString("access_token"));
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.packTypeDropDown+widget.purchaseId.toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        }
    );
    log("=============="+response.body);
    log("=============="+'https://$finalUrl${StringConst.packTypeDropDown+widget.purchaseId.toString()}');

    List<PackingTypeDetailsItemwise> respond = [];

    final responseData = json.decode(response.body);
    for(int i=0;i<json.decode(response.body)['purchase_order_details'][0]['packing_type_details_itemwise'].length;i++){
      packingTypeValue.add(json.decode(response.body)['purchase_order_details'][0]['packing_type_details_itemwise'][i]['packing_type_name']);
    }
    log(items.toString());
    responseData['purchase_order_details'][0]['packing_type_details_itemwise'].forEach(
          (element) {
        respond.add(
          PackingTypeDetailsItemwise.fromJson(element),
        );
      },
    );



    if (response.statusCode == 200||response.statusCode==201) {
      log("Respond:"+respond.toString());
      return respond;
    }
  }
  @override
  void dispose() {
    qtyController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initDataWedgeListener();

    loadControllers(widget._purchaseOrderDetails[widget.index]);
    loadPackingTypeDetails(widget._purchaseOrderDetails[widget.index]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.updateSerialNumber,  style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () async {
              print('Total Quantity : $totalQuantity');
              if (packingType == StringConst.packingType) {
                displayToast(msg: 'Please Select a Packing Type');
              } else if (totalQuantity == 0 || totalQuantity < 0) {
                displayToast(msg: 'Please Specify Your Total Quantity');
              } else {
                log("im here");
                saveUserData(widget._purchaseOrderDetails[widget.index]);
                savePurchaseOrders();
                // widget.onPressed();


                log("im dome");
              }
            },
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(
                  StringConst.saveButton,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: kMarginPaddSmall,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Name',
                  style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8,),
                Flexible(
                  child: Text(
                    widget._purchaseOrderDetails[widget.index].itemName,
                    overflow: TextOverflow.clip,
                    style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            kHeightBig,
            _serialNoForm(),
            kHeightMedium,
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Colors.brown.shade800,
              child: Padding(
                padding: kMarginPaddSmall,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Serial No',
                            style: kTextStyleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Count',
                                style: kTextStyleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Pack.',
                                style: kTextStyleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kHeightSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            _serialNo,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color:Colors.white),
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$count / ${totalUnitsInBoxes}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color:Colors.white),
                              ),
                              Text(
                                '$packageCount / ${totalUnitBoxes}',
                                style: TextStyle(color:Colors.white),
                                overflow: TextOverflow.ellipsis,

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kHeightSmall,
                  ],
                ),
              ),
            ),
            kHeightMedium,
            _displayBox()
          ],
        ),
      ),
    );
  }

  void loadControllers(PurchaseOrderDetail purchaseOrderDetail) {
    qtyController = TextEditingController();

    orderQty = purchaseOrderDetail.qty.toString();
    log("hello baby order qty"+orderQty.toString());
    qtyController!.text = orderQty;
    totalQuantity = double.parse(orderQty).toInt();
    log("hello baby order qty total"+totalQuantity.toString());
  }

  _dropdownItems(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: kTextStyleBlack.copyWith(fontSize: 16.0),
      ),
    );
  }

  _serialNoForm() {
    return Form(
      key: _scannerFormKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(4.0),
            padding: EdgeInsets.all(4.0),
            decoration: kFormBoxDecoration,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: fetchPackType(),
              builder: (BuildContext context,
                  AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text("Loading");
                }
                if (snapshot.hasData) {

                  try {

                    final List<PackingTypeDetailsItemwise> snapshotData =
                        snapshot.data;
                    return DropdownButton<PackingTypeDetailsItemwise>(
                      elevation: 24,
                      isExpanded: true,
                      hint: Text(
                          "${dropdownvalueUser.isEmpty ? "Select Packing Type" : dropdownvalueUser}"),
                      // value: snapshotData.first,
                      iconSize: 24.0,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.grey,
                      ),

                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      items: snapshotData
                          .map<DropdownMenuItem<PackingTypeDetailsItemwise>>(
                              (PackingTypeDetailsItemwise items) {
                            return DropdownMenuItem<PackingTypeDetailsItemwise>(
                              value: items,
                              child: Text(items.packingTypeName.toString()),
                            );
                          }).toList(),
                      onChanged: (PackingTypeDetailsItemwise? newValue) {
                        setState(
                              () {
                            dropdownvalueUser =
                                newValue!.packingTypeName.toString();
                            packingBranchId = newValue!.packingType.toString();
                            packingBranchDetail = newValue!.id.toString();
                            packQtyDrop = newValue.packQty.toString();
                            log("pack qty to frop"+packQtyDrop.toString());
                            _calculatePackQuantity(newValue.packingTypeName!);

                          },
                        );
                      },
                    );
                  } catch (e) {
                    throw Exception(e);
                  }
                } else {
                  return Text(snapshot.error.toString());
                }
              },
            ),
          ),
          // Container(
          //   padding: kMarginPaddSmall,
          //   decoration: kSerialFormDecoration,
          //   child: DropdownButton<String>(
          //     hint: Text(packingType, style: kHintTextStyle),
          //     value: packingType,
          //     elevation: 24,
          //     isExpanded: true,
          //     style: kTextStyleBlack,
          //     underline: hideDropDownLine(),
          //     onChanged: (newValue) {
          //       setState(() {
          //         packingTypeId = newValue!;
          //         log("packing type"+packingTypeId.toString());
          //         _calculatePackQuantity(newValue!);
          //       });
          //     },
          //     items: packingTypeValue
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return _dropdownItems(value);
          //     }).toList(),
          //     iconSize: 24.0,
          //     icon: dropdownIcon(),
          //   ),
          // ),
          kHeightMedium,
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            child: Padding(
              padding: kMarginPaddMedium,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text(
                        ' Pack Qty : $totalUnitsInBoxes',
                        style: kTextBlackSmall,
                      )),
                  Container(
                      child: Text(
                        'Order Qty : ${orderQty}',
                        style: kTextBlackSmall,
                      )),
                ],
              ),
            ),
          ),
          kHeightMedium,
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      TextSelection previousSelection = qtyController!.selection;
                      qtyController!.text = value;
                      qtyController!.selection = previousSelection;
                    },
                    decoration: kopenScannerDecoration.copyWith(
                        labelText: 'Received Qty', hintText: '100'),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 2,
                  child: RoundedButtonTwo(
                    buttonText: 'Update',
                    onTap: () =>
                        updateReceivedQty(qtyController!.text.toString()),
                    color: Colors.brown.shade800,
                  ),
                )
              ],
            ),
          ),
          kHeightMedium,
        ],
      ),
    );
  }

  /*Display Serial Numbers*/

  _displayBox() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalUnitBoxes,
        itemBuilder: (context, boxIndex) {
          return _displayBoxItems(boxIndex);
        });
  }

  _displayBoxItems(boxIndex) {
    return ExpandablePanel(
      header: Container(
        margin: kMarginPaddSmall,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_packingUnitType ${boxIndex + 1}',
              style: kTextStyleBlack,
            ),
          ],
        ),
      ),
      expanded: Card(
        elevation: kCardElevation,
        child: Container(
          padding: kMarginPaddSmall,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalUnitsInBoxes,
              itemBuilder: (context, boxItemIndex) {
                return Padding(
                  padding: kMarginPaddSmall,
                  child: _displaySerialNo(boxItemIndex, boxIndex),
                );
              }),
        ),
      ),
      collapsed: const Divider(),
    );
  }

  _displaySerialNo(boxItemIndex, boxIndex) {
    if (serialNoList.isNotEmpty && serialNoList.length == packageCount) {
      return Text(serialNoList[boxIndex].isNotEmpty
          ? serialNoList[boxIndex][boxItemIndex].isNotEmpty
          ? serialNoList[boxIndex][boxItemIndex]
          : ''
          : '');
    } else {
      return Text('');
    }
  }

  // create a listener for data wedge package
  Future<void> _initDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic> jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {

            if (packageCount != totalUnitBoxes) {


              setState(() {
                _serialNo = jsonResponse["decodedData"].toString().trim();
                dataArray.add(_serialNo);
                var dataNew = dataArray.toList().toSet();
                dataArray.clear();
                dataArray.addAll(dataNew);
                count = dataArray.length;
              });

              if (dataArray.length == totalUnitsInBoxes) {
                setState(() {
                  serialNoList.add(dataArray.toList());
                  packageCount++;
                  dataArray.clear();
                  count = 0;
                  if (packageCount == totalUnitBoxes) {
                    _serialNo = 'Task Completed';
                  } else {
                    _serialNo = 'Package $packageCount Added';
                  }
                });
              }
            } else {
              setState(() {
                _serialNo = 'Task Completed';
              });

              // displayToast(msg: 'Task Completed, Please Save your Task');
            }
          } else {
            setState(() {
              _source = "An error Occured";
            });
          }
        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }
      }
    });
  }

  void loadPackingTypeDetails(PurchaseOrderDetail purchaseOrderDetail) {
    int packingOptions = purchaseOrderDetail.packingTypeDetailsItemwise.length;
    log("length of itemwise"+packingOptions.toString());
    var _packingTypeDetails = purchaseOrderDetail.packingTypeDetailsItemwise;
    packingTypeValue.clear();
    packingTypeValueUnits.clear();
    // packingTypeValue.add(StringConst.packingType);
    packingTypeValueUnits.add('0');
    for (int i = 0; i < packingOptions; i++) {
      log("959+5"+packingTypeValue.toString());
      // packingTypeValue.add(_packingTypeDetails.toString());
      // packingTypeValue.add(items[i].toString());
      // packingTypeValueString.add(_packingTypeDetails[i].packingTypeName);
      // _packingTypeDetails[i].packingTypeName+
      log("packing types added"+packingTypeValue.toString());
      packingTypeValueUnits.add(packQtyDrop);
      log("qty"+packingTypeValueUnits.toString());
    }
  }

  void _calculatePackQuantity(String newValue) {
    // log("value pack"+packingTypeValue[1]);
    packingType = newValue;
    if (packingType == StringConst.packingType) {
      totalUnitsInBoxes = 0;
      totalUnitBoxes = 0;
      displayToast(msg: 'Please Select a Packing Type');

    } else {

      for (int i = 0; i < packingTypeValueUnits.length; i++) {

        if (packingTypeValue[i].toString() == packingType.toString()) {
          log("packingTypeValueUnits[i]"+packingTypeValueUnits[i]);
          totalUnitsInBoxes = double.parse(packQtyDrop).toInt();


          setState(() {
            _packingUnitType = packingTypeValue[i].toString();
            log(_packingUnitType.toString());
          });
          double _boxes = totalQuantity / totalUnitsInBoxes;
          log(totalQuantity.toString()+totalUnitsInBoxes.toString());
          log("hello baby"+totalQuantity.toString());
          log("hello baby 2--"+totalUnitsInBoxes.toString());
          log("hello baby 3--"+_boxes.toString());
          totalUnitBoxes = (_boxes).toInt();
        }
      }
    }
  }

  void saveUserData(PurchaseOrderDetail purchaseOrderDetail) async {
    String packingType = packingBranchId.toString();
    String packingTypeDetail =
    packingBranchDetail.toString();
    String serialNos = json.encode(serialNoList);
    String totalBoxes = totalUnitBoxes.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _qty = prefs.getStringList(StringConst.pQty) ?? [];
    _totalUnitBoxes = prefs.getStringList(StringConst.pTotalUnitBoxes) ?? [];
    _packingType = prefs.getStringList(StringConst.pPackingType) ?? [];

    _serialNos = prefs.getStringList(StringConst.pSerialNo) ?? [];

    log("Saving Serial No : ${_serialNos.toString()}");
    log("Saving boxes : ${_totalUnitBoxes.toString()}");

    _packingTypeDetail =
        prefs.getStringList(StringConst.pPackingTypeDetail) ?? [];

    /*Adding New Data in List*/
    _qty.add(totalQuantity.toString());
    _totalUnitBoxes.add(totalBoxes);
    _packingType.add(packingType);
    _packingTypeDetail.add(packingTypeDetail);
    _serialNos.add(serialNos);

    // Saving to Shared Prefs
    prefs.setStringList(StringConst.pQty, _qty);
    prefs.setStringList(StringConst.pPackingType, _packingType);
    prefs.setStringList(StringConst.pPackingTypeDetail, _packingTypeDetail);
    prefs.setStringList(StringConst.pSerialNo, _serialNos);
    prefs.setStringList(StringConst.pTotalUnitBoxes, _totalUnitBoxes);

    displayToast(msg: 'Your Data is Saved');
    Navigator.pop(context);
  }

  displaySave() {
    displayToast(msg: 'Save Your Serial No');
  }

  void updateReceivedQty(String quantityUpdated) {
    log("box"+totalUnitsInBoxes.toString());

    if (totalUnitsInBoxes.toInt() != 0) {
      try {
        int _quantityUpdated = double.parse(quantityUpdated).toInt();
        log("box qty"+_quantityUpdated.toString());
        if (_quantityUpdated % totalUnitsInBoxes != 0) {
          displayToast(
              msg: 'Please Enter in the multiple of $totalUnitsInBoxes');
        } else {
          setState(() {
            totalQuantity = _quantityUpdated;
            totalUnitsInBoxes = totalUnitsInBoxes;
            totalUnitBoxes = totalQuantity ~/ totalUnitsInBoxes;
            // _packingUnitType = dropdownvalueUser;
          });
          displayToast(msg: 'Quantity Updated');
        }
      } catch (e) {
        print(e.toString());
        displayToast(msg: 'Something went wrong, Please Check your Input');
      }
    }
    else {
      displayToast(msg: 'Please Select a valid Packing Type');
    }
  }
}
