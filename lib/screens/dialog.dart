import 'dart:developer';

import 'package:berberozkan/models/randevu_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class actionButtonDialog extends StatefulWidget {
  const actionButtonDialog({Key? key}) : super(key: key);

  @override
  _actionButtonDialogState createState() => _actionButtonDialogState();
}

class _actionButtonDialogState extends State<actionButtonDialog> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  late int randevubaslangic = 9;
  late int randevubitis = 20;
  Future<TimeOfDay> asd() async {
    await RandevuTime(randevubaslangic, randevubitis);
    throw ('done');
  }

  static final Map<String, String> sacSakalMap = {
    'sac': 'Saç',
    'sakal': 'Sakal',
    'sacsakal': 'Saç + Sakal',
  };
  late DateTime pickedDate;

  late String hangiGun = "Gün Seçiniz";
  String _selectedSacSakal = sacSakalMap.keys.first;
  String formattedDate = "";
  List<TimeOfDay> TimeList = [];
  late TimeOfDay dropdownvalue;
  var loading = false;
  @override
  void initState() {
    asd().then((value) => {setState(() {})});
    dropdownvalue = TimeList[0];
    super.initState();
    pickedDate = DateTime.now();
  }

  DateTime when = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
              right: -40,
              top: -40,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              )),
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text('İşlem Seçiniz',
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontSize: 15.0,
                      )),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),
                  CupertinoRadioChoice(
                      choices: sacSakalMap,
                      onChange: sacSakalSelected,
                      initialKeyValue: _selectedSacSakal),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Gün Seçiniz',
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontSize: 15.0,
                      )),
                  ListTile(
                    title: Text(
                        "${pickedDate.day}/${pickedDate.month} ${hangiGun}"),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: when,
                        firstDate: DateTime(DateTime.now().day - 1),
                        lastDate: DateTime(
                            DateTime.now().year + DateTime.now().day + 7),
                      );

                      if (picked != null) {
                        int cases;
                        setState(() {
                          when = picked;
                          pickedDate = picked;
                          formattedDate =
                              DateFormat('dd/MM/yyyy').format(picked);
                          cases = when.weekday;
                          switch (cases) {
                            case 1:
                              hangiGun = "Pazartesi";
                              break;
                            case 2:
                              hangiGun = "Salı";
                              break;
                            case 3:
                              hangiGun = "Çarşamba";
                              break;
                            case 4:
                              hangiGun = "Perşembe";
                              break;
                            case 5:
                              hangiGun = "Cuma";
                              break;
                            case 6:
                              hangiGun = "Cumartesi";
                              break;
                            case 7:
                              hangiGun = "Pazar";
                              break;
                            default:
                              break;
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Randevu Saatini Seçiniz',
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontSize: 15.0,
                      )),
                  DropdownButton<TimeOfDay>(
                    hint: const Text('Randevu saatini seçiniz'),
                    value: dropdownvalue,
                    items: TimeList.map((TimeOfDay vvalue) {
                      return DropdownMenuItem<TimeOfDay>(
                          child: Text("${vvalue.format(context)}"),
                          value: vvalue);
                    }).toList(),
                    onChanged: (TimeOfDay? value) {
                      setState(() {
                        if (value != null) dropdownvalue = value;
                      });

                      /*
                      switch (_selectedSacSakal) {
                        case "Saç":
                          
                          break;
                        case "Sakal":
                          break;
                        case "Saç + Sakal":
                          break;
                      }  */
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MaterialButton(
                          elevation: 5,
                          color: Colors.blueAccent,
                          child: Text('Randevu Al'),
                          onPressed: () async {
                            if (pickedDate == null || dropdownvalue == null) {
                              Fluttertoast.showToast(
                                  msg: "Randevu gün ve saatini seçiniz");
                            } else {
                              await PosttoFirestore();

                              Fluttertoast.showToast(
                                  msg: "Randevu başarıyla oluşturuldu");
                              Navigator.of(context).pop();
                            }
                          }),
                      MaterialButton(
                          elevation: 5,
                          color: Colors.red,
                          child: Text('İptal'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  void sacSakalSelected(String asd) {
    setState(() {
      _selectedSacSakal = asd;
    });
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().month),
        lastDate: DateTime(DateTime.now().day + 7));

    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  Future<void> RandevuTime(int baslangic, int bitis) async {
    for (int i = baslangic; i < bitis; i++) {
      TimeOfDay t = TimeOfDay(hour: i, minute: 0);
      TimeList.add(t);
      t = TimeOfDay(hour: i, minute: 30);
      TimeList.add(t);
    }
    setState(() {});
  }

  PosttoFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;
    RandevuModel randevuModel = RandevuModel();
    randevuModel.uid = user!.uid;
    randevuModel.islem = _selectedSacSakal;
    randevuModel.RandevuGun = formattedDate;
    randevuModel.RandevuSaat = "${dropdownvalue.format(context)}";
    randevuModel.onaylandiMi = false;
    DocumentReference ref = firebaseFirestore.collection("randevu").doc();
    randevuModel.randevuid = ref.id;

    await firebaseFirestore
        .collection("randevu")
        .doc(randevuModel.randevuid)
        .set(randevuModel.toMap());
  }
}
