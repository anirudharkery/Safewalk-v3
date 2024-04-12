import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [ 
            //SafeWalkSCU Logo
            Padding(
              padding: EdgeInsets.only(top: 152.0), 
              child: Image.asset(
                "./assets/images/logo_red.png",
                height: 250,
                width: 250,
              ),
            ),

            //Safewalk Text
            //
            //
            Text(
              "SafeWalkSCU",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                letterSpacing: 1,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(height: 20),

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
                  SizedBox(
                    width: 345,
                    height: 83,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        "Sign In with Google",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),

                  //Dispatcher Button
                  //
                  //
                  SizedBox(height: 20),
                  SizedBox(
                    width: 345,
                    height: 74,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Call Dispatcher",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1,
                          fontFamily: "Inter",
                        
                        ),  
                      ),
                    ),
                  ),

                  //Campus Safety Button
                  //
                  //
                  SizedBox(height: 20),
                  SizedBox(
                    width: 345,
                    height: 74,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.black
                      ),
                      child: Text(
                        "Call Campus Safety",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1,
                          fontFamily: "Inter",
                          ),
                      ),
                    ),
                  )
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}
