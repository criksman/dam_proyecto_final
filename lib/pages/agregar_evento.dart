import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_final/services/firestore_service.dart';
import 'package:dam_proyecto_final/widgets/evento_campo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({super.key});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final formatoFecha = DateFormat('dd-MM-yyyy');

  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController descCtrl = new TextEditingController();
  TextEditingController lugarCtrl = new TextEditingController();

  DateTime fecha_evento = DateTime.now();
  String tipo = '';
  String imageUrl = '';
  bool isTimePicked = false;

  DateTime timestamps = DateTime.now();

  TimeOfDay time_evento = TimeOfDay.now();
  String selectedTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar evento'),
        ),
        body: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        //print('${file?.path}');

                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('img');

                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        try {
                          await referenceImageToUpload
                              .putFile(File(file!.path));
                          setState(() async {
                            imageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          });
                        } catch (error) {
                          //
                        }
                      },
                      icon: Icon(MdiIcons.camera)),
                  EventoCampo(nombre: 'Nombre', controller: nombreCtrl),
                  EventoCampo(nombre: 'Descripción', controller: descCtrl),
                  EventoCampo(nombre: 'Lugar', controller: lugarCtrl),
                  FutureBuilder(
                    future: FirestoreService().tipos(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Cargando tipos de eventos...');
                      } else {
                        var tipos = snapshot.data!.docs;
                        return DropdownButtonFormField<String>(
                          value: tipo == '' ? tipos[0]['nombre'] : tipo,
                          decoration: InputDecoration(labelText: 'Tipo'),
                          items: tipos.map<DropdownMenuItem<String>>((tip) {
                            return DropdownMenuItem<String>(
                              child: Text(tip['nombre']),
                              value: tip['nombre'],
                            );
                          }).toList(),
                          onChanged: (tipoSeleccionado) {
                            setState(() {
                              tipo = tipoSeleccionado!;
                            });
                          },
                        );
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Text('Fecha de evento: '),
                        Text(formatoFecha.format(fecha_evento),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Spacer(),
                        IconButton(
                          icon: Icon(MdiIcons.calendar),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              locale: Locale('es', 'ES'),
                            ).then((fecha) {
                              setState(() {
                                fecha_evento = fecha ?? fecha_evento;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Text('Hora del evento: '),
                        Text(
                          selectedTime.isNotEmpty
                              ? selectedTime
                              : 'Seleccione la hora',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(MdiIcons.clock),
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((time) {
                              if (time != null) {
                                setState(() {
                                  time_evento = time;
                                  selectedTime = time.format(context);
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Agregar evento',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      String nombre = nombreCtrl.text;
                      String desc = descCtrl.text;
                      String lugar = lugarCtrl.text;

                      DateTime combinedDateTime = DateTime(
                        fecha_evento.year,
                        fecha_evento.month,
                        fecha_evento.day,
                        time_evento.hour,
                        time_evento.minute,
                      );

                      FirestoreService().agregarEvento(
                          nombre, tipo, desc, combinedDateTime, lugar, imageUrl);

                      Navigator.pop(context);
                    },
                  )
                ],
              )),
            ],
          ),
        ));
  }
}
