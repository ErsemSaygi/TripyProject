import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:tripyproject/bloc/map_cubit.dart';
import 'package:tripyproject/ui/widget/slider.dart'; // SliderCarousel yerine doğru import eklenmeli

class MockMapCubit extends Mock implements MapCubit {
  @override
  LatLng userLocation = LatLng(40.7128, -74.0060); // Örnek bir konum ataması yapın
}

void main() {
  late MockMapCubit mockCubit;

  final MaterialApp app = MaterialApp(
    home: BlocProvider(
      create: (context) => MapCubit(),
      child: const SliderCarousel(), // SliderCarousel yerine doğru widget kullanıldı
    ),
  );

  setUp(() {
    mockCubit = MockMapCubit();
  });

  testWidgets('Carousel widget should be displayed', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    expect(find.byType(CarouselSlider), findsOneWidget);
  });



}
