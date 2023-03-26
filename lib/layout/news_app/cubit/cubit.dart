import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/news_app/cubit/states.dart';
import 'package:todo/modules/business/business_screen.dart';
import 'package:todo/modules/science/science.dart';
import 'package:todo/modules/settings/setings_screen.dart';
import 'package:todo/modules/sports/sports_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitialState());
  static NewsCubit get(context) => BlocProvider.of(context);
  int currentInde = 0;
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];
  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScinceScreen(),
    const SettingsScreen(),
  ];
  void onTab(int value) {
    currentInde = value;
    emit(NewsBottomNavBarlState());
  }

  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        "country": "eg",
        "category": "business",
        "apiKey": "143c27d91196443c93e56c1b064da4b6",
      },
    ).then((value) {
      emit(NewsGetBusinessSuccessState());
      business = value.data["articles"];
      print(business);
    }).catchError((error) {
      emit(NewsGetBusinessErorrState(error.toString()));
      print(error.toString());
    });
  }

  void getSports() {
    emit(NewsGetSportsLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        "country": "eg",
        "category": "sports",
        "apiKey": "143c27d91196443c93e56c1b064da4b6",
      },
    ).then((value) {
      sports = value.data["articles"];
      emit(NewsGetSportsSuccessState());

      print(sports);
    }).catchError((error) {
      emit(NewsGetSportsErorrState(error.toString()));
      print(error.toString());
    });
  }

  void getScience() {
    emit(NewsGetScienceLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        "country": "eg",
        "category": "science",
        "apiKey": "143c27d91196443c93e56c1b064da4b6",
      },
    ).then((value) {
      science = value.data["articles"];
      emit(NewsGetScienceSuccessState());
      print(science);
    }).catchError((error) {
      emit(NewsGetScienceErorrState(error.toString()));
      print(error.toString());
    });
  }

  void getSearch({required String valueOfsearch}) {
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
      url: 'v2/everything',
      query: {
        "q": valueOfsearch,
        "apiKey": "df5583ee08d944a6886e2d90a3de496b",
      },
    ).then((value) {
      search = value.data["articles"];
      emit(NewsGetSearchSuccessState());
      print(search);
    }).catchError((error) {
      emit(NewsGetSearchErorrState(error.toString()));
      print(error.toString());
    });
  }

  Future<void> getUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
