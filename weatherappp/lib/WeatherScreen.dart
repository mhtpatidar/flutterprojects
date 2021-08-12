import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:weatherappp/History.dart';

import 'database_helpers.dart';

class WeatherScreen extends StatefulWidget {
  @override
  double lat, lng;
  String city;

  WeatherScreen(this.lat, this.lng, this.city);

  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late SharedPreferences sharedPreferences;
  var _tabIndex = 0;
    Weather? current ;
   late List<Weather> forecast;
  bool _isInAsyncCall = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _isInAsyncCall = true;
    });

    _controller = new TabController(length: 2, vsync: this);
    _controller.addListener(_handleTabSelection);
    initView();
  }

  _handleTabSelection() {
    if (_controller.indexIsChanging) {
      setState(() {
        _tabIndex = _controller.index;
      });
    }
  }

  Future<bool> _onWillPop() async {

  /*  History addHistory = new History(
      Id: DateTime.now().millisecondsSinceEpoch,
      Name: current!.areaName.toString(),
      mobile: sharedPreferences.getString("mobilenumber").toString(),
      date: current!.date.toString(),
      weather: current!.weatherDescription.toString(),
    );

    DatabaseHelper.instance
        .insert(addHistory.toMapWithoutId());*/

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                decoration: new BoxDecoration(color: Colors.lime[100]),
                child: new TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  controller: _controller,
                  tabs: [
                    new Tab(
                      text: 'Today',
                    ),
                    new Tab(
                      text: 'Forecast',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: [
                    Expanded(
                      child: Container(
                        child: Container(
                          child: Column(
                            children: [
                              (current != null)
                                  ? Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 10,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Text(current!.areaName??"-"),
                                            Text('Date: ' + current!.date.toString()),
                                            Text("Temperature: " +
                                                current!.temperature.toString()),
                                            Text("Cloudiness: " +
                                                current!.cloudiness.toString()),
                                            Text("Weather: " +
                                                current!.weatherDescription.toString()),
                                          ],
                                        ),
                                      ),
                                  )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Container(
                          child: (forecast != null && forecast.length > 0)
                              ? ListView.builder(
                                  itemCount: forecast.length,
                                  itemBuilder: (BuildContext ctxt, int i) {
                                    var  model = forecast[i];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 10,
                                      child:Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            Text(model.areaName!),
                                            Text('Date: ' + model.date.toString()!),
                                            Text("Temperature: " +
                                                model.temperature.toString()),
                                            Text("Cloudiness: " +
                                                model.cloudiness.toString()),
                                            Text("Weather: " +
                                                model.weatherDescription
                                                    .toString()),

                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Container(),
                        ),
                      ),
                    ),
                  ][_tabIndex],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initView() async {
    setState(() {
      _isInAsyncCall = true;
    });

    String key = '856822fd8e22db5e1ba48c0e7d69844a';

    WeatherFactory wf = WeatherFactory(key);

    sharedPreferences = await SharedPreferences.getInstance();
    current = await wf.currentWeatherByLocation(widget.lat, widget.lng);
    forecast = await wf.fiveDayForecastByLocation(widget.lat, widget.lng);


    History addHistory = new History(
      Id: DateTime.now().millisecondsSinceEpoch,
      Name: current!.areaName.toString(),
      mobile: sharedPreferences.getString("mobilenumber").toString(),
      date: current!.date.toString(),
      weather: current!.weatherDescription.toString(),
    );

    DatabaseHelper.instance.insert(addHistory.toMapWithoutId());


    setState(() {
      _isInAsyncCall = false;
    });
  }
}
