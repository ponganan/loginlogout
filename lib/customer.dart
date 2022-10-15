import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 2 line if want to work with Datetime
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';
import 'model/customerlist.dart';
import 'model/userlist.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  //final controllerDate = TextEditingController();

  String? customerID;

  @override
  void dispose() {
    controllerName.dispose();
    controllerAge.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
        child: Column(
          //padding: EdgeInsets.all(15),
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
            // const SizedBox(height: 25),
            // DateTimeField(
            //   controller: controllerDate,
            //   decoration: decorationTF('Birthday'),
            //   format: DateFormat('yyyy-MM-dd'),
            //   //can use 2 way to select this line for call showDatePicker
            //   // onShowPicker: (context, currentValue) => showDatePicker(
            //   onShowPicker: (context, currentValue) {
            //     return showDatePicker(
            //       context: context,
            //       firstDate: DateTime(1900),
            //       initialDate: currentValue ?? DateTime.now(),
            //       lastDate: DateTime(2100),
            //     );
            //   },
            // ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                final userAddCustomer = AddCustomer(
                  //get value from name TextField
                  name: controllerName.text,
                  //get int value to string
                  age: int.parse(controllerAge.text),
                  dateTime: DateTime.now(),
                  //get date value to string
                );
                createUserAddCustomer(userAddCustomer);

                Navigator.pop(context);
              },
              child: const Text(
                'เพิ่มรายชื่อลูกค้า',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const HomePage();
                    },
                  ),
                );
              },
              child: const Text(
                'Back to HomePage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            Flexible(
              child: StreamBuilder<List<CustomerList>>(
                stream: readCustomer(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went Wrong!!! ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final customer = snapshot.data!;

                    return ListView(
                      children: customer.map(buildUser).toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //decoration method to call for TextField
  InputDecoration decorationTF(String label) => InputDecoration(
        labelText: label,
        //use OutlineInputBorder to Border all Textfield
        border: const OutlineInputBorder(),
      );

  Future createUserAddCustomer(AddCustomer userAddUser) async {
    final docUser = FirebaseFirestore.instance.collection('customer').doc();
    //add id from Firebase Auth id
    userAddUser.id = docUser.id;
    //userAddUser.id = userFirebase.uid;

    final json = userAddUser.toJson();
    await docUser.set(json);
  }

  Widget buildUser(CustomerList customer) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ชื่อ : ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  customer.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      controllerName.text = customer.name;
                      controllerAge.text = customer.age.toString();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Form(
                          child: Dialog(
                            child: ListView(
                              children: <Widget>[
                                const SizedBox(height: 28),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: TextFormField(
                                    controller: controllerName,
                                    decoration: decorationTF('ชื่อ'),

                                    //autovalidateMode for automatic validate value
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'กรุณาระบุหัวข้อประกาศ'
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: controllerAge,
                                    decoration: decorationTF('อายุ'),

                                    //autovalidateMode for automatic validate value
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'กรุณาระบุประกาศ'
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      customerID = customer.id;

                                      getUpdateCustomerDetail();

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return const HomePage();
                                          },
                                        ),
                                      );
                                    },
                                    color: Colors.green[200],
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'อายุ : ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  customer.age.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                size: 30,
              ),
              color: Colors.red,
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('ลบลูกค้ารายนี้'),
                  content: const Text('ต้องการลบลูกค้ารายนี้ใช่หรือไม่'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        final docTopic = FirebaseFirestore.instance
                            .collection('customer')
                            .doc(customer.id);
                        docTopic.delete();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      );

  Stream<List<CustomerList>> readCustomer() => FirebaseFirestore.instance
      .collection('customer')
      .orderBy('datetime', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CustomerList.fromJson(doc.data()))
          .toList());

  void getUpdateCustomerDetail() {
    final updateCustomer = UpdateCustomer(
      name: controllerName.text,
      age: int.parse(controllerAge.text),
      dateTime: DateTime.now(),
    );
    updateCustomerDetail(updateCustomer);
  }

  Future updateCustomerDetail(UpdateCustomer CustomerUpdateDetail) async {
    final docTopic =
        FirebaseFirestore.instance.collection('customer').doc(customerID);
    //add id from Firebase Auth id
    CustomerUpdateDetail.id = docTopic.id;
    //userAddTopic.uID = userFirebase.uid;
    //userAddTopic.topicPic = picPostURL!;

    final json = CustomerUpdateDetail.toJson();
    await docTopic.update(json);
  }
}

class UpdateCustomer {
  String id;

  final String name;
  final int age;
  final DateTime dateTime;

  UpdateCustomer({
    this.id = '',
    required this.name,
    required this.age,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'datetime': dateTime,
      };
}

//************************************************//
// New Flutter have to create Class and define object//
//************************************************//

class AddCustomer {
  String id;
  final String name;
  final int age;
  final DateTime dateTime;

  AddCustomer({
    this.id = '',
    required this.name,
    required this.age,
    required this.dateTime,
  });

  //************************************************//
  // HAVE TO USE THIS CODE TO MAP JSON TO FIREBASE //
  //************************************************//
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'datetime': dateTime,
      };
}
