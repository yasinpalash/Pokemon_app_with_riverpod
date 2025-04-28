import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildUI(context));
  }
}

Widget _buildUI(BuildContext context) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _allPokemonList(context),
          ],
        ),
      ),
    ),
  );
}

Widget _allPokemonList(BuildContext context) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("All Pokemons",style: TextStyle(
          fontSize: 25,
        ),),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.60,
          child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context,index){
            return ListView();
          }),
        )
      ],
    ),
  );
}