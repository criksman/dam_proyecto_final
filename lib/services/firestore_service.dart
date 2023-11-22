import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  
  Stream<QuerySnapshot> eventos(){
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  Future<void> eventoBorrar(String docId) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }
  
  Future<QuerySnapshot> tipos() async{
    return FirebaseFirestore.instance.collection('tipo').get();
  }

  Future<void> agregarEvento(String nombre, String tipo, String desc, DateTime fecha, String lugar, String imageUrl){
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'tipo': tipo,
      'fecha': fecha,
      'descripcion': desc,
      'lugar': lugar,
      'foto': imageUrl,
      'me_gusta': 0,
    });
  }

  Future<void> addMeGusta(String docId) async{
    return FirebaseFirestore.instance.collection('eventos').doc(docId).update({'me_gusta' : FieldValue.increment(1)});
  }
}