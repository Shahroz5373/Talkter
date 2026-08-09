import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserData extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController mailController;
  final GlobalKey<FormState> formKey ;

   const UserData({super.key,
     required this.nameController,
     required this.mailController,
     required this.formKey
  });

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {



  @override
  Widget build(BuildContext context) {
    return
      Container(
        //color: Colors.transparent,
        padding: EdgeInsets.all(10),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              Text(
                "Create Your Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Join the conversation — just a few details",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _inputField(controller: widget.nameController ),
              const SizedBox(height: 21),
              _inputField(controller: widget.mailController ,type: "Mail" ),
            ],
          ),
        ),
      );
  }
}
  TextFormField _inputField({
    required TextEditingController controller,
    String type = "Name"

  }){
    return TextFormField(
              controller: controller,
              keyboardType:type == "Name" ?
                TextInputType.text : TextInputType.emailAddress ,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              cursorErrorColor: Colors.red,
              decoration: InputDecoration(
                hintText: type == "Name" ?
                  " e.g., Alex Rivers" : "hello@example.com"  ,
                hintStyle: TextStyle(color: Color.fromARGB(255, 203, 200, 200)),
                labelText: type == "Name" ? "Full Name" : "Email address",
                labelStyle: TextStyle(color: Color.fromARGB(255, 203, 200, 200)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
              (value ==null || value.isEmpty) ? "Please enter the $type" : null,
            );
  }

