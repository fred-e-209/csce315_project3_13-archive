import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:csce315_project3_13/Services/order_processing_helper.dart';
import 'package:csce315_project3_13/Services/weather_API.dart';
import 'package:flutter/material.dart';

/// A StatefulWidget that provides a test page for Win_Functions.
class Win_Functions_Test_Page extends StatefulWidget {
  static const String route = '/functions-test-page';
  const Win_Functions_Test_Page({super.key});

  @override
  State<Win_Functions_Test_Page> createState() => _Win_Functions_Test_Page_StartState();
}


class _Win_Functions_Test_Page_StartState extends State<Win_Functions_Test_Page> {


  order_processing_helper order_helper = order_processing_helper();
  login_helper login_helper_instance = login_helper();
  weather_API weather = weather_API();

  bool is_high_contrast = false;


  @override
  Widget build(BuildContext context) {
    final my_color_manager = Color_Manager.of(context);


    return Scaffold(
      appBar: AppBar(
        title: Text("Test functions page",
        style: TextStyle(
          color: my_color_manager.active_color,
        ),
        ),
      ),
      backgroundColor: my_color_manager.primary_color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: (){
              login_helper_instance.is_signed_in();
            }, child: const Text("Get logged in user")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              // weather.get_user_city();
            }, child: const Text("Get UID")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              login_helper_instance.sign_out();
            }, child: const Text("Sign out")),
            const SizedBox(
              height: 20,
            ),





            // t
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}