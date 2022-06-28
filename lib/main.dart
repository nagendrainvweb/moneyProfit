import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/pages/home/home_page.dart';
import 'package:moneypros/pages/login/login_page.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/user_repository.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setUpLocator();
  setupDialogUi();
  setupSnackbarUi();
  final model = UserRepo();
  model.setCityList();
  model.setStateList();
  await model.init();
  model.setUserDatafromServer();
  runApp(MyApp(repo: model));
}

class MyApp extends StatelessWidget {
  final UserRepo repo;

  const MyApp({Key key, this.repo}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepo>.value(value: repo),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoneyPros',
        navigatorKey: StackedService.navigatorKey,
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage()
        },
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            accentColor: AppColors.orange,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
                brightness: Brightness.light,
                titleTextStyle: TextStyle(color: AppColors.blackGrey),
                iconTheme: IconThemeData(color: AppColors.blackGrey))),
        home: (repo.login || repo.loginSkipped)
            ? HomePage(
                position: (repo.login && repo.subscribe) ? 1 : 0,
              )
            : LoginPage(),
        //LoginPage()
        //
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
