import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:giphy_search/pages/view_page.dart';
import 'package:share/share.dart';

const request = 'https://api.giphy.com/v1/gifs/trending?api_key=Gj1n7FZhtS8xQarLsO3bu6HUtZn6gUfe&limit=20&rating=g';
const search = 'https://api.giphy.com/v1/gifs/search?api_key=Gj1n7FZhtS8xQarLsO3bu6HUtZn6gUfe&q=&limit=20&offset=0&rating=g&lang=en';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? search;

  int offSet = 0;

  Future<Map> getGifs () async {
    http.Response response;
    if (search == 'null') {
      response = await http.get((request));
    } else {
      response = await http.get(('https://api.giphy.com/v1/gifs/search?api_key=Gj1n7FZhtS8xQarLsO3bu6HUtZn6gUfe&q=$search&limit=19&offset=$offSet&rating=g&lang=en'));
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getGifs().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquise Aqui: ',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                hintText: 'Digite uma chave'
              ),
              onSubmitted: (text) {
                setState(() {
                  if (text.isEmpty) {
                    search = null;
                    return;
                  }
                  search = text;
                });
              },
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: getGifs(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return createGifTable(context, snapshot);
                      }
                  }
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: snapshot.data['data'].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(snapshot.data['data'][index]['images']['fixed_height']['url'],
            height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewPage(snapshot.data['data'][index]))
              );
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },
          );
        },
    );
  }
}