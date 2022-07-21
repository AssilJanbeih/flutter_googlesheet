// ignore_for_file: constant_identifier_names

import 'dart:convert' as convert;
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../model/info.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class InformationController {
  // Google App Script Web URL.
  static const String URL =
      ""; // Pass your own generated Web App url from App Script

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitInfo(Information info, void Function(String) callback) async {
    try {
      await http
          .post(Uri.parse(URL), body: info.toJson())
          .then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(Uri.parse(url.toString())).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<Information>> getInfoList() async {
    /////Advanced Tip: if a specific is needed to be send in our get function then replace the below URL with
    /////// example: http.get(Uri.parse(URL + "?name=" + userName))
    /// where userName is a string passed in getinfoList param : getInfoList(String userName)
    return await http.get(Uri.parse(URL)).then((response) {
      //In Appscript we initialized data = [], this is why we are checking the response output
      if (response.body.toString() != "[]") {
        var jsonFeedback = convert.jsonDecode(response.body) as List;
        return jsonFeedback.map((json) => Information.fromJson(json)).toList();
      }
      // if the response was empty, then we will return an empty list.
      else {
        List<Information> infoList = [];
        return infoList;
      }
    });
  }
}
