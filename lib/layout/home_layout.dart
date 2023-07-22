import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../components/task_component.dart';

class HomeLayout extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){
          // if(state is AppInsertIntoDBState){
          //   Navigator.pop(context);
          // }
        },
        builder: (context, state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('Todo App'),
            ),
            body: state is! AppLoadDBState ? cubit.bodyScreens[cubit.currentIndex] : buildLoader(),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (value){
                  cubit.setCurrentIndex(value);
                },
                items: const [
                  BottomNavigationBarItem(
                    label: 'New Tasks',
                    icon: Icon(Icons.list),
                  ),
                  BottomNavigationBarItem(
                      label: 'Done Tasks',
                      icon: Icon(Icons.check_circle)
                  ),
                  BottomNavigationBarItem(
                      label: 'Archived Tasks',
                      icon: Icon(Icons.archive)
                  ),
                ]
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomSheetOpened){
                  if(_formKey.currentState!.validate()){
                    cubit.insertNewTask(
                      title: titleController.text!.toString(),
                      date: dateController.text!.toString(),
                      time: timeController.text!.toString()
                    ).then((value){Navigator.pop(context);});
                  }
                }else{
                  _scaffoldKey.currentState?.showBottomSheet((context) => Container(
                      width: double.infinity,
                      color: Colors.grey[100],

                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.title),
                              ),
                              validator: (String? value) {
                                return value!.isEmpty ? "Title can't be empty" : null;
                              },
                            ),

                            const SizedBox(height: 15),

                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.date_range),
                              ),
                              validator: (String? value) {
                                return value!.isEmpty ? "Date can't be empty" : null;
                              },
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 30)),
                                ).then((dynamic? value) {
                                  dateController.text = DateFormat.yMMMd().format(value);
                                });
                              },
                            ),

                            const SizedBox(height: 15),

                            TextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.watch_later_outlined),
                              ),
                              validator: (String? value) {
                                return value!.isEmpty ? "Time can't be empty" : null;
                              },
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now()
                                ).then((dynamic? value) => timeController.text = value?.format(context));
                              },
                            ),
                          ],
                        ),
                      )
                  ),
                    elevation: 20,
                  ).closed.then((value) {
                    cubit.setBottomSheetOpenStatus(false);
                  });

                  cubit.setBottomSheetOpenStatus(true);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
          );
        }
      )
    );
  }
}

