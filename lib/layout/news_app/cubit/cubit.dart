import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/news_app/cubit/states.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitialState());
}
