import 'package:flutter/material.dart';

class EventoCampo extends StatelessWidget {
  const EventoCampo({
    super.key,
    required this.nombre,
    required this.controller,
  });

  final String nombre;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(this.nombre),
        ),
      ),
    );
  }
}
