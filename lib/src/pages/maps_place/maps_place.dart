import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as HandlerPermission;

import 'data/ubs_data.dart';
import 'ubs_repository.dart';

class MapsPlace extends StatefulWidget {
  const MapsPlace({super.key});

  @override
  State<MapsPlace> createState() => _MapsPlaceState();
}

class _MapsPlaceState extends State<MapsPlace> {
  final localizacaoController = Location();

  var status = HandlerPermission.Permission.location.status;

  LatLng? posAtual;

  late final GoogleMapController _mapController;

  Map<String, Marker> _markers = {};

  static const destino = LatLng(-20.014471165111992, -45.97834020445445);
  static const bambui = LatLng(-20.014442652072827, -45.976337386374325);

  static const pos_default = LatLng(-20.01163940586836, -45.97828215465096);

  MapType _tipoMapa = MapType.normal;

  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  final TextEditingController _searchController = TextEditingController();

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadData();
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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              hintText: 'Pesquisar Ubs',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  //colcoar num controller dps
                                  final place = await UbsRepository()
                                      .getUbs(_searchController.text);

                                  if (place != null) {
                                    _goPlace(place);
                                  } else {
                                    void _showDialog() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Erro'),
                                            content: const Text(
                                                'Nenhum lugar encontrado'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.search),
                              ),
                            ),
                            onChanged: (value) {
                              print('PESQUISA--------$value-----------');
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            onCameraMove: (position) {
                              _customInfoWindowController.onCameraMove!();
                              _locationData = LocationData.fromMap({
                                'latitude': position.target.latitude,
                                'longitude': position.target.longitude,
                              });
                            },
                            initialCameraPosition: CameraPosition(
                              target: posAtual!,
                              zoom: 16,
                            ),
                            onMapCreated: (controller) {
                              _customInfoWindowController.googleMapController =
                                  controller;
                              // addMarkers('TESTE', destino, false);
                              // addMarkers('bambui cidade boa', bambui, false);
                              addMarkers('VOCE', posAtual!, true);
                            },
                            markers: _markers.values.toSet(),
                            mapType: _tipoMapa,
                            onTap: (position) {
                              _customInfoWindowController.hideInfoWindow!();
                            },
                          ),
                          CustomInfoWindow(
                              controller: _customInfoWindowController,
                              height: 200,
                              width: 250,
                              offset: 50),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      _customInfoWindowController.googleMapController!.animateCamera(
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
                  padding: const EdgeInsets.only(top: 80, right: 10),
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
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // FloatingActionButton(
                      //   onPressed: _novaPos,
                      //   child: const Icon(
                      //     Icons.access_time_rounded,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // FloatingActionButton(
                      //   onPressed: _goPosDefault,
                      //   child: const Icon(Icons.restore),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  addMarkers(String mkID, LatLng position, bool vc) async {
    // var markerIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(1, 1)), 'assets/icons/hospital.png' );

    var icon;

    vc ? icon = BitmapDescriptor.hueAzure : icon = BitmapDescriptor.hueRed;

    var marker = Marker(
      markerId: MarkerId(mkID),
      position: position,
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // width: 100,
                    // height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: !vc ? const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                  'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=t6449eiDJard-dsME9kw7g&cb_client=search.gws-prod.gps&w=408&h=240&yaw=340.2773&pitch=0&thumbfov=100'                      ),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ): const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Text(
                      mkID,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          LatLng(position.latitude, position.longitude),
        );
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(icon),
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
          _locationData = atualLocalizacao;
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
          markerId: const MarkerId('add local'),
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
        infoWindow: InfoWindow(
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
    const posDefault = pos_default;
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: pos_default,
          zoom: 16,
        ),
      ),
    );

    setState(() {
      const marker = Marker(
        markerId: MarkerId('pos padrao'),
        icon: BitmapDescriptor.defaultMarker,
        position: posDefault,
        infoWindow: InfoWindow(
          title: 'posicao padrao',
          snippet: 'teste de posicao padrao',
        ),
      );

      _markers
        ..clear()
        ..addAll({'pos padrao': marker});
    });
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Serviço de localização desabilitado pelo usuário
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        if (await HandlerPermission.Permission.speech.isPermanentlyDenied) {
          HandlerPermission.openAppSettings();
        }
        _checkLocationPermission();
      }
    }

    fetchLocationUpdate();
  }

  Future<void> _goPlace(Map<String, dynamic> place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];

    final placeLatLng = LatLng(lat, lng);

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: placeLatLng,
          zoom: 16,
        ),
      ),
    );

    setState(() {
      _markers.clear();
      addMarkers(place['name'], placeLatLng, false);
    });
  }
  
  void _loadData() {
    MarkerDataSet() 
      ..markers.forEach((element) {
        addMarkers(element.mkID, element.position, element.vc);
      });
  }
}
