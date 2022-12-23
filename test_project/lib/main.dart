import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/main/allert_screen.dart';
import 'package:test_project/quiz/view/quiz_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main/provider/main_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const MyHomePage(),
        '/quiz': (context) => const QuizGameScreen(),
        '/no_internet': (context) => const AllertScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey webViewKey = GlobalKey();

  WebViewController? webViewController;

  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainProvider()..initData(context),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<MainProvider>(builder: ((context, provider, child) {
            if (provider.data.state == MainState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.data.state == MainState.success) {
              webViewController!.loadRequest(Uri.parse(provider.data.url!));
              if (provider.data.url != null) {
                return WillPopScope(
                    onWillPop: () async {
                      bool? goBack = await webViewController?.canGoBack();
                      if (goBack != true) {
                        return false;
                      } else {
                        await webViewController!.goBack();
                        return false;
                      }
                    },
                    child: WebViewWidget(
                      controller: webViewController!,
                    ));
              }
            }
            return const SizedBox();
            //return const Center(child: CircularProgressIndicator());
          })),
        ),
      ),
    );
  }
}
