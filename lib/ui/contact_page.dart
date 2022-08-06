import 'package:flutter/material.dart';
import 'dart:io';
import 'package:contats/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final nameFocus = FocusNode();

  late String textname = editedContact?.name ?? '';

  bool userEddited = false;

  Contact? editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      editedContact = Contact();
    } else {
      editedContact = Contact.fromMap(widget.contact!.toMap());

      nameController.text = editedContact!.name ?? '';
      emailController.text = editedContact?.email ?? '';
      phoneController.text = editedContact?.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(editedContact?.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.save),
            onPressed: () {
              print(textname);
              if (editedContact != null && textname.isNotEmpty) {
                Navigator.pop(context, editedContact);
              } else {
                FocusScope.of(context).requestFocus(nameFocus);
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: editedContact?.img != null ?
                            FileImage(File(editedContact?.img ?? '')) :
                            AssetImage('images/person.jpg') as ImageProvider
                        )
                    ),
                  ),
                  onTap: () {
                    ImagePicker().getImage(source: ImageSource.gallery).then((file) {
                      setState(() {
                        editedContact!.img = file.path;
                      });
                    });
                  },
                ),
                TextField(
                  controller: nameController,
                  focusNode: nameFocus,
                  decoration: InputDecoration(
                      labelText: "Nome"
                  ),
                  onChanged: (text) {
                    userEddited = true;
                    setState(() {
                      textname = text;
                      text.isEmpty ? editedContact?.name = null :
                      editedContact!.name = text;
                    });
                  },
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email'
                  ),
                  onChanged: (text) {
                    userEddited = true;
                    editedContact!.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      labelText: 'Telefone'
                  ),
                  onChanged: (text) {
                    userEddited = true;
                    editedContact!.phone = text;
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
    );
  }

  Future<bool> requestPop () {
    if (userEddited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar Alterações?'),
              content: Text('Se sair as alterações serão perdidas!'),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ), TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Confirmar')
                )
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}