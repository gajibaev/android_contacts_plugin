import 'package:android_contacts_plugin/models/models.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:android_contacts_plugin/android_contacts_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts Plugin Example App'),
          actions: [
            IconButton(
              onPressed: () {
                setState(
                  () {},
                );
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: SafeArea(
          child: FutureBuilder<List<Contact>>(
            future: getContacts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var phone = data[index].phones.isNotEmpty
                        ? data[index].phones[0]
                        : '';
                    var avatar = data[index].getContactImage();
                    return SizedBox(
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 75,
                            width: 75,
                            child: avatar ??
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(7.5),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'No image',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(data[index].name ?? ''),
                                Text(phone),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    var result = await AndroidContacts.getContacts();
    return result;
  }
}
