import 'package:berberozkan/models/user_model.dart';
import 'package:berberozkan/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final adSoyadEditingController = new TextEditingController();
  final mailEditingController = new TextEditingController();
  final numaraEditingController = new TextEditingController();
  final sifreEditingController = new TextEditingController();
  final sifreTekrarEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //adsoyad
    final adSoyadField = TextFormField(
      autofocus: false,
      controller: adSoyadEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Bu alan boş bırakılamaz");
        }
        if (!regex.hasMatch(value)) {
          return ("İsminizi giriniz");
        }
      },
      onSaved: (value) {
        adSoyadEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_outline_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Ad Soyad ",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final telefonField = TextFormField(
      autofocus: false,
      controller: numaraEditingController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
        if (value!.isEmpty) {
          return ("Numarayı Giriniz");
        }
        if (!regex.hasMatch(value)) {
          return ("Geçerli bir telefon numarası giriniz");
        }
        return null;
      },
      onSaved: (value) {
        numaraEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.smartphone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Telefon no ",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //email
    final emailField = TextFormField(
      autofocus: false,
      controller: mailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Lütfen email adresinizi giriniz");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Lütfen geçerli bir mail adresi giriniz");
        }
        return null;
      },
      onSaved: (value) {
        mailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: sifreEditingController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Şifre giriniz");
        }
        if (!regex.hasMatch(value)) {
          return ("Şifre en az 6 karakter olmalıdır");
        }
      },
      onSaved: (value) {
        sifreEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: sifreTekrarEditingController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (sifreEditingController.text != value) {
          return ("Şifreler aynı değil");
        }
        return null;
      },
      onSaved: (value) {
        sifreTekrarEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifre Tekrar",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          signUp(mailEditingController.text, sifreEditingController.text);
        },
        child: Text(
          "Kayıt ol",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        minWidth: MediaQuery.of(context).size.width,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Container(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/logo1.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    adSoyadField,
                    SizedBox(
                      height: 25,
                    ),
                    telefonField,
                    SizedBox(
                      height: 25,
                    ),
                    emailField,
                    SizedBox(
                      height: 25,
                    ),
                    passwordField,
                    SizedBox(
                      height: 25,
                    ),
                    confirmPasswordField,
                    SizedBox(
                      height: 35,
                    ),
                    loginButton,
                    SizedBox(
                      height: 15,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.adSoyad = adSoyadEditingController.text;
    userModel.numara = numaraEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Kullanıcı başarıyla oluşturuldu");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
