import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:meu_recibo/model/venda_helper.dart';
import 'package:meu_recibo/ui/VendaPage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  VendasHelper helper = VendasHelper();

  List<Venda> vendas = List();

  String totalDashboard = "carregando..";
  String totalPago = "carregando..";
  String totalReceber = "carregando..";
  String msgSaldo = "Total de vendas: ";
  var saldoIcon = Icons.visibility_off;
  bool saldoVisivel = true;

  @override
  void initState() {
    super.initState();

    _getAllVendas();
    _getTotal();
    _getTotalPago();
    _getTotalReceber();
    // String total = _getTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("meuRecibo - Dashboard"),
        backgroundColor: Colors.pink,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre',
            onPressed: showAboutMessage,

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.local_grocery_store, color: Colors.white),
        onPressed: () {
          _showVendaPage();
        },
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  if (totalDashboard == "0.0") {
                    _msgNenhumDado();
                  } else {
                    _requestDetails();
                  }
                },
                child: Card(
                  color: Colors.pink,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(children: [
                      GestureDetector(
                        onTap: _alteraVisiblidadeSalso,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Icon(saldoIcon, color: Colors.white, size: 40),
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msgSaldo,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Visibility(
                              visible: saldoVisivel,
                              child: Text("R\$ " + totalDashboard ?? " 0",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )
                          ]),
                    ]),
                  ),
                ),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text("Histórico de vendas:",
                      style: TextStyle(

                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              )),
          Expanded(
            child: _listagemWdg(context),
          ),
        ],
      ),
    );
  }
  
  Widget _listagemWdg(BuildContext context){
    if(vendas.length > 0){
      return  ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: vendas.length,
          itemBuilder: (context, index) {
            return _vendaCard(context, index);
          }
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(8), child: Icon(Icons.add_shopping_cart, size: 40, color: Colors.white,),),
          Text("Parece que você ainda não fez vendas",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  color: Colors.white, backgroundColor: Colors.pink),),
          Text("Para começar clique no ícone de carrinho abaixo",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic, color: Colors.white),)
        ],
      );
    }
  }
  
  Widget _vendaCard(BuildContext context, int index) {
    var cor = Color(0xA020F0);
    var icon = Icons.shopping_bag_outlined;
    if (vendas[index].pago == "0") {

      cor = Color(0x000000);
      icon = Icons.money_off;
    } else {
     // cor = Colors.lightGreen[100];
      //#FF0000
      cor = Color(0xFF1C1C1C);
      //cor = Color(0xFF363636);
    }
    return GestureDetector(
      child: Card(
        color: cor,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendas[index].titulo ?? "Venda sem título",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    vendas[index].tipo ?? "sem categoria",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic, color: Colors.white, backgroundColor: Colors.pink),
                    overflow: TextOverflow.visible,
                  ),
                  Text(
                    vendas[index].descricao ?? "nenhuma descição informada",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    overflow: TextOverflow.visible,
                  ),
                  Text(
                    "R\$: " + vendas[index].valor.toString() ?? "",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    vendas[index].dataPagemnto ?? "",
                    style: TextStyle(fontSize: 15,  color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            backgroundColor: Colors.pink,
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        FlatButton(
                          child: Text(
                            "Editar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showVendaPage(venda: vendas[index]);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever, color: Colors.white),
                        FlatButton(
                          child: Text(
                            "Excluir",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: () {
                            helper.deleteVenda(vendas[index].id);
                            setState(() {
                              vendas.removeAt(index);
                              Navigator.pop(context);
                            });
                            _getTotal();
                            _getTotalReceber();
                            _getTotalPago();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showVendaPage({Venda venda}) async {
    final recVenda = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VendaPage(
                  venda: venda,
                )));
    print(venda.toString());
    if (recVenda != null) {
      if (venda != null) {
        await helper.updateVenda(recVenda);
      } else {
        await helper.saveVenda(recVenda);
      }
      _getTotal();
      _getTotalPago();
      _getTotalReceber();
      _getAllVendas();
    }
  }

  void _getAllVendas() {
    helper.getAll().then((list) {
      setState(() {
        vendas = list;
      });
    });
  }

  void _getTotal() {
    helper.getTotalVendas().then((string) {
      setState(() {
        if (string != "null") {
          totalDashboard = string;
        } else {
          totalDashboard = "0.0";
        }
      });
    });
  }

  void _getTotalPago() {
    helper.getTotalPago().then((string) {
      setState(() {
        if (string != "null") {
          totalPago = string;
        } else {
          totalPago = "0.0";
        }
      });
    });
  }

  void _getTotalReceber() {
    helper
      ..getTotalReceber().then((string) {
        setState(() {
          if (string != "null") {
            totalReceber = string;
          } else {
            totalReceber = "0.0";
          }
        });
      });
  }

  Future<bool> _requestDetails() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Extrato"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total pago: ", style: TextStyle(fontSize: 15)),
                    Text("Total a receber: ", style: TextStyle(fontSize: 15)),
                    Text(
                      "Total: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(totalPago ?? "Pago", style: TextStyle(fontSize: 15)),
                    Text(totalReceber ?? "Receber", style: TextStyle(fontSize: 15)),
                    Text(totalDashboard ?? "Tudo",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize:  15)),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return Future.value(true);
  }

  Future<bool> _msgNenhumDado() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Não há vendas para gerar extrato"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return Future.value(true);
  }

  void _alteraVisiblidadeSalso() {
    if (saldoVisivel == true) {
      setState(() {
        saldoIcon = Icons.visibility_off;
        saldoVisivel = false;
        msgSaldo = "O total está culto";
      });
    } else {
      setState(() {
        saldoIcon = Icons.monetization_on;
        saldoVisivel = true;
        msgSaldo = "Total de vendas: ";
      });
    }
  }

  void showAboutMessage() {
    showDialog(
        context: context,
        builder: (context) {
      return CupertinoAlertDialog(
        title: Text("meuRecibo v3.5"),
        content: Text("It's a simple app for vending control. \ndeveloping by @rowtigo with Flutter :)",
            style: TextStyle(
                 fontSize: 15)),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
        });
  }
}
