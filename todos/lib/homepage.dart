import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todos/controller/appcontroller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Creating instance
    AppController appController = Get.put(AppController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ToDo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            //color: Theme.of(context).colorScheme.primary
          ),
        ),
      ),
      body: SafeArea(
          child: Expanded(
        child: Obx(
          () => ListView.builder(
              itemCount: appController.newTask.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Obx(
                        () => InkWell(
                          onTap: () => appController.taskDone(index),
                          child: appController.isDone[index].value
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(appController.newTask[index],
                            style: appController.isDone[index].value
                                ? const TextStyle(
                                    fontSize: 26,
                                    decoration: TextDecoration.lineThrough)
                                : const TextStyle(fontSize: 26)),
                      )
                    ],
                  ),
                  trailing: InkWell(
                      onTap: () => appController.delete(index),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      )),
                );
              }),
        ),
      )),
      floatingActionButton: floatingActionButton(context),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => showMyDialog(context),
        child: const Text(
          "+",
          style: TextStyle(fontSize: 29),
        ));
  }

  void showMyDialog(BuildContext context) {
    TextEditingController addTaskController = TextEditingController();
    AppController appController = Get.put(AppController());
    Get.defaultDialog(
        title: "ADD TASK",
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        content: Column(
          children: [
            TextField(
              controller: addTaskController,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Enter your Task"),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  appController.addTask(addTaskController.text);
                  Fluttertoast.showToast(msg: "Task Added Successfully");
                  //appController.saveList();
                  Navigator.pop(context);
                },
                child: const Text("ADD"))
          ],
        ));
  }
}
