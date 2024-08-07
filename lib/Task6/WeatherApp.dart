import 'package:aicp_internship/Task6/WeatherService.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Map<dynamic, dynamic> _weather = {};
  late Map<String, String> _additionalWeatherData = {};
  late Map<String, String> _additionalWeatherDataTitles = {};
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    // _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _fetchWeather({String city = ""}) async {
    try {
      print("City:");
      if(city.isEmpty){
        Position position = await _determinePosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        Placemark placemark = placemarks[0];
        city = placemark.locality ?? 'Unknown';
      }

      print("City: $city");

      Map<dynamic, dynamic> weather = await _weatherService.fetchWeather(city);
      print(weather);
      setState(() {
        _weather = weather;
        _addAdditionalWeatherData();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      _isLoading = false;
    }
  }

  String _formatTime(int timeEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeEpoch * 1000);
    return DateFormat.j().format(dateTime);
  }

  String _formatDay(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return 'Today';
    }
    return DateFormat.EEEE().format(dateTime);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _isLoading = true;
      _fetchWeather(city: query);
      _toggleSearch();
    }
  }

  void _addAdditionalWeatherData(){
    _additionalWeatherData["uv"] = _weather["current"]["uv"].toString();
    _additionalWeatherDataTitles["uv"] = "UV Index";
    _additionalWeatherData["humidity"] = _weather["current"]["humidity"].toString();
    _additionalWeatherDataTitles["humidity"] = "Humidity";
    _additionalWeatherData["wind_kph"] = _weather["current"]["wind_kph"].toString();
    _additionalWeatherDataTitles["wind_kph"] = "Wind";
    _additionalWeatherData["dewpoint_c"] = _weather["current"]["dewpoint_c"].toString();
    _additionalWeatherDataTitles["dewpoint_c"] = "Dew Point";
    _additionalWeatherData["pressure_mb"] = _weather["current"]["pressure_mb"].toString();
    _additionalWeatherDataTitles["pressure_mb"] = "Pressure";
    _additionalWeatherData["vis_km"] = _weather["current"]["vis_km"].toString();
    _additionalWeatherDataTitles["vis_km"] = "Visibility";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter city name',
            border: InputBorder.none,
          ),
          onSubmitted: _onSearchSubmitted,
        )
            : Text('Weather Forecast'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(13.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "${_weather["location"]["name"]}",
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.location_pin, size: 34),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Text(
                      "${_weather["location"]["region"]}, ${_weather["location"]["country"]}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[300],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_weather["current"]["temp_c"]}\u2103",
                          style: TextStyle(fontSize: 66),
                        ),
                        Text(
                          "${_weather["current"]["condition"]["text"]}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "${_weather["forecast"]["forecastday"][0]["day"]["maxtemp_c"]}\u2103 / ${_weather["forecast"]["forecastday"][0]["day"]["mintemp_c"]}\u2103 Feels Like ${_weather["current"]["feelslike_c"]}\u2103",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(13.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueGrey[100],
                        elevation: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_weather["forecast"]["forecastday"][0]["day"]["condition"]["text"]}. Low ${_weather["forecast"]["forecastday"][0]["day"]["mintemp_c"]}\u2103",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(height: 3, color: Colors.white),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _weather["forecast"]["forecastday"][0]["hour"]
                                      .map<Widget>((item) {
                                    return _hourlyCard(
                                      _formatTime(item["time_epoch"]),
                                      item["temp_c"].toString(),
                                      item["condition"]["icon"],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(13.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueGrey[100],
                        elevation: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: _weather["forecast"]["forecastday"]
                                .map<Widget>((item) {
                              return _dailyCard(
                                _formatDay(item["date"]),
                                item["day"]["daily_chance_of_rain"].toString(),
                                item["hour"][0]["condition"]["icon"],
                                item["day"]["condition"]["icon"],
                                item["day"]["maxtemp_c"].toString(),
                                item["day"]["mintemp_c"].toString(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final key = _additionalWeatherData.keys.elementAt(index);
                  final value = _additionalWeatherData[key]!;

                  return _dataCard(key, value);
                },
                childCount: _additionalWeatherData.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _hourlyCard(String time, String temp, String imgSrc){
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        child: Column(
          children: [
            Text("$time", style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16
            )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Image.network("https:$imgSrc", height: 55, width: 55),
            ),
            Text("$temp", style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600
            ))
          ],
        ),
      ),
    );
  }
  Widget _dailyCard(String day, String percp, String img1, String img2, String temp1, String temp2){
    return Row(
      children: [
        Text("$day", style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white
        )),
        Spacer(),
        Row(
          children: [
            Icon(Icons.water_drop_rounded, color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 5.0),
              child: Text("$percp%", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Image.network("https:$img1", height: 35, width: 35),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, top: 5.0),
              child: Image.network("https:$img2", height: 35, width: 35),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: Text("$temp1\u2103"),
            ),
            Text("$temp2\u2103"),
          ],
        )
      ],
    );
  }
  Widget _dataCard(String title, String value){
    return Card(
        color: Colors.blueGrey[100],
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 150,
            child: Column(
            children: [
              Text("${_additionalWeatherDataTitles[title]}", style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 30
              )),
              Text("$value", style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 50,
                  fontWeight: FontWeight.w600
              ))
            ],
          ),
          ),
        )
    );
  }
}