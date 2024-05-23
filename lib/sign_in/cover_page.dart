import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sample_auth/sign_in/sign_in.dart';

class CoverPage extends StatefulWidget {
  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  bool _isLoading = false;

  void _navigateToSignIn() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for the loading animation, then navigate
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).push(_createRoute()).then((_) {
        setState(() {
          _isLoading =
              false; // Reset the loading state if user returns to this page
        });
      });
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SignIn(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lottie animation background
          Lottie.asset(
            'assets/animations/BG.json',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/Cog.png'),
                ),
                SizedBox(height: 60),
                _isLoading
                    ? Lottie.asset('assets/animations/loading.json')
                    : ElevatedButton(
                        onPressed: _navigateToSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 32, 10, 51),
                          foregroundColor:
                              const Color.fromARGB(255, 254, 255, 255),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
