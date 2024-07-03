import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(
            255, 220, 225, 232), // Set primary color to AppBar color
        scaffoldBackgroundColor: Color.fromARGB(
            255, 7, 28, 76), // Set background color for other screens
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 27, 24, 95), // Set the background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://mir-s3-cdn-cf.behance.net/projects/404/5bca4d201291965.Y3JvcCwxMzgwLDEwODAsNjgwLDA.png', // Replace with your image URL
              // height: 700,
            ),
            SizedBox(height: 150),
            Text(
              "Get weather updates here!",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                   Color.fromARGB(255, 27, 178, 228) , // Dark blue color
                shadowColor:
                    Color.fromARGB(255, 27, 178, 228), // Light blue shadow
                elevation: 10,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
              child: Text(
                'Get Start',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.fetchWeather(_controller.text);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Set the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 7, 30, 66), // AppBar color
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlue.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'WEATHER APP',
              style: TextStyle(fontSize: 15, color: Colors.white),
              // Set the font size of the title
            ),
            // centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _searchWeather,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),
              if (_isLoading)
                CircularProgressIndicator()
              else if (_weather != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        255, 7, 30, 66), // Container color matches AppBar
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlue.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'http://openweathermap.org/img/wn/${_weather!.icon}@2x.png',
                            height: 100,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${_weather!.cityName}, ${_weather!.country}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 18, 166, 230),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap:
                            true, // To make the GridView fit inside its parent
                        crossAxisCount: 2, // Number of columns
                        mainAxisSpacing: 10.0, // Space between rows
                        crossAxisSpacing: 10.0, // Space between columns
                        childAspectRatio: 2, // Ratio of child width to height
                        children: [
                          _buildDetailCard('Temperature',
                              '${_weather!.temperature}°C', Colors.red),
                          _buildDetailCard('Feels Like',
                              '${_weather!.feelsLike}°C', Colors.red),
                          _buildDetailCard(
                              'Description', _weather!.description, Colors.red),
                          _buildDetailCard(
                              'Humidity', '${_weather!.humidity}%', Colors.red),
                          _buildDetailCard('Wind Speed',
                              '${_weather!.windSpeed} m/s', Colors.red),
                          _buildDetailCard('Wind Direction',
                              '${_weather!.windDirection}°', Colors.red),
                          _buildDetailCard('Visibility',
                              '${_weather!.visibility} m', Colors.red),
                          _buildDetailCard('Cloudiness',
                              '${_weather!.cloudiness}%', Colors.red),
                          _buildDetailCard(
                              'Sunrise',
                              '${DateTime.fromMillisecondsSinceEpoch(_weather!.sunrise * 1000)}',
                              Colors.red),
                          _buildDetailCard(
                              'Sunset',
                              '${DateTime.fromMillisecondsSinceEpoch(_weather!.sunset * 1000)}',
                              Colors.red),
                        ],
                      ),
                    ],
                  ),
                )
              else if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail card
  Widget _buildDetailCard(String title, String value, Color valueColor) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 7, 30, 66), // Matches AppBar color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: valueColor),
          ),
        ],
      ),
    );
  }
}
