import 'package:escorpionico_proj/src/pages/maps_page/ubs_model.dart';
import 'package:escorpionico_proj/src/pages/maps_page/ubs_repository.dart';
import 'package:flutter/material.dart';

class UbsController extends ChangeNotifier {
  final _ubsRepository = UbsRepository();

  Future<List<UbsModel>> getUbs() async {
    // final ubs = await _ubsRepository.getUbs();
    // return ubs;
    return [];
  }
}
