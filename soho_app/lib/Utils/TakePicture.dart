
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TakePictureScreenState();
  }

}

class _TakePictureScreenState extends State<TakePictureScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;

  Future<void> _initCameraController() async {
    if (_controller != null) {
      await _controller.dispose();
    }

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      Fluttertoast.showToast(
          msg: "Error con la cámara del dispositivo.",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 4,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0x99E51F4F),
          textColor: Colors.white
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
          future: _initCameraController(),
          builder: (context, snapshot) {
            if (_controller != null || _controller.value.isInitialized) {
              return CameraPreview(_controller);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

}