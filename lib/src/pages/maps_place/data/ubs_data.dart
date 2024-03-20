import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  String mkID;
  LatLng position;
  bool vc;

  MarkerData({required this.mkID, required this.position, required this.vc});
}

class MarkerDataSet {
  List<MarkerData> markers = [
    MarkerData(
      mkID: "UBS Delma Rosa Silva Gontijo",
      position: LatLng(-20.013427823280512, -45.97010017200662),
      vc: false,
    ),
    MarkerData(
      mkID: "Psf sao sebastiao",
      position: LatLng(-20.016297439211666, -45.97849398923116),
      vc: false,
    ),
    MarkerData(
      mkID: "UBS Padre Rafael de Paulo Lopes 07",
      position: LatLng(-20.019307778519977, -45.97354531361249),
      vc: false,
    ),
    MarkerData(
      mkID: 'PSF Etevolde Lopes Lima',
      position: LatLng(-20.014431226721733, -45.98372832013234),
      vc: false,
    ),
    MarkerData(
      mkID: 'PSF Dr. Jandir Chaves "PSF Santana"',
      position: LatLng(-20.00227573191085, -45.977245462774434),
      vc: false,
    ),
    MarkerData(
      mkID: 'Hospital Nossa Senhora do Brasil',
      position: LatLng(-20.009083227109546, -45.98179009879605),
      vc: false,
    ),
    MarkerData(
      mkID: 'PSF Nossa Senhora das Graças',
      position: LatLng(-20.008838757180584, -45.98327285212417),
      vc: false,
    ),
    // Adicione mais marcadores conforme necessário
  ];
}
