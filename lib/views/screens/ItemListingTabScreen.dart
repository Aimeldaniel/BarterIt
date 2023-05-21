import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../myconfig.dart';

class ItemListingTabScreen extends StatefulWidget {
  const ItemListingTabScreen({super.key});

  @override
  State<ItemListingTabScreen> createState() => _ItemListingTabScreenState();
}

class _ItemListingTabScreenState extends State<ItemListingTabScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("ItemListingTab"),);
  }

  
}