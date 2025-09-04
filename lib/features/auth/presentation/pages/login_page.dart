
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbalautism/components/login%20page%20components/login_button.dart';
import 'package:verbalautism/components/login%20page%20components/text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:verbalautism/features/auth/presentation/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // username and password text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {

    // Prepare email and password
    final String email = emailController.text;
    final String password = passwordController.text;

    // get auth cubit
    final authCubit = context.read<AuthCubit>();

    // Ensure fields are not empty
    if(email.isNotEmpty && password.isNotEmpty){
        // Login
        authCubit.login(email, password);
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Please enter an email and password"),
            )
        );
    }
        
  }

  // Google Sign in
  void googleSignIn(){
    final authCubit = context.read<AuthCubit>();
    authCubit.googleSignIn();
  }
 
  @override
  Widget build(BuildContext context) {
    
    // Screen check
    bool smallHeight(BuildContext context) =>
      MediaQuery.of(context).size.height <= 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20,),

                  // logo
                  Image.asset(
                    'assets/loginpage_images/logo.png',
                    height: smallHeight(context) ? 125 : 150,
                    // width: 300,
                  ),

                const SizedBox(height: 10,),

                Text(
                  'Welcome Back',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
          
                const SizedBox(height:15),
          
                // email textfield
                SizedBox(
                  width: 400,
                  child: MyTextField( 
                    controller: emailController,
                    textBoxDetails: 'Email',
                    hideText: false,
                    ),
                ),
          
                const SizedBox(height: 15),
                
                // password textfield 
                SizedBox(
                  width: 400,
                  child: MyTextField(
                    controller: passwordController,
                    textBoxDetails: 'Password',
                    hideText: true,
                    ),
                ),
          
                const SizedBox(height:15),

                // forget password
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TextButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
                          )
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.ubuntu(color:Colors.white, fontSize: 18, decoration: TextDecoration.underline, decorationColor: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 80,),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TextButton(
                        onPressed: widget.onTap,
                        child: Text(
                          'Create Account',
                           style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 18, decoration: TextDecoration.underline, decorationColor: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 20),
          
                // sign in button
                SizedBox(
                  width: 300.0,
                  child: LoginButton(
                    tapFunction: signUserIn,
                    text: 'Sign In',
                  ),
                ),
          
                const SizedBox(height:20),
          
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
                  onTap: () => googleSignIn(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border:Border.all(color:Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                          color:Colors.white,
                        ),
                        child: Image.asset(
                          'assets/loginpage_images/google.png',
                          height:50,
                        )
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}
