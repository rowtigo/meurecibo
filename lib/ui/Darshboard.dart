import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:meu_recibo/model/venda_helper.dart';
import 'package:meu_recibo/ui/VendaPage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  VendasHelper helper = VendasHelper();

  List<Venda> vendas = List();

  String totalDashboard;

  @override
  void initState() {
    super.initState();

    _getAllVendas();
    _getTotal();
    // String total = _getTotal();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("meuRecibo - Dashboard"),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.local_grocery_store, color: Colors.white),
        onPressed: (){
          _showVendaPage();
        },
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('meuRecibo',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("It's a simple app for vending control. \ndeveloping by @rowtigo with Flutter :)",
                      style: TextStyle(
                          color: Colors.white, fontSize: 15)),
                  Text("V 2.0",
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            // ListTile(
            //   title: Text('Categoria'),
            //   leading: Icon(Icons.category),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
            // ListTile(
            //   title: Text('Backup/Restaurar'),
            //   leading: Icon(Icons.sd_storage),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
          ],
        ),
      ),
      body:  Column(
        children: [
          Padding(padding: EdgeInsets.all(8) , child: Card(
              color: Colors.pink,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Icon(Icons.attach_money, color: Colors.white, size: 40),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total de vendas até agora:",
                            style: TextStyle(
                                color: Colors.white, fontSize: 15)),
                        Text("R\$ "+totalDashboard ??" 0",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
              ))),
          Padding(padding: EdgeInsets.fromLTRB(8,0,0,0) , child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                  "Histórico de vendas:" ,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)
              ),
            ),
          )),

          Expanded (

            child: ListView.builder(
               padding: EdgeInsets.all(10.0),
                itemCount: vendas.length,
                itemBuilder: (context, index) {
              return _vendaCard(context, index);
    }
            )),
        ],
      ),

    );
  }

  Widget _vendaCard(BuildContext context, int index){
    var cor = Colors.redAccent;
    if(vendas[index].pago == "0"){
      cor = Colors.redAccent;
    } else{
      cor = Colors.greenAccent;
    }
    return GestureDetector(

      child: Card(
        color: cor,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.attach_money, size: 40),
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendas[index].titulo ?? "Venda sem título",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow:  TextOverflow.ellipsis,),
                  Text(vendas[index].tipo ?? "sem categoria",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow:  TextOverflow.visible,),
                  Text(vendas[index].descricao ?? "nenhuma descição informada",style: TextStyle(fontSize: 16, color: Colors.black45), overflow:  TextOverflow.visible,),
                  Text("R\$: "+vendas[index].valor.toString() ?? "",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), overflow:  TextOverflow.ellipsis,),
                  Text(vendas[index].dataPagemnto ?? "",style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic), overflow:  TextOverflow.ellipsis,),

                ],
              )),

            ],
          ),
        ),

      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            backgroundColor: Colors.pink,
            onClosing: (){},
            builder: (context){
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
                          child: Text("Editar",
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showVendaPage(venda: vendas[index]);
                          },
                        ),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever, color: Colors.white),
                        FlatButton(
                          child: Text("Excluir",
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: (){
                            helper.deleteVenda(vendas[index].id);
                            setState(() {
                              vendas.removeAt(index);
                              Navigator.pop(context);
                            });
                            _getTotal();
                          },
                        ),
                      ],),



                  ],
                ),
              );
            },
          );
        }
    );
  }


  void _showVendaPage({Venda venda}) async {
    final recVenda = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => VendaPage(venda: venda,))

    );
    print(venda.toString());
    if(recVenda != null){
      if(venda != null){
        await helper.updateVenda(recVenda);
      } else {
        await helper.saveVenda(recVenda);
      }
      _getTotal();
      _getAllVendas();
    }
  }

  void _getAllVendas(){
    helper.getAll().then((list){
      setState(() {
        vendas = list;
      });
    });
  }
  void _getTotal() {
    helper.getTotalVendas().then((string) {
      setState(() {
        if(string != "null") {
          totalDashboard = string;
        } else{
          totalDashboard = "0.0";
        }
      });
    });
  }
}

