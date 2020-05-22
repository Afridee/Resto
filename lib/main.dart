import 'package:project_resto/Screens/Records.dart';
import 'package:flutter/material.dart';
import 'package:project_resto/Screens/login_screen.dart';
import 'package:project_resto/Screens/resetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: login_page(),
  )
);