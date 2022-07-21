// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'controller/info_controller.dart';
import 'model/info.dart';

class InfoListPage extends StatefulWidget {
  const InfoListPage({Key? key}) : super(key: key);

  @override
  State<InfoListPage> createState() => _InfoListPageState();
}

class _InfoListPageState extends State<InfoListPage> {
  List<Information> infoItems = List<Information>.empty();

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();

    InformationController().getInfoList().then((infoItems) {
      setState(() {
        this.infoItems = infoItems;
      });
    });
  }

  final f = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List"),
      ),
      body: ListView.builder(
        itemCount: infoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: <Widget>[
                const Icon(Icons.person, size: 50.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Name: ${infoItems[index].first_name} ${infoItems[index].last_name}"),
                      Text("Email: ${infoItems[index].email}"),
                    ],
                  ),
                )
              ],
            ),
            subtitle: const Text(""),
          );
        },
      ),
    );
  }
}
