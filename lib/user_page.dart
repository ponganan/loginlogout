import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 2 line if want to work with Datetime
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: decorationTF('name'),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: controllerAge,
            decoration: decorationTF('Age'),
            //use this for let user only choose Number
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 25),
          DateTimeField(
            controller: controllerDate,
            decoration: decorationTF('Birthday'),
            format: DateFormat('yyyy-MM-dd'),
            //can use 2 way to select this line for call showDatePicker
            // onShowPicker: (context, currentValue) => showDatePicker(
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              final userAddUser = UserAddUser(
                //get value from name TextField
                name: controllerName.text,
                //get int value to string
                age: int.parse(controllerAge.text),
                //get date value to string
                birthday: DateTime.parse(controllerDate.text),
              );
              createUserAddUser(userAddUser);

              Navigator.pop(context);
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }

  //decoration method to call for TextField
  InputDecoration decorationTF(String label) => InputDecoration(
        labelText: label,
        //use OutlineInputBorder to Border all Textfield
        border: const OutlineInputBorder(),
      );

  Future createUserAddUser(UserAddUser userAddUser) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    userAddUser.id = docUser.id;

    final json = userAddUser.toJson();
    await docUser.set(json);
  }
}

//************************************************//
// New Flutter have to create Class and define object//
//************************************************//

class UserAddUser {
  String id;
  final String name;
  final int age;
  final DateTime birthday;
  UserAddUser({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  //************************************************//
  // HAVE TO USE THIS CODE TO MAP JSON TO FIREBASE //
  //************************************************//
  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'age': age, 'birthday': birthday};
}
