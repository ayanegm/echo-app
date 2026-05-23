import 'package:echo/features/auth/cubit/auth_state.dart';
import 'package:echo/features/auth/pages/profile_setup_page.dart';
import 'package:echo/features/auth/pages/sign_up_page.dart';
import 'package:echo/features/auth/widgets/auth_button.dart';
import 'package:echo/features/auth/widgets/auth_test_field.dart';
import 'package:echo/features/search/cubit/search_cubit.dart';
import 'package:echo/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:echo/features/auth/cubit/auth_cubit.dart';
class SignInPage extends StatelessWidget {
   SignInPage({super.key});
final TextEditingController emailController=TextEditingController();
final TextEditingController passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:BlocConsumer<AuthCubit,AuthState>(builder: (context, state) {
        return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    'echo.',
    style: TextStyle(
      color: Colors.white70, 
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5, 
    ),
  ),
),
const SizedBox(height: 40),
                Spacer(),
                AuthTextField(field_title: 'Enter your email', controller: emailController, validator: (val) {
                    if(val==''){
                      return 'Cannot be empty';
                    }
                },),
                SizedBox(height: 12,),
                AuthTextField(field_title: 'Enter your password', controller: passwordController, validator: (val) {
                    if(val==''){
                      return 'Cannot be empty';
                    }
                },isPassword: true,),
                
                SizedBox(height: 20,),
                if(state is AuthLoadingState)
                CircularProgressIndicator(color: Colors.white,)
               else AuthButton(text: 'Login',onTap: ()async {
                  context.read<AuthCubit>().signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                },),
                 const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont't have an account?",style: TextStyle(color: Colors.white),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SignUpPage();
                        },));
                      },
                      child: Text('Sign Up',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),

                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
      }, listener: (context, state) {
        if(state is AuthLoggedIn){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return HomePage();
          },));
        }
        else if(state is AuthFailureState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage))
          );
        }
        
      },) 
    );
  }
}