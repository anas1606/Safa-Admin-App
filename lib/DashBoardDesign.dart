import 'package:flutter/material.dart';
import 'package:safa_admin/Decoraters/GradiantText.dart';

class DashBoardDesign extends StatefulWidget {
  DashBoardDesign({Key key}) : super(key: key);

  @override
  _DashBoardDesignState createState() => _DashBoardDesignState();
}

class _DashBoardDesignState extends State<DashBoardDesign> {
  Widget _buildSingleContainer(
      {IconData icon,
      String text,
      int count,
      BuildContext contex,
      String route}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        elevation: 20,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            gradient: LinearGradient(
              colors: [Colors.blueGrey[900], Colors.blueGrey[900]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [Colors.black12, Colors.black12]),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.blueGrey[800],
                      size: 30,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GradientText(
                        text,
                        gradient: LinearGradient(
                          colors: [Colors.blue[400], Colors.purple[300]],
                        ),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "kalam",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GradientText(
                        count.toString(),
                        gradient: LinearGradient(
                          colors: [Colors.blue[400], Colors.purple[300]],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: <Widget>[
        _buildSingleContainer(
            icon: Icons.category,
            text: "Category",
            count: 3,
            contex: context,
            route: "category"),
      ],
    );
  }
}
