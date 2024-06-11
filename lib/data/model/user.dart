
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class User with ClusterItem {
  final String name;
  final bool isClosed;
  final LatLng latLng;

  User({required this.name, required this.latLng, this.isClosed = false});

  @override
  String toString() {
    return 'User $name ';
  }

  @override
  LatLng get location => latLng;
}