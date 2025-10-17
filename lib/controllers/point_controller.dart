import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sa_app_registro_ponto/models/location_points.dart';

class PointController {
  final DateFormat _formatar = DateFormat("dd/MM/yyyy - HH:mm:ss");

  /// Obtém a localização atual e retorna um objeto LocationPoints
  Future<LocationPoints> getcurrentLocation() async {
    // Verifica se o serviço de GPS está ativo
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Serviço de localização desativado.");
    }

    // Checa e solicita permissão de localização
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // <- aqui era o erro
      if (permission == LocationPermission.denied) {
        throw Exception("Permissão de acesso ao GPS negada.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permissão de localização permanentemente negada.");
    }

    // Obtém a posição atual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Formata a data e hora no padrão brasileiro
    String dataHora = _formatar.format(DateTime.now());

    // Cria o objeto de localização
    LocationPoints posicaoAtual = LocationPoints(
      latitude: position.latitude,
      longitude: position.longitude,
      timeStamp: dataHora,
    );

    return posicaoAtual;
  }

  /// Persiste o ponto no banco (Firebase, Sqflite etc.)
  Future<void> savePoint(LocationPoints point, DateTime when) async {
   
    print('Salvando ponto: ${point.latitude}, ${point.longitude}, ${point.timeStamp}');
  }
}
