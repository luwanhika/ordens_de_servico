import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ordens_de_servico/repository/orders_helpers.dart';
import 'package:image_picker/image_picker.dart';

class OrderPage extends StatefulWidget {
  final Order order;

  OrderPage({this.order});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _numbController = TextEditingController();
  final _namebController = TextEditingController();
  final _tipoController = TextEditingController();
  final _observController = TextEditingController();
  final _tiposController = TextEditingController();

  final listTipo = ["testes","expermento"];

  final picker = ImagePicker();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Order _editedOrder;

  @override
  void initState() {
    super.initState();

    if (widget.order == null) {
      _editedOrder = Order();
    } else {
      _editedOrder = Order.fromMap(widget.order.toMap());

      _numbController.text = _editedOrder.numb;
      _namebController.text = _editedOrder.name;
      _tipoController.text = _editedOrder.tipo;
      _observController.text = _editedOrder.observ;
      _tiposController.text = _editedOrder.tipos;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text(_editedOrder.name ?? "Nova Ordem"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedOrder.name != null && _editedOrder.name.isNotEmpty) {
              Navigator.pop(context, _editedOrder);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red[900],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _numbController,
                decoration: InputDecoration(labelText: "Número da Ordem"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedOrder.numb = text;
                },
                keyboardType: TextInputType.number,
              ),
              Divider(),
              TextField(
                controller: _namebController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome do Cliente"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedOrder.name = text;
                  });
                },
              ),
              Divider(),
              TextField(
                controller: _tipoController,
                decoration: InputDecoration(labelText: "Tipo de Serviço"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedOrder.tipo = text;
                },
              ),
              Divider(),
              TextField(
                controller: _observController,
                decoration: InputDecoration(labelText: "Digite aqui algumas observações"),
                // maxLength: 20,
                maxLines: 4,
                onChanged: (text) {
                  _userEdited = true;
                  _editedOrder.observ = text;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: _editedOrder.img != null
                            ? FileImage(File(_editedOrder.img))
                            : AssetImage("images/photo.png"),
                      ),
                    ),
                  ),
                  onTap: (){
                    picker.getImage(source: ImageSource.gallery).then((file){
                      if(file == null) return;
                      setState(() {
                        _editedOrder.img = file.path;
                      });
                    });
                  },
                ),
              ),
              Text(
                "Insira uma imagem",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
