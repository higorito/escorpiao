// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  String mkID;
  LatLng position;
  String image;

  MarkerData({
    required this.mkID,
    required this.position,
    required this.image,
  });
}

class MarkerDataSet {
  List<MarkerData> markers = [
    MarkerData(
        mkID: "UBS Delma Rosa Silva Gontijo",
        position: LatLng(-20.013427823280512, -45.97010017200662),
        image:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=ZjzXNN6jKt6bKmYb1DRwlg&cb_client=search.gws-prod.gps&w=408&h=240&yaw=348.14728&pitch=0&thumbfov=100'),
    MarkerData(
        mkID: "Psf sao sebastiao",
        position: LatLng(-20.016297439211666, -45.97849398923116),
        image:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=QVpnINYVc4pQac2WYLM5bA&cb_client=search.gws-prod.gps&w=408&h=240&yaw=101.20206&pitch=0&thumbfov=100'),
    MarkerData(
        mkID: "UBS Padre Rafael de Paulo Lopes 07",
        position: LatLng(-20.019307778519977, -45.97354531361249),
        image:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=pcE1sJG-fYPvPws9dgbAlQ&cb_client=search.gws-prod.gps&w=408&h=240&yaw=29.598553&pitch=0&thumbfov=100'),
    MarkerData(
        mkID: 'PSF Etevolde Lopes Lima',
        position: LatLng(-20.014431226721733, -45.98372832013234),
        image:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=QN5P2pUQPjwcdVWPOCcgBQ&cb_client=search.gws-prod.gps&w=408&h=240&yaw=181.4117&pitch=0&thumbfov=100'),
    MarkerData(
        mkID: 'PSF Dr. Jandir Chaves "PSF Santana"',
        position: LatLng(-20.00227573191085, -45.977245462774434),
        image:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=QNVqLirbrP3Eif5BxkcBJA&cb_client=search.gws-prod.gps&w=408&h=240&yaw=98.29088&pitch=0&thumbfov=100'),
    MarkerData(
        mkID: 'Hospital Nossa Senhora do Brasil',
        position: LatLng(-20.009083227109546, -45.98179009879605),
        image:
            'https://lh5.googleusercontent.com/p/AF1QipOvUpc-kDLQRtJ9cJKOBh4Xl_nySt7b6KUqqTQu=w532-h240-k-no'),
    MarkerData(
        mkID: 'PSF Nossa Senhora das Graças',
        position: LatLng(-20.008838757180584, -45.98327285212417),
        image:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=t6449eiDJard-dsME9kw7g&cb_client=search.gws-prod.gps&w=408&h=240&yaw=340.2773&pitch=0&thumbfov=100'),
    // Adicione mais marcadores conforme necessário
  ];
}
