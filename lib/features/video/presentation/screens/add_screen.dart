import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_store/features/features.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _addVideoUseCase = GetIt.I<AddVideoUseCase>();
  bool _isUploading = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
  Permission permissionToRequest;

  if (Platform.isAndroid) {
    permissionToRequest = Permission.videos;
  } else {
    permissionToRequest = Permission.photos;
  }

  var status = await permissionToRequest.status;

  if (!status.isGranted) {
    status = await permissionToRequest.request();

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      status = await permissionToRequest.status;
    }
  }

  setState(() {
    _hasPermission = status.isGranted || status.isLimited;
  });

  if (!_hasPermission && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permissão necessária. Vá em Configurações > Apps > Seu App > Permissões e ative "Vídeos e fotos".'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}

  Future<void> _pickAndAddVideos() async {
    await _checkAndRequestPermission();

    if (!_hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão necessária para acessar vídeos')),
      );
      await _checkAndRequestPermission();
      return;
    }

    setState(() => _isUploading = true);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (file.path != null) {
          await _addVideoUseCase(file.path!);
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${result.files.length} vídeo(s) adicionado(s)')),
        );
      }
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isUploading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Adicionando vídeos...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline, size: 120, color: Colors.white),
                  const SizedBox(height: 32),
                  const Text(
                    'Adicionar vídeos',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecione um ou mais vídeos do seu dispositivo',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Escolher vídeos'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    onPressed: _pickAndAddVideos,
                  ),
                  if (!_hasPermission)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Precisamos de permissão para acessar seus vídeos. Toque no botão acima para conceder.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[300]),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
