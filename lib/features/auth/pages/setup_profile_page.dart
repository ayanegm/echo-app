import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/features/auth/cubit/auth_state.dart';
import 'package:echo/features/auth/widgets/auth_button.dart';
import 'package:echo/features/auth/widgets/auth_test_field.dart';
import 'package:echo/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupProfilePage extends StatelessWidget {
   SetupProfilePage({super.key,required this.email,required this.uid});
String email;
String uid;
TextEditingController usernameController=TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController bioController=TextEditingController();
TextEditingController linksController=TextEditingController();

final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is AuthProfileSetupSuccess){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return HomePage();
            },));
          }
          else if(state is AuthFailureState){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {        
      
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Form(
                key:_formKey ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [                        
                    AuthTextField(field_title: 'Full Name', controller: nameController, validator: (val) {
                        if(val==''){
                          return 'name Cannot be empty';
                        }
                    },),
                    SizedBox(height: 14,),
                    AuthTextField(field_title: 'username', controller: usernameController, validator: (val) {
                        if(val==''){
                          return 'Userame cannot be empty';
                        }
                        return null;
                    },),
                    SizedBox(height: 14,),
                    AuthTextField(field_title: 'Bio (optional)', controller: bioController, validator: (val) => null,),
                    SizedBox(height: 14,),
                    AuthTextField(field_title: 'Link (Optional)', controller: linksController, validator: (val) => null,
                        
                    ),
                    SizedBox(height: 14,),
                    
                    SizedBox(height: 14,),
                     state is AuthLoadingState ?CircularProgressIndicator(color: Colors.white,)
                    :AuthButton(text: 'Sign up',onTap: ()async {
                     context.read<AuthCubit>().setupUserProfile(name: nameController.text, username: usernameController.text, email: email, uid: uid,bio: bioController.text.isNotEmpty?bioController.text:null,link: linksController.text.isNotEmpty?linksController.text:null);
                    },),
                   
                  ],
                ),
              ),
            ),
          ),
        );
        }
      ),
      );
  }
}