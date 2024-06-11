import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripyproject/bloc/map_cubit.dart';
import 'package:tripyproject/ui/map_screen/map_content.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => MapCubit(),
          child:const Scaffold(
          body: MapContent(),
    )
      )
    );
  }
}


