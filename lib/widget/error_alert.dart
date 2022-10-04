import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void errorAlert(String content, BuildContext context){
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Center(
        child: FaIcon(
          FontAwesomeIcons.circleExclamation,
          color: Color(0xffBF616A),
          size: 80,
        )
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xffdee5ee)
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    ),
  );
}
