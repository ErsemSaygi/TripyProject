import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripyproject/data/model/user.dart';

List<User> generateUsers(LatLng userLocation) {
  List<User> generatedUsers = [];
  generatedUsers.add(User(name: 'John', latLng: LatLng(userLocation.latitude + 2 * 0.001, userLocation.longitude + 2 * 0.001)));
  generatedUsers.add(User(name: 'Michael', latLng: LatLng(userLocation.latitude - 2 * 0.002, userLocation.longitude + 2 * 0.001)));
  generatedUsers.add(User(name: 'David', latLng: LatLng(userLocation.latitude - 2 * 0.003, userLocation.longitude - 2 * 0.001)));
  generatedUsers.add(User(name: 'James', latLng: LatLng(userLocation.latitude + 2 * 0.004, userLocation.longitude - 2 * 0.001)));
  generatedUsers.add(User(name: 'Robert', latLng: LatLng(userLocation.latitude + 3 * 0.005, userLocation.longitude + 3 * 0.001)));
  generatedUsers.add(User(name: 'William', latLng: LatLng(userLocation.latitude - 3 * 0.006, userLocation.longitude + 3 * 0.001)));
  generatedUsers.add(User(name: 'Richard', latLng: LatLng(userLocation.latitude - 3 * 0.007, userLocation.longitude - 3 * 0.001)));
  generatedUsers.add(User(name: 'Joseph', latLng: LatLng(userLocation.latitude + 3 * 0.008, userLocation.longitude - 3 * 0.001)));
  generatedUsers.add(User(name: 'Charles', latLng: LatLng(userLocation.latitude + 4 * 0.0065, userLocation.longitude + 4 * 0.001)));
  generatedUsers.add(User(name: 'Thomas', latLng: LatLng(userLocation.latitude - 4 * 0.0054, userLocation.longitude + 4 * 0.001)));


  return generatedUsers;
}
