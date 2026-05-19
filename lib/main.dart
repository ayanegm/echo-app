import 'package:echo/features/auth/cubit/auth_cubit.dart';
import 'package:echo/features/auth/pages/sign_in_page.dart';
import 'package:echo/features/auth/pages/sign_up_page.dart';
import 'package:echo/features/posts/cubit/post_cubit.dart';
import 'package:echo/features/profile/profile_cubit.dart';
import 'package:echo/features/search/cubit/search_cubit.dart';
import 'package:echo/firebase_options.dart';
import 'package:echo/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<searchCubit>(
          create: (context) => searchCubit(),
        ),
         BlocProvider<PostCubit>(
          create: (context) => PostCubit(),
        ),
         BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SignInPage() ,
    );
  }
}