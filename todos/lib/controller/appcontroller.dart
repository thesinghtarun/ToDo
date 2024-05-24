import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  RxList<String> newTask = <String>[].obs;
  RxList<RxBool> isDone = <RxBool>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void addTask(String task) {
    if (task.isNotEmpty) {
      newTask.add(task);
      saveList();
      isDone.add(false.obs);
    }
  }

  void taskDone(int index) {
    isDone[index].value = !isDone[index].value;
    saveList();
  }

  void delete(int index) {
    if (index < newTask.length && index < isDone.length) {
      newTask.removeAt(index);
      isDone.removeAt(index);
      saveList();
    }
  }

  Future<void> saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listString = jsonEncode(newTask);
    String isDoneListString =
        jsonEncode(isDone.map((done) => done.value).toList());
    await prefs.setString('myList', listString);
    await prefs.setString('isDoneList', isDoneListString);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listString = prefs.getString('myList');
    String? isDoneListString = prefs.getString('isDoneList');
    if (listString != null && isDoneListString != null) {
      List<dynamic> decodedList = jsonDecode(listString);
      List<dynamic> decodedIsDoneList = jsonDecode(isDoneListString);
      newTask.value = decodedList.cast<String>();
      isDone.value = decodedIsDoneList.map((done) => RxBool(done)).toList();
    }
  }
}
