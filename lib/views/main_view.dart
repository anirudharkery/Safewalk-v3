import 'package:flutter/material.dart';
import 'auth/login_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            //SafeWalkSCU Logo
            Padding(
              padding: EdgeInsets.only(top: 152.0),
              child: Column(children: [
                Image.asset(
                  "./assets/images/logo_redcircle.png",
                  height: 129,
                  width: 124,
                ),
                //SizedBox(height: 20),
                Text(
                  "SafeWalkSCU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.1,
                    fontFamily: "Inter",
                  ),
                )
              ]),
            ),

            SizedBox(height: 75),
            //Column of Buttons
            //
            //
            Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Sign in with Google Button
                      //
                      //
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginView()),
                          );
                        },
                        child: SizedBox(
                          width: 345,
                          height: 83,
                          child: Image.asset(
                            "./assets/images/signin_google.png",
                            fit: BoxFit
                                .contain, // Adjust how the image fits within the button
                          ),
                        ),
                      ),
                      //Dispatcher Button
                      //
                      //
                      SizedBox(height: 20),
                      SizedBox(
                        width: 334,
                        height: 74,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone_in_talk,
                                color: Colors.black,
                                size: 40,
                              ),
                              SizedBox(
                                  width:
                                      10), // Adjust the spacing between icon and text
                              Text(
                                " Call Dispatcher",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.125,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Campus Safety Button
                      //
                      //
                      SizedBox(height: 20),
                      SizedBox(
                        width: 334,
                        height: 74,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: Colors.black),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(
                                  width:
                                      10), // Adjust the spacing between icon and text
                              Text(
                                " Call Campus Safety",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.125,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
