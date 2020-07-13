import 'package:flutter/material.dart';
import 'package:fluttermestutos/entites/tasks.dart';
import 'package:fluttermestutos/persistances/tasks_persistance.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final TextEditingController _controllerText =  TextEditingController();
  String text ='';

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

  _saveTask(BuildContext context) async {
    if(text.isNotEmpty){
      Task t = Task(text,'',false);
      List<Task> listTaskLocal = await getTasks();
      listTaskLocal.add(t);

      bool isSave   =  await saveTask(listTaskLocal);
      if(isSave){
        setState(() {
          _controllerText.clear();
          text = '';
        });
        _showSnackBar(context, 'Task save');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controllerText,
            onChanged: (value){
              setState(() {
                text = value;
              });
            },
            cursorColor: Colors.red,
            decoration: InputDecoration(
              icon: Icon(
                Icons.mode_edit,
                color: Colors.black,
              ),
              hintText: 'Add Task',
              border: InputBorder.none,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text('Sauvegarder',
                   style: TextStyle(
                     color: Colors.white
                   ),
                  ),
                  onPressed: (){
                    _saveTask(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String s) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(s, style: TextStyle(color: Colors.white),),));
  }
}
