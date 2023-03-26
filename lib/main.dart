// by mohamed ali

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:todo/shared/myBlocObserver%20.dart';
import 'package:todo/shared/network/local/cache_helper.dart';
import 'package:todo/shared/network/remote/dio_helper.dart';

import 'layout/news_app/cubit/cubit.dart';
import 'layout/news_app/news_layout.dart';
import 'layout/todo_app/todo_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: "isDark");
  runApp(Todo(isDark!));
}

class Todo extends StatelessWidget {
  final bool isDark;
  const Todo(this.isDark, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..changeMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => NewsCubit()
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                titleSpacing: 20,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.deepOrange,
                type: BottomNavigationBarType.fixed,
                elevation: 20,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: HexColor("333739"),
              appBarTheme: AppBarTheme(
                titleSpacing: 20,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                backgroundColor: HexColor("333739"),
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: HexColor("333739"),
                    statusBarIconBrightness: Brightness.light),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                elevation: 20,
                backgroundColor: HexColor('33339'),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: const NewsLayout(),
          );
        },
      ),
    );
  }
}
