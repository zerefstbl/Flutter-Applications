import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ViewPage extends StatelessWidget {
  final Map gifData;

  ViewPage(this.gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData['title']),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Share.share(gifData['images']['fixed_height']['url']);
              },
              icon: Icon(Icons.share),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          gifData['images']['fixed_height']['url'],
        )
      ),
    );
  }
}