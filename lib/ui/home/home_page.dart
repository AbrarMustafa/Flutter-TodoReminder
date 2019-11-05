import 'dart:async';

//import 'package:firebase_admob/firebase_admob.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:todoreminder/firebase_Helper.dart';
import 'package:todoreminder/page_update_version.dart';

import 'package:todoreminder/ui/task/tab_view/daily_task.dart';
import 'package:todoreminder/ui/task/tab_view/monthly_task.dart';
import 'package:todoreminder/ui/task/tab_view/weekly_task.dart';
import 'package:todoreminder/ui/widget/my_drawer.dart';
import 'package:todoreminder/ui/widget/search/search_bar.dart';
import 'package:todoreminder/ui/widget/app_bar/my_sliver_app_bar.dart';
import 'package:todoreminder/util/appconst.dart';
import 'dart:io';

import 'package:todoreminder/util/dialogs.dart';


class HomePage extends StatefulWidget {
  static final String route = '/';

  @override
  HomePageState createState() => HomePageState();

  @override
  void dispose() {
    myBanner?.dispose();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isScrolled = false;
  TabController tabController;
  FireBase_Helper firebaseHelper;
  @override
  initState() {
    super.initState();
    firebaseHelper = new  FireBase_Helper.initalize();

    isScrolled = false;
    tabController = new TabController(
      vsync: this,
      length: 3
    );
    firebaseHelper.init().then((nothing){
      isUpdateReq();
    });

    setupAdmob_Ads();
  }



  void setupAdmob_Ads() {
    FirebaseAdMob.instance.initialize(appId: Platform.isIOS?APP_ID_IOS:APP_ID_ANDROID);


//    loadAdInstertialAdmob();
//    loadAdInstertialFB();

//    if(!isAdsShowed) {
//      reloadAdTimer = Timer.periodic(Duration(seconds: 10), (Timer t) => refetchAd(context));
//    }
  }
  void refreshUI( ){
    setState((){
    });
  }


  isUpdateReq()  {
    firebaseHelper.queryVersion().then((documentSnapshot){
      if (documentSnapshot.exists) {
        PackageInfo.fromPlatform().then((packageInfo){
          String versionName = packageInfo.version;
          String versionCode = packageInfo.buildNumber;

          if (documentSnapshot.data[UPDATENOW]==true &&
              ((Platform.isIOS &&versionCode!=documentSnapshot.data[VERSIONIOS].toString()) || (Platform.isAndroid &&versionName!=documentSnapshot.data[VERSIONANDROID].toString()))
          ){
            Route route = MaterialPageRoute(builder: (context) => UpdateScreen());
            Navigator.of(context).push(route);
          }
        });
      }

    });

  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification.depth == 1) {
      if (tabController.index == 0) {
        final double pixels = notification.metrics.pixels;
        final bool elevated = pixels > 0 ? true : false;

        if (elevated != isScrolled) {
          setState(() {
            isScrolled = elevated;
          });
        }
      }
    } else {
      if (isScrolled != false) {
        setState(() {
          isScrolled = false;
        });
      }
    }

    return true;
  }

  Widget build(BuildContext context) {
    // TabBar View Builder
    final tabbarViewBuilder = (view) => SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return view;
        },
      ),
    );

    // build
    return Scaffold(

      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Expanded(
            flex: 12,
              child: CustomScrollView(
                slivers: <Widget>[
                  buildSliverAppBar(context),
                  SliverFillRemaining(
                      child: NotificationListener(
                        onNotification: onNotification,
                        child: TabBarView(
                          controller: tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            tabbarViewBuilder(DailyTaskView()),
                            tabbarViewBuilder(WeeklyTaskView()),
                            tabbarViewBuilder(MonthlyTaskView()),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            Expanded(
            flex: 1,
            child:
              ISSHOWADMOBBANNER?loadAdBannerAdmob(refreshUI):loadAdBannerFB()
            )
          ]);
        },
      )
    );
  }

  Widget buildSliverAppBar(BuildContext context) {
     // TabBar
    final tabBar = PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Column(
        children: <Widget>[
          SearchBar(),
          TabBar(
            controller: tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: <Widget>[
              Tab(text: 'DAILY'),
              Tab(text: 'WEEKLY'),
              Tab(text: 'MONTHLY'),
            ],
          )
        ],
      ),
    );

    return MySliverAppBar(
      context: context,
      pinned: true,
      bottom: tabBar,
      titleSpacing: 0,
      forceElevated: isScrolled,
    );
  }
}

//-------------------------- ads FB------------------------------
bool fbInterstetialloaded=false;
loadAdBannerFB() {
  return Container(
    alignment: Alignment(0.5, 1),
    child: FacebookBannerAd(
      placementId: Platform.isIOS?PLACEMENTID_FBBANNER_IOS:PLACEMENTID_FBBANNER_ANDROID,
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Error: $value");
            break;
          case BannerAdResult.LOADED:
            print("Loaded: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Clicked: $value");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Logging Impression: $value");
            break;
        }
      },
    ),
  );
}
loadAdInstertialFB()
{
  FacebookInterstitialAd.loadInterstitialAd(
    placementId: Platform.isIOS?PLACEMENTID_FBINTERSTETIAL_IOS:PLACEMENTID_FBINTERSTETIAL_ANDROID,
    listener: (result, value) {
      if (result == InterstitialAdResult.LOADED)
        fbInterstetialloaded=true;
    },
  );
}
//-------------------------- ads ADMOB------------------------------


bool admobInterstetialloaded=false;
double paddingValue;
BannerAd myBanner;
InterstitialAd myInterstitialAdmob;
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
);



Widget loadAdBannerAdmob(refreshUI) {
  myBanner = BannerAd(
    adUnitId:Platform.isIOS?ADS_ID_BANNER_IOS:ADS_ID_BANNER_ANDROID,// BannerAd.testAdUnitId,
    size: AdSize.banner,

    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      if(event==MobileAdEvent.loaded)
        paddingValue=AdSize.banner.height.toDouble();//Theme.of(context).platform == TargetPlatform.iOS?80.0:60.0;
      else
        paddingValue=0.0;
      refreshUI;
      print("BannerAd event is $event");
    },
  );
  myBanner
  // typically this happens well before the ad is shown
    ..load()
    ..show(
      // Positions the banner ad 60 pixels from the bottom of the screen
      anchorOffset: 0.0,
      // Banner Position

      anchorType: AnchorType.bottom,
    );
  return new Container();
}
void loadAdInstertialAdmob() {
  myInterstitialAdmob = InterstitialAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: Platform.isIOS?ADS_ID_INTERSTETIAL_IOS:ADS_ID_INTERSTETIAL_ANDROID,// InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      admobInterstetialloaded=event==MobileAdEvent.loaded;
      print("InterstitialAd event is $event");
    },
  );

}



//-------------------------- SHOWING ADS------------------------------//
Timer loadingDialogTimer;
bool isAdsShowed=false;
Timer reloadAdTimer;

refetchAd(BuildContext context){

  if((!ISSHOWADMOBINTERSTETIAL&&fbInterstetialloaded)||(ISSHOWADMOBINTERSTETIAL&&admobInterstetialloaded)){
    showDialogForInterstetial(reloadAdTimer,context);
  }
  else
  {
    loadAdInstertialAdmob();
    loadAdInstertialFB();
  }

}

void showDialogForInterstetial(Timer timer, BuildContext context) {
  new Dialogs().loadingDialog(context, ".Fetching Ad.");
  adsDisplay(context);
  timer.cancel();
}

void adsDisplay(BuildContext context) {

  loadingDialogTimer = new Timer(const Duration(seconds: 1), () {
    Navigator.pop(context);
    if(ISSHOWADMOBINTERSTETIAL)
      myInterstitialAdmob.show(anchorType: AnchorType.bottom, anchorOffset: 0.0,);
    else
      FacebookInterstitialAd.showInterstitialAd(delay: 0);
    loadingDialogTimer.cancel();
    isAdsShowed=true;
  }
  );
}
