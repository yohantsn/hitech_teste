import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hitechteste/helpers/consult_firebase.dart';
import 'package:hitechteste/widgets/appbar_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BorderRadiusGeometry _borderRadius;
  Map _map;
  Color _colorCard;
  String _title = "";
  String _status = "";
  String _description;
  String _colorString = "";
  int _docNum = 1;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _colorCard = Colors.white;
      _borderRadius = BorderRadius.circular(15);
      _description = "Clique em Iniciar Pedido";
    });
  }

  /* Ao clicar no botão o método iniciaProcesso é iniciado, com isso ele realiza
    a consulta na classe consult_firebase, após isso é iniciado o método timer.
    Com isso é criado um loop, até que seja completado os 5 status disponíveis no Firebase.
  */

  void iniciaProcesso(int _document) async {
    _map = await ConsultaFirebase(_document);
    setState(() {
      try {
        _status = _map["status"];
        _status = _status.toUpperCase();
        _colorString = _map["color"];
        _title = _map["title"];
        _description = _map["text"];
        _colorCard = Color(int.parse(_colorString));
      } catch (error) {
        _mostraSnackbar("Ocorreu um erro ao receber os dados.");
      }
    });

    if (_document >= 1 && _document < 5) {
      _docNum = _document;
      timer(10);
    } else {
      _btnController.success();
      _btnController.reset();
      return;
    }
  }

  void timer(int _seconds) {
    const sec = const Duration(seconds: 1);
    _timer = new Timer.periodic(sec, (Timer timer) {
      if (_seconds < 1) {
        timer.cancel();
        _docNum += 1;
        iniciaProcesso(_docNum);
      } else {
        _seconds -= 1;
      }
    });
  }

  /* Método invoca um snackbar, apresentando a mensagem de erro, caso essa exista
   */

  void _mostraSnackbar(String _content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(_content),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
    ));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment(0, 0.9),
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: _borderRadius,
                      color: _colorCard,
                    ),
                    duration: Duration(milliseconds: 600),
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child:
                              Text("$_status", style: TextStyle(fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "$_title",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("$_description",
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),



                /* Widget Button */
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: RoundedLoadingButton(
                    child: Text(
                      "Iniciar Pedido",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    controller: _btnController,
                    onPressed: () {
                      iniciaProcesso(1);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
