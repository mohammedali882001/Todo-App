import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:todo/shared/network/local/cache_helper.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Map> tasks = [];

  List screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeButtonNavBaState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // ignore: avoid_print
        print('database is created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , data TEXT , time TEXT , status TEXT )')
            .then((value) {
          // ignore: avoid_print
          print('table is created');
        }).catchError((error) {
          // ignore: avoid_print
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database) {
        // ignore: avoid_print
        print('database is opend');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title , data , time , status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        // ignore: avoid_print
        print("$value inserted successfully");
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        // ignore: avoid_print
        print('error when inserting data ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetLoadingDatabaseState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetFromDatabaseState());
    });
  }

  void updateDatabase({required String status, required int id}) {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteFromDatabase({required int id}) {
    database!
        .rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }

  bool isBottomSheetShowen = false;
  IconData iconData = Icons.edit;

  void chaneBottomSheetState({required bool isShowen, required IconData icon}) {
    isBottomSheetShowen = isShowen;
    iconData = icon;

    emit(AppChaneBottomSheetState());
  }

  bool isDark = false;
  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChaneModdState());
    } else {
      isDark = !isDark;
      CacheHelper.putData(key: "isDark", value: isDark).then((value) {
        emit(AppChaneModdState());
      });
    }
  }
}
