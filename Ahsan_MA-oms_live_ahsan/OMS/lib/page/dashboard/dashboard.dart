import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:BSProOMS/data/BarData.dart';
import 'package:BSProOMS/data/ProductOffers.dart';
import 'package:BSProOMS/page/dashboard/cubit/dashboard_event.dart';
import 'package:BSProOMS/page/ledger/cubit/ledger_event.dart';
import 'package:BSProOMS/page/ledger/ledger_page.dart';
import 'package:BSProOMS/page/sale-order/sale_order_list.dart';
import 'package:BSProOMS/page/sale-order/status_order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../auth/form_submission_status.dart';
import '../../data/Constants.dart';
import '../../widget/DrawermenuWidget.dart';
import '../../widget/MyShimmerEffectUI.dart';
import '../UnAuthorized.dart';
import '../ledger/cubit/ledger_bloc.dart';
import '../sale-order/add_sale_order_page.dart';
import 'cubit/dashboard_bloc.dart';
import 'cubit/dashboard_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardList extends StatefulWidget {
  final VoidCallback openDrawer;
  DashboardList({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<DashboardList> createState() => _DashboardListState();
}

class _DashboardListState extends State<DashboardList> {
  bool isShowClose = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetDashboardData());
  }

  Future<void> _pullRefresh() async {
    // FocusManager.instance.primaryFocus?.unfocus();
    context.read<DashboardBloc>().add(GetDashboardData());
    // isShowClose = false;
    // editingController.text = '';
    // context.read<DashboardBloc>().add(GetDashboardList());
    // await Future.delayed(Duration(milliseconds: 1000));
  }
  Future<bool> _onWillPop() async {

    // This dialog will exit your app on saying yes
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure? dashboard'),
        content: new Text('Do you want to exit an App'),
        actions: [
           TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
           TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
        return Sizer(builder: (context, orientation, deviceType) {
          return Scaffold(
            backgroundColor: Colors.white,
            // resizeToAvoidBottomInset: true,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: MyConstants.of(context)!.primaryColor,
                leading: DrawerMenuWidget(
                  onClicked: widget.openDrawer,
                ),
                title: Text('Dashboard'),
              actions: [
                /*IconButton(
                    icon: const Icon(Icons.notifications_active_outlined),
                    tooltip: "Notification",
                    onPressed: () {
                      // _pullRefresh();
                    }),*/
                IconButton(
                    icon: const Icon(Icons.sync),
                    tooltip: "Refresh Dashboard",
                    onPressed: () {
                      _pullRefresh();
                    }),
                    
              ]),
            body: state.formStatus is FormSubmitting
                ? Center(
                    child: CircularProgressIndicator(
                    color: MyConstants.of(context)!.primaryColor,
                  ))
                : RefreshIndicator(
              color: MyConstants.of(context)!.primaryColor,
                    onRefresh: _pullRefresh,
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                SizedBox(height: 40,child: Container(),),
                             state.productOffers.length > 0 ? CarouselSlider(
                              items: makeSlider(state.productOffers),
                              options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  height: 200,
                                  aspectRatio: 16/9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.horizontal,
                              ),
                              ) : Container(),
                                state.objBar.isNotEmpty ?
                                SizedBox(
                                    height: 30.0.h,
                                    width: 97.0.w,
                                    child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                          child: state.objBar.isEmpty
                                              ? Text('No Data Found')
                                              : Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10),
                                                  child: BarChart(BarChartData(
                                                    gridData:
                                                        FlGridData(show: false),
                                                    borderData:
                                                        FlBorderData(show: false),
                                                    barTouchData: BarTouchData(
                                                        touchTooltipData: BarTouchTooltipData(
                                                          fitInsideHorizontally: true,
                                                            fitInsideVertically: true,
                                                            // tooltipBgColor: Colors.blueGrey,

                                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                              BarData bar = state.objBar[group.x.toInt()];
                                                              return BarTooltipItem(
                                                               'Barcode: ' + bar.nBarcode + '\n' 'Item: ' + bar.nItem + '\n',
                                                                const TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 14,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: "Quantity: "+(rod.toY).toString(),
                                                                    style: const TextStyle(
                                                                      color: Colors.yellow,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            })),

                                                    // groupsSpace: 10,

                                                    titlesData: FlTitlesData(
                                                      show: true,
                                                      bottomTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: true,
                                                          getTitlesWidget:
                                                              getTitles,
                                                          reservedSize: 30,
                                                        ),
                                                      ),
                                                      leftTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: false,
                                                        ),
                                                      ),
                                                      topTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: false,
                                                        ),
                                                      ),
                                                      rightTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: false,
                                                        ),
                                                      ),
                                                    ),
                                                    barGroups: state.objBar
                                                        .map((e) => makeGroupData(
                                                            state.objBar
                                                                .indexOf(e),
                                                            e.nQuantity
                                                                .toDouble(),barColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)))
                                                        .toList(),
                                                  )),
                                                ),
                                        ))) : Container(),
                                state.objBar.isNotEmpty ? SizedBox(height: 15) : Container(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (_) => OrderStatus(formName: "Completed Orders", orderType: "0")));
                                      },
                                      child: SizedBox(
                                          height: 15.0.h,
                                          width: 32.0.w,
                                          child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              child: Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesomeIcons.shoppingBag,
                                                      color:
                                                          MyConstants.of(context)!
                                                              .primaryColor,
                                                      size: 40),
                                                  SizedBox(height: 5),
                                                  Text( state.nCompletedOrder.length > 0 ?
                                                      state.nCompletedOrder.split("|")[1]
                                                          .toString() : "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 3),
                                                  Text( state.nCompletedOrder.length > 0 ?
                                                    state.nCompletedOrder.split("|")[0].replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => (' ' + m.group(0)!))
                                                    : "",
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              )))),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (_) => OrderStatus(formName: "Pending Orders", orderType: "1")));
                                      },
                                      child: SizedBox(
                                          height: 15.0.h,
                                          width: 32.0.w,
                                          child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              child: Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      FontAwesomeIcons
                                                          .shoppingBasket,
                                                      color:
                                                          MyConstants.of(context)!
                                                              .primaryColor,
                                                      size: 40),
                                                  SizedBox(height: 5),
                                                  Text( state.nPendingOrder.length > 0 ?
                                                      state.nPendingOrder.split("|")[1]
                                                          .toString() : "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 3),
                                                  Text(state.nPendingOrder.length > 0 ?
                                                    state.nPendingOrder.split("|")[0].replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => (' ' + m.group(0)!))
                                                    : "",
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              )))),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => LedgerPage(openDrawer: () => widget.openDrawer)));
                                      },
                                      child: SizedBox(
                                          height: 15.0.h,
                                          width: 32.0.w,
                                          child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              child: Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesomeIcons.landmark,
                                                      color:
                                                          MyConstants.of(context)!
                                                              .primaryColor,
                                                      size: 40),
                                                  SizedBox(height: 5),
                                                  Text( state.nAccountBalance.length > 0 ?
                                                      state.nAccountBalance.split("|")[1]
                                                          .toString() : ""
                                                      ,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 3),
                                                  Text( state.nAccountBalance.length > 0 ?
                                                    state.nAccountBalance.split("|")[0].replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => (' ' + m.group(0)!))
                                                    : "",
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              )))),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: _launchWhatsapp,
                                //       child: SizedBox(
                                //           height: 15.0.h,
                                //           width: 30.0.w,
                                //           child: Card(
                                //               color: Colors.green.shade600,
                                //               elevation: 6,
                                //               shape: RoundedRectangleBorder(
                                //                   borderRadius:
                                //                       BorderRadius.circular(20)),
                                //               child: Center(
                                //                   child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   Icon(FontAwesomeIcons.whatsapp,
                                //                       color: Colors.white,
                                //                       size: 45),
                                //                   SizedBox(height: 5),
                                //                   Text('WhatsApp',
                                //                       style: TextStyle(
                                //                           fontWeight:
                                //                               FontWeight.bold,
                                //                           fontSize: 16,
                                //                           color: Colors.white)),
                                //                 ],
                                //               )))),
                                //     ),
                                //     GestureDetector(
                                //       onTap: () =>
                                //           {_makePhoneCall(state.nContactNo)},
                                //       child: SizedBox(
                                //           height: 15.0.h,
                                //           width: 30.0.w,
                                //           child: Card(
                                //               color: MyConstants.of(context)!
                                //                   .secondaryColor,
                                //               elevation: 6,
                                //               shape: RoundedRectangleBorder(
                                //                   borderRadius:
                                //                       BorderRadius.circular(20)),
                                //               child: Center(
                                //                   child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   Icon(FontAwesomeIcons.phoneAlt,
                                //                       color: Colors.white,
                                //                       size: 45),
                                //                   SizedBox(height: 5),
                                //                   Text('Call',
                                //                       style: TextStyle(
                                //                           fontWeight:
                                //                               FontWeight.bold,
                                //                           fontSize: 16,
                                //                           color: Colors.white)),
                                //                 ],
                                //               )))),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (_) =>
                                         state.objUser!.nCustomerCode.length < 1 ?
                                         UnAuthorizedScreen(openDrawer: widget.openDrawer) :
                                         AddSaleOrder(isEdit: false,)
                                        ));
                                      },
                                      child: SizedBox(
                                          height: 10.0.h,
                                          width: 20.0.w,
                                          child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Icon(FontAwesomeIcons.cartPlus,
                                                          color:
                                                          MyConstants.of(context)!
                                                              .primaryColor,
                                                          size: 30),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        'New Order',
                                                        style: TextStyle(fontSize: 10),
                                                      ),
                                                    ],
                                                  )))),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        height: 10.0.h,
                                        width: 20.0.w,
                                        child: Card(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Stack(
                                                // alignment: Alignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.calendar_today_rounded,
                                                    color:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                    size: 50.0,
                                                  ),
                                                  Positioned(
                                                    bottom: 13,
                                                    left: 12,
                                                    child: Text(
                                                      state.nOrderDeliveryWeekDay
                                                                  .length >
                                                              3
                                                          ? state
                                                              .nOrderDeliveryWeekDay
                                                              .substring(0, 3)
                                                              .toUpperCase().trim()
                                                          : state
                                                              .nOrderDeliveryWeekDay,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyConstants.of(
                                                                  context)!
                                                              .secondaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        height: 10.0.h,
                                        width: 20.0.w,
                                        child: Card(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.solidClock,
                                                    color:
                                                        MyConstants.of(context)!
                                                            .primaryColor,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    state.nAfterNextOrderDeliver
                                                            .toString() +
                                                        ' Days Left',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ))),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (int index){
                if(index == 0){
                  _makePhoneCall(state.nContactNo);
                }
                else if(index == 1){
                  _launchWhatsapp();
                }
                setState(() { _selectedIndex = index; });
              },
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.shifting,
              backgroundColor: MyConstants.of(context)!.primaryColor,
              selectedFontSize: 20,
              unselectedItemColor: Colors.black54,
              selectedIconTheme: IconThemeData(color: MyConstants.of(context)!.primaryColor),
              selectedItemColor: MyConstants.of(context)!.primaryColor,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.phoneAlt, size: 30,),
                  label: ""
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.whatsapp,color: Colors.green,size: 30,),
                    label: ""
                ),
              ],
            ),
          );
        });
      }),
    );
  }
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    barColor,
    double width = 22,
    // List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: width,
        ),
      ],
      // showingTooltipIndicators: showTooltips,
    );
  }
   List<Widget> makeSlider(List<ProductOffers> offers) {
    return offers.map((e) => Container(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[

                // Image.network(e.nAttribute1Image, fit: BoxFit.fitHeight,width: 100.0.w),
            Image.memory(base64Decode(e.nAttribute1Image),
              errorBuilder:(BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Text('No Image found');
              },
              fit: BoxFit.fitHeight,width: 100.0.w,),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '\n' + DateFormat.yMMMEd().format(e.nStartDate) + " - " + DateFormat.yMMMEd().format(e.nEndDate) + '\n',
                              style: TextStyle( fontSize: 12)),
                          TextSpan(
                              text: "Barcode: " +e.nBarCode+ '\n',
                              style:
                              TextStyle(fontSize: 14)),
                          TextSpan(
                              text: e.nOfferDescription,
                              style: TextStyle(fontSize: 14)),
                        ], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    // child: Text(
                    //   'DESC ${e.nOfferDescription}',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 14.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ),
                ),
              ],
            )),
      ),
    )).toList();
  }
  String url(phone, message) {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    }
  }
  _launchWhatsapp() async {
    var whatsapp = context.read<DashboardBloc>().state.nWhatsappNo;
    var whatsappAndroid = Uri.parse("whatsapp://send?phone=$whatsapp&text=How may I help you?");
    // var whatsappAndroid = Uri.parse(url(whatsapp, "Hi"));

    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget shimmerEffectUIWidget() => ListTile(
        leading: MyShimmerEffectUI.circular(height: 64, width: 64),
        title: Align(
          alignment: Alignment.centerLeft,
          child: MyShimmerEffectUI.rectangular(
              height: 16, width: MediaQuery.of(context).size.width * 0.35),
        ),
        subtitle: MyShimmerEffectUI.rectangular(height: 14),
      );
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle( color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 5,
          child: Text(state.objBar[value.toInt()].nQuantity.toString(), style: style),
        );
      },
    );
  }
}
