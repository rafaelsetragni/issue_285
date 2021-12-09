import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';

void main()async{
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
        )
      ]
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
            MaterialButton(
              color: Colors.yellow,
              child: const Text("Permission"),
              onPressed: ()async{
                await AwesomeNotifications().isNotificationAllowed().then((isAllowed)async{
                  if (!isAllowed){
                    await AwesomeNotifications().requestPermissionToSendNotifications();
                  }
                });
              },
            ),
            const Text(" "),
            MaterialButton(
              color: Colors.yellow,
              child: const Text("Make Scheduled Notification"),
              onPressed: ()async{
                await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: Random().nextInt(9999),
                      displayOnForeground: true,
                      displayOnBackground: true,
                      channelKey: 'basic_channel',
                      title: 'Simple Notification',
                      body: 'Simple body'
                  ),
                  schedule: NotificationCalendar.fromDate(
                      date: DateTime.now().add(const Duration(seconds: 5))),
                );
              },
            ),
            const Text(" "),
            MaterialButton(
              color: Colors.yellow,
              child: const Text("Scheduled Notifs"),
              onPressed: ()async{
                goTo(context, const ScheduledNotif());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduledNotif extends StatefulWidget {
  const ScheduledNotif({Key? key}) : super(key: key);

  @override
  _ScheduledNotifState createState() => _ScheduledNotifState();
}

class _ScheduledNotifState extends State<ScheduledNotif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduled Notifs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder(
          future: AwesomeNotifications().listScheduledNotifications(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return const Center(
                  child: CircularProgressIndicator()
              );
            }
            List<NotificationModel> _list = snapshot.data;
            List<ListTile> _tiles = _list.map((e) {
              return ListTile(
                title: Text(e.content!.id.toString()),
                subtitle: Text(e.content.toString()),
              );
            }).toList();

            return ListView(
              children: [
                if(_tiles.isEmpty) const Text("No Scheduled Notification"),
                ..._tiles,
              ],
            );
          },
        ),
      ),
    );
  }
}

void goTo(BuildContext context, Widget Page){
  Navigator.push(context,
      MaterialPageRoute(
          builder: (context)=> Page
      )
  );
}