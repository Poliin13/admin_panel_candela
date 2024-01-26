import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance
      .ref()
      .child("physics_1st_paper");

  // Future<List<String>> fetchListNames() async {
  //   DataSnapshot dataSnapshot = await _databaseReference.once();
  //   Map<dynamic, dynamic> data = dataSnapshot.value;
  //
  //   // Assuming the top-level keys are the names of your lists
  //   List<String> listNames = data.keys.cast<String>().toList();
  //
  //   return listNames;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Names Drawer'),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: _databaseReference.once(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              DataSnapshot dataSnapshot = snapshot.data!.snapshot;
              List<Map<String, dynamic>> listNames =
              (dataSnapshot.key as List<dynamic>)
                  .cast<Map<String, dynamic>>();
              return ListView.builder(
                itemCount: listNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listNames[index] as String),
                    // Add onTap functionality for each list item if needed
                  );
                },
              );
            }
          },
        ),
      ),
      body: Center(
        child: Text('Your App Content Goes Here'),
      ),
    );
  }
}
