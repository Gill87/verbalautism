import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbalautism/components/my_button.dart';
import 'package:verbalautism/components/text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // username and password text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user in method
  void register() {

    // get text fields
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Auth Cubit
    final authCubit = context.read<AuthCubit>();
    
    // ensure fields aren't empty 
    if(email.isNotEmpty && name.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty){

      // Check passwords match
      if(password == confirmPassword){
        authCubit.register(email, password, name);
      } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")),
          );
      }
    } 
    
    // Fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
    }
  }

  void googleSignIn(){
    final authCubit = context.read<AuthCubit>();
    authCubit.googleSignIn();
  }


  @override
  Widget build(BuildContext context) {

    bool smallHeight(BuildContext context) =>
      MediaQuery.of(context).size.height >= 600;
      
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
                  'lib/images/loginpage_images/logo4.png',
                  height: smallHeight(context) ? 250 : 125,
                  width: 250,
                ),

                const SizedBox(height:15),
          
                // Create an Account
                Text(
                  'Create Account',
                  style:GoogleFonts.ubuntu(color: Colors.white, fontSize: 40),
                ),
          
                const SizedBox(height:25),
                
                // name textfield
                SizedBox(
                  width: 400.0,
                  child: MyTextField(
                    controller: nameController,
                    textBoxDetails: 'Name',
                    hideText: false,
                    ),
                ),

                const SizedBox(height:15),

                // email textfield
                SizedBox(
                  width: 400.0,
                  child: MyTextField(
                    controller: emailController,
                    textBoxDetails: 'Email',
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
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: MyButton(
                      tapFunction: register,
                      text: 'Sign Up',
                    ),
                  ),
                ),
          
                const SizedBox(height:40),
          
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  onTap: () => googleSignIn,
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
                        'lib/images/loginpage_images/google.png',
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
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          'Login Now',
                          style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 14, decoration: TextDecoration.underline, decorationColor: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),
              ]
            ),
          ),
        ),
      )
    );
  }
}
