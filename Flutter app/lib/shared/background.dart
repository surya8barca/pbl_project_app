import 'package:flutter/material.dart';


class Background extends StatelessWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
      color: Colors.green[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(height: 15.0,),
            Center(
      child: CircleAvatar(
        backgroundImage: AssetImage('images/agnel.jpg'),
        radius: 80,
      ),
            ),
            SizedBox(height: 15.0,),
            Divider(
                      height: 5.0,
                      thickness: 2.0,
                      color: Colors.blueAccent,
                      indent: 30.0,
                      endIndent: 30.0,
                    ),
            ],
    );
  }
}