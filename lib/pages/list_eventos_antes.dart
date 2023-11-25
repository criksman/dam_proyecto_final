import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_final/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ListEventosAntes extends StatefulWidget {
  //const ListEventos({super.key});

  @override
  State<ListEventosAntes> createState() => _ListEventosAntesState();
}

class _ListEventosAntesState extends State<ListEventosAntes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirestoreService().eventoAntesDeFechaActual(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var evento = snapshot.data!.docs[index];
                    return Slidable(
                      startActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: MdiIcons.information,
                          label: 'Información',
                          onPressed: (context) {
                            String nombre = evento['nombre'];
                            String lugar = evento['lugar'];
                            String tipo = evento['tipo'];
                            String descripcion = evento['descripcion'];
                            String me_gusta = evento['me_gusta'].toString();
                            String foto = evento['foto'];
                            Timestamp fechaTimestamp = evento['fecha'];
                            DateTime fecha = fechaTimestamp.toDate();

                            infoEvento(context, nombre, lugar, tipo,
                                descripcion, fecha, me_gusta, foto);
                          },
                        ),
                      ]),
                      child: ListTile(
                        title: Text('${evento['nombre']}'),
                        subtitle: Text('${evento['lugar']}'),
                        trailing: Column(
                          children: [
                            InkWell(
                              child: Icon(
                                MdiIcons.heart,
                                color: Colors.red,
                              ),
                              onTap: () async {
                                await FirestoreService().addMeGusta(evento.id);
                              },
                            ),
                            Text('${evento['me_gusta'].toString()}'),
                          ],
                        ),
                        leading: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(evento['foto']),
                        ),
                      ),
                      endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: MdiIcons.trashCan,
                          label: 'Borrar',
                          onPressed: (context) {
                            FirestoreService().eventoBorrar(evento.id);
                          },
                        ),
                      ]),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void infoEvento(BuildContext context, nombre, lugar, tipo, descripcion, fecha,
      me_gusta, foto) {
    final formatoFecha = DateFormat('dd-MM-yyyy');
    final formatoHora = DateFormat('HH:mm');

    showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              border: Border.all(color: Colors.black38),
            ),
            padding: EdgeInsets.all(18),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('Detalles del evento',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF051E34))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 18),
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.network(foto),
                ),
                Text('Nombre: ${nombre}'),
                Text('Descripción: ${descripcion}'),
                Text('Lugar: ${lugar}'),
                Text('Fecha: ${formatoFecha.format(fecha)}'),
                Text('Hora: ${formatoHora.format(fecha)}'),
                Text('Tipo: ${tipo}'),
                Text('Cantidad de likes: ${me_gusta}'),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style:
                        OutlinedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text('Cerrar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
