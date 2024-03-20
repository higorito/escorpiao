import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPlace extends StatefulWidget {
  const MapsPlace({super.key});

  @override
  State<MapsPlace> createState() => _MapsPlaceState();
}

class _MapsPlaceState extends State<MapsPlace> {
  final localizacaoController = Location();

  LatLng? posAtual;

  late final GoogleMapController _mapController;

  Map<String, Marker> _markers = {};

  static const destino = LatLng(-20.014471165111992, -45.97834020445445);
  static const bambui = LatLng(-20.014442652072827, -45.976337386374325);

  static const pos_default = LatLng(-20.01163940586836, -45.97828215465096);

  MapType _tipoMapa = MapType.normal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubs Disponíveis'),
      ),
      body: posAtual == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: posAtual!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    addMarkers('TESTE', destino);
                    addMarkers('bambui cidade boa', bambui);
                  },
                  markers: _markers.values.toSet(),
                  mapType: _tipoMapa,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      _mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: posAtual!,
                            zoom: 16,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.gps_fixed),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _changeMapType,
                        child: const Icon(
                          Icons.satellite_alt_rounded,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: _addMarker,
                        child: const Icon(
                          Icons.add_location_alt_rounded,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: _novaPos,
                        child: const Icon(
                          Icons.access_time_rounded,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: _goPosDefault,
                        child: const Icon(Icons.restore),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  addMarkers(String mkID, LatLng position) async {
    // var markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(1, 1)), 'assets/icons/hospital.png' );

    var marker = Marker(
      markerId: MarkerId(mkID),
      position: position,
      infoWindow: InfoWindow(title: mkID, snippet: 'testando askas'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    _markers[mkID] = marker;

    setState(() {});
  }

  Future<void> fetchLocationUpdate() async {
    bool isLocationEnabled = await localizacaoController.serviceEnabled();
    PermissionStatus permissionStatus;
    if (isLocationEnabled) {
      isLocationEnabled = await localizacaoController.requestService();
    } else {
      return;
    }

    permissionStatus = await localizacaoController.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await localizacaoController.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    localizacaoController.onLocationChanged.listen((atualLocalizacao) {
      if (atualLocalizacao.latitude != null &&
          atualLocalizacao.longitude != null) {
        setState(() {
          posAtual =
              LatLng(atualLocalizacao.latitude!, atualLocalizacao.longitude!);
        });
      }
    });
  }

  void _changeMapType() {
    setState(() {
      _tipoMapa =
          _tipoMapa == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _addMarker() {
    setState(() {
      _markers.addAll({
        'teste': Marker(
          markerId: MarkerId('add local'),
          icon: BitmapDescriptor.defaultMarker,
          position: posAtual!,
          infoWindow: const InfoWindow(
              title: 'adicionei', snippet: 'teste de adicionar local '),
        ),
      });
    });
  }

  Future<void> _novaPos() async {
    const LatLng novaPos = LatLng(-20.014442652072827, -45.976337386374325);
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: novaPos,
          zoom: 16,
        ),
      ),
    );

    setState(() {
      const marker = Marker(
        markerId: MarkerId('novaPos'),
        icon: BitmapDescriptor.defaultMarker,
        position: novaPos,
        infoWindow: const InfoWindow(
          title: 'nova posicao',
          snippet: 'teste de nova posicao',
        ),
      );

      _markers
        ..clear()
        ..addAll({'novaPos': marker});
    });
  }

  Future<void> _goPosDefault() async {
    const _posDefault = pos_default;
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: pos_default,
          zoom: 16,
        ),
      ),
    );

    setState(() {
      const marker = Marker(
        markerId: MarkerId('pos padrao'),
        icon: BitmapDescriptor.defaultMarker,
        position: _posDefault,
        infoWindow: const InfoWindow(
          title: 'posicao padrao',
          snippet: 'teste de posicao padrao',
        ),
      );

      _markers
        ..clear()
        ..addAll({'pos padrao': marker});
    });
  }
}
