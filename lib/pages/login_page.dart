import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbalautism/components/my_button.dart';
import 'package:verbalautism/components/text_field.dart';

class LoginPage extends StatefulWidget {
  
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // username and password text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {

    // show loading circle
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );

      // Pop Loading Circle
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      // Pop Loading Circle
      Navigator.pop(context);

      // Wrong EMAIL
      if(e.code == 'invalid-email') {
        errorMessage('Invalid Email');
      } 

      // Wrong PASSWORD
      else if (e.code == 'invalid-credential'){
        errorMessage('Invalid Password');
      }
    }
  }

  // Display Incorrect Credential Dialog
  void errorMessage(String errorText){
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(errorText),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 224, 206, 206),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height:50),
          
                // logo
                Image.asset('lib/images/logo-new.png'),
          
                const SizedBox(height:50),
          
                // welcome back
                const Text(
                  'Welcome Back!',
                  style:TextStyle(
                    color:Colors.black,
                    fontSize: 40,
                  )
                ),
          
                const SizedBox(height:25),
          
                // email textfield
                MyTextField( 
                  controller: emailController,
                  textBoxDetails: 'Email',
                  hideText: false,
                  ),
          
                const SizedBox(height: 15),
                
                // password textfield 
                MyTextField(
                  controller: passwordController,
                  textBoxDetails: 'Password',
                  hideText: true,
                  ),
          
                const SizedBox(height:15),

                // forget password
                const Text(
                  'Forgot Password?',
                  style: TextStyle(color:Colors.black),
                ),
          
                const SizedBox(height: 20),
          
                // sign in button
                MyButton(
                  tapFunction: signUserIn,
                  text: 'Sign In',
                ),
          
                const SizedBox(height:40),
          
                // or continue with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(child: 
                        Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
          
                // google button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border:Border.all(color:Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                      color:Colors.white,
                    ),
                    child: Image.asset(
                      'lib/images/google.png',
                      height:50,
                    )
                  ),
                ),
          
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    SizedBox(width:4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color:Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )
                      ),
                    )
                  ],
                )
              ]
            
            ),
          ),
        ),
      )
    );
  }
}
