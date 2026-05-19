import 'package:echo/features/search/cubit/search_cubit.dart';
import 'package:echo/features/search/cubit/search_state.dart';
import 'package:echo/features/search/widgets/result_container.dart';
import 'package:echo/screens/my_profile_page.dart';
import 'package:echo/screens/other_usre_profile_page.dart';
import 'package:echo/widgets/bottom_navigator.dart';
import 'package:echo/features/search/widgets/seach_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      bottomNavigationBar: CustomBottomNavigatorBar(selectedIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CustomSeachBar(),
            const SizedBox(height: 10),
            Expanded(child: BlocBuilder<searchCubit,searchState>(
              
              builder: (context, state) {
              if(state is seachLoading){
                return Center(child: CircularProgressIndicator(),);
              }
              else if(state is searchSuccessState){
                return ListView.builder(itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return OtherUsreProfilePage(index: 1,user:state.users[index] ,);                        
                      },));
                    },
                    child: ResultContainer(user: state.users[index]));
                },itemCount: state.users.length,);
              }
              else if(state is searchInitial){
                return Center(child: Text("Try search for people",style: TextStyle(color: Colors.grey),));
              }
              return SizedBox();
            },),
            )
          ],
        ),
      ),
    );
  }
}