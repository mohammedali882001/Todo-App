
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

// ignore: must_be_immutable
class TodoLayout extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TodoLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShowen) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShowen = false;
                    //     //   setState(() {
                    //     //     iconData = Icons.edit;
                    //     //   });
                    //     //   tasks = value;
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.grey[100],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormFaild(
                                  controller: titleController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ('title must not be empty');
                                    }
                                    return null;
                                  },
                                  hintText: 'Task Title',
                                  label: 'Task Title',
                                  prefixIcon: const Icon(Icons.title),
                                ),
                                const SizedBox(height: 20),
                                defaultTextFormFaild(
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      // ignore: avoid_print
                                      print(value.format(context).toString());
                                    }).catchError((error) {
                                      // ignore: avoid_print
                                      print(
                                          "error innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn ${error.toString()}");
                                    });
                                  },
                                  controller: timeController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ('time must not be empty');
                                    }
                                    return null;
                                  },
                                  hintText: 'time Title',
                                  label: 'time Title',
                                  prefixIcon:
                                      const Icon(Icons.watch_later_outlined),
                                ),
                                const SizedBox(height: 20),
                                defaultTextFormFaild(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2024-04-04'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    }).catchError((error) {
                                      // ignore: avoid_print
                                      print(
                                          'error innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn ${error.toString()}');
                                    });
                                  },
                                  controller: dateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ('date must not be empty');
                                    }
                                    return null;
                                  },
                                  hintText: 'date Title',
                                  label: 'date Title',
                                  prefixIcon: const Icon(Icons.date_range),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubit.chaneBottomSheetState(
                            isShowen: false, icon: Icons.edit);
                      });

                  cubit.chaneBottomSheetState(isShowen: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.iconData),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeIndex(value);
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Tasks',
                  icon: Icon(Icons.menu),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon: Icon(Icons.check_circle_outline),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon: Icon(Icons.archive),
                ),
              ],
            ),
            body: ConditionalBuilder(
              // ignore: unrelated_type_equality_checks
              condition: state != AppGetFromDatabaseState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
