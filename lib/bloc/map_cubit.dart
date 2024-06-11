import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripyproject/data/model/user.dart';
import 'package:tripyproject/data/dummy_data/user_generation.dart';

import '../data/remote/map_service.dart';

enum MapStatus { loading, loaded, error ,googleMapDirectionsLoaded,googleMapDirectionsLoading}

class MapCubit extends Cubit<MapStatus> {
  late ClusterManager manager;
  Completer<GoogleMapController> controller_ = Completer();
  Set<Marker> markers = {};
  List<User> allItems = [];
  Set<Polyline> polylines = {};
  LatLng userLocation = const LatLng(0, 0);
  LatLng userPos = const LatLng(0, 0);
  CameraPosition initialCameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 12.0);
  GoogleMapController? googleMapController;

  MapCubit() : super(MapStatus.loading) {
    _requestLocationPermission();
  }

  /// Requests location permission and initializes the map.
  ///
  /// This method requests the user's location permission, retrieves the current
  /// position, initializes the map with the user's location, and fetches initial
  /// data.
  Future<void> _requestLocationPermission() async {
    emit(MapStatus.loading);
    final position = await Geolocator.getCurrentPosition();
    userLocation = LatLng(position.latitude, position.longitude);
     initialCameraPosition = CameraPosition(target: userLocation, zoom: 12.0);
    _getInitAllData();
  }

  Future<void> _getInitAllData() async {
    allItems = generateUsers(userLocation);
    manager = _initClusterManager();

  }



  /// Initializes the cluster manager for marker clustering.
  ///
  /// This method initializes the cluster manager with the list of all items,
  /// updates the markers on the map, and sets the marker builder.
  ClusterManager _initClusterManager() {
    emit(MapStatus.loaded);
    return ClusterManager<User>(
      allItems,
      updateMarkers,
      markerBuilder: markerBuilder,
    );

  }

  /// Builds markers for clustering.
  ///
  /// This method builds markers for each cluster, sets the marker ID, position,
  Future<Marker> Function(Cluster<User>) get markerBuilder => (cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      infoWindow: InfoWindow(
        title: cluster.isMultiple ? 'Cluster' : cluster.items.first.name,
        snippet: cluster.isMultiple
            ? 'Contains ${cluster.count} places'
            : (cluster.items.first.isClosed != null
            ? (cluster.items.first.isClosed! ? 'Closed' : 'Open')
            : ''),
      ),
      onTap: () {
        print('---- $cluster');
        cluster.items.forEach((p) => print(p));
      },
      icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 150,cluster.isMultiple ? true : false,
          text: cluster.isMultiple ? cluster.count.toString() : distance(cluster.location)),
    );
  };

  /// Updates markers on the map.
  ///
  /// This method updates the markers with the provided set of markers, and emits
  /// loading and loaded states.
  void updateMarkers(Set<Marker> markers) {
    this.markers = markers;
    emit(MapStatus.loading);
    emit(MapStatus.loaded);
  }


  /// Generates a custom marker bitmap.
  Future<BitmapDescriptor> _getMarkerBitmap(int size, bool isMultiple,{String? text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.red;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size /2, paint1);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);



    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: isMultiple?text:"$text KM",
        style: TextStyle(fontSize: isMultiple?size /2:size /6, color: Colors.white, fontWeight: FontWeight.bold),
      );
      painter.layout();

      double x=size / 2 - painter.width / 2;
      double y=size / 2 - painter.height / 2;
      if(!isMultiple){
        final ByteData byteData = await rootBundle.load('assets/avatar.png');
        final Uint8List buffer = byteData.buffer.asUint8List();
        final ui.Codec codec = await ui.instantiateImageCodec(buffer);
        final ui.FrameInfo imageFI = await codec.getNextFrame();
        final ui.Image image = imageFI.image;


        final double imageRadius = size / 2.5;
        final Rect imageRect = Rect.fromCircle(center: Offset(size / 2, size / 2), radius: imageRadius);
        canvas.drawImageRect(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), imageRect, Paint());
        final double textWidth = painter.width;
        final double textHeight = painter.height;


        x = size - (textWidth);
        y = 0;


        final Paint backgroundPaint = Paint()..color = Colors.blue;
        final Rect backgroundRect = Rect.fromLTWH(x - 4, y - 2, textWidth + 8, textHeight + 4); // Kutu boyutunu ve pozisyonunu belirle
        canvas.drawRect(backgroundRect, backgroundPaint);
      }


      painter.paint(
        canvas,
        Offset(x, y),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());


  }

  /// Retrieves directions between user's current location and the destination.
  Future<void> getDirections(LatLng userPos_) async {
    emit(MapStatus.googleMapDirectionsLoading);
    GoogleMapService mapService = GoogleMapService();
    try {
      final directions = await mapService.getDirections(userLocation, userPos_);
      polylines = {
        Polyline(
          polylineId: const PolylineId('route_to_nearest_place'),
          points: directions,
          color: Colors.blue,
          width: 5,
        ),
      };
      userPos = userPos_;
      emit(MapStatus.googleMapDirectionsLoaded);
    } catch (e) {
      emit(MapStatus.error);
    }
  }

 /// Animates the map to fit the bounds of the user's and destination's locations.
  Future<void> animateTo(GoogleMapController controller_) async {


      final bounds = LatLngBounds(
        southwest: LatLng(min(userLocation.latitude, userPos.latitude), min(userLocation.longitude, userPos.longitude)),
        northeast: LatLng(max(userLocation.latitude, userPos.latitude), max(userLocation.longitude, userPos.longitude)),
      );
      controller_.animateCamera(CameraUpdate.newLatLngBounds(bounds, 25));


  }

  /// Calculates the distance between the user's location and the provided position.
  String distance(LatLng pos){
    double distance = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, pos.latitude, pos.longitude)/1000;
    return distance.toStringAsFixed(2);
  }


}