import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/views/bottom_sheet.dart';
import 'package:to_do_app/models/db_helper.dart';
import 'package:to_do_app/controllers/dbprovider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CustomBottomSheet bottomSheet = CustomBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title:
            Text("ToDo List 📝", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 5,
      ),
      body: Consumer<DBProvider>(
        builder: (ctx, provider, __) {
          ctx.read<DBProvider>().getInitialNotes();
          List<Map<String, dynamic>> allTasks = provider.getNotes();

          return allTasks.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: allTasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            allTasks[index][DbHelper.COLUMN_TASK],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            allTasks[index][DbHelper.COLUMN_DESC],
                            style: TextStyle(color: Colors.black54),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  taskController.text =
                                      allTasks[index][DbHelper.COLUMN_TASK];
                                  descriptionController.text =
                                      allTasks[index][DbHelper.COLUMN_DESC];
                                  bottomSheet.getBottomSheet(context,
                                      taskController, descriptionController,
                                      isUpdate: true,
                                      sno: allTasks[index]
                                          [DbHelper.COLUMN_S_NO]);
                                },
                                icon:
                                    Icon(Icons.edit, color: Colors.blueAccent),
                              ),
                              IconButton(
                                onPressed: () async {
                                  context.read<DBProvider>().deleteNote(
                                      allTasks[index][DbHelper.COLUMN_S_NO]);
                                },
                                icon:
                                    Icon(Icons.delete, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "No Tasks Yet",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Tap + to add a new task",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 5,
        onPressed: () async {
          taskController.clear();
          descriptionController.clear();
          bottomSheet.getBottomSheet(
              context, taskController, descriptionController);
        },
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
