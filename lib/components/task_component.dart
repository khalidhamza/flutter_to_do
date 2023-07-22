import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTasksListView({required BuildContext context, required List<Map> tasks}){
  return tasks.isNotEmpty ?
    ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(context, tasks[index]),
      separatorBuilder: (context, index) => buildLineSeparator(),
      itemCount: tasks.length
    ) :
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.list,
            color: Colors.grey,
            size: 50,
          ),
          Text(
              'No Tasks Found',
            style: TextStyle(
              fontSize: 18
            ),
          ),
        ],
      ),
    );
}

Widget buildTaskItem(BuildContext context, Map task){
  AppCubit cubit = AppCubit.get(context);
  var datetime = task['created_at'].toString().split('  ');
  var newTasksIcon = const Icon(Icons.list, color: Colors.blue, size: 30);
  var doneTasksIcon = const Icon(Icons.check_circle, color: Colors.green, size: 30);
  var archivedTasksIcon = const Icon(Icons.archive, color: Colors.redAccent, size: 30);
  List<Map> actions = [];
  if(task['status'] == 'new'){
    actions.add({'icon': doneTasksIcon, 'status': 'done'});
    actions.add({'icon': archivedTasksIcon, 'status': 'archived'});
  }

  else if(task['status'] == 'done'){
    actions.add({'icon': newTasksIcon, 'status': 'new'});
    actions.add({'icon': archivedTasksIcon, 'status': 'archived'});
  }

  else {
    actions.add({'icon': newTasksIcon, 'status': 'new'});
    actions.add({'icon': doneTasksIcon, 'status': 'done'});
  }

  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction){
      cubit.deleteTask(id: task['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(datetime.asMap().containsKey(1) ? datetime[1] : ''),
          ),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'].toString(), style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )),
                Text(datetime[0], style: const TextStyle(
                    color: Colors.grey
                )),
              ],
            ),
          ),
          const SizedBox(width: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (){
                  cubit.updateTaskStatus(id: task['id'], status: actions[0]['status']);
                },
                icon: actions[0]['icon'],
              ),
              IconButton(
                onPressed: (){
                  cubit.updateTaskStatus(id: task['id'], status: actions[1]['status']);
                },
                icon: actions[1]['icon'],
              ),
            ],
          ),

        ],
      ),
    ),
  );
}

Widget buildLineSeparator(){
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 20),
    child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    ),
  );
}

Widget buildLoader(){
  return const Center(
    child: CircularProgressIndicator(),
  );
}