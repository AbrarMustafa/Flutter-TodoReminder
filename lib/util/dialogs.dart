import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Dialogs{
  iconDialog(BuildContext context, String description){
    var descriptionBody;

      descriptionBody =new CircleAvatar(
        radius: 100.0,
        maxRadius: 100.0,
        child: new Icon(Icons.adjust),
      );


    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: descriptionBody,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text(description))
                ],
              ),
            ),
          );
        }
    );
  }


  loadingDialog(BuildContext context ,String content){
    var descriptionBody;

    descriptionBody = new Center(
      child: new CircularProgressIndicator(),
    );
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: descriptionBody,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text(content))
                ],
              ),
            ),
          );
        }
    );
  }
}