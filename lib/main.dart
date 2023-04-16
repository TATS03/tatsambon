import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' TATS Contacts App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  // demande la permission d'accéder aux contacts
  Future<void> _requestContactPermission() async {
    final PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      _getContacts();
    } else if (status.isDenied) {
     // ignore: use_build_context_synchronously
     showDialog(
          context: context,
          builder: (BuildContext context) {
          return AlertDialog(
            title: Text("acces refuser"),
            content: Text("acces refuser relancer l\'apli"),
            actions: <Widget>[
              TextButton(
                child: Text("fermer l\'apli"),
                onPressed: () {
                   SystemNavigator.pop();
                },
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                             },
        ),
      ],
    );
  },
);

    } else if (status.isPermanentlyDenied) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
          return AlertDialog(
            title: Text("acces refuser"),
            content: Text("autoriser lacces dans parametre"),
            actions: <Widget>[
              TextButton(
                child: Text("fermer l\'apli"),
                onPressed: () {
                   SystemNavigator.pop();
                },
              ),
      ],
    );
  },
);
    }
  }

  // récupère la liste des contacts
  void _getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TATS Contacts App'),
      ),
      body: _contacts == null
          ? Center(
              child: ElevatedButton (
                onPressed: _requestContactPermission,
                child: Text('Demander la permission d\'accéder aux contacts'),
              ),
            )
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts[index];
                return ListTile(
                  leading: contact.avatar != null
                      ? CircleAvatar(
                           child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                        ),
                  title: Text(contact.displayName ?? ''),
                  // subtitle: Text(contact.phones.isNotEmpty
                  //     ? contact.phones.first.value
                  //     : ''),
                );
              },
            ),
    );
  }
}
