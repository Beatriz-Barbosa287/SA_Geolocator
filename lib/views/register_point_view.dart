import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sa_app_registro_ponto/controllers/point_controller.dart';
import 'package:sa_app_registro_ponto/models/location_points.dart';

class RegisterPointView extends StatefulWidget {
  const RegisterPointView({super.key});

  @override
  State<RegisterPointView> createState() => _RegisterPointViewState();
}

class _RegisterPointViewState extends State<RegisterPointView> {
  final List<Map<String, dynamic>> listaPosicoes = [];
  final _pointController = PointController();

  bool _isLoading = false;
  String? _error;

  // Local fixo do trabalho
  static const double localTrabalhoLat = -22.570991565;
  static const double localTrabalhoLon = -47.4042606411; //localização manual do SENAI Limeira
  static const double distanciaMaxima = 100.0;

  Future<void> _adicionarPonto() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Obtém localização e hora atual
      LocationPoints novaMarcacao = await _pointController.getcurrentLocation();

      // Converte o timestamp formatado em DateTime real (para salvar)
      final agora = DateTime.now();

      // Calcula a distância até o local de trabalho
      final distancia = Geolocator.distanceBetween(
        localTrabalhoLat,
        localTrabalhoLon,
        novaMarcacao.latitude,
        novaMarcacao.longitude,
      );

      if (distancia > distanciaMaxima) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fora da área de trabalho (${distancia.toStringAsFixed(1)} m)',
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Monta o item que aparece na lista
      final item = {
        'dataHora':
            novaMarcacao.timeStamp, // formatado em dd/MM/yyyy - HH:mm:ss
        'latitude': novaMarcacao.latitude,
        'longitude': novaMarcacao.longitude,
        'distancia': distancia,
      };

      setState(() {
        listaPosicoes.insert(0, item);
      });

      // Salva no banco (Firebase)
      await _pointController.savePoint(novaMarcacao, agora);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ponto registrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _error = e.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar ponto: $_error')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Interface da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Ponto")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _adicionarPonto,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_location_alt),
                label: const Text('Registrar Ponto de Trabalho'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Data / Hora',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Latitude',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Longitude',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Dist. (m)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: listaPosicoes.isNotEmpty
                  ? ListView.separated(
                      itemCount: listaPosicoes.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = listaPosicoes[index];
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(item['dataHora'] ?? ''),
                            ),
                            Expanded(
                              child: Text(
                                item['latitude']?.toStringAsFixed(6) ?? '',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item['longitude']?.toStringAsFixed(6) ?? '',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item['distancia']?.toStringAsFixed(1) ?? '',
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : const Center(child: Text('Nenhum ponto registrado')),
            ),
          ],
        ),
      ),
    );
  }
}
