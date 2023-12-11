import 'package:flutter/material.dart';

Future showErrorPopUp(BuildContext context,String e){
  return showDialog(
      context: context,
      builder: ((BuildContext context) {
        return  AlertDialog(
          title: const Text("OOPS...!!!"),
          content: SizedBox(
              width: 300,
              child: Text(e.toString(),textAlign: TextAlign.center,)
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("ok")
            )
          ],
        );
      })
  );
}

