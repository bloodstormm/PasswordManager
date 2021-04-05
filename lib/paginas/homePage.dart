import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dialogs/dialogAddPass.dart';
import '../dialogs/dialogDeletePass.dart';
import '../dialogs/dialogEditPass.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home';

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    var snapshots = FirebaseFirestore.instance
        .collection('senhas')
        .orderBy('data')
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Bem-vindo(a)',
                          style: TextStyle(
                              fontFamily: 'SanFrancisco',
                              fontSize: 35,
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: '\nSuas senhas cadastradas',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: snapshots,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              // Mensagem de erro
              if (snapshot.hasError) {
                return Center(
                    child: Text('Ocorreu um erro: \n${snapshot.error}'));
              }

              // Bolinha carregando enquanto processa os arquivos.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Se nenhuma senha for encontrada
              if (snapshot.data.docs.length == 0) {
                return ColumnNenhumaSenhaEncontrada();
              }

              // Mostrando as senhas
              return Container(
                margin: const EdgeInsets.only(top: 130),
                child: Flexible(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int i) {
                      var doc = snapshot.data.docs[i];
                      var itens = doc.data();
                      print(itens['nomeDaSenha']);

                      return Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),

                        // Layout de cada senha
                        child: ListTile(
                          isThreeLine: true,
                          // ignore: missing_required_param
                          leading: IconButton(icon: Icon(Icons.lock)),
                          title: Text(
                            itens['nomeDaSenha'],
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.orange[700],
                            ),
                          ),
                          subtitle: Text(
                            "Senha: ${itens['senha']}",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Botão Edit
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.yellow[800],
                                ),
                                onPressed: () {
                                  // Chamando o dialog e passando as
                                  // informações do Firestore para ele
                                  dialogEditSenha(context, doc['nomeDaSenha'],
                                      doc['senha'], doc);
                                },
                              ),

                              // Botão delete
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.red[300],
                                ),
                                onPressed: () {
                                  dialogDeleteSenha(context, doc);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // Floating button Adicionar
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 5),
        child: FloatingActionButton(
          onPressed: () => dialogAddSenha(context),
          tooltip: 'Adicionar',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ColumnNenhumaSenhaEncontrada extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Imagem no_data_found
        Image(
          image: AssetImage('assets/no_data_found.png'),
          height: 300,
        ),
        Container(
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '\nOops!\n',
                    style: TextStyle(
                        fontFamily: 'SanFrancisco',
                        fontSize: 35,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                  text: 'Nenhuma senha encontrada',
                  style: TextStyle(
                    fontFamily: 'SanFrancisco',
                    fontSize: 23,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
