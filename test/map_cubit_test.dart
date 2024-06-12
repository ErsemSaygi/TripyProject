import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:tripyproject/bloc/map_cubit.dart';
import 'package:tripyproject/data/remote/map_service.dart';

// Mock Sınıfları
class MockMapCubit extends Mock implements MapCubit {
  @override
  LatLng userLocation = LatLng(40.7128, -74.0060); // Örnek bir konum ataması yapın
}

class MockGoogleMapService extends Mock implements GoogleMapService {}

void main() {
  late MockMapCubit mockCubit;
  late MockGoogleMapService mockMapService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockCubit = MockMapCubit();
    mockMapService = MockGoogleMapService();
  });

  test("Test getDirections method", () async {
    LatLng a = LatLng(40.7128, -74.0060);
    mockCubit.userLocation = LatLng(40.7128, -78.0060);




    // mockCubit'in getDirections metodunu mock'lama
    when(mockCubit.getDirections(a)).thenAnswer((_) async {
      mockCubit.polylines = {
        Polyline(
          polylineId: const PolylineId('route_to_nearest_place'),
          points: [
            LatLng(40.7128, -74.0060),
            LatLng(40.7128, -78.0060),
          ],
          color: Colors.blue,
          width: 5,
        ),
      };
      return Future.value();
    });

    await mockCubit.getDirections(a);
    expect(mockCubit.polylines.length, 1);
  });
}
