import 'package:flutter/material.dart';



class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('History Item $index'),
                subtitle: Text('Details about history item $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
