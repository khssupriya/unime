import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Each extends StatefulWidget {
  Each({Key key, this.documentSnapshot}) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  @override
  _EachState createState() => _EachState(documentSnapshot: documentSnapshot,);
}

class _EachState extends State<Each> {

  _EachState({this.documentSnapshot});

  DocumentSnapshot documentSnapshot;  

   Future<Widget> _getImage(String name) async{
     print(name);
     final ref = FirebaseStorage.instance.ref().child(name);
      var url = await ref.getDownloadURL();
      return Image.network(url);
   }

  Widget _displayImage(String name){
    return FutureBuilder(
      future: _getImage(name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot!= null)
          return snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting && snapshot!= null)
          return CircularProgressIndicator();
        return Container(child:Text('No poster available :('),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Image(image: AssetImage('assests/title.png'), width: 100,),
      ),
      body:
      SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            SizedBox(height: 20.0,),
            Text(
              this.documentSnapshot['Title'],
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0,) ,
            Text(
              this.documentSnapshot['Short Description'],
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,) ,
            FlatButton(
              padding: EdgeInsets.all(0) ,
              onPressed: (){
                Add2Calendar.addEvent2Cal(
                  Event(
                    title: documentSnapshot['Title'],
                    description: documentSnapshot['Short Description'],
                    location: 'uni.me app',
                    startDate: documentSnapshot['Date'].toDate(),
                    endDate: documentSnapshot['Date'].toDate().add(Duration(days: 1)),
                    allDay: false,
                  ),
                ).then((success) {
                  scaffoldState.currentState.showSnackBar(
                  SnackBar(content: Text(success ? 'Success' : 'Error')));
                });
              },
              child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Date :',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat("dd-MM-yyy HH:mm").format(this.documentSnapshot['Date'].toDate(),).substring(0,10),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                   // SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Time :',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat("dd-MM-yyy HH:mm").format(this.documentSnapshot['Date'].toDate(),).substring(10,16),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                RaisedButton(
                  onPressed: (){
                    Add2Calendar.addEvent2Cal(
                      Event(
                        title: documentSnapshot['Title'],
                        description: documentSnapshot['Short Description'],
                        location: 'uni.me app',
                        startDate: documentSnapshot['Date'].toDate(),
                        endDate: documentSnapshot['Date'].toDate().add(Duration(days: 1)),
                        allDay: false,
                      ),
                    ).then((success) {
                      scaffoldState.currentState.showSnackBar(
                      SnackBar(content: Text(success ? 'Success' : 'Error')));
                    });
                  },
                  color: Colors.blue[100],
                    shape: CircleBorder( ),
                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),

            ),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Text(
                'College:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10.0,) ,
              Text(
                this.documentSnapshot['College Name'],
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              Text(
                'Fee:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10.0,) ,
              Text(
                this.documentSnapshot['Fee'],
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Center(
            child: FlatButton(
              color:Colors.redAccent,
              onPressed: () async {
              final url = documentSnapshot['Link'];
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
              child: Text(
                'Register now',
                style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
         (documentSnapshot['Has Poster'] == 1)? _displayImage(DateFormat('yyyy-MM-dd hh:mm').format(documentSnapshot['_timeStampUTC'].toDate())):Center(child: Text('no poster :('),),
        ],
    ),
        ),
      ),
      floatingActionButton: Stack(
              children: <Widget>[
                 Padding(padding: EdgeInsets.only(right:0),
                  child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 50,
                child: FloatingActionButton(
                    heroTag: null,                    
                    onPressed: () async {
                      String url = "tel:" + this.documentSnapshot['Phone Number'];   
                      if (await canLaunch(url)) {
            await launch(url);
                      } else {
          throw 'Could not launch $url';
                      }
                    },
                    backgroundColor: Colors.orangeAccent,
                    shape: CircleBorder(),
                    child: Icon(
                    Icons.phone,
                    size: 25.0,  
                    color: Colors.white,          
                    ),
                  ),
              ),
        ),
                 ),
                  Padding(padding: EdgeInsets.fromLTRB(0,31,0,60),
                  child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 50,
                child: FloatingActionButton(
                    heroTag: null, 
                    onPressed: () async{
                      var url = "mailto:" + documentSnapshot['Email Address'];
                      if (await canLaunch(url)) {
            await launch(url);
                      } else {
          throw 'Could not launch $url';
                      }
                    },
                    backgroundColor: Colors.orangeAccent,
                    shape: CircleBorder(),
                    child: Icon(
                    Icons.email,
                    size: 25.0,  
                    color: Colors.white,          
                    ),
                  ),
              ),
        ),
                 ),

              ],
      ),
    );
  }
}