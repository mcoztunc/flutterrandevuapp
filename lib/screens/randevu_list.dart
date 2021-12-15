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

final navigatorKey = GlobalKey<NavigatorState>();
CollectionReference randevuref =
    FirebaseFirestore.instance.collection('randevu');
List<DocumentSnapshot> dsList = List.empty(growable: true);
List<DocumentSnapshot> userList = List.empty(growable: true);

class _RandevuListState extends State<RandevuList> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RandevuModel randevuModel = RandevuModel();

  @override
  void initState() {
    super.initState();
  }
/*
  getRandevuitems() async {
    await randevuref.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot ds) {
        dsList.add(ds);
        print(ds.data());
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var asd;
    User? u = _auth.currentUser;
    CollectionReference ref = firebaseFirestore.collection('users');
    final snappie =
        FirebaseFirestore.instance.collection("randevu").snapshots();

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
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future: randevuref.get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        dsList = List.empty(growable: true);
                        snapshot.data!.docs.forEach((DocumentSnapshot ds) {
                          dsList.add(ds);
                        });
                        // dsList.forEach((DocumentSnapshot ds){});

                        return Expanded(
                            child: ListView.builder(
                                itemCount: dsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  RandevuModel r =
                                      RandevuModel.fromMap(dsList[index]);

                                  return Column(
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future: ref.doc(r.uid).get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          } else {
                                            userList.add(snapshot.data!);
                                            UserModel us = UserModel.fromMap(
                                                snapshot.data);
                                            return InkWell(
                                              onTap: () {
                                                _onayDialog(
                                                    us.uid.toString(),
                                                    us.numara.toString(),
                                                    us.adSoyad.toString(),
                                                    r.RandevuGun.toString(),
                                                    r.RandevuSaat.toString(),
                                                    r.randevuid.toString(),
                                                    context);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(r.RandevuGun.toString() +
                                                      " - "),
                                                  Text(
                                                      r.RandevuSaat.toString() +
                                                          " - "),
                                                  Text(us.adSoyad.toString() +
                                                      " - "),
                                                  Text(us.numara.toString()),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }));
                      }
                    },
                  ),
                  /* Expanded(
                      child: ListView.builder(
                          itemCount: dsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(dsList[index].data().toString());
                          })),*/
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

void _onayDialog(String uid, String userNo, String userName,
    String randevuTarih, String randevuSaat, String rid, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                    right: -15,
                    top: -15,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: IntrinsicWidth(
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            userName +
                                " " +
                                userNo +
                                " " +
                                randevuTarih +
                                " " +
                                randevuSaat,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            " Randevu onaylansın mı?",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("randevu")
                                        .doc(rid)
                                        .delete();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  },
                                  child: Text("Randevu iptal et"),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("randevu")
                                        .doc(rid)
                                        .update({"onaylandiMi": true});
                                    Navigator.pop(context);
                                  },
                                  child: Text("Randevu Onayla"),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      });
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
