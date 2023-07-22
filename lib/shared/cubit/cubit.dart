import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/screens/archived_tasks_screen.dart';
import 'package:todo_app/screens/done_tasks_screen.dart';
import 'package:todo_app/screens/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';


class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialState());

  static AppCubit get (context) => BlocProvider.of(context);

  // Bottom nav bar
  int currentIndex  = 0;
  List bodyScreens  = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  void setCurrentIndex(index){
    currentIndex = index;
    emit(AppChangeTaskViewState());
  }

  // bottom sheet
  bool isBottomSheetOpened = false;
  IconData fabIcon  = Icons.edit;
  void setBottomSheetOpenStatus(bool status){
    isBottomSheetOpened = status;
    if(isBottomSheetOpened){
      fabIcon = Icons.add;
    }else{
      fabIcon = Icons.edit;
    }
    emit(AppChangeIsBottomSheetOpenedState());
  }


  // DB and Tasks
  var database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() async {
    // await deleteDatabase('todo.db');
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version){
          print('database created');
          database
              .execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, created_at TEXT, status TEXT)')
              .then((value) {print('tables created successfully');})
              .catchError((error){print('error while creating the tables ${error.toString()}');});
        },
        onOpen: (database){
          print('database opened');
          getTasks(database);
        }
    ).then((value){
      database  = value;
      emit(AppCreateDBState());
    });
  }

  Future insertNewTask({required String? title, required String? date, required String? time}) async {
    await database.transaction((txn) async {
      await txn.rawInsert('insert into tasks (title, created_at, status) values ("$title", "$date  $time", "new")')
          .then((value){
            print('$value task inserted successfully');
            emit(AppInsertIntoDBState());
            emit(AppChangeTaskViewState());
            getTasks(database);
          }).catchError((error){
            print('error while inserting new task ${error.toString()}');
          });
    });
  }

  Future updateTaskStatus({required int id, required String status}) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]
    ).then((value) {
      print('$value task updated successfully');
      emit(AppUpdateDBState());
      getTasks(database);
    }).catchError((error){
      print('error while updating new task ${error.toString()}');
    });
  }

  Future deleteTask({required int id}) async {
    await database.rawUpdate(
          'DELETE FROM tasks WHERE id = ?', [id]
        ).then((value) {
          print('$value task deleted successfully');
          emit(AppDeleteFromDBState());
          getTasks(database);
        }).catchError((error){
          print('error while deleting new task ${error.toString()}');
        });
  }


  Future getTasks(database, {String? status}) async {
    emit(AppLoadDBState());
    newTasks  = [];
    archivedTasks  = [];
    doneTasks  = [];
    await database.rawQuery('SELECT * FROM tasks')
        .then((List<Map> value){
          value.forEach((element) {
            if(element['status'] == 'new'){
              newTasks.add(element);
            }
            else if(element['status'] == 'done'){
              doneTasks.add(element);
            }
            else{
              archivedTasks.add(element);
            }
          });
          emit(AppGetDBState());
        })
        .catchError((error){
          print('error while getting the data ${error.toString()}');
        });
  }
}