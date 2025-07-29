import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SearchBar(),
          Center(child: Text('Search Here', style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}
