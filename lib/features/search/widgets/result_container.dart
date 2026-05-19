import 'package:echo/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';

class ResultContainer extends StatelessWidget {
  const ResultContainer({super.key, required this.user});
final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(children: [
            Row(
              children: [
                Text(user.name,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Inter',fontSize: 15,letterSpacing: -0.5,color: Colors.white),),
                SizedBox(width: 2,),
                Icon(Icons.verified,color: Color(0xFF1D9BF0),size: 18,)
              ],
            ),
            SizedBox(height: 2,),
            Text(user.username,style: TextStyle(foreground: Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5 
      ..color = Colors.white.withOpacity(0.5),fontSize: 14))
          
        ],
      ),
      Spacer(),
      IconButton(onPressed:() {
        
      } , icon: Icon(Icons.close),color:Color(0xFF1D9BF0) ,iconSize:20,)
    ])
    );
  }
}