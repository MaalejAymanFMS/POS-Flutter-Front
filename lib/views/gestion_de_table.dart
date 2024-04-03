library gestion_de_table;

import 'package:flutter/material.dart';
import 'package:klitchyapp/config/app_colors.dart';
import 'package:klitchyapp/utils/responsive.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/viewmodels/room_vm.dart';
import 'package:klitchyapp/viewmodels/start_page_vm.dart';
import 'package:klitchyapp/widget/available_waiters.dart';
import 'package:klitchyapp/widget/current_waiter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/AppState.dart';
import '../utils/locator.dart';
import '../viewmodels/room_interactor.dart';
import '../widget/drawer/room.dart';
import '../widget/drawer/rooms.dart';
import 'StartPageUI.dart';

part '../widget/drawer/top_menu_drawer.dart';

part 'left_drawer.dart';

class GestionDeTable extends StatefulWidget {
  const GestionDeTable({super.key});

  @override
  State<GestionDeTable> createState() => _GestionDeTableState();
}

bool? isDrawerOpen;

class _GestionDeTableState extends State<GestionDeTable> {
  String nameWaiter = "";
  fetchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameWaiter = prefs.getString("full_name")!;
    });
  }

  void _handleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen!;
    });
  }

  @override
  void initState() {
    isDrawerOpen = true;
    fetchPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: Responsive.isMobile(context)
            ? SizedBox()
            : TopMenuDrawer(_handleDrawer),
        actions: [
          CurrentWaiter(
            name: nameWaiter,
          )
        ],
      ),
      drawer: !Responsive.isMobile(context)
          ? null
          : Drawer(
              backgroundColor: Colors.black,
              child: LeftDrawer(_handleDrawer, appState)),

      body: Column(
        children: [
          Expanded(
              child: Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      Responsive.isMobile(context)
                          ? const SizedBox()
                          : Container(
                              width: 215,
                              child: appState.isWidgetEnabled
                                  ? Drawer(
                                      child:
                                          LeftDrawer(_handleDrawer, appState),
                                    )
                                  : const SizedBox(),
                            ),
                      Expanded(
                        flex: 5,
                        child: StartPageVM(
                            name: appState.choosenRoom["name"] ?? "name",
                            id: appState.choosenRoom["id"] ?? "id",
                            appState: appState,
                            room: appState.room),
                      ),
                    ],
                  ))),
        ],
      ),

      //  Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Stack(
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(top: 20.v, left: 5.h),
      //             child: InkWell(
      //                 onTap: () => appState.toggleWidget(),
      //                 child: const Icon(Icons.menu, color: Colors.white)),
      //           ),
      //           appState.isWidgetEnabled
      //               ? Drawer(
      //                   width: 300.h,
      //                   child: LeftDrawer(_handleDrawer, appState),
      //                 )
      //               : const SizedBox(),
      //         ],
      //       ),
      //       SizedBox(
      //         width: 15.h,
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.end,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(15),
      //             child: Row(
      //               children: [
      //                 //AvailableWaiters(appState.numberOfTables, appState.choosenRoom["name"] ?? "choose Room"),
      //                 CurrentWaiter(
      //                   name: nameWaiter,
      //                 )
      //               ],
      //             ),
      //           ),
      //           Expanded(
      //             child: StartPageVM(
      //                 name: appState.choosenRoom["name"] ?? "name",
      //                 id: appState.choosenRoom["id"] ?? "id",
      //                 appState: appState,
      //                 room: appState.room),
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
    );
  }
}
