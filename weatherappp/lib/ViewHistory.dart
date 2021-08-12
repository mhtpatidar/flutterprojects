import 'package:flutter/material.dart';
import 'package:weatherappp/History.dart';
import 'database_helpers.dart';

class ViewHisory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewHisoryState();
  }
}

class ViewHisoryState extends State<ViewHisory> {
  List<History> list = [];

  Future<List<Map<String, dynamic>>> getHistory() async {
    List<Map<String, dynamic>> listMap = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      listMap.forEach((map) => list.add(History.fromMap(map)));
    });

    return listMap;
  }

  @override
  void initState() {
    // TODO: implement initState
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("View History"),
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, position) {
                  History gethistory = list[position];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("ID: "+gethistory.Id.toString(),
                                  style: TextStyle(fontSize: 18))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("Place: "+gethistory.Name.toString(),
                                  style: TextStyle(fontSize: 18))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("Date: "+gethistory.date.toString(),
                                  style: TextStyle(fontSize: 18))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("Weather: "+gethistory.weather.toString(),
                                  style: TextStyle(fontSize: 18))),



                        ],
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}