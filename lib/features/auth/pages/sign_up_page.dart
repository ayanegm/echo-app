import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/features/auth/cubit/auth_state.dart';
import 'package:echo/features/auth/pages/setup_profile_page.dart';
import 'package:echo/features/auth/pages/sign_in_page.dart';
import 'package:echo/features/auth/widgets/auth_button.dart';
import 'package:echo/features/auth/widgets/auth_test_field.dart';
import 'package:echo/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
   SignUpPage({super.key});
final TextEditingController emailController=TextEditingController();
final TextEditingController passwordController=TextEditingController();
final TextEditingController usernameController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AuthCubit,AuthState>(
        listener: (context, state) {
          if(state is AuthSignedUp){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return SetupProfilePage(email: state.email,uid: state.uid,);
            },));
          }
        
        else if(state is AuthFailureState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage))
          );
        }
        },
        builder:(context, state) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthTextField(field_title: 'Email', controller: emailController, validator: (val) {
                      if(val==''){
                        return 'Cannot be empty';
                      }
                  },),
                  SizedBox(height: 14,),
                  AuthTextField(field_title: 'Password', controller: passwordController, validator: (val) {
                      if(val==''){
                        return 'Cannot be empty';
                      }
                  },isPassword: true,),
                  
                  SizedBox(height: 20,),
                  AuthButton(text: 'Sign up',onTap: ()async {
                    context.read<AuthCubit>().signUpWithEmailAndPassword(email:emailController.text,password:passwordController.text);
                  },),
                 
                ],
              ),
            ),
          ),
        );
        
  })
    );
  }
}