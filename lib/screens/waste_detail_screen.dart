import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteDetailScreen extends StatefulWidget {
  final String title;
  final post;

  WasteDetailScreen({Key key, this.title, this.post}) : super(key: key);

  @override
  _WasteDetailScreenState createState() => _WasteDetailScreenState();
}

class _WasteDetailScreenState extends State<WasteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // if (locationData == null) {
    //   return Center(child: CircularProgressIndicator());
    // } else {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            postDate(context), 
            postPhoto(context),
            postQuantity(context),
            postLocation(context),
          ],
        )));
  }

  Widget postDate(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        DateFormat.yMMMMEEEEd('en_US').format(widget.post['date'].toDate()),
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget postPhoto(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Semantics(
        child: Image.network(widget.post['imageURL']),
        label: "Image of food waste",
      ),
    );
  }

    Widget postQuantity(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(60),
      child: Text(
        'Items: ' + widget.post['quantity'].toString(),
        style: Theme.of(context).textTheme.headline4),
    );
  }

  Widget postLocation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        '(' + widget.post['latitude'].toString() + ', ' + 
                widget.post['longitude'].toString() + ')'
      )
    );
  }
}
// }
