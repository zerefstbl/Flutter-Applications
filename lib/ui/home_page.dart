import 'package:contats/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:contats/helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';

enum OderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  void initState() {
    super.initState();
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list as List<Contact>;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contatos'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry> [
                const PopupMenuItem(
                    child: Text('Ordernar de A-Z'),
                ),
              ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return contactCard(context, index);
          },
      ),
    );
  }

  Widget contactCard (BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                      FileImage(File(contacts[index].img ?? '')) :
                          AssetImage("images/person.jpg") as ImageProvider
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contacts[index].name ?? '',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    Text(contacts[index].email ?? "",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    ),
                    Text(contacts[index].phone ?? "",
                    style: TextStyle(
                      fontSize: 18
                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showOptions(context, index);
      },
    );
  }

  void showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            launch('tel:${contacts[index].phone}');
                            Navigator.pop(context);
                          },
                          child: Text('Ligar', style: TextStyle(color: Colors.red)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size.fromHeight(50)
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showContactPage(contact: contacts[index]);
                          },
                          child: Text('Editar', style: TextStyle(color: Colors.red)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size.fromHeight(50)
                          )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            helper.deleteContact(contacts[index].id as int);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: Text('Apagar', style: TextStyle(color: Colors.red)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size.fromHeight(50),
                          )
                        )
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  void showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      helper.getAllContacts().then((list) {
        setState(() {
          contacts = list as List<Contact>;
        });
      });
    }
  }
}