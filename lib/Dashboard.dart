import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safa_admin/DashBoardDesign.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';
import 'package:safa_admin/Drawer.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            brightness: Brightness.dark,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                                      child: Text("DashBoard",
                        style: TextStyle(
                          color: _tabController.index == 0
                              ? Colors.white
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.5,
                        )),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.add_business,
                    color: Colors.white,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Manage",
                        style: TextStyle(
                          color: _tabController.index == 1
                              ? Colors.white
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.5,
                        )),
                  ),
                ),
              ],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.blue[900], Colors.purple[500]]),
              ),
            ),
            backgroundColor: Colors.blueGrey[900],
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: GradientText(
                  "Safa Enterprise",
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[400],
                      Colors.purple[500],
                    ],
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: "fugzOne"),
                ),
              ),
            ),
            centerTitle: true,
            elevation: 15.0,
            shadowColor: Colors.blueGrey[550],
          ),
        ),
        body: Container(
          color: Colors.blueGrey[900],
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(child: DashBoardDesign()),
                Container(
                  child: Center(
                    child: Icon(
                      Icons.add_business,
                      size: 130,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: MyDrawer(),
        drawerEdgeDragWidth: 40,
      ),
    );
  }
}
