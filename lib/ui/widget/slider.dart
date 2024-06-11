import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/map_cubit.dart';

class SliderCarousel extends StatelessWidget {
  const SliderCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: 300,
          height: 250,
          child: CarouselSlider(
            items: context.read<MapCubit>().allItems.map((place) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/avatar.png',
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height: 100.0,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 30.0,
                              child: Container(
                                color: Colors.red,
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${context.read<MapCubit>().distance(place.latLng)} km",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Icon(Icons.arrow_forward, color: Colors.black),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                context.read<MapCubit>().getDirections(context.read<MapCubit>().allItems[index].latLng);
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}
