import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as HandlerPermission;

import '../../models/casos_model.dart';
import '../../services/download_image.dart';
import '../../services/get_casos_service.dart';
import '../../services/user_profile.dart';
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
    'assets/icons/sinal-de-alerta.png',
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

  bool show = false;

  final List<Data> localEscorpiao = [];

  Future getLocalEscorpiao() async {
    setState(() {
      isLoading = true;
    });
    for (var docId in docIds) {
      List<Data> dataList = await GetCasosService.getCasesData(docId);
      localEscorpiao.addAll(dataList);
    }
  }

  var isEscorpiao = false;

  GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

  final MarkerDataSet ubsData = MarkerDataSet();

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarkerWithHue(200);

  bool isLoading = false;

  final UserProfileService _userService = UserProfileService();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdate());
    getDocsID();
    _checkLocationPermission();

    addCustomMarkerYou();
    createMarkersUbs(ubsData);
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
                              height: size.height * 0.2,
                              width: size.width * 0.6,
                              offset: 25),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Legenda',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
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
                              const Text(' - UBS'),
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
                              const Text(' - Avistamento'),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(images[2]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Text(' - Acidente'),
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
                          if (!show) {
                            await getLocalEscorpiao();
                            show = true;
                          }
                          createMarkersEscorpioes(localEscorpiao);
                          if (mounted) {
                            setState(() {
                              isEscorpiao = !isEscorpiao;
                              isLoading = false;
                            });
                          }
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

    if (mounted) {
      setState(() {});
    }
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
        if (mounted) {
          setState(() {
            posAtual =
                LatLng(atualLocalizacao.latitude!, atualLocalizacao.longitude!);
            _locationData = atualLocalizacao;
          });
        }
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
      if (mounted) {
        setState(() {});
      }
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

  Future<void> createMarkersEscorpioes(List<Data> locations) async {
    final FirebaseImageDownloader imageDownloader = FirebaseImageDownloader();

    for (var location in locations) {
      Uint8List? imageData = await imageDownloader.getImage(location.img);

      Uint8List defaultImage =
          await getBytesFromAsset('assets/images/escorp.jpg', 400);

      final Uint8List markerIcon = await getBytesFromAsset(images[1], 100);
      final Uint8List acidente = await getBytesFromAsset(images[2], 100);

      escorpiaoMarker.add(
        Marker(
          markerId: MarkerId('escorpiao ${location.latLong.latitude}'),
          position:
              LatLng(location.latLong.latitude, location.latLong.longitude),
          icon: BitmapDescriptor.fromBytes(
              location.tipo == 'avistamento' ? markerIcon : acidente),
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
                          image: DecorationImage(
                            image: MemoryImage(imageData ?? defaultImage),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Text(
                        location.tipo == 'avistamento'
                            ? 'Escorpião avistado ${location.per2}'
                            : 'Acidente com escorpião ${location.per2}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              LatLng(location.latLong.latitude, location.latLong.longitude),
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
    if (mounted) {
      setState(() {});
    }
  }

  void addCustomMarkerYou() async {
    if (FirebaseAuth.instance.currentUser!.photoURL == null ||
        FirebaseAuth.instance.currentUser!.photoURL!.isEmpty) {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), 'assets/icons/tia.png')
          .then((icon) {
        if (mounted) {
          setState(() {
            customIcon = icon;
          });
        }
      });
    } else {
      final Uint8List markerIcon = await getBytesFromUrl(
          FirebaseAuth.instance.currentUser!.photoURL.toString());

      final BitmapDescriptor bitmapDescriptor =
          BitmapDescriptor.fromBytes(markerIcon);
      if (mounted) {
        setState(() {
          customIcon = bitmapDescriptor;
        });
      }
    }
  }

  Future<Uint8List> getBytesFromUrl(String url) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }
}
