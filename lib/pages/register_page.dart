import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbalautism/components/my_button.dart';
import 'package:verbalautism/components/text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/services/auth_google.dart';

class RegisterPage extends StatefulWidget {
  
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // username and password text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {

    // show loading circle
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if(passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      errorMessage('Passwords do not match');
    } 
    else {
      // try creating the user
      try {
        // check if password is confirmed
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
      backgroundColor:  const Color.fromARGB(255, 33, 150, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height:5),
          
                // logo
                Image.asset(
                  'lib/images/logo4.png',
                  height: 250,
                  width: 250,
                ),

                const SizedBox(height:15),
          
                // Create an Account
                Text(
                  'Create Account',
                  style:GoogleFonts.ubuntu(color: Colors.white, fontSize: 40),
                ),
          
                const SizedBox(height:25),
          
                // email textfield
                SizedBox(
                  width: 400.0,
                  child: MyTextField(
                    controller: emailController,
                    textBoxDetails: 'Username',
                    hideText: false,
                    ),
                ),
          
                const SizedBox(height: 15),
                
                // password textfield 
                SizedBox(
                  width:400.0,
                  child: MyTextField(
                    controller: passwordController,
                    textBoxDetails: 'Password',
                    hideText: true,
                    
                    ),
                ),

                const SizedBox(height:15),

                // confirm password textfield 
                SizedBox(
                  width: 400,
                  child: MyTextField(
                    controller: confirmPasswordController,
                    textBoxDetails: 'Confirm Password',
                    hideText: true,
                  ),
                ),
                        
                const SizedBox(height: 20),
          
                // sign up button
                SizedBox(
                  width:425.0,
                  child: MyButton(
                    tapFunction: signUserUp,
                    text: 'Sign Up',
                  ),
                ),
          
                const SizedBox(height:40),
          
                // or continue with
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const Expanded(child: 
                        Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
          
                // google button
                GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(),
                  child: Padding(
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
                ),
          
                // already a member? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?', 
                      style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 14),

                      ),

                    const SizedBox(width:4),

                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login Now',
                        style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 14),
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
