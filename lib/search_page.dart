import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:search_test/new_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _pres = TextEditingController();
  String searchString;
  @override
  void initState() {
    super.initState();
    Future res = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("Search Presidents"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _pres,
              decoration: InputDecoration(
                  hintText: "President Name",
                  contentPadding: EdgeInsets.all(10)),
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () {
                _addToDatabase(_pres.text);
              },
              child: Text(
                "Add to Database",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchString = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream:
                            (searchString == null || searchString.trim() == "")
                                ? FirebaseFirestore.instance
                                    .collection('presidents')
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('presidents')
                                    .where("searchIndex",
                                        arrayContains: searchString)
                                    .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                              break;
                            default:
                              return new ListView(
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  return new ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: NewScreen(),
                                              type: PageTransitionType.fade));
                                    },
                                    title: new Text(document['name']),
                                  );
                                }).toList(),
                              );
                          }
                        }))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

Future _addToDatabase(String name) async {
  await Firebase.initializeApp();
  List<String> splitList = name.split(" ");
  List<String> indexList = [];
  for (int i = 0; i < splitList.length; i++) {
    for (int y = 1; y < splitList[i].length + 1; y++) {
      indexList.add(splitList[i].substring(0, y).toLowerCase());
    }
  }

  print(indexList);
  FirebaseFirestore.instance
      .collection('presidents')
      .doc()
      .set({'name': name, 'searchIndex': indexList});
}
