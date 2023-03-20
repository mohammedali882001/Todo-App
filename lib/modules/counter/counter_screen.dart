import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules/counter/cubit/cubit.dart';
import 'package:todo/modules/counter/cubit/states.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state is CounterPlusState) {}
          if (state is CounterMinusState) {}
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('counter'),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      CounterCubit.get(context).minusCounter();
                    },
                    child: const Text(
                      'Minus',
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    '${CounterCubit.get(context).counter}',
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    onPressed: () {
                      CounterCubit.get(context).plusCounter();
                    },
                    child: const Text(
                      'Plus',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
