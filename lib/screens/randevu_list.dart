import 'package:berberozkan/models/randevu_model.dart';
import 'package:berberozkan/models/user_model.dart';
import 'package:berberozkan/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RandevuList extends StatefulWidget {
  const RandevuList({Key? key}) : super(key: key);

  @override
  _RandevuListState createState() => _RandevuListState();
}

class _RandevuListState extends State<RandevuList> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RandevuModel randevuModel = RandevuModel();

  @override
  Widget build(BuildContext context) {
    User? u = _auth.currentUser;
    CollectionReference ref = firebaseFirestore.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: InkResponse(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Text("Geri"),
        ),
      ),
      body: Container(
          child: FutureBuilder<DocumentSnapshot>(
        future: ref.doc(u!.uid).get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            Map<String, dynamic> data =
                asyncSnapshot.data!.data() as Map<String, dynamic>;
            if (data["isAdmin"] == "yes") {
              return Column(
                children: <Widget>[
                  FutureBuilder<QuerySnapshot>(
                      future: ref.where('onaylandiMi', isEqualTo: false).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          Map<String, dynamic> data =
                              asyncSnapshot.data!.docs as Map<String, dynamic>;
                          return Text(data["uid"]);
                        }
                        return Text("z");
                      })
                ],
              );
            }
          }
          return Text("okay");
        },
      )),
    );
  }
}
/*
Future<Widget> userCreden() async {
  
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(u!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new CircularProgressIndicator();
        }
        var document = snapshot.data;
        return Text(document.toString());
      }); 
} */
