import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttermestutos/entites/tasks.dart';
import 'package:fluttermestutos/persistances/tasks_persistance.dart';

class ListTask extends StatefulWidget {
  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<Task> taskList;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTaskData(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data ==null){
          return Container(
            child: Center(
              child: constSpinLoading(context),
            ),
          );
        }else if(snapshot.data.length ==0){
          return Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width *0.07),
            child: Center(
              child: Text('Pas des tasks, cliquer sur add task'),
            ),
          );
        }else{
          return ListView.builder(

            itemCount: taskList.length,
            itemBuilder: (BuildContext context, int index){
              return Slidable(
                key: ValueKey(taskList[index].index),
                actionPane: SlidableDrawerActionPane(),
                actions: <Widget>[

                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: (){
                      _delete(context, taskList[index], index);
                    },
                  ),
                  IconSlideAction(
                    caption: 'Update',
                    color: Colors.blue,
                    icon: Icons.mode_edit,
                    onTap: (){
                      _update(context, taskList[index], index);
                    },
                  ),
                ],
                dismissal: _slidabledimissal(context, taskList[index], index),

                child: itemTask(context, taskList[index], index),
              );
            },

          );
        }
      },
    );
  }


  Future<List<Task>> getTaskData() async{
    List<Task> listTaskLocal = await getTasks();
    if(listTaskLocal ==null){
      return null;
    }else{
      setState(() {
        taskList = sortBy(listTaskLocal);
      });
      return taskList;
    }
  }

   void _showSnackBar(BuildContext context, String text){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text),));
   }
  Widget constSpinLoading(BuildContext context){
    return SpinKitFadingCube(
      color: Colors.green,
      size: MediaQuery.of(context).size.width *0.1,
    );
  }

  List<Task> sortBy(List<Task> listTaskLocal) {
    listTaskLocal.sort((a,b){
      return a.nom.toLowerCase().compareTo(b.nom.toLowerCase());
    });
    return listTaskLocal;
  }

  itemTask(BuildContext context, Task item, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      title: Text(
        '${item.nom}',
        style: TextStyle(
          decoration: item.isCompleted ==false ?null : TextDecoration.lineThrough
        ),
      ),
      subtitle: item.isCompleted ==false ?null: Text('${item.terminer}'),

      leading: item.isCompleted == false ?
           CircleAvatar(
             child: Icon(
               Icons.school, color: Colors.green,
             ),
           )
          :CircleAvatar(
           foregroundColor: Colors.green,
          backgroundImage: AssetImage('assets/images/success.png'),
      ),
      onLongPress: (){
        _update(context, item, index);
      },
    );
  }

  void _update(BuildContext context, Task item, int index) async{
    List<Task> taskLocal = taskList;
    taskLocal.removeAt(index);
    if(item.isCompleted){
      item.isCompleted = false;
      item.terminer = '';
    }else{
      item.isCompleted = true;
      item.terminer = 'finish task ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}, ${DateTime.now().hour} : ${DateTime.now().minute}';
    }
    taskLocal.add(item);

    bool isSave = await saveTask(taskLocal);
    if(isSave){
      _showSnackBar(context, 'Task update');
    }
  }

  void _delete(BuildContext context, Task item, int index) async{
    List<Task> taskLocal = taskList;
    taskLocal.removeAt(index);

    bool isSave = await saveTask(taskLocal);
    if(isSave){
      _showSnackBar(context, 'Task delete');
    }
  }

  _slidabledimissal(BuildContext context, Task item, int index) {
    return SlidableDismissal(
      child: SlidableDrawerDismissal(),
      closeOnCanceled: true,
      onWillDismiss: (actionType){
        return showDialog<bool>(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Delete'),
              content: Text('Item will be deleted'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: ()=> Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text('Ok'),
                  onPressed: (){
                    _delete(context, item, index);
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }


}


