import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/image_picker.dart';

enum AuthMode { signUp, login }

class AuthScreenForm extends StatefulWidget {
  const AuthScreenForm(this.submit, this.isLoading, {super.key});
  final void Function(
    String name,
    String email,
    String password,
    bool isLogin,
    File? image,
    BuildContext ctx,
  ) submit;
  final bool isLoading;

  @override
  State<AuthScreenForm> createState() => _AuthScreenFormState();
}

class _AuthScreenFormState extends State<AuthScreenForm> {
  AuthMode _authmode = AuthMode.login;
  final _key = GlobalKey<FormState>();
  Map<String, String> userData = {
    'name': '',
    'email': '',
    'password': '',
  };
  File? image;

  void _pickedImage(File img) {
    image = img;
  }

  void submitForm(BuildContext ctx) {
    final isvalid = _key.currentState!.validate();
    if (image == null && _authmode == AuthMode.signUp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    if (isvalid) {
      _key.currentState!.save();
      widget.submit(
          userData['name'].toString().trim(),
          userData['email'].toString().trim(),
          userData['password'].toString().trim(),
          _authmode == AuthMode.login ? true : false,
          image,
          ctx);
    }
  }

  void _switchAuthMode() {
    if (_authmode == AuthMode.login) {
      setState(() {
        _authmode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authmode = AuthMode.login;
      });
    }
    _key.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: _authmode == AuthMode.signUp ? 450 : 350,
      width: 280,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_authmode == AuthMode.signUp)
                    ImagePickerFile(_pickedImage),
                  if (_authmode == AuthMode.signUp)
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          label: Text(
                        'Name',
                        style: TextStyle(color: Colors.grey),
                      )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        } else if (value.length < 6) {
                          return 'Name should be atleast 6 digits.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        userData['name'] = newValue.toString();
                      },
                    ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        label: Text(
                      'Email',
                      style: TextStyle(color: Colors.grey),
                    )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      userData['email'] = newValue.toString();
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        label: Text(
                      'Password',
                      style: TextStyle(color: Colors.grey),
                    )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password should be atleast 6 digits.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      userData['password'] = newValue.toString();
                    },
                  ),
                  SizedBox(
                    height: _authmode == AuthMode.login ? 75 : 20,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        submitForm(context);
                      },
                      child: _authmode == AuthMode.login
                          ? const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  TextButton(
                      onPressed: () {
                        _switchAuthMode();
                      },
                      child: _authmode == AuthMode.login
                          ? const Text('Not a member? Sign Up.')
                          : const Text('Already a user? Login.'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
