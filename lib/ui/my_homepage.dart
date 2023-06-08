import 'dart:convert';
import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:indigo_paints/ui/RePacketing/rePacketUi.dart';
import 'package:indigo_paints/ui/Repackagaing/chalanRePackaging/chalanRePackListUI.dart';
import 'package:indigo_paints/ui/ppb/Measure/qtyDrop.dart';
import 'package:indigo_paints/ui/ppb/Task%20Lot%20Output/taskLotOutputDrop.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/taskMaster.dart';
import 'package:indigo_paints/ui/ppb/lotPickupReturn/lotPickupReturnUi.dart';
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
import 'TransferRepackaging/rePackListUI.dart';
import 'department transfer/drop/master.dart';
import 'department transfer/pickup/pickupUi.dart';
import 'department transfer/receive/master.dart';
import 'drop/Bulk Drop/ui/bulkDropListPage.dart';
import 'drop/ui/drop_ order_list.dart';
import 'location Shift/locationShiftPage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  List? permissions=[];
  HomePage(this.permissions);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String ? name;
  int numNotific = 10;

  String userName='';

  getUserDetail() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();

  setState(() {
    userName=prefs.get("user_name").toString();
  });
  }

      connectSocket() async{
        log('im here');
       SharedPreferences preferences = await SharedPreferences.getInstance();
          // final wsUrl = Uri.parse('wss://api-demo.ybs.com.np/ws/notification?Token=${preferences.get("access_token")}');
          final wsUrl = Uri.parse('wss://api-demo.sooritechnology.com.np/ws/notification?Token=${preferences.get("access_token")}');
        final channel = IOWebSocketChannel.connect(wsUrl);

          channel.stream.listen((message) async{

            log("Response from socket:"+message);

            play(message);
            AssetsAudioPlayer.newPlayer().open(
              Audio('assets/images/notificationIMS.mp3'),
            );

          });
        if(channel.ready==true){
          await Future.delayed(Duration(seconds: 1));
          log("connected");
        }else{
          log("disconnected");
        }

      }
  final player = AudioPlayer();

      play(msg) async{
        log("im here");
        await AssetsAudioPlayer.newPlayer().open(
          Audio('assets/images/notificationIMS.mp3'),
        );
        await  Fluttertoast.showToast(msg: jsonDecode(msg)['msg'],
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.brown.shade800
        );
      }

  late AssetsAudioPlayer _assetsAudioPlayer;
  @override
  void initState() {
    super.initState();
    connectSocket();
    getUserDetail();
    // log(widget.permissions.toString());
    final data = Provider.of<NotificationClass>(context, listen: false);
    data.fetchCount(context);

  }

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<NotificationClass>(context);
    return  Scaffold(
      appBar:AppBar(
        leading: Icon(Icons.person,color: Colors.brown.shade800,),
        actions: [
          InkWell(
            onTap: () {   },
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notification_add,
                    color:Color(0xffBF1E2E),
                    size: 30,
                  ),
                  onPressed: ()async{
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {   },
            child: Stack(
              children: [


                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color:Color(0xffBF1E2E),
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
              userName.toUpperCase(),
              style: TextStyle(color: Colors.brown.shade800, fontSize: 15,fontWeight: FontWeight.bold),
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
              Text(
                "Welcome To",
                style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left:85.0),
                child: Row(
                  children: [
                    Text(
                      "${StringConst.name}",
                      style: TextStyle(fontSize: 22,color: Color(0xffBF1E2E),fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Warehouse",
                      style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              kHeightVeryBig,
              Padding(
                padding: const EdgeInsets.only(top:10.0,left: 20,right:20 ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    // height: 350,
                    // width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //   boxShadow:[
                    //     BoxShadow(
                    //       color: Color(0x155665df),
                    //       spreadRadius: 5,
                    //       blurRadius: 17,
                    //       offset: Offset(0, 3),
                    //     ),
                    //   ],
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.poIn,'assets/images/receive.png',widget.permissions!.contains('receive_purchase_order')?true:false,
                                goToPage: () => goToPage(context, PendingOrderInList())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.poDrop,'assets/images/drop.png',widget.permissions!.contains('drop_packet')?true:false,
                                goToPage: () => goToPage(context, BulkPODrop())),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.poOut,'assets/images/PickUp.png',widget.permissions!.contains('pickup_customer_order')||widget.permissions!.contains("pickup_verify_customer_order")?true:false,
                                goToPage: () => goToPage(context, PickOrder())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.poAudit,'assets/images/audit.png',widget.permissions!.contains('view_audit_report')?true:false,
                                goToPage: () => goToPage(context, AuditList())),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.locationShifting,'assets/images/locationshift.png',widget.permissions!.contains('view_audit_report')?true:false,
                                goToPage: () => goToPage(context, LocationShifting())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.info,'assets/images/packinfo.png', widget.permissions!.contains('view_packet_info')?true:false,
                                goToPage: () => (OpenDialogInfo(context))),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            _poButtonDesign(Icons.arrow_drop_down, StringConst.RePacketing,'assets/images/openstock.png',true,
                                goToPage: () => OpenDialogRePacketting(context)
                              // goToPage(context, RePacketUI())
                            ),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.department,'assets/images/openstock.png',true,
                              goToPage: () => OpenDialogDepartmentTransfer(context)),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.ppb,'assets/images/openstock.png',true,
                                goToPage: () => openLotDialog(context)
                              // goToPage(context, RePacketUI())
                            ),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.repackage,'assets/images/openstock.png',true,
                                goToPage: () => OpenDialogRePackaging(context)),
                          ],
                        ),
                        // kHeightVeryBig,

                        kHeightVeryBig,
                        _poButtonDesign(Icons.arrow_drop_up, StringConst.openingStock,'assets/images/openstock.png',true,
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
          backgroundColor: Colors.white,
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
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, "FG Drop",widget.permissions!.contains("drop_task_output")?true:false,
                                goToPage: () =>
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LotOutputMasterPage()))
                            ),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down,"Lot Pickup",widget.permissions!.contains("pickup_task_lot")?true:false,
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
                            _poButtonDesignDailog(Icons.arrow_drop_down,"Measure",true,
                                goToPage: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>QtyDropMaster()))),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down,"Pickup Return",true,
                                goToPage: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>LotPickupReturnMaster()))),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),
                        // kHeightVeryBig,
                        // _poButtonDesignDailog(Icons.arrow_drop_down,"Pickup Drop",
                        //     goToPage: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>PickupDrop()))),
                        kHeightVeryBig,


                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top:-35,


                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
                    radius: 40,

                  )),
            ],
          ),
        ),
      );

  _poButtonDesign(IconData buttonIcon, String buttonString,String image,bool visible,
      {required VoidCallback goToPage}) {
    return Visibility(
      visible: visible,
      child: Card(
        elevation: kCardElevation,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
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

            child: Column(
              children: [
                SizedBox(height: 10,),
                Image.asset(
                    image
                ),
                SizedBox(width: 10,),
                Text(
                  buttonString,
                  style: kTextStyleBlackForHomePage,
                ),
              ],
            ),
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
         backgroundColor: Colors.white,
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
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.saleRePackaging,true,
                                goToPage: () => goToPage(context, RePackListUi())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.chalanRePackaging,true,
                                goToPage: () => goToPage(context, ChalanRePackListUi())),
                            kHeightVeryBig,
                            kHeightVeryBig,

                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),
                        _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.transferReapckaging,true,
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
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
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
         backgroundColor: Colors.white,
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
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.dropDepartment,widget.permissions!.contains("drop_department_transfer")?true:false,
                                goToPage: () => goToPage(context, DropDepartmentTransferUI())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.pickDepartment,widget.permissions!.contains("pickup_department_transfer")?true:false,
                                goToPage: () => goToPage(context, DepartmentTransferPickOrder())),
                            kHeightVeryBig,

                            kHeightVeryBig,
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),
                        _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.receiveDepartment,widget.permissions!.contains("receive_department_transfer")?true:false,
                            goToPage: () => goToPage(context, DepartmentTransferReceive())),


                      ],
                    ),
                  ),

                ),
              ),
               Positioned(
                  top:-35,


                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
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
          backgroundColor: Colors.white,
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
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.dropRepacket,true,
                                goToPage: () => goToPage(context, DropRepacket())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.RePacketing,true,
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
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );

  _poButtonDesignDailog(IconData buttonIcon, String buttonString,bool visible,
      {required VoidCallback goToPage}) {
    return Visibility(
      visible: visible,
      child: Card(
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
      ),
    );
  }

  Future OpenDialogCustomer(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
         backgroundColor: Colors.white,
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
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, StringConst.bulkDrop,true,
                                goToPage: () => goToPage(context, BulkPODrop())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.singleDrop,true,
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
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
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
          // backgroundColor: Colors.indigo.shade50,
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
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.getPackInfo,true,
                                goToPage: () => goToPage(context, PackInfo())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.serialInfo,true,
                                goToPage: () => goToPage(context, SerialInfoPage())),
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
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
                    radius: 45,

                  )),

            ],
          ),
        ),

      );
}

