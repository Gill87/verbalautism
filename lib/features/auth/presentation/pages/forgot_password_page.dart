import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/login%20page%20components/text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Function to handle password reset
  Future passwordReset() async {

    // Get the email from the text field
    String email = emailController.text.trim();

    if (email.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address.")),
      );
      return;
    } 

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email.")),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      appBar: AppBar(
        title: Text("VERBAL Academic Support", style: GoogleFonts.ubuntu(fontSize: 24),),
        elevation: 0,
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
        
            Text(
              "Forgot Password?",
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
        
            const SizedBox(height: 20),
        
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Enter your email address below and we'll send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 16,    
                  color: Colors.white          
                ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            SizedBox(
              width: 400,
              child: MyTextField(
                controller: emailController,
                textBoxDetails: "Email",
                hideText: false,
              ),
            ),
        
            const SizedBox(height: 20),
        
            // Button to send password reset link
            ElevatedButton(
              
              onPressed: () {
                passwordReset();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text(
                "Send Reset Link",
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            // Button to navigate back to login page
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: Text(
                "Back to Login",
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}