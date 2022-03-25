import 'package:flutter/material.dart';

callNext(var className, var context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => className),
  );
}