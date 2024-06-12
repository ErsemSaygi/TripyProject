import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:tripyproject/bloc/map_cubit.dart';
import 'package:tripyproject/data/dummy_data/user_generation.dart';

class MockMapCubit extends Mock implements MapCubit {}
class MockGeolocator extends Mock implements GeolocatorPlatform {}
void main() {
  late MapCubit mapCubit;
  late MockGeolocator mockGeolocator;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockGeolocator = MockGeolocator();
    GeolocatorPlatform.instance = mockGeolocator;
    mapCubit = MapCubit();
  });

  test('_getInitAllData initializes allItems and manager correctly', () async {

    final expectedUsers = generateUsers(LatLng(40.7128, -74.0060));


    mapCubit.userLocation = LatLng(40.7128, -74.0060);


    await mapCubit.getInitAllData();


    expect(mapCubit.allItems.length, expectedUsers.length);
    for (var i = 0; i < mapCubit.allItems.length; i++) {
      expect(mapCubit.allItems[i].name, expectedUsers[i].name);
      expect(mapCubit.allItems[i].latLng, expectedUsers[i].latLng);
    }


    expect(mapCubit.manager, isNotNull);
  });

  test('requestLocationPermission updates userLocation and initialCameraPosition', () async {
    final mockPosition = Position(
      latitude: 40.7128,
      longitude: -74.0060,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    when(mockGeolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    )).thenAnswer((_) async => mockPosition);

    await mapCubit.requestLocationPermission();

    expect(mapCubit.userLocation.latitude, mockPosition.latitude);
    expect(mapCubit.userLocation.longitude, mockPosition.longitude);
    expect(mapCubit.initialCameraPosition.target.latitude, mockPosition.latitude);
    expect(mapCubit.initialCameraPosition.target.longitude, mockPosition.longitude);
    expect(mapCubit.initialCameraPosition.zoom, 12.0);
  });

}
