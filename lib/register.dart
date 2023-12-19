import 'package:flutter/material.dart';
class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 40.0,
              ),
              const Image(
                image: AssetImage("images/tsc_logo no background.png"),
                fit: BoxFit.fitWidth,
                width: 300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Text(
                    "Mwalimu ",
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                    ),
                  ),
                  const Text(
                    "Na ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                    ),
                  ),
                  Text(
                    "Mazingira ",
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage("images/coat of arms no background.png"),
                  fit: BoxFit.fitWidth,
                  width: 70,
                  height: 100,
                ),
                Text(
                  "greening the nation",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ]
          )
        ]
    );
  }
}

