import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      'https://edubot-api-vrnb.onrender.com/chat';

  static Future<String> enviarMensagem(String mensagem) async {

    final response = await http.post(
      Uri.parse(baseUrl),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'mensagem': mensagem,
      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data['resposta'];

    } else {

      return 'Erro ao conectar com servidor';
    }
  }
}