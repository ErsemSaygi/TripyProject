import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tripyproject/bloc/map_cubit.dart';
import 'package:tripyproject/data/remote/map_service.dart';



class MockGeolocatorPlatform extends Mock with MockPlatformInterfaceMixin implements GeolocatorPlatform {
  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) {
    return super.noSuchMethod(
      Invocation.method(#getCurrentPosition, [], {
        #desiredAccuracy: desiredAccuracy,
        #forceAndroidLocationManager: forceAndroidLocationManager,
        #timeLimit: timeLimit,
      }),
      returnValue: Future.value(Position(
        latitude: 40.7128,
        longitude: -74.0060,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      )),
      returnValueForMissingStub: Future.value(Position(
        latitude: 40.7128,
        longitude: -74.0060,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      )),
    );
  }
}


class MockMapService extends Mock implements GoogleMapService {}
void main() {
  late MapCubit mapCubit;
  late MockGeolocatorPlatform mockGeolocatorPlatform;
  late MockMapService mockMapService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockGeolocatorPlatform = MockGeolocatorPlatform();
    GeolocatorPlatform.instance = mockGeolocatorPlatform;
    mockMapService = MockMapService();
    mapCubit = MapCubit();
  });

  tearDown(() {
    mapCubit.close();
  });

  group('MapCubit', () {

    blocTest<MapCubit, MapStatus>(
      'emits [loading, loaded] when requestLocationPermission is called and succeeds',
      build: () => mapCubit,
      act: (cubit) async {
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

        when(mockGeolocatorPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        )).thenAnswer((_) async => mockPosition);

        await cubit.requestLocationPermission();
      },
      expect: () => [MapStatus.loading, MapStatus.loaded],
      verify: (_) {
        expect(mapCubit.userLocation.latitude, 40.7128);
        expect(mapCubit.userLocation.longitude, -74.0060);
        expect(mapCubit.initialCameraPosition.target.latitude, 40.7128);
        expect(mapCubit.initialCameraPosition.target.longitude, -74.0060);
        expect(mapCubit.initialCameraPosition.zoom, 12.0);
      },
    );


  });
}
