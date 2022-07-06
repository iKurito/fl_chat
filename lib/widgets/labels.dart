// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({
    Key? key,
    required this.ruta,
    required this.titulo,
    required this.subtitulo,
  }) : super(key: key);

  final String ruta;
  final String titulo;
  final String subtitulo;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(titulo, style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w300)),
          const SizedBox(height: 10),
          GestureDetector(
            child: Text(subtitulo, style: TextStyle(fontSize: 18, color: Colors.blue[600], fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
          ),
        ],
      ),
    );
  }
}