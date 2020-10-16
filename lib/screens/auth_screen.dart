import 'package:cookbook/models/http_exception.dart';
import 'package:cookbook/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/landscape_logo_appname.dart';

enum AuthMode {
  Login,
  Signup,
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffff6200),
                  Color(0xfffdb777).withOpacity(.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (orientation == Orientation.landscape)
                  LandscapeLogoAppName(),
                if (orientation == Orientation.portrait)
                  Image.asset(
                    'assets/images/meal.png',
                    height: 100,
                  ),
                if (orientation == Orientation.portrait)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Welcome to Cookbook',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                AuthCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occured.'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password'])
            .catchError((error) {
          throw error;
        });
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password'])
            .catchError((error) {
          throw error;
        });
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';
      print(error.toString());
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use!';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'The password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with the provided email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid e-mail/password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'There seems to be a problem with the internet connection.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final deviceOrientation = MediaQuery.of(context).orientation;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: _authMode == AuthMode.Signup
            ? (deviceOrientation == Orientation.landscape ? 280 : 340)
            : 280,
        width: deviceSize.width * .75,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    labelText: 'E-mail',
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please provide an email address!';
                    if (RegExp(
                            r'/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/')
                        .hasMatch(value))
                      return 'Please provide a valid email address.';
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            enabled: _authMode == AuthMode.Signup,
                            labelText: 'Re-enter Password',
                            icon: Icon(Icons.refresh)),
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (deviceOrientation == Orientation.landscape)
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: _submit,
                          /*() {
                          Navigator.of(context).pushNamed(TabsScreen.routeName);
                        },*/
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                          textColor: Colors.white,
                        ),
                        FlatButton(
                          onPressed: _switchAuthMode,
                          // textTheme: ButtonTextTheme.accent,
                          child: Text(
                            '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                if (deviceOrientation == Orientation.portrait)
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: _submit,
                      /*() {
                        Navigator.of(context).pushNamed(TabsScreen.routeName);
                      },*/
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      textColor: Colors.white,
                    ),
                if (deviceOrientation == Orientation.portrait)
                  FlatButton(
                    onPressed: _switchAuthMode,
                    // textTheme: ButtonTextTheme.accent,
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
