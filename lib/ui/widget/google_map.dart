import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/map_cubit.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({Key? key}) : super(key: key);

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  @override
  Widget build(BuildContext context) {
    return  GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      polylines: context.read<MapCubit>().polylines,
      mapType: MapType.normal,
      initialCameraPosition: context.read<MapCubit>().initialCameraPosition,
      markers: context.read<MapCubit>().markers,
      onMapCreated: (GoogleMapController controller) {
        context.read<MapCubit>().googleMapController=controller;
        if (!context.read<MapCubit>().controller_.isCompleted) {
          context.read<MapCubit>().controller_.complete(controller);
        }

        context.read<MapCubit>().manager.setMapId(controller.mapId);
      },
      onCameraMove: context.read<MapCubit>().manager.onCameraMove,
      onCameraIdle: context.read<MapCubit>().manager.updateMap,
    );
  }
}

