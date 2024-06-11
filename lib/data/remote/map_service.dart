import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/constants.dart';


abstract class MapService {
  Future<List<LatLng>> getDirections(LatLng userLocation, LatLng destination);
}
/// Implementation of MapService using Google Maps API.
///
/// This class implements the [MapService] interface to retrieve directions
/// using the Google Maps Directions API.
class GoogleMapService implements MapService {
  @override
  Future<List<LatLng>> getDirections(LatLng userLocation, LatLng destination) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation.latitude},${userLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=${Constants.googleApiKey}';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final List<LatLng> decodedPoints = _decodePoly(data['routes'][0]['overview_polyline']['points']);
      return decodedPoints;
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    var polyline = List<LatLng>.empty(growable: true);
    for (var i = 0; i < lList.length; i += 2) {
      polyline.add(LatLng(lList[i], lList[i + 1]));
    }
    return polyline;
  }
}
