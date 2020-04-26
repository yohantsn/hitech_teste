
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

/* A consulta é realiza um documento por vez, sendo assim documento é um parametro
nesse método.
O Firebase retorna um snapshot com o resultado, recebemos o JSON como String e o
mesmo é convertido para um map e devolvido para o método de origem */


Future<Map>  ConsultaFirebase(int documento) async {
  String value;
  await Firestore.instance.collection("status").document("$documento").get().then((DocumentSnapshot ds){
    value = ds.data["result"];

  });
  Map _map = json.decode(value);
  return _map;
}
