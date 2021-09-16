import 'package:flutter/material.dart';
import 'package:vigidas_pack/components/top-title.dart';
import 'package:provider/provider.dart';
import 'package:vigidas_pack/constants.dart';
import 'package:vigidas_pack/models/current-task.dart';
import '../models/tasks-provider.dart';
import '../components/task-card.dart';

class TasksScreen extends StatefulWidget {
  static const String id = 'tasks';
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TasksProvider>(context).initTasks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopTitle('Please, select task'),
                Expanded(
                  child: TasksList(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, data, child) {
        return RefreshIndicator(
          color: kColorGray54,
          onRefresh: () async {
            await Provider.of<TasksProvider>(context, listen: false)
                .setDatabaseSnapshot();
            Provider.of<TasksProvider>(context, listen: false).initTasks(true);
          },
          child: data.tasksLen > 0
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
                  itemCount: data.tasksLen,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      data.getTasks[index].title,
                      data.getTasks[index].container,
                      data.getTasks[index].date,
                      data.getTasks[index].time,
                      data.getTasks[index].isDone,
                      () => {CurrentTask.selectedTask = data.getTasks[index]},
                      data.getTasks[index].id,
                    );
                  },
                )
              : ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Center(
                          child: Text(
                            'No tasks found\n\nPull screen down to refresh\nOr choose other measurement and length',
                            style: kTextSTyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
