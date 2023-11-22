import 'package:dam_proyecto_final/pages/agregar_evento.dart';
import 'package:dam_proyecto_final/pages/list_eventos.dart';
import 'package:dam_proyecto_final/pages/sign_in.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.admin});

  final bool admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de eventos'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 90,
                child: const DrawerHeader(
                    decoration: BoxDecoration(
                        //
                        ),
                    child: Text('Iniciado Sesión como: N/A')),
              ),
              Visibility(
                visible: admin, // Only show if admin is true
                child: ListTile(
                  title: const Text('Agregar evento'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AgregarEvento()),
                    );
                  },
                ),
              ),
              ListTile(
                title: Text('Cerrar Sesión'),
                onTap:() {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
                },
              )
            ],
          ),
        ),
        body: ListEventos());
  }
}
