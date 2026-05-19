
import 'package:echo/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AuthTextField extends StatefulWidget {
   AuthTextField({super.key,this.readOnly=false,this.onTap,this.isPassword = false,required this.field_title,this.isText=true,this.maxLines,required this.controller,required this.validator});
String field_title;
TextEditingController controller;
String? Function(String?)?validator;
  final VoidCallback? onTap;
final bool readOnly;
bool isText;
int? maxLines;
final bool isPassword;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    // Initialize with the value passed from the parent
    _obscureText = widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      controller: widget.controller,
      validator:widget.validator,
      obscureText:_obscureText,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white
      ),
      inputFormatters: widget.isText 
          ? null 
          : [FilteringTextInputFormatter.digitsOnly],
          keyboardType: widget.isText ? TextInputType.text : TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                fillColor:Color(0xFF1E1E1E),
                focusColor: Colors.white,
                suffixIcon: widget.isPassword 
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
               
                
                hintText: widget.field_title,
                hintStyle: const TextStyle(color:Color(0xFF757575) ,fontSize: 15,fontWeight: FontWeight.w500),
              ),
            );
  }
}