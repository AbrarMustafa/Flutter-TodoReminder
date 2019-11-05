import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:todoreminder/theme/colors.dart';
import 'package:todoreminder/ui/category/category_page.dart';
import 'package:todoreminder/ui/task/pages/task_form_page.dart';
import 'package:todoreminder/ui/task/pages/task_filtered_page.dart';

class MyDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildDrawerHeader(),
        buildListTile(
          icon: FontAwesomeIcons.plus,
          title: 'Task',
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => TaskFormPage(previousContext: context),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        buildListTile(
          icon: FontAwesomeIcons.star,
          title: 'Important',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => TaskFilteredPage(filterType: 'important'),
              ),
            );
          },
        ),
        buildListTile(
          icon: FontAwesomeIcons.check,
          title: 'Done',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => TaskFilteredPage(filterType: 'done'),
              ),
            );
          },
        ),
        buildListTile(
          icon: FontAwesomeIcons.clock,
          title: 'Later',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => TaskFilteredPage(filterType: 'later'),
              ),
            );
          },
        ),
        buildListTile(
          icon: FontAwesomeIcons.tags,
          title: 'Category',
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => CategoryPage()),
            );
          },
        ),
        // buildListTile(
        //   icon: FontAwesomeIcons.cog,
        //   title: 'Settings',
        //   onTap: () {},
        // ),
        // buildListTile(
        //   icon: FontAwesomeIcons.signOutAlt,
        //   title: 'Logout',
        //   onTap: () {}
        // )
      ],
    );
  }

  Widget buildDrawerHeader() {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              constraints: BoxConstraints.tightFor(
                width: 70,
                height: 70
              ),
//              decoration: BoxDecoration(
//                color: kPrimaryColor,
//                border: Border.all(
//                  width: 5,
//                  color: Color.lerp(kPrimaryColor, Colors.white, 0.5)
//                ),
//                borderRadius: BorderRadius.circular(100)
//              ),
              child: new Image(
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                  image: new AssetImage('assets/logo.png')
              ),
            ),
            Text(
              'Things Todo',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            )
          ],
        )
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
      ),
    );
  }

  Widget buildListTile({ icon, title, onTap }) {
    return ListTile(
      dense: true,
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
