import 'package:flutter/material.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool remember = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: remember,
              onChanged: (value) {
                setState(() {
                  remember = value ?? false;
                });
              },
            ),
            const Text("Remember Me"),
          ],
        ),

        TextButton(
          onPressed: () {},
          child: const Text("Forgot Password?"),
        ),
      ],
    );
  }
}