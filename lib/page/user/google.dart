import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/HomeAdmin.dart';
import 'package:flutter_news_app/page/history/histories.dart';
import 'package:flutter_news_app/page/home/news_page.dart';
import 'package:flutter_news_app/page/user/EmailTOtp.dart';
import 'package:flutter_news_app/page/user/login.dart';
import 'package:flutter_news_app/page/user/profile.dart';
import 'package:flutter_news_app/page/user/userauth.dart';
import 'package:flutter_news_app/page/widget/home_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

// Make sure UserAuth is a ChangeNotifier and properly set up for this to work.
// Add your other necessary imports and configurations here.

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserAuth(), // Initialize your UserAuth provider here.
      child: MaterialApp(
        title: 'Google Sign In',
        home: SignInDemo(),
      ),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  const SignInDemo({Key? key}) : super(key: key);

  @override
  State createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  bool _isSigningIn = false;
  int _currentIndex = 0;
  Timer? _signInTimer;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // User is signed in, update your UserAuth state and cancel any pending sign-in attempts
        Provider.of<UserAuth>(context, listen: false).updateUser(account);
        _cancelSignInAttempt();
      }
    });
    _googleSignIn.signInSilently();
    _startSignInAttempt();
  }

  void _startSignInAttempt() {
    if (_currentUser == null && !_isSigningIn) {
      // No user signed in and no sign-in attempt in progress, start the sign-in process
      _signInTimer?.cancel(); // Cancel any existing timer
      _signInTimer = Timer(Duration(seconds: 2), _handleSignIn);
    }
  }

  void _cancelSignInAttempt() {
    _signInTimer?.cancel();
    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  void dispose() {
    _cancelSignInAttempt(); // Cancel any sign-in attempt when the widget is disposed
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_isSigningIn) {
      setState(() {
        _isSigningIn = true;
      });
      try {
        await _googleSignIn.signIn();
        // Handle successful sign-in
      } catch (error) {
        // Handle sign-in error
        print(error);
      } finally {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    // Update your UserAuth state here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Widget _buildBody() {
    if (_isSigningIn) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else
      if (_currentUser != null) {
      GoogleIdentity identity = _currentUser!;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(identity: identity),
            title: Text(_currentUser?.displayName ?? ''),
            subtitle: Text(_currentUser?.email ?? ''),
          ),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startSignInAttempt,
              child: const Text('Sign in with Google'),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
        centerTitle: true,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    bottomNavigationBar: BottomNavigationBar(
      fixedColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: 'Widget',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Personal',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsPage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home_Widget()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Histories()),
            );
            break;
          case 3:

            final userAuth = Provider.of<UserAuth>(context, listen: false);
            if (userAuth.isLoggedIn) {
              final isAdmin = userAuth.userData['isAdmin'] ?? 2;

              if(isAdmin == 1){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(userData: userAuth.userData), // Pass the userData here
                  ),
                );
              }
              else{
                if(isAdmin== 0){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminApp(), // Pass the userData here
                    ),
                  );
                }

              }

              if(isAdmin== 2){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInDemo(), // Pass the userData here
                  ),
                );
              }


            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>Login()),
              );
            }
            break;
        }
      },
    ),
    );
  }



}
