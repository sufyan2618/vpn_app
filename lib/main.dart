import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpn_app/Controlllers/homeProvider.dart';
import 'package:vpn_app/Controlllers/locationProvider.dart';
import 'package:vpn_app/Controlllers/pref.dart';
import 'package:vpn_app/Views/Constant.dart';
import 'package:vpn_app/Views/Screens/Splash_Screen.dart';
import 'package:vpn_app/Views/Screens/onBoardingScreen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://nvdvtbmoadsxzdgvvoit.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im52ZHZ0Ym1vYWRzeHpkZ3Z2b2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2NTM3MzMsImV4cCI6MjA2MzIyOTczM30.9jVWjQH6BzBj9HyCvKJkJPK-hF3CQ1fd01BEdvRKq7w");

   await Pref.initializeHive();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

///For Checking the user is new or not
  bool newUser= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MobileAds.instance.initialize();
    WheretoGo();
  }

  Check() async{
    await  WheretoGo();
  }

  ///For checking if user is new or old user
  WheretoGo() async {
    var sharedpreference = await SharedPreferences.getInstance();
    var user = sharedpreference.getBool('newUser');
    print(user);
    if (user != null) {
      if (user) {
        setState(() {
          newUser = true;
        });
      } else {
        setState(() {
          newUser = false;

        });
      }
    } else {
      setState(() {
        newUser = false;

      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider<VpnProvider>( create: (context) => VpnProvider()),
          ChangeNotifierProvider<LocationProvider>( create: (context) => LocationProvider()),

        ],
        child: Builder(
          builder: (context) {

            return MaterialApp(
              theme: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: IconLightBlue,
                ),
                scaffoldBackgroundColor: darkBlue,
                appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent,centerTitle: true,
                    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor:darkBlue, systemNavigationBarColor:darkBlue, )
                ),
                brightness: Brightness.light,
                unselectedWidgetColor: Colors.white,
  
                // canvasColor: Colors.transparent



              ),

              debugShowCheckedModeBanner: false,
              home: newUser ? Splash_Screen(): OnBoardingScreen()   ,
            );
          }
        ),
      );}




}

