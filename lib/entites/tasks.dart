class Task{
  String nom;
  String terminer;
  bool isCompleted;
  int index;

  Task(this.nom,this.terminer,this.isCompleted);

  Map toJson() =>{
    'nom':nom,
    'terminer':terminer,
    'isCompleted': isCompleted,
    'index': index,
  };
}