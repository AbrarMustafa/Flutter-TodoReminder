import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoreminder/data/model/task_model.dart';

class LocalNotify{
  var TRIMSIZE=10000;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  BuildContext context;


  LocalNotify(this.context);

  initialize(){
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification : onSelectNotification);
  }


  Future onSelectNotification(String payload)   {
//    showDialog(
//      context: context,
//      builder: (_) {
//        return new AlertDialog(
//          title: Text("PayLoad"),
//          content: Text("Payload : $payload"),
//        );
//      },
//    );
  }

  Future showNotificationWithDelay(int id, TaskModel task) async{

    int diff=new DateTime.now().compareTo(task.date);
    if(diff<0) {
      id = (id / TRIMSIZE)
          .round(); //must be in 32 bit int other wise notification id fails to add .2^31

      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          task.title, task.title, task.description,
          sound: 'sana',
          importance: Importance.Max,
          priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails(
          presentSound: true,
          sound: "sounds/sonar.aiff");
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//    var scheduledNotificationDateTime = new DateTime.now().add(new Duration(seconds: 5));
      await flutterLocalNotificationsPlugin.schedule(
        id,
        task.title,
        task.description+" : "+task.status.toString(),
        task.date,
        platformChannelSpecifics,
        payload: 'Custom_Sound',
      );
    }
    return null;
  }

  Future removeNotification(int id) async{
    id=(id/TRIMSIZE).round();
    await flutterLocalNotificationsPlugin.cancel(id);
    return null;
  }

}