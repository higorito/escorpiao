import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageEmergencia extends StatelessWidget {
  const PageEmergencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergência'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            Text(
              'orientações de emergência aqui... \n texto sla oq \n',
            ),
            SizedBox( height: 20,),
            Text(
              'mais orientações de emergência aqui... \n texto sla oq \n',
            ),
            SizedBox(child: Expanded(child: ElevatedButton(onPressed: (){
              _launchPhone('192');
            }, child: Text('Ligar p Emergência'))),),

            SizedBox(height: 20,),

            SizedBox(child: Expanded(child: ElevatedButton(onPressed: (){
             
            }, child: Text('Encontrar UBS'))),),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }
}