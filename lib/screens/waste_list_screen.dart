import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import 'waste_detail_screen.dart';
import 'new_waste_screen.dart';

class WasteListScreen extends StatefulWidget {
  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  WasteListScreen({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  @override
  _WasteListScreenState createState() => _WasteListScreenState();
}

class _WasteListScreenState extends State<WasteListScreen> {
  int totalItems = 0;
  Stream stream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date', descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  // trying to get everything to reload after post added so count can refresh
  @override
  void didUpdateWidget(WasteListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.crash();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        // title: Text(widget.title + ' - ' + totalItems.toString()),
      ),
      body: listOfPosts(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        child: addPostFab(context),
        button: true,
        enabled: true,
        onTapHint: 'Add a post',
      ),
    );
  }

  Widget listOfPosts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.docs != null &&
                  snapshot.data.docs.length > 0) {
                totalItems = 0;
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var post = snapshot.data.docs[index];
                      // I cannot get this to update no matter what I try.
                      // I've tried setting state in various places, calling
                      // a separate funtion to calculate it, and various other
                      // things, no matter what I try I just get errors.
                      // The total will only update when I save/hot reload
                      totalItems = totalItems + post['quantity'];
                      return Semantics(
                        child: ListTile(
                            title: Text(
                              DateFormat.yMMMMEEEEd('en_US')
                                  .format(post['date'].toDate()),
                              // style: Theme.of(context).textTheme.bodyText1
                            ),
                            trailing: Text(post['quantity'].toString(),
                                style:
                                    Theme.of(context).textTheme.headline5),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WasteDetailScreen(
                                      title: 'Wasteagram', post: post)));
                            }),
                        onTapHint: 'See post details',
                      );
                    }
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })),
      ],
    );
  }

  Widget addPostFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewWasteScreen(title: 'Wasteagram')));
      },
      tooltip: 'New Waste Post',
      child: Icon(Icons.add),
    );
  }
}
