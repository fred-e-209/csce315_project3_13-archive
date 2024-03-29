/// Window for creating an account.

import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Contrast_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_TextField.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:flutter/material.dart';


class Win_Create_Account extends StatefulWidget {
  static const String route = '/create-account';
  const Win_Create_Account({Key? key}) : super(key: key);

  @override
  State<Win_Create_Account> createState() => _Win_Create_AccountState();
}

class _Win_Create_AccountState extends State<Win_Create_Account> {

  bool _show_password = false;

  late TextEditingController _username_controller;
  late TextEditingController _password_controller1;
  late TextEditingController _password_controller2;

  login_helper _login_helper_instance = login_helper();

  void _switch_show_password(){
    setState(() {
      _show_password = !_show_password;
    });
  }

  void _create_account({required BuildContext context}){
    if(_password_controller1.text == _password_controller2.text){
      //  If both passwords are the same calls the login helper function
      _login_helper_instance.create_account(context: context, user_email: _username_controller.text, user_password: _password_controller1.text);
    }else{
      //  If the passwords are different
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Entered different passwords'),
            content: const Text('Try again, and ensure your passwords match'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // Perform some action here
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    }

  }



  @override
  void initState() {
    super.initState();
    _username_controller = TextEditingController();
    _password_controller1 = TextEditingController();
    _password_controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _username_controller.dispose();
    _password_controller1.dispose();
    _password_controller2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    return Scaffold(
      appBar: Page_Header(
          context: context,
          pageName: "Create account",
          buttons: [
            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context, Win_Login.route);
            }, buttonName: "Back",
              fontSize: 15,
            ),
          ]),

      backgroundColor: _color_manager.background_color,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Enter your email and password:',
                  style: TextStyle(
                    fontSize: 30,
                    color: _color_manager.text_color,
                  ),
                ),
              ),

              Login_TextField(
                context: context,
                textController: _username_controller,
                onSubmitted: (){
                  _create_account(context: context);
                },
                labelText: "Email",
              ),


              Login_TextField(
                context: context,
                textController: _password_controller1,
                onSubmitted: (){
                  _create_account(context: context);
                },
                obscureText: !_show_password,
                labelText: "Password",
              ),

              Login_TextField(
                  context: context,
                  textController: _password_controller2,
                  onSubmitted: (){
                    _create_account(context: context);
                  },
                  obscureText: !_show_password,
                  labelText: "Re-enter Password",
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      fillColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                        Set<MaterialState> interactiveStates = <MaterialState>{
                          MaterialState.pressed,
                          MaterialState.hovered,
                          MaterialState.focused,
                        };
                        return _color_manager.active_color;
                      }),
                      hoverColor: _color_manager.hover_color,
                      activeColor: _color_manager.active_color,
                      checkColor: _color_manager.text_color,
                      value: _show_password,
                      onChanged: (changed_value){
                        _switch_show_password();
                      }),

                  Text("Show password",
                  style: TextStyle(
                    color: _color_manager.text_color,
                  ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Login_Button(onTap: (){
                  _create_account(context: context);
                }, buttonName: "Create",
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
