import 'package:dam_proyecto_final/pages/base_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue)
                  ),
                  child: Text('Admin'),
                ),
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => BasePage(admin: true),));
                },
              ),

              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue)
                  ),
                  child: Text('Usuario'),
                ),
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => BasePage(admin: false),));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}