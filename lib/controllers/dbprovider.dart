import 'package:flutter/widgets.dart';
import 'package:to_do_app/models/db_helper.dart';

class DBProvider extends ChangeNotifier {
  DbHelper? dbRef;
  DBProvider({required this.dbRef});
  List<Map<String, dynamic>> _mData = [];

  void addNotes(String mtitle, String mdesc) async {
    bool check = await dbRef!.addTask(mTask: mtitle, mDesc: mdesc);
    if (check) {
      _mData = await dbRef!.getAllTasks();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getNotes() => _mData;

  void getInitialNotes() async {
    _mData = await dbRef!.getAllTasks();
    notifyListeners();
  }

  void updateNote(String mtitle, String mdesc, int sno) async {
    bool check =
        await dbRef!.updateTask(mTask: mtitle, mDesc: mdesc, s_no: sno);
    if (check) {
      _mData = await dbRef!.getAllTasks();
      notifyListeners();
    }
  }

  void deleteNote(int sno) async {
    bool check = await dbRef!.deleteTask(sno: sno);
    if (check) {
      _mData = await dbRef!.getAllTasks();
      notifyListeners();
    }
  }
}
