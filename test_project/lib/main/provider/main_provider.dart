import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/main/allert_screen.dart';
import 'package:test_project/main/data/main_data.dart';

enum MainState {
  noInternet,
  loading,
  success,
}

List types = ['', 'Эмулятор', 'НЕТ СИМ', null];

class MainProvider extends ChangeNotifier {
  MainData data = MainData();

  Future<void> initData(context) async {
    data.state = MainState.loading;
    notiy();

    final prefs = await SharedPreferences.getInstance();

    data.url = prefs.getString('url');

    try {
      if (data.url == null) {
        await conntectToRemote();
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => AllertScreen(
              allert: e.toString(),
            ),
          ),
          (route) => false);
    }

    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/no_internet', (route) => false);
    } else if (types.contains(data.url)) {
      Navigator.pushNamedAndRemoveUntil(context, '/quiz', (route) => false);
    } else {
      data.state = MainState.success;
      notiy();
    }
  }

  Future<void> conntectToRemote() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.fetchAndActivate();

    final config = remoteConfig.getAll();

    if (config['url'] != null) {
      data.url = config['url']!.asString();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('url', data.url!);
    }
  }

  notiy() {
    notifyListeners();
  }
}
