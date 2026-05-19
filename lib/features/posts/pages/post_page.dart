import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/features/auth/models/user_model.dart';
import 'package:echo/features/posts/cubit/post_cubit.dart';
import 'package:echo/features/posts/cubit/post_state.dart';
import 'package:echo/features/posts/widgets/post_button.dart';
import 'package:echo/features/posts/widgets/post_text_field.dart';
import 'package:echo/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
 final TextEditingController _controller=TextEditingController();
 void dispose(){
  _controller.dispose();
  super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit,PostState>(
      builder: (context, state) {
        return Scaffold(
        
        backgroundColor: Color(0xFF141414),
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
  child:PostButton(
  onTap: () {
    print("🔘 Post Button Clicked!");
    
    // 1. بنحاول نجيب الـ user من الـ Cubit
    var user = context.read<AuthCubit>().currentUser;
    
    // 2. خط الدفاع الثاني: لو بـ null بسبب الحساب الجديد، بنصنعه طازة بأمان
    if (user == null) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final generatedUsername = firebaseUser.email?.split('@')[0] ?? 'user';
        final displayName = firebaseUser.displayName ?? 'User';
        
        user = UserModel(
          uid: firebaseUser.uid,
          name: displayName,
          searchName: displayName.trim().toLowerCase(), // 🔥 ضفنا الـ searchName هنا عشان الموديل يكتمل صح
          username: generatedUsername.trim().toLowerCase(),
          email: firebaseUser.email ?? '',
          followers: const [],
          following: const [],
          followersCount: 0,
          followingCount: 0,
        );
      }
    }

    print("👤 Final verified User ID: ${user?.uid}");

    if (user != null && _controller.text.isNotEmpty) {
      context.read<PostCubit>().createTweet(text: _controller.text, currentUser: user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check your network or type something!'))
      );
    }
  },
  isLoading: state is PostLoadingState,
)
            )
          ],
        ),
        body: Column(
          children: [
            PostTextField(controller: _controller,),
            SizedBox(height: 10,),
          ],
        ),
      );
      },
      listener:(context, state) {
        if(state is PostFailureState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage))
          );
        }
        else if(state is PostSuccess){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
            return HomePage();
          },));
        }
      } ,
      
    );
  }
}