import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../bloc/map_cubit.dart';
import '../widget/google_map.dart';
import '../widget/loading.dart';
import '../widget/slider.dart';

/// Widget for displaying the map content.
///
/// This widget manages the UI for displaying the map content, including the Google Map,
/// loading indicators, and slider for selecting destinations.

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  _MapContentState createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {



  @override
  Widget build(BuildContext context) {
    return BlocListener<MapCubit, MapStatus>(
      listener: (context, state) {
        if (state == MapStatus.googleMapDirectionsLoaded) {
          GoogleMapController? controller=context.read<MapCubit>().googleMapController;
          context.read<MapCubit>().animateTo(controller!);
        }
      },
      child: BlocBuilder<MapCubit, MapStatus>(
        builder: (context, state) {
          if (state == MapStatus.loading) {
            return const Center(
              child: LoadingCircle(),
            );
          } else if (state == MapStatus.error) {
            return const Center(
              child: Text('Error loading map'),
            );
          } else {
            return Scaffold(
              body: Stack(
                children: [
                  MapGoogle(),

                  if (context.read<MapCubit>().state == MapStatus.googleMapDirectionsLoading)
                    const LoadingCircle(),

                  const SliderCarousel(),
                ],
              ),
            );
          }
        },
      ),
    );

  }
}