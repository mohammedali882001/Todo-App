abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsBottomNavBarlState extends NewsState {}

class NewsGetBusinessSuccessState extends NewsState {}

class NewsGetBusinessErorrState extends NewsState {
  final String erorr;

  NewsGetBusinessErorrState(this.erorr);
}

class NewsGetBusinessLoadingState extends NewsState {}

class NewsGetSportsSuccessState extends NewsState {}

class NewsGetSportsErorrState extends NewsState {
  final String erorr;

  NewsGetSportsErorrState(this.erorr);
}

class NewsGetSportsLoadingState extends NewsState {}

class NewsGetScienceSuccessState extends NewsState {}

class NewsGetScienceErorrState extends NewsState {
  final String erorr;

  NewsGetScienceErorrState(this.erorr);
}

class NewsGetScienceLoadingState extends NewsState {}

class NewsGetSearchLoadingState extends NewsState {}

class NewsGetSearchSuccessState extends NewsState {}

class NewsGetSearchErorrState extends NewsState {
  final String erorr;

  NewsGetSearchErorrState(this.erorr);
}

class NewsUrlLuncherState extends NewsState {}
