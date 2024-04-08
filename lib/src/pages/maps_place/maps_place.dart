import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as HandlerPermission;

import '../../services/get_casos_service.dart';
import '../../utils/loading.dart';
import 'data/ubs_data.dart';

class MapsPlace extends StatefulWidget {
  const MapsPlace({super.key});

  @override
  State<MapsPlace> createState() => _MapsPlaceState();
}

class _MapsPlaceState extends State<MapsPlace> {
  final localizacaoController = Location();

  var status = HandlerPermission.Permission.location.status;

  LatLng? posAtual;

  Map<String, Marker> _markers = {};

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

  List<String> docIds = [];

  Future getDocsID() async {
    await FirebaseFirestore.instance.collection('casos').get().then(
          (snapshot) => snapshot.docs.forEach(
            (doc) {
              docIds.add(doc.reference.id);
            },
          ),
        );
  }

  // Future<List<LatLng>> getCasos() async {
  //   for (var docId in docIds) {
  //     List<LatLng> latLngList =
  //         await GetCasosService.getCasesCoordinates(docId);
  //     print('LISTAAAA: $latLngList');
  //   }
  //   return [];
  // }

  final List<LatLng> localEscorpiao = [];

  Future getLocalEscorpiao() async {
    setState(() {
      isLoading = true;
    });
    for (var docId in docIds) {
      List<LatLng> latLngList =
          await GetCasosService.getCasesCoordinates(docId);
      print('LISTAAAA: $latLngList');
      localEscorpiao.addAll(latLngList);
    }
  }

  var isEscorpiao = false;

  GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

  final MarkerDataSet ubsData = MarkerDataSet();

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDocsID();
    _checkLocationPermission();
    addCustomMarkerYou();
    createMarkersUbs(ubsData);

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdate());
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Bambuí'),
        centerTitle: true,
      ),
      body: posAtual == null
          ? const CustomLoadingWidget()
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 9,
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
                            },
                            markers: isEscorpiao
                                ? {
                                    Marker(
                                      markerId: const MarkerId('voce'),
                                      position: posAtual!,
                                      icon: customIcon,
                                    ),
                                    ...ubsMarker,
                                    ...escorpiaoMarker,
                                  }
                                : {
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
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Legenda',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(images[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Text(' - Unidade de Saúde'),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(images[1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Text(' - Escorpião avistado'),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                Positioned(
                  bottom: size.height * 0.095,
                  left: size.width * 0.018,
                  child: FloatingActionButton(
                    onPressed: () {
                      _customInfoWindowController.googleMapController!
                          .animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: posAtual!,
                            zoom: 17,
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
                                          const Text('AINDA NÃO IMPLEMENTADO'),
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
                          Icons.edit_location_alt_sharp,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          await getLocalEscorpiao();
                          createMarkersEscorpioes(localEscorpiao);
                          setState(() {
                            isEscorpiao = !isEscorpiao;
                            isLoading = false;
                          });
                        },
                        child: !isLoading
                            ? Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/icons/scorpion.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  addMarkers(String mkID, LatLng position, bool vc, String image) async {
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
    });

    location.onLocationChanged.listen((newLoc) {
      posAtual = LatLng(newLoc.latitude!, newLoc.longitude!);
      setState(() {});
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

  void gerarObjetoFirebase(List<String> docIds) {
    //iterar sobre docsIds e adicionar em documetos
  }

  Future<void> createMarkersEscorpioes(List<LatLng> locations) async {
    final Uint8List markerIcon = await getBytesFromAsset(images[1], 100);

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
                      flex: 4,
                      child: Container(
                        width: 250,
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(''),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Expanded(
                      child: Text(
                        'Escorpiao avistado! Cuidado!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

  Future<void> createMarkersUbs(MarkerDataSet ubs) async {
    final Uint8List markerIcon = await getBytesFromAsset(images[0], 90);
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
                      flex: 5,
                      child: Container(
                        width: 250,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(ubs.image),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: Text(
                        ubs.mkID,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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

  void addCustomMarkerYou() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/icons/tia.png')
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }
}
