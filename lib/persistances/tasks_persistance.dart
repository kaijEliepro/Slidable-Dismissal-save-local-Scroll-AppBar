
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttermestutos/entites/tasks.dart';


Future<bool> saveTask(List<Task> tabTasks) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('jsonTasks', jsonEncode(tabTasks));
}

getTasks()async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String jsonString = prefs.get('jsonTasks');

  if(jsonString !=null && jsonString.isNotEmpty){
    var jsonData = json.decode(jsonString);
    List <Task> listTasks =[];
    int i =0;

    for(var emp in jsonData){
      Task task = Task(emp['nom'],emp['terminer'],emp['isCompleted']);
      task.index = i;

      listTasks.add(task);
    }
    return listTasks;
  }else{
    List<Task> listVide =[];
    return listVide;
  }
}