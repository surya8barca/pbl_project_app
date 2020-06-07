import 'package:flutter/material.dart';

var fieldDecoration = InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 25.0,
                            ));