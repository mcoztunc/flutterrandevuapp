import 'package:berberozkan/screens/dialog.dart';
import 'package:berberozkan/screens/randevu_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  List<FlutterWeekViewEvent> events = [];
  late int randevubaslangic;
  late int randevubitis;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime noww = DateTime.now();
    randevubaslangic = 9;
    randevubitis = 20;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.secondary,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () => {},
              icon: Icon(Icons.home),
              iconSize: 40.0,
            ),
            IconButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RandevuList()))
              },
              icon: Icon(Icons.list),
              iconSize: 40.0,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _dialogCall(context);
          },
          child: Center(
            child: Icon(Icons.add),
          )),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              WeekView(
                minimumTime: HourMinute(hour: randevubaslangic),
                maximumTime: HourMinute(hour: randevubitis),
                userZoomable: false,
                dates: [
                  noww,
                  noww.add(Duration(days: 1)),
                  noww.add(Duration(days: 2)),
                  noww.add(Duration(days: 3)),
                  noww.add(Duration(days: 4)),
                  noww.add(Duration(days: 5))
                ],
                events: [
                  FlutterWeekViewEvent(
                    title: 'An event 1',
                    description: 'A description 1',
                    start: noww.subtract(Duration(minutes: 30)),
                    end: noww.add(Duration(hours: 18, minutes: 30)),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _dialogCall(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return actionButtonDialog();
        });
  }
}
