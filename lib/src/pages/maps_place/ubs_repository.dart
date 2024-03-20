
import 'package:dio/dio.dart';
class UbsRepository {
  final String key =  'AIzaSyCVYQllfn_1PEwp-57PBRUS6QVraRfclSM';

  final Dio _client = Dio();

  Future<String> getPlaceId(String input) async{

    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&fields=place_id&key=$key';

    var response = await _client.get(url);

    if(response.statusCode != 200){
      throw Exception('Erro ao buscar o lugar');
    }

    print(response.data['candidates'][0]['place_id']);
    return response.data['candidates'][0]['place_id'];
  } 

  Future<Map<String,dynamic>> getUbs(String input) async {
    final placeId = await getPlaceId(input);
  final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,formatted_phone_number&key=$key';
  
  var response = await _client.get(url);

  if(response.statusCode != 200){
    throw Exception('Erro ao buscar o lugar');}

  print('Resultado: ${response.data['result'] as Map<String,dynamic>}');
  return response.data['result'] as Map<String,dynamic>;
  
  }
}
