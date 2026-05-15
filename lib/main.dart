import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: ThemeData.dark(),

      home: ChatPage(),
    );
  }
}



class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() =>
      _ChatPageState();
}



class _ChatPageState
    extends State<ChatPage> {

  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  bool carregando = false;


  List<Map<String,String>>
  mensagens = [];



  Future<void> enviarMensagem() async {

    String texto =
        controller.text.trim();

    if(texto.isEmpty) return;



    setState(() {

      mensagens.add({

        "autor":"usuario",

        "texto":texto
      });

      carregando = true;
    });



    controller.clear();

    scrollFim();



    final resposta =
        await ApiService
            .enviarMensagem(texto);



    setState(() {

      mensagens.add({

        "autor":"bot",

        "texto":resposta
      });

      carregando = false;
    });


    scrollFim();
  }



  void scrollFim(){

    Future.delayed(
        const Duration(milliseconds:200),

            (){

          scrollController.animateTo(

            scrollController
                .position
                .maxScrollExtent,

            duration:
            const Duration(
                milliseconds:300),

            curve:
            Curves.easeOut,
          );
        });
  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(

        title:
        const Text("EduBot"),

        centerTitle:true,
      ),



      body: Column(

        children:[


          Expanded(

            child:
            ListView.builder(

              controller:
              scrollController,

              itemCount:
              mensagens.length,

              itemBuilder:
                  (context,index){

                final mensagem =
                mensagens[index];

                bool usuario =

                    mensagem["autor"]
                    =="usuario";



                return Align(

                  alignment:

                  usuario

                      ? Alignment
                      .centerRight

                      : Alignment
                      .centerLeft,


                  child: Container(

                    margin:
                    const EdgeInsets
                        .symmetric(

                        horizontal:12,

                        vertical:6),

                    padding:
                    const EdgeInsets
                        .all(14),

                    constraints:

                    BoxConstraints(

                      maxWidth:

                      MediaQuery.of(
                          context)

                          .size

                          .width
                          *0.75,
                    ),

                    decoration:

                    BoxDecoration(

                      color:

                      usuario

                          ? Colors.blue

                          : Colors
                          .grey[850],

                      borderRadius:

                      BorderRadius
                          .circular(16),
                    ),


                    child:

                    SelectableText(

                      mensagem["texto"]!,

                      style:
                      const TextStyle(

                          fontSize:16),
                    ),
                  ),
                );
              },
            ),
          ),



          if(carregando)

            const Padding(

              padding:
              EdgeInsets.all(8),

              child:
              CircularProgressIndicator(),
            ),



          Container(

            padding:
            const EdgeInsets
                .all(12),

            color:
            Colors.black54,

            child: Row(

              children:[

                Expanded(

                  child:

                  TextField(

                    controller:
                    controller,

                    decoration:

                    InputDecoration(

                      hintText:
                      "Pergunte algo...",

                      filled:true,

                      fillColor:
                      Colors.grey[900],

                      border:

                      OutlineInputBorder(

                        borderRadius:

                        BorderRadius
                            .circular(30),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),


                const SizedBox(width:8),



                CircleAvatar(

                  child:

                  IconButton(

                    onPressed:
                    enviarMensagem,

                    icon:
                    const Icon(
                        Icons.send),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}