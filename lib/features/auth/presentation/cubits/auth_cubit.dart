import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbalautism/features/auth/domain/entities/app_user.dart';
import 'package:verbalautism/features/auth/domain/repo/auth_repo.dart';
import 'package:verbalautism/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState>{

  final AuthRepo authRepo;
  AppUser? _currentUser;
  
  AuthCubit(
    {
      required this.authRepo
    }
  ) : super(AuthInitial());

  // check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if(user != null){
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user getter
  AppUser? get currentUser => _currentUser;

  // login with email and password
  Future <void> login(String email, String password) async {
    try{
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);
      if(user != null){
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e){
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register with email and password
  Future <void> register(String email, String password, String name) async {
      try{

      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, password);

      if(user != null){
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }

    } catch (e){
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout
  Future <void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }

  // Google Sign In - Updated method in AuthCubit
  Future<void> googleSignIn() async {
    try {
      emit(AuthLoading());
      
      // Call the repository method
      await authRepo.googleSignIn();
      
      // After successful Google sign in, get the current user
      final user = await authRepo.getCurrentUser();
      
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

}