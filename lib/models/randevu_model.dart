import 'package:flutter/material.dart';

class RandevuModel {
  String? randevuid;
  String? RandevuGun;
  String? RandevuSaat;
  String? islem;
  String? uid;
  bool? onaylandiMi;

  RandevuModel(
      {this.randevuid,
      this.RandevuGun,
      this.RandevuSaat,
      this.islem,
      this.uid,
      this.onaylandiMi});

  factory RandevuModel.fromMap(map) {
    return RandevuModel(
        uid: map['uid'],
        RandevuGun: map['RandevuGun'],
        RandevuSaat: map['RandevuSaat'],
        islem: map['islem'],
        randevuid: map['randevuid'],
        onaylandiMi: map['onaylandiMi']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'RandevuGun': RandevuGun,
      'RandevuSaat': RandevuSaat,
      'islem': islem,
      'randevuid': randevuid,
      'onaylandiMi': onaylandiMi
    };
  }
}
