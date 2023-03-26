import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/news_app/cubit/cubit.dart';
import 'package:todo/layout/news_app/cubit/states.dart';
import 'package:todo/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  var screenController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: defaultTextFormFaild(
              onChanged: (value) {
                NewsCubit.get(context).getSearch(valueOfsearch: value);
              },
              controller: screenController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'search must not be empty';
                }
                return null;
              },
              hintText: 'Search',
              label: 'Search',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          BlocConsumer<NewsCubit, NewsState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var list = NewsCubit.get(context).search;
              return Expanded(child: newsBuilder(state, list));
            },
          )
        ],
      ),
    );
  }
}
