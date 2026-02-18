import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(home: StudentGrid(), debugShowCheckedModeBanner: false));

class StudentGrid extends StatefulWidget {
  @override
  _StudentGridState createState() => _StudentGridState();
}

class _StudentGridState extends State<StudentGrid> {
  List<Map<String, String>> students = [];
  final name = TextEditingController(),
      id = TextEditingController(),
      section = TextEditingController();

  void showAdd() {
    showDialog(
      context: context,
      builder: (_) => Center(
        // Center the dialog
        child: Container(
          width: 320,
          height: 300, // fixed height
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            // Needed for text fields inside Container
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Student",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                buildField(name, "Name"),
                buildField(id, "Student ID"),
                buildField(section, "Section"),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(onPressed: addStudent, child: Text("Add")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController ctrl, String label) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.pink[100],
      ),
    ),
  );

  void addStudent() {
    if (name.text.isEmpty || id.text.isEmpty || section.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill all fields!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    setState(
      () => students.add({
        "name": name.text,
        "id": id.text,
        "section": section.text,
      }),
    );
    name.clear();
    id.clear();
    section.clear();
    Navigator.pop(context); // close dialog
  }

  Color tileColor(int i) {
    List<Color> c = [
      Colors.pink[100]!,
      Colors.orange[100]!,
      Colors.green[100]!,
      Colors.blue[100]!,
    ];
    return c[i % c.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STUDENT MANAGEMENT SYSTEM"),
        backgroundColor: Colors.pink[700],
        centerTitle: true,
      ),
      body: students.isEmpty
          ? Center(child: Text("No Students Details Added"))
          : Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 2,
                ),
                itemCount: students.length,
                itemBuilder: (_, i) {
                  final s = students[i];
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tileColor(i),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s["name"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[900],
                              ),
                            ),
                            Text("ID: ${s["id"]}"),
                            Text("Section: ${s["section"]}"),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                setState(() => students.removeAt(i)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAdd,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[700],
      ),
    );
  }
}
