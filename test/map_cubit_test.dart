import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:tripyproject/bloc/map_cubit.dart';
import 'package:tripyproject/data/dummy_data/user_generation.dart';

class MockMapCubit extends Mock implements MapCubit {}

void main() {
  late MapCubit mapCubit;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
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
}
