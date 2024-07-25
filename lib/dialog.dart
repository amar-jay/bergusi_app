import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String result,
    {void Function()? callback, String? title}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? "unknown"),
        content: Text(result),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
              if (callback != null) {
                callback();
              }
            },
          ),
        ],
      );
    },
  );
}
//}