import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'API_KEY';

  Future<double> fetchTemperature() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Sylhet&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['main']['temp'].toDouble();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
