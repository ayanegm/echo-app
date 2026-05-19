import 'package:echo/features/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSeachBar extends StatelessWidget {
  const CustomSeachBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        
        // color: Color(0xFFfafafa),
        border: Border.all(
          width: 0.5,
      color:Color(0xFF676c70),
    ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Center(
          child: TextField(
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              context.read<searchCubit>().onSearchChanged(value.toLowerCase().trim());
            },
            decoration: InputDecoration(
              
              hintText: 'Search',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: const Color(0xFF676c70),
                size: 23,
              ),
              hintStyle: TextStyle(color: const Color(0xFF676c70)),
              border: InputBorder.none,
          
            ),
          ),
        ),
      ),
    );
  }
}