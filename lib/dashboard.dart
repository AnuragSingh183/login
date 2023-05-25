import 'package:assignment/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class dashboard extends StatelessWidget {
  const dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
          ),
          body: Center(child: Text(user.email)),
        );
      },
    );
  }
}
