import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meu_recibo/model/venda_helper.dart';
import 'package:meu_recibo/ui/Darshboard.dart';

class VendaPage extends StatefulWidget {
  final Venda venda;

  VendaPage({this.venda});

  @override
  _VendaPageState createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _datadepagamentoeController = TextEditingController();
  final _valoreController = TextEditingController();
  final _tipoController = TextEditingController();
  final _clienteeController = TextEditingController();
  final _pagoController = TextEditingController();

  final _valorFoco = FocusNode();

  bool _userEdited = false;
  bool _marcadopago = false;

  Venda _editedVenda;
  var estaMarcadoPago = Text("Pago", style: (TextStyle(color: Colors.white)),);

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    String dia = DateFormat('dd/MM/yyyy').format(now);
    _datadepagamentoeController.text = dia;
    _pagoController.text="0";

    if (widget.venda == null) {
      _editedVenda = Venda();
      _pagoController.text = "0";
      _editedVenda.pago = "0";
    } else {
      _editedVenda = Venda.fromMap(widget.venda.toMap());
      print(_editedVenda.titulo);
      _tituloController.text = _editedVenda.titulo;
      _descricaoController.text = _editedVenda.descricao;
      _clienteeController.text = _editedVenda.clientes;
      _tipoController.text = _editedVenda.tipo;
      _datadepagamentoeController.text = _editedVenda.dataPagemnto;
      _valoreController.text = _editedVenda.valor.toString();
      _pagoController.text = _editedVenda.pago;
    }
    if(_pagoController.text == "1"){
      _marcadopago =true;
      estaMarcadoPago =   Text("Pago", style: (TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
    };
  }

  @override
  Widget build(BuildContext context) {
    _editedVenda.dataPagemnto = _datadepagamentoeController.text;
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(_editedVenda.titulo ?? "Nova venda"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: _tituloController,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedVenda.titulo = text;
                  });

                },
                decoration: InputDecoration(
                    labelText: "Título da venda", prefixIcon: Icon(Icons.create)),
              ),
              TextField(
                controller: _descricaoController,
                onChanged: (text) {
                  _userEdited = true;
                  _editedVenda.descricao = text;
                },
                decoration: InputDecoration(
                    labelText: "Descrição....", prefixIcon: Icon(Icons.segment)),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextField(
                onChanged: (text) {
                  _userEdited = true;
                  _editedVenda.clientes = text;
                },
                controller: _clienteeController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: "Clientes",
                    prefixIcon: Icon(Icons.supervisor_account)),
              ),
              TextField(
                onChanged: (text) {
                  _userEdited = true;
                  _editedVenda.tipo = text;
                },
                controller: _tipoController,
                decoration: InputDecoration(
                    labelText: "Categoria"
                        "", prefixIcon: Icon(Icons.category)),
              ),
              TextField(
                onChanged: (text) {
                  _userEdited = true;
                  _editedVenda.dataPagemnto = text;
                },
                controller: _datadepagamentoeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: "Data de pagamento",
                    prefixIcon: Icon(Icons.calendar_today)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: FlatButton(
                            onPressed: () {
                              _datadepagamentoeController.text = _hoje();
                            },
                            child: Text("Hoje",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18)),
                            color: Colors.pinkAccent)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: FlatButton(
                            onPressed: () {
                              String novaData = _adiciona7();
                              _datadepagamentoeController.text = novaData;
                            },
                            child: Text("+7",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18)),
                            color: Colors.pinkAccent)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: FlatButton(
                            onPressed: () {
                              String novaData = _adiciona15();
                              _datadepagamentoeController.text = novaData;
                            },
                            child: Text("+15",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18)),
                            color: Colors.pinkAccent)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: FlatButton(
                            onPressed: () {
                              String novaData = _adiciona30();
                              _datadepagamentoeController.text = novaData;
                            },
                            child: Text("+30",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18)),
                            color: Colors.pinkAccent)),
                  ],
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                focusNode: _valorFoco,
                onChanged: (text) {
                  _userEdited = true;
                  _editedVenda.valor = double.parse(text);
                },
                controller: _valoreController,

                decoration: InputDecoration(
                    labelText: "Valor",
                    prefixIcon: Icon(Icons.monetization_on),
                    prefix: Text("R\$ ")),
              ),
              CheckboxListTile(
                title: estaMarcadoPago ,

                value: _marcadopago,
                selected: _marcadopago,
                activeColor: Colors.pink,
                onChanged: alteraPago,
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
                contentPadding: EdgeInsets.all(0),
              ),

              // TextField(
              //   keyboardType: TextInputType.number,
              //   onChanged: (text) {
              //     _userEdited = true;
              //     _editedVenda.pago = text;
              //   },
              //   controller: _pagoController,
              //   decoration: InputDecoration(
              //       labelText: "Pago",
              //       prefixIcon: Icon(Icons.monetization_on),
              //   )
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: FlatButton(
                  onPressed: () {
                    if (_editedVenda.valor != null) {

                      Navigator.pop(context, _editedVenda);

                    } else {

                        showDialog(
                            context: context,
                            builder: (_) => new CupertinoAlertDialog(
                              title: new Text("Ops.."),
                              content: new Text("O campo valor é obrigatório, não esqueça de preenche-lo!"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    FocusScope.of(context).requestFocus(_valorFoco);
                                  },
                                )
                              ],
                            ));
                      }

                  },
                  minWidth: double.infinity,
                  child: Text("Salvar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  String _adiciona7() {
    var today = DateTime.now();
    var adicionadoBruto = today.add(const Duration(days: 7));
    String dataformatada = DateFormat('dd/MM/yyyy').format(adicionadoBruto);
    return dataformatada.toString();
  }

  String _hoje() {
    var today = DateTime.now();
    String dataformatada = DateFormat('dd/MM/yyyy').format(today);
    return dataformatada.toString();
  }

  String _adiciona15() {
    var today = DateTime.now();
    var adicionadoBruto = today.add(const Duration(days: 15));
    String dataformatada = DateFormat('dd/MM/yyyy').format(adicionadoBruto);
    return dataformatada.toString();
  }

  String _adiciona30() {
    var today = DateTime.now();
    var adicionadoBruto = today.add(const Duration(days: 30));
    String dataformatada = DateFormat('dd/MM/yyyy').format(adicionadoBruto);
    return dataformatada.toString();
  }

  void alteraPago(bool newValue) => setState(() {
    _userEdited = true;
        if (_marcadopago == false) {
          _marcadopago = true;
        estaMarcadoPago =   Text("Pago", style: (TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
          _editedVenda.pago = "1";
          _pagoController.text = "1";
        } else {
          _marcadopago = false;
          estaMarcadoPago = Text("Pago", style: (TextStyle(color: Colors.white)),);
          _pagoController.text = "0";
          _editedVenda.pago = "0";
        }

      });

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return CupertinoAlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Descartar"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);

                  },
                )
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
