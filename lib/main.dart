import 'package:flutter/material.dart';

import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatPage());
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();

  String resposta = '';

  bool carregando = false;

  Future<void> enviarMensagem() async {
    final mensagem = controller.text;

    if (mensagem.isEmpty) return;

    setState(() {
      carregando = true;
    });

    final respostaApi = await ApiService.enviarMensagem(mensagem);

    setState(() {
      resposta = respostaApi;
      carregando = false;
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EduBot')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              TextField(
                controller: controller,

                decoration: const InputDecoration(
                  hintText: 'Digite sua pergunta',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: enviarMensagem,

                  child: const Text('Enviar'),
                ),
              ),

              const SizedBox(height: 20),

              if (carregando) const CircularProgressIndicator(),

              if (!carregando)
                SelectableText(resposta, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
