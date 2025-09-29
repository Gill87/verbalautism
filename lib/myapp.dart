import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbalautism/features/auth/data/firebase_auth_repo.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_states.dart';
import 'package:verbalautism/features/auth/presentation/pages/auth_page.dart';
import 'package:verbalautism/features/home/pages/home_page.dart' deferred as home;

class MyApp extends StatelessWidget {

  final firebaseAuthRepo = FirebaseAuthRepo();
  
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Cubit
        BlocProvider <AuthCubit> (create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth()),
        
      ], 

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // Check Auth State and Guide to correct page
        home: BlocConsumer <AuthCubit, AuthState>(
          builder:(context, authState) {
            
            // Unauthenticated
            if(authState is Unauthenticated){
              return const AuthPage();
            } 

            if (authState is Authenticated) {
              return FutureBuilder(
                future: home.loadLibrary(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return home.HomePage();
                  } else {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }

            // Loading
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }, 

          listener: (context, authState) {
            if(authState is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.message)));
            }
          }
        )
      )

    );
  }
}