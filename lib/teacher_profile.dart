import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: ProfileT(),
)
);

class ProfileT extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
    title: Text(
      'Mahendra Mehra',
      style: TextStyle(
        color: Colors.white,
        fontSize: 25.0,
      ),
      ),
    centerTitle: true,
    backgroundColor: Colors.black,
        ),
        body: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(
        color: Colors.green[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    'FR. CONCEICAO RODRIGUES COLLEGE OF ENGINEERING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '(Approved by AICTE & Affiliated to university of Mumbai)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Bandstand,Bandra (W), Mumbai - 400 050. *Tel.: 6711 4000 * Fax: 6711 4200 ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
              ),
          ],
        ),
      ),
      Center(
        child: CircleAvatar(
          backgroundImage: NetworkImage('https://yt3.ggpht.com/a/AATXAJzNgJlmLKSWBIxpT_yoZDrzHBlvXvoRE82Mpw=s288-c-k-c0xffffffff-no-rj-mo'),
          radius: 60.0,
        ),
      ),
        Row(
          children: <Widget>[
            Text(
              'Name:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              'Mahendra Mehra',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

        ),
        Row(
          children: <Widget>[
            Text(
              'DOB:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              '12.05.1980',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'College Id No:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              '8367354684',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Department:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              'COMPUTERS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    ]
        ),
      );
  }
}