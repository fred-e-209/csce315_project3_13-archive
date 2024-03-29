import 'package:csce315_project3_13/GUI/Pages/Loading/Loading_Page.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/GUI/Pages/Server_View/Win_Server_View.dart';
import 'package:csce315_project3_13/Models/employee.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A helper class for logging in a user with email and password.
class login_helper{

  /// Logs in a user with the given email and password.
  ///
  /// Returns `true` if the sign-in was successful, `false` otherwise.
  void login({required BuildContext context, required String username, required String password}) async {
    String cleared_username = username.replaceAll(" ", "");
    bool sign_in_successful = await sign_in_email_password(user_email: cleared_username, user_password: password);
    if(sign_in_successful){
      //Shows the loading screen while the function runs
      Navigator.pushNamed(context, Win_Loading_Page.route);
      navigate_to_landing(context: context);
    }else{
      print("Failed login");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign in failed'),
            content: Text('Username or password is incorrect.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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



  /// Sign in the user with their email and password.
  ///
  /// @param user_email The email of the user trying to sign in.
  /// @param user_password The password of the user trying to sign in.
  /// @return A Future that resolves to a boolean value indicating whether the sign in was successful or not.
  Future<bool> sign_in_email_password({required String user_email, required String user_password}) async {
    //signs the user in with email and password

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user_email,
        password: user_password,
      );
      // Handle successful login
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }


  /// Navigate the logged in user to the correct first page for them.
  ///
  /// @param context The BuildContext of the current screen.
  /// @return A Future with no return value.
  Future<void> navigate_to_landing({required BuildContext context}) async {
    // this navigates the logged in user to the correct first page for them

    //TODO add functionality to navigate to correct page for user

    String user_uid = await get_firebase_uid();

    employee current_employee = await get_employee_by_UID_database(user_uid);

    print("Current employee's role = ");
    print(current_employee.role);

    if(current_employee.role == "Manager"){
      //  TODO Add navigation to Manager page
      print("Navigating to manager page");


      //Pops the loading screen
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, Win_Manager_View.route);

    }else if(current_employee.role == "Server"){
      //  TODO Add navigation to Server page
      print("Navigating to server page");



      //Pops the loading screen
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, Win_Server_View.route);


    }else{
      // TODO Handle the edge case
      print("!!! The role was not one of the options");
      print("Handling unknown navigation");

      // Navigator.pushReplacementNamed(context, Win_Manager_View.route);

      //Pops the loading screen
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign in failed'),
            content: Text('You are not an authorized user'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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


  ///  Signs up a user with the provided email and password.
  ///  @param context The [BuildContext] used for navigation and displaying an alert dialog if an error occurs.
  ///  @param user_email The email address of the user to be signed up.
  ///  @param user_password The password of the user to be signed up.
  Future<void> create_account({ required BuildContext context, required String user_email, required String user_password}) async {
    //signs the user in with email and password

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user_email, password: user_password);
      // if account creation is successful
      Navigator.pushReplacementNamed(context, Win_Login.route);

    } on FirebaseAuthException catch (e) {

      print('ERROR Could not create email');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account creation failed'),
            content: const Text('Something went wrong, ensure email is valid and try again'),
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


  ///  Sends a password reset email to the provided email address.
  ///  @param user_email The email address of the user who needs to reset their password.
  ///  @param context The [BuildContext] used for displaying an alert dialog if an error occurs.
  Future<void> reset_password({required String user_email, required BuildContext context}) async {
    //signs the user in with email and password

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user_email);
      // Handle successful login
    } on FirebaseAuthException catch (e) {

      print('ERROR Could not reset email');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reset password failed'),
            content: const Text('Something went wrong, ensure email is correct and try again'),
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


  ///  Checks if a user is signed in to the app
  ///  Returns true if the user is signed in, false otherwise
  Future<bool> is_signed_in() async {
    // returns true if the user is signed in

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("Signed in as: ");
      print(user.email);
    }else{
      print("Not logged in");
    }

    return user != null;
  }

  ///  Retrieves the UID of the currently signed in user from Firebase
  ///  Returns the UID as a string if the user is signed in, and an empty string otherwise
  Future<String> get_firebase_uid() async {
    // gets the UID of the signed in user from firebase users

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Signed in and UID is:");
      print(user.uid);
      return user.uid;
    }else{
      print("Not logged in");
      return "";
    }
  }

  /// Retrieves the email address of the currently signed in user from Firebase
  /// Returns the email address as a string if the user is signed in, and an empty string otherwise
  Future<String> get_firebase_email() async {
    // gets the email of the signed in user from firebase users

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Signed in and email is:");
      print(user.email);
      String user_email = "notemail@gmail.com";
      user_email = (user.email).toString();
      return user_email;
    }else{
      print("Not logged in");
      return "";
    }
  }

  /// Signs out the user
  /// This function signs out the user by calling the signOut method of the FirebaseAuth instance.
  /// Returns a Future that completes when the user has been signed out.
  Future<void> sign_out() async {
    //signs out the user
    await FirebaseAuth.instance.signOut();
  }


  // Queries the psql database to get the data from the employee table
  // returns an employee object populated by the row with the given uid
  // if the uid is not in the database, the function returns an employee with
  // role = 'Customer', and email and name set to the logged in email and name
  /// Queries the psql database to get the data from the employee table
  /// This function queries the psql database to get the data from the employee table and returns an employee object populated
  /// by the row with the given uid. If the uid is not in the database, the function returns an employee with
  /// role = 'Customer', and email and name set to the logged in email and name.
  /// employee_uid - the uid of the employee to be retrieved from the database.
  ///
  /// Returns a Future that completes with the employee object populated with the retrieved
  Future<employee> get_employee_by_UID_database(String employee_uid) async {

    String employee_email = await get_firebase_email();

    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getEmployeeByUID');

    try{

      // Call the function with the employee UID as input

      final results = await callable.call(<String, dynamic>{
        'employee_uid': employee_uid,
      });



      // Extract the name of the employee from the data returned by the function
      List<dynamic> employeeData = results.data;



      String employee_name = employeeData[0]['employee_name'];
      String employee_role = employeeData[0]['employee_role'];
      int employee_id = employeeData[0]['employee_id'];



      String employee_hourly_rate_string = employeeData[0]['hourly_rate'];

      employee_hourly_rate_string = employee_hourly_rate_string.replaceAll('\$', '');
      double employee_hourly_rate = double.parse(employee_hourly_rate_string);



      print(employee_name);
      print(employee_role);
      print(employee_email);
      print(employee_id);
      print(employee_uid);
      print(employee_hourly_rate_string);

      return employee(id: employee_id, name: employee_name, email: employee_email, role: employee_role, uid: employee_uid, hourly_rate: employee_hourly_rate);

    }catch(e){
      print("Could not get employee by uid from database");
      print("error was");
      print(e);

      return employee(id: 0, name: employee_email, email: employee_email, role: "Customer", uid: employee_uid, hourly_rate: 0.0);
    }
  }


// These functions were used for testing getting an employee
// Future<employee> get_employee_by_uid({required String user_uid}) async {
//   // calls the get_employee_by_UID_database function and returns the results
//
//   employee employee_to_return = employee(id: 0, name: "", email: "", role: "", uid: "", hourly_rate: 0.0);
//
//   employee_to_return = await get_employee_by_UID_database(user_uid);
//
//   return employee_to_return;
// }


// This was temporary to get the hard coded values of the employees
// Future<employee> get_employee_by_UID_hardcoded(String employee_uid) async {
//
//
//   Map<String, employee> employee_hash_map = {
//     'RPhPjO2LQ2MMTHMwZS7N3JWFOAx2': employee(
//       id: 1,
//       name: 'Maharshi',
//       email: '',
//       role: 'Manager',
//       uid: 'RPhPjO2LQ2MMTHMwZS7N3JWFOAx2',
//       hourly_rate: 25.87,
//     ),
//     'wQI6aAGC4DYDHoNGXRNORnSnasb2': employee(
//       id: 2,
//       name: 'Jonas',
//       email: '',
//       role: 'Server',
//       uid: 'wQI6aAGC4DYDHoNGXRNORnSnasb2',
//       hourly_rate: 14.99,
//     ),
//     'FjOPjWpPRNYl2W6XqFymugBlKcs2': employee(
//       id: 3,
//       name: 'Tyler',
//       email: '',
//       role: 'Server',
//       uid: 'FjOPjWpPRNYl2W6XqFymugBlKcs2',
//       hourly_rate: 14.99,
//     ),
//     'kvrLmJjlxDgupk3IS6fgpO6KRM33': employee(
//       id: 4,
//       name: 'Freddy',
//       email: '',
//       role: 'Server',
//       uid: 'kvrLmJjlxDgupk3IS6fgpO6KRM33',
//       hourly_rate: 14.99,
//     ),
//     '2XkBeUBFQ9TjEYr2rOjwaqJkGFm2': employee(
//       id: 5,
//       name: 'Seth',
//       email: '',
//       role: 'Manager',
//       uid: '2XkBeUBFQ9TjEYr2rOjwaqJkGFm2',
//       hourly_rate: 25.87,
//     ),
//   };
//
//   employee current_employee = employee(id: 0, name: "", email: "", role: "Customer", uid: employee_uid, hourly_rate: 0.0);
//
//   if(employee_hash_map[employee_uid] != null){
//     current_employee = employee_hash_map[employee_uid] as employee;
//   }
//
//   String employee_email = await get_firebase_email();
//
//   print(employee_email);
//
//   current_employee.email = employee_email;
//
//   return current_employee;
// }

}