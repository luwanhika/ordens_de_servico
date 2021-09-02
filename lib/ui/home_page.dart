import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordens_de_servico/repository/orders_helpers.dart';
import 'package:ordens_de_servico/ui/order_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  OrderHelper helper = OrderHelper();

  List<Order> orders = [];

  @override
  void initState() {
    super.initState();

    _getAllOrders();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Ordens de Serviço"),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOrderPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red[900],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _orderCard(context, index);
        }
      ),
    );
  }
  Widget _orderCard(BuildContext context, int index){

    DateTime now = new DateTime.now();
    
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: orders[index].img != null ?
                      FileImage(File(orders[index].img)) :
                      AssetImage("images/photo.png")
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orders[index].numb ?? "",
                      style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold),
                    ),
                    Text(orders[index].name ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(orders[index].tipo ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(orders[index].observ ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      width: 270,
                      child: Text(orders[index].date ?? "",
                      textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
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
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton(
                      child: Text("Editar",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        _showOrderPage(order: orders[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton(
                      child: Text("Excluir",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: (){
                        helper.deleteOrder(orders[index].id);
                        setState(() {
                          orders.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

  void _showOrderPage({Order order}) async {
    final recOrder = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => OrderPage(order: order,))
    );
    if(recOrder != null){
      if(order != null){
        await helper.updateOrder(recOrder);
      } else {
        await helper.saveOrder(recOrder);
      }
      _getAllOrders();
    }
  }

  void _getAllOrders(){
    helper.getAllOrders().then((list){
      setState(() {
        orders = list;
      });
    });
  }

}
