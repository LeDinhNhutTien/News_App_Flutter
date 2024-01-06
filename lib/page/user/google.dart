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
      if (mounted) {
        setState(() {
          _currentUser = account;
        });
      }
      if (_currentUser != null) {
        // User is signed in, update your UserAuth state and cancel any pending sign-in attempts
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (account != null) {
            if (mounted) {
              Provider.of<UserAuth>(context, listen: false).updateUser(account);
              _cancelSignInAttempt();
            }
          }

        });
      }
    });
    _googleSignIn.signInSilently();
    _startSignInAttempt();
  }


  void _startSignInAttempt() {
    if (_currentUser == null && !_isSigningIn) {

      _signInTimer?.cancel();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserAuth>(context, listen: false).setLoggedIn(true, userData: null);
      });

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
    _signInTimer?.cancel(); // Cancel any sign-in attempt when the widget is disposed
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_isSigningIn) {
      if (!mounted) return; // Check if the widget is still in the tree
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
        if (!mounted) return; // Check again if the widget is still in the tree
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<void> _handleSignOut() async {

    await _googleSignIn.disconnect();
    // Update your UserAuth state here
    Provider.of<UserAuth>(context, listen: false).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
  Widget _buildBody() {
    final userAuth = Provider.of<UserAuth>(context, listen: false);

    if (_isSigningIn) {
      return Center(child: CircularProgressIndicator());
    } else if (userAuth.isLoggedIn) {
      // Access the user information from the UserAuth provider.
      final user = userAuth.user; // This should be the user data you set in UserAuth after sign-in.
      if (user != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            ListTile(
              leading: user.googleIdentity != null ? GoogleUserCircleAvatar(identity: user.googleIdentity!) : null,
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email ?? ''),
            ),
            ElevatedButton(
              onPressed: _handleSignOut,
              child: const Text('SIGN OUT'),
            ),
          ],
        );
      }
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

    return SizedBox.shrink();
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
      initState();
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
