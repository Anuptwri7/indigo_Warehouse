import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:indigo_paints/ui/RePacketing/rePacketUi.dart';
import 'package:indigo_paints/ui/Repackagaing/chalanRePackaging/chalanRePackListUI.dart';
import 'package:indigo_paints/ui/ppb/Measure/qtyDrop.dart';
import 'package:indigo_paints/ui/ppb/Task%20Lot%20Output/taskLotOutputDrop.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/taskMaster.dart';
import 'package:indigo_paints/ui/ppb/lotPickupReturn/lotPickupReturnUi.dart';
import 'package:indigo_paints/ui/ppb/pickupDrop/pickupDrop.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indigo_paints/SerialInfo/serialInfoPage.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/consts/style_const.dart';
import 'package:indigo_paints/in/po_in_list.dart';
import 'package:indigo_paints/ui/Pack%20Info/packInfoPage.dart';
import 'package:indigo_paints/ui/audit/ui/audit_list.dart';
import 'package:indigo_paints/ui/opening/ui/opening_list.dart';
import 'package:indigo_paints/ui/pick/ui/pick_order_list.dart';
import '../main.dart';
import 'Notification/controller/notificationController.dart';
import 'RePacketing/dropRepacket.dart';
import 'Repackagaing/saleRepackaging/rePackListUI.dart';
import 'Repackagaing/saleRepackaging/repackagingList.dart';
import 'TransferRepackaging/rePackListUI.dart';
import 'department transfer/drop/master.dart';
import 'department transfer/pickup/pickupUi.dart';
import 'department transfer/receive/master.dart';
import 'drop/Bulk Drop/ui/bulkDropListPage.dart';
import 'drop/ui/drop_ order_list.dart';

import 'location Shift/locationShiftPage.dart';
import 'package:http/http.dart' as http;
import 'login/login_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String ? name;
  int numNotific = 10;

  @override
  void initState() {
    super.initState();
    final data = Provider.of<NotificationClass>(context, listen: false);
    data.fetchCount(context);

  }

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<NotificationClass>(context);
    return  Scaffold(
      appBar:AppBar(
        actions: [
          // const Icon(
          //   Icons.search,
          //   color: Color(0xff2c51a4),
          // ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const NotificationPage()));
                },
              ),
              if (count.notificationCountModel?.unreadCount != null)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      "${(count.notificationCountModel?.unreadCount)}",
                      //! > (numNotific) ?"9+":count.notificationCountModel?.unreadCount
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),

          // const SizedBox(
          //   width: 10,
          // ),
          InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const NotificationPage()));
            },
            child: Stack(
              children: [


                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: ()async{
                    final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                    sharedPreferences.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
                  },
                ),

              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],

        title: Row(
          children:  [

            Text(
              "Indigo Warehouse",
              style: TextStyle(color: Colors.blueGrey, fontSize: 15,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top:10.0,left: 20,right:20 ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    // height: 350,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow:[
                        BoxShadow(
                          color: Color(0x155665df),
                          spreadRadius: 5,
                          blurRadius: 17,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.poIn,
                                goToPage: () => goToPage(context, PendingOrderInList())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.poDrop,
                                goToPage: () => (OpenDialogCustomer(context))),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.poOut,
                                goToPage: () => goToPage(context, PickOrder())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.poAudit,
                                goToPage: () => goToPage(context, AuditList())),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.locationShifting,
                                goToPage: () => goToPage(context, LocationShifting())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.info,
                                goToPage: () => (OpenDialogInfo(context))),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.RePacketing,
                                goToPage: () => OpenDialogRePacketting(context)
                              // goToPage(context, RePacketUI())
                            ),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.department,
                              goToPage: () => OpenDialogDepartmentTransfer(context)),
                          ],
                        ),
                        kHeightVeryBig,
                        _poButtonDesign(Icons.arrow_drop_up, StringConst.ppb,
                            goToPage: () => openLotDialog(context)),


                        kHeightVeryBig,
                        _poButtonDesign(Icons.arrow_drop_up, StringConst.repackage,
                            goToPage: () => OpenDialogRePackaging(context)),

                        // kHeightVeryBig,

                        kHeightVeryBig,
                        _poButtonDesign(Icons.arrow_drop_up, StringConst.openingStock,
                            goToPage: () => goToPage(context, OpeningStockList())),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }

  Future openLotDialog(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, "FG Drop",
                                goToPage: () =>
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LotOutputMasterPage()))
                            ),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down,"Lot Pickup",
                                goToPage: () =>
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskMasterPage()))
                            ),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),

                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_drop_down,"Measure",
                                goToPage: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>QtyDropMaster()))),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down,"Pickup Return",
                                goToPage: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>LotPickupReturnMaster()))),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),
                        // kHeightVeryBig,
                        // _poButtonDesignDailog(Icons.arrow_drop_down,"Pickup Drop",
                        //     goToPage: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>PickupDrop()))),
                        kHeightVeryBig,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView(
                              // controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: [

                              ],
                            ),


                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top:-35,
                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,
                  )),
            ],
          ),
        ),
      );

  _poButtonDesign(IconData buttonIcon, String buttonString,
      {required VoidCallback goToPage}) {
    return Card(
      elevation: kCardElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        focusColor: Colors.white,
        onTap: goToPage,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 60,
          width: 150,
          // color: Colors.blueGrey[700],
          // color: Colors.white10,
          decoration: BoxDecoration(
            color: const Color(0xffeff3ff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffeff3ff),
                offset: Offset(-2, -2),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                buttonIcon,
                size: 32,
                color: Colors.black,
              ),
              Text(
                buttonString,
                style: kTextStyleBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future OpenDialogRePackaging(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.saleRePackaging,
                                goToPage: () => goToPage(context, RePackListUi())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.chalanRePackaging,
                                goToPage: () => goToPage(context, ChalanRePackListUi())),
                            kHeightVeryBig,
                            kHeightVeryBig,

                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),
                        _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.transferReapckaging,
                            goToPage: () => goToPage(context, TransferRePackListUi())),
                        kHeightVeryBig,

                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
  Future OpenDialogDepartmentTransfer(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.dropDepartment,
                                goToPage: () => goToPage(context, DropDepartmentTransferUI())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.pickDepartment,
                                goToPage: () => goToPage(context, DepartmentTransferPickOrder())),
                            kHeightVeryBig,

                            kHeightVeryBig,
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),
                        _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.receiveDepartment,
                            goToPage: () => goToPage(context, DepartmentTransferReceive())),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
  Future OpenDialogRePacketting(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.dropRepacket,
                                goToPage: () => goToPage(context, DropRepacket())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.RePacketing,
                                goToPage: () => goToPage(context, RePacketUI())),
                            kHeightVeryBig,
                            kHeightVeryBig,

                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );

  _poButtonDesignDailog(IconData buttonIcon, String buttonString,
      {required VoidCallback goToPage}) {
    return Card(
      elevation: kCardElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        focusColor: Colors.white,
        onTap: goToPage,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 60,
          width: 120,
          // color: Colors.blueGrey[700],
          // color: Colors.white10,
          decoration: BoxDecoration(
            color: const Color(0xffeff3ff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffeff3ff),
                offset: Offset(-2, -2),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Icon(
                buttonIcon,
                size: 20,
                color: Colors.black,
              ),
              // SizedBox(height: 5,),
              Text(
                buttonString,
                style: kTextStyleBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future OpenDialogCustomer(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, StringConst.bulkDrop,
                                goToPage: () => goToPage(context, BulkPODrop())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.singleDrop,
                                goToPage: () => goToPage(context, PODrop())),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView(
                              // controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: [

                              ],
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
  Future OpenDialogInfo(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, StringConst.getPackInfo,
                                goToPage: () => goToPage(context, PackInfo())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.serialInfo,
                                goToPage: () => goToPage(context, SerialInfoPage())),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView(
                              // controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: [

                              ],
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
}

