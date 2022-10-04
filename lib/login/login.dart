import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:programmics/map/map_integration.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:
        centerTitle: true,
        title: const Text(
          'Login to continue',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SvgPicture.asset("assets/svg/login.svg"),
          InkWell(
            onTap: () async {
              await loginWithGoogle();
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  "Login with google",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String name = "";
  String email = "";
  loginWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        await auth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ))
            .then((value) {
          setState(() {
            name = value.user!.displayName.toString();
            email = value.user!.email.toString();
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MapIntegration(
                        name: name,
                        email: email,
                      )));
        });

        //   return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'missing google id token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'error aborted by user');
    }
  }
}
