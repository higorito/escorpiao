import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  static const bambui = LatLng(-20.014442652072827, -45.976337386374325);
  static const destino = LatLng(-20.014471165111992, -45.97834020445445);

  final localizacaoController = Location();

  LatLng? posAtual;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await fetchLocationUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubs Disponíveis'),
      ),
      body: 
      posAtual == null ?
      const Center(
        child: CircularProgressIndicator(),
      ) :
      Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: bambui, zoom: 15),
              markers: {
                // Marker(
                //   markerId: MarkerId('teste'),
                //   icon: BitmapDescriptor.defaultMarker,
                //   position: bambui,
                // ),
                Marker(
                  markerId: MarkerId('destino'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: destino,
                ),
                Marker(
                  markerId: MarkerId('posAtual'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  position: posAtual!,
                ),
              },
            ),
          ),
          Container(
            height: 200,
          )
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdate() async {
    bool isLocationEnabled = await localizacaoController.serviceEnabled();
    PermissionStatus permissionStatus;
    if (isLocationEnabled){
      isLocationEnabled = await localizacaoController.requestService();
    }else{
      return;
    }

    permissionStatus = await localizacaoController.hasPermission();
    if (permissionStatus == PermissionStatus.denied){
      permissionStatus = await localizacaoController.requestPermission();
      if (permissionStatus != PermissionStatus.granted){
        return;
      }
    }

    localizacaoController.onLocationChanged.listen((atualLocalizacao){
      if (atualLocalizacao.latitude != null && atualLocalizacao.longitude != null){
        setState(() {
          posAtual = LatLng(atualLocalizacao.latitude!, atualLocalizacao.longitude!);
        });
      }
    });

  }

}
