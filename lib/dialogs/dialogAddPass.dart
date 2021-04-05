// Caixa de dialogo para adicionar senhas
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

dialogAddSenha(BuildContext context) {
  var form = GlobalKey<FormState>();

  // Pegando os valores dos campos
  var nomeDaSenha = TextEditingController();
  var senha = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar nova senha 📝'),
          titleTextStyle: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontFamily: "SanFrancisco",
              fontWeight: FontWeight.w500),
          content: Form(
            key: form,
            child: Container(
              // Deixando o Dialog menor
              height: MediaQuery.of(context).size.height / 3.6,
              width: MediaQuery.of(context).size.width,

              // SingleChildScrollView é usado para evitar Overflowed Bottom com
              // alguns tipos de teclados
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Nome da Senha',
                      style:
                          TextStyle(fontFamily: "SanFrancisco", fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                        // Passando os valores para a variavel nomeDaSenha
                        controller: nomeDaSenha,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Ex: Banco Itaú',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        // Tornando o campo obrigatório
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          return null;
                        }),
                    SizedBox(height: 15),
                    Text(
                      'Senha',
                      style:
                          TextStyle(fontFamily: "SanFrancisco", fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    TextFormField(
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        // Passando o valor para a variavel senha
                        controller: senha,
                        decoration: InputDecoration(
                          hintText: 'Ex: 12345',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        // Tornando o campo obrigatório
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Preencha este campo";
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ),
          ),

          // Botão Cancelar
          actions: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(5),
              child: MaterialButton(
                minWidth: 10,
                child: Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Botão Adicionar
            Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.orange,
              child: MaterialButton(
                minWidth: 90,
                child: Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () async {
                  if (form.currentState.validate()) {
                    await FirebaseFirestore.instance.collection('senhas').add({
                      'nomeDaSenha': nomeDaSenha.text.trim(),
                      'senha': senha.text.trim(),
                      'data': Timestamp.now(),
                    });

                    Navigator.of(context).pop();

                    Fluttertoast.showToast(
                      msg: "Senha adicionada!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                },
              ),
            ),
          ],
        );
      });
}
