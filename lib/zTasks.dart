/*


class ZTasks extends StatefulWidget {

  List<String> taskList;
  List<String> subtitleList;
  List<String> isCheckedList;
  List<String> isTodayList;

  ZTasks(this.taskList, this.subtitleList, this.isCheckedList, this.isTodayList,
     {super.key});

  void saveToFireStore() {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      CollectionReference users = FirebaseFirestore.instance.collection(
          'users');
      users.where('email', isEqualTo: userEmail).get().then((value) {
        value.docs.forEach((element) {
          users.doc(element.id).update({
            'taskList': zTasks.taskList,
            'subtitleList': zTasks.subtitleList,
            'isCheckedList': zTasks.isCheckedList,
            'isTodayList': zTasks.isTodayList,
          });
        });
      });
    }
  }

  void add(String task, String subtitle, bool isChecked, bool isToday) {
    zTasks.taskList.add("New Task");
    zTasks.subtitleList.add("#default");
    zTasks.isCheckedList.add(isChecked.toString());
    zTasks.isTodayList.add(isToday.toString());
    saveToFireStore();
  }

  void delete(int index) {
    zTasks.taskList.removeAt(index);
    zTasks.subtitleList.removeAt(index);
    zTasks.isCheckedList.removeAt(index);
    zTasks.isTodayList.removeAt(index);
  }

  void updateAt(String task, String subtitle, bool isChecked, bool isToday, int index) {
    zTasks.taskList[index] = task;
    zTasks.subtitleList[index] = subtitle;
    zTasks.isCheckedList[index] = isChecked.toString();
    zTasks.isTodayList[index] = isToday.toString();
  }



  @override
  State<ZTasks> createState() => ZTasksState();

}
class ZTasksState extends State<ZTasks> {


  initState() {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null) {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      users
          .where('taskListLength', isGreaterThan: 0)
          .get()
          .then((QuerySnapshot querySnapshot) =>
      {
        querySnapshot.docs.forEach((doc) async {
          if (doc['email'] == userEmail) {
            widget.taskList = doc['taskList'].cast<String>();
            widget.subtitleList = doc['subtitleList'].cast<String>();
            widget.isCheckedList = doc['isCheckedList'].cast<String>();
            widget.isTodayList = doc['isTodayList'].cast<String>();
          }
        })
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();



  }

}


*/