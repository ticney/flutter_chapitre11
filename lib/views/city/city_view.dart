import 'package:flutter/material.dart';
import './widgets/trip_activity_list.dart';
import './widgets/activity_list.dart';
import './widgets/trip_overview.dart';
import '../../views/home/home_view.dart';
import '../../widgets/dyma_drawer.dart';
import '../../models/city_model.dart';
import '../../models/activity_model.dart';
import '../../models/trip_model.dart';

class CityView extends StatefulWidget {
  static const String routeName = '/city';
  final City city;
  final Function addTrip;

  List<Activity> get activities {
    return city.activities;
  }

  CityView({
    required this.city,
    required this.addTrip,
  });

  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<CityView> {
  late Trip mytrip;
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
    mytrip = Trip(activities: [], date: null, city: 'Paris');
  }

  List<Activity> get tripActivities {
    return widget.activities
        .where((activity) => mytrip.activities.contains(activity.id))
        .toList();
  }

  double get amount {
    return mytrip.activities.fold(0.0, (prev, element) {
      var activity =
          widget.activities.firstWhere((activity) => activity.id == element);
      return prev + activity.price;
    });
  }

  void setDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          mytrip.date = newDate;
        });
      }
    });
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toggleActivity(String id) {
    setState(() {
      mytrip.activities.contains(id)
          ? mytrip.activities.remove(id)
          : mytrip.activities.add(id);
    });
  }

  void deleteTripActivity(String id) {
    setState(() {
      mytrip.activities.remove(id);
    });
  }

  void saveTrip() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Voulez vous sauvegarder ?'),
          contentPadding: const EdgeInsets.all(20),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('annuler'),
                  onPressed: () {
                    Navigator.pop(context, 'cancel');
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: const Text(
                    'sauvegarder',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pop(context, 'save');
                  },
                ),
              ],
            )
          ],
        );
      },
    );
    if (result == 'save') {
      widget.addTrip(mytrip);
      Navigator.pushNamed(context, HomeView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisation voyage'),
      ),
      drawer: const DymaDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            TripOverview(
                cityName: widget.city.name,
                trip: mytrip,
                setDate: setDate,
                amount: amount),
            Expanded(
              child: index == 0
                  ? ActivityList(
                      activities: widget.activities,
                      selectedActivities: mytrip.activities,
                      toggleActivity: toggleActivity,
                    )
                  : TripActivityList(
                      activities: tripActivities,
                      deleteTripActivity: deleteTripActivity,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.forward),
        onPressed: saveTrip,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          const BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: 'Découverte',
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.stars),
            label: 'Mes activités',
          )
        ],
        onTap: switchIndex,
      ),
    );
  }
}
