import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationsRepository {
  // static final FirebaseFirestore database = FirebaseFirestore.instance;

  static final CollectionReference exchanges = FirebaseFirestore.instance.collection('exchanges');

  static Future addData({required String exchangeId}) async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    await exchanges.add({
      'exchangeId': exchangeId,
      'fcmToken': fcmToken,
    });

    debugPrint("Added $exchangeId to Firestore");
  }

  static Future deleteData({required String exchangeId}) async {
    exchanges.where("exchangeId", isEqualTo: exchangeId).get().then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });

    debugPrint("Deleted $exchangeId from Firestore");
  }
}
