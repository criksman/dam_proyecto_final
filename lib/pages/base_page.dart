import 'package:dam_proyecto_final/pages/agregar_evento.dart';
import 'package:dam_proyecto_final/pages/list_eventos.dart';
import 'package:dam_proyecto_final/pages/list_eventos_antes.dart';
import 'package:dam_proyecto_final/pages/list_eventos_futuros.dart';
import 'package:dam_proyecto_final/pages/sign_in.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.admin});

  final bool admin;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final List<Widget> paginas = [ListEventosAntes(), ListEventos(), ListEventosFuturos()];
  var paginaSeleccionada = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(paginaSeleccionada == 1 ? 'Todos los eventos' : paginaSeleccionada == 0 ? 'Eventos pasados' : 'Eventos Futuros'),
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
              ListTile(
                title: Text('Todos los eventos'),
                onTap: () {
                  setState(() {
                    paginaSeleccionada = 1;
                  });
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: Text('Eventos futuros'),
                onTap: () {
                  setState(() {
                    paginaSeleccionada = 2;
                  });
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: Text('Eventos pasados'),
                onTap: () {
                  setState(() {
                    paginaSeleccionada = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              Visibility(
                visible: widget.admin,
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
        body: paginas[paginaSeleccionada]
      );
  }
}
