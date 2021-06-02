import 'package:flutter/material.dart';
import '../../views/trips/widgets/trip_list.dart';
import '../../models/trip_model.dart';
import '../../widgets/dyma_drawer.dart';

class TripsView extends StatefulWidget {
  static const String routeName = '/trips';
  final List<Trip> trips;

  TripsView({required this.trips});

  @override
  _TripsViewState createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Mes voyages'),
            bottom: const TabBar(
              tabs: <Widget>[
                const Tab(
                  text: 'A venir',
                ),
                const Tab(
                  text: 'Passés',
                ),
              ],
            ),
          ),
          drawer: const DymaDrawer(),
          body: TabBarView(
            children: <Widget>[
              TripList(
                trips: widget.trips
                    .where((trip) => DateTime.now().isBefore(trip.date!))
                    .toList(),
              ),
              TripList(
                trips: widget.trips
                    .where((trip) => DateTime.now().isAfter(trip.date!))
                    .toList(),
              ),
            ],
          )),
    );
  }
}
