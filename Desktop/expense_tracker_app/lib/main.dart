import 'package:expense_tracker_app/core/widgets/constants/app_theme.dart';
import 'package:expense_tracker_app/presentation/providers/theme_provider.dart';
import 'package:expense_tracker_app/presentation/providers/total_expense_provider.dart';
import 'package:expense_tracker_app/presentation/providers/user_provider.dart';
import 'package:expense_tracker_app/presentation/screens/auth_screen.dart';
import 'package:expense_tracker_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'presentation/providers/expense_provider.dart';
import 'data/data_sources/expense_db_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  try {
    await ExpenseDbHelper().openDb();
  } catch (e) {
    print('Database initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => TotalExpenseProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: ExpenseTrackerApp(isLoggedIn: isLoggedIn),
    ),
  );
}

Future<void> _initializeNotifications() async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint("Notification clicked: ${response.payload}");
    },
  );

  // **Request Notification Permission for Android 13+**
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // **Create Notification Channel (For Android 8.0+)**
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'reminder_channel',
    'Reminders',
    description: 'Channel for reminders',
    importance: Importance.high,
  );

  final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(channel);
  }
}


class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Expenzy',
      theme:
          themeProvider.isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: isLoggedIn ? const HomeScreen() : AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
