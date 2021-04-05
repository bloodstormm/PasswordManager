import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

dialogDeleteSenha(BuildContext context, doc) {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Você tem certeza que deseja excluir a senha?'),
        actions: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(5),
            child: MaterialButton(
              minWidth: 15,
              child: Text(
                "Cancelar",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Material(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5),
            child: MaterialButton(
              minWidth: 70,
              child: Text(
                "Sim",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onPressed: () => {
                doc.reference.delete(),
                Navigator.of(context).pop(),
                Fluttertoast.showToast(
                  msg: "Senha excluida!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                )
              },
            ),
          ),
        ],
      );
    },
  );
}
