import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // late final GoogleMapController _mapController;

  Map<String, Marker> _markers = {};

  // static const destino = LatLng(-20.014471165111992, -45.97834020445445);
  // static const bambui = LatLng(-20.014442652072827, -45.976337386374325);

  // static const pos_default = LatLng(-20.01163940586836, -45.97828215465096);

  MapType _tipoMapa = MapType.normal;

  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final List<Marker> escorpiaoMarker = [];

  final List<Marker> ubsMarker = [];

  List<String> images = [
    'assets/icons/ubs.png',
    'assets/icons/scorpion.png',
    'assets/icons/sinal-de-alerta.png'
    'assets/icons/homem.png'
  ];

  final List<LatLng> localAvistado = [
    const LatLng(-20.014590160341797, -45.98005804062814),
    const LatLng(-20.01059074560931, -45.97601834533593),
    const LatLng(-20.012303737314173, -45.970747217929684),
    const LatLng(-20.00966248795663, -45.97842906392004),
    const LatLng(-20.016457062657167, -45.97222779734214),
    const LatLng(-20.015090898017174, -45.977450327874834),
    const LatLng(-20.017600053158354, -45.9804094910854),
    const LatLng(-20.013590160341797, -45.98005804062814),
    const LatLng(-20.01059074560931, -45.97601834533593),
    const LatLng(-20.012303737314173, -45.970747217929684),
  ];

  var isEscorpiao = false;

  GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

  final MarkerDataSet ubsData = MarkerDataSet();

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    addCustomMarkerYou();
    createMarkersUbs(ubsData);
    createMarkersEscorpioes(localAvistado);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Mapa de Bambuí'),
        centerTitle: true,
      ),
      body: posAtual == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Column(
                  children: [
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
                              // addMarkers('VOCE', posAtual!, true, '');
                            },
                            
                            markers:
                            isEscorpiao?
                             {
                              Marker(
                                markerId: const MarkerId('voce'),
                                position: posAtual!,
                                icon: customIcon,
                                
                              ),
                              ...ubsMarker,
                              ...escorpiaoMarker,
                            }: {
                              Marker(
                                markerId: const MarkerId('voce'),
                                position: posAtual!,
                                icon: customIcon,
                              ),
                              ...ubsMarker,
                            },
                            mapType: _tipoMapa,
                            onTap: (position) {
                              _customInfoWindowController.hideInfoWindow!();
                            },
                          ),
                          CustomInfoWindow(
                              controller: _customInfoWindowController,
                              height: 200,
                              width: 250,
                              offset: 25),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      _customInfoWindowController.googleMapController!
                          .animateCamera(
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
                        onPressed: () {
                          showDialog(
                            useSafeArea: true,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Filtrar por'),
                                content: Form(
                                  key: dialogFormKey,
                                  child: SizedBox(
                                    child: Container(
                                      constraints: const BoxConstraints.expand(
                                        height: 200,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: false,
                                                  onChanged: (value) {}),
                                              const Text(
                                                  'Avistamento de escorpião'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: false,
                                                  onChanged: (value) {}),
                                              const Text(
                                                  'Acidentes com escorpião'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                        },
                        child: const Icon(
                          Icons.add_location_alt_rounded,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            isEscorpiao = !isEscorpiao;
                          });
                        },
                        child: const Icon(
                          Icons.filter_alt,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  addMarkers(String mkID, LatLng position, bool vc, String image) async {
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
                    width: 250,
                    height: 150,
                    padding: const EdgeInsets.all(8),
                    decoration: !vc
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: image != ''
                                  ? NetworkImage(image)
                                  : Image.asset(images[0]).image,
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high,
                            ),
                          )
                        : const BoxDecoration(
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

  void getCurrentLocation() async {
    Location location = Location();
    
    location.getLocation().then((location) {
      posAtual = LatLng(location.latitude!, location.longitude!);
    } );
      
    

    location.onLocationChanged.listen((newLoc) {
      posAtual = LatLng(newLoc.latitude!, newLoc.longitude!);
      setState(() {
        
      });
    });
  }

  void _changeMapType() {
    setState(() {
      _tipoMapa =
          _tipoMapa == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _checkLocationPermission();
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  Future<void> createMarkersEscorpioes(List<LatLng> locations) async {
    final Uint8List markerIcon = await getBytesFromAsset(images[1], 150);

    for (var location in locations) {
      escorpiaoMarker.add(
        Marker(
          markerId: MarkerId('escorpiao ${location.latitude}'),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.fromBytes(markerIcon),
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
                        width: 250,
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://gurupi.to.gov.br/wp-content/uploads/2022/08/image-1-1-1.png'),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        child: const Text(
                          'Escorpiao avistado! Cuidado!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              LatLng(location.latitude, location.longitude),
            );
          },
        ),
      );
    }

    setState(() {});
  }

  // void _loadData() {
  //   // ignore: avoid_single_cascade_in_expression_statements
  //   MarkerDataSet()
  //     ..markers.forEach((element) {
  //       addMarkers(element.mkID, element.position, element.vc, element.image);
  //     });
  // }

  Future<void> createMarkersUbs(MarkerDataSet ubs) async {
    final Uint8List markerIcon = await getBytesFromAsset(images[0], 90);
    print('------------${ubs.markers.length}------------');
    for (var ubs in ubs.markers) {
      ubsMarker.add(
        Marker(
          markerId: MarkerId(ubs.mkID),
          position: LatLng(ubs.position.latitude, ubs.position.longitude),
          icon: BitmapDescriptor.fromBytes(markerIcon),
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
                        width: 250,
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(ubs.image),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        child: Text(
                          ubs.mkID,
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
              LatLng(ubs.position.latitude, ubs.position.longitude),
            );
          },
        ),
      );
    }
    setState(() {});
  }

  void addCustomMarkerYou() async{
    BitmapDescriptor.fromAssetImage(
             ImageConfiguration(), 'assets/icons/homem1.png'  ) 
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }
 
  //   final Uint8List markerIcon = await getBytesFromAsset(images[3], 150);

  //   setState(() {
  //     customIcon = BitmapDescriptor.fromBytes(markerIcon);
  //   });
  // }
}




//metodos nao usados mais que pode ser util
  // void _addMarker() {
  //   setState(() {
  //     _markers.addAll({
  //       'teste': Marker(
  //         markerId: const MarkerId('add local'),
  //         icon: BitmapDescriptor.defaultMarker,
  //         position: posAtual!,
  //         infoWindow: const InfoWindow(
  //             title: 'adicionei', snippet: 'teste de adicionar local '),
  //       ),
  //     });
  //   });
  // }

  // Future<void> _novaPos() async {
  //   const LatLng novaPos = LatLng(-20.014442652072827, -45.976337386374325);
  //   _mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       const CameraPosition(
  //         target: novaPos,
  //         zoom: 16,
  //       ),
  //     ),
  //   );

  //   setState(() {
  //     const marker = Marker(
  //       markerId: MarkerId('novaPos'),
  //       icon: BitmapDescriptor.defaultMarker,
  //       position: novaPos,
  //       infoWindow: InfoWindow(
  //         title: 'nova posicao',
  //         snippet: 'teste de nova posicao',
  //       ),
  //     );

  //     _markers
  //       ..clear()
  //       ..addAll({'novaPos': marker});
  //   });
  // }

  // Future<void> _goPosDefault() async {
  //   const posDefault = pos_default;
  //   _mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       const CameraPosition(
  //         target: pos_default,
  //         zoom: 16,
  //       ),
  //     ),
  //   );

  //   setState(() {
  //     const marker = Marker(
  //       markerId: MarkerId('pos padrao'),
  //       icon: BitmapDescriptor.defaultMarker,
  //       position: posDefault,
  //       infoWindow: InfoWindow(
  //         title: 'posicao padrao',
  //         snippet: 'teste de posicao padrao',
  //       ),
  //     );

  //     _markers
  //       ..clear()
  //       ..addAll({'pos padrao': marker});
  //   });
  // }