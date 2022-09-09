import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_example/user.dart';

const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask =
    "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        print('User data : ${activeUser.name} , ${activeUser.rank}');
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;
      case rescheduledTaskKey:
        final key = inputData!['key']!;
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('unique-$key')) {
          print('has been running before, task is successful');
          return true;
        } else {
          await prefs.setBool('unique-$key', true);
          print('reschedule task');
          return false;
        }
      case failedTaskKey:
        print('failed task');
        return Future.error('failed');
      case simpleDelayedTask:
        print("$simpleDelayedTask was executed");
        break;
      case simplePeriodicTask:
        activeUser.rank++;
        print("$simplePeriodicTask was executed");
        break;
      case simplePeriodic1HourTask:
        activeUser.rank++;
        print("$simplePeriodic1HourTask was executed");
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = await getTemporaryDirectory();
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}
