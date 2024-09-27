import 'package:bergusi/drawer.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DroneControlPage extends StatefulWidget {
  const DroneControlPage({super.key});

  @override
  State<DroneControlPage> createState() => _DroneControlWidgetState();
}

class _DroneControlWidgetState extends State<DroneControlPage> {
  late VideoPlayerController _controller;
  Offset _leftJoystickPosition = Offset.zero;
  Offset _rightJoystickPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'assets/videos/344.mp4',
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      // set orientation to potrait
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   // Add back button
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return const Center(
              child: Text('Please rotate your device to landscape mode'),
            );
          }
          return Stack(
            children: [
              // Video player background
              _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : Container(color: Colors.black),

              // Left joystick
              Positioned(
                left: 50,
                bottom: 50,
                child: _buildJoystick(true),
              ),

              // Right joystick
              Positioned(
                right: 50,
                bottom: 50,
                child: _buildJoystick(false),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJoystick(bool isLeft) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          if (isLeft) {
            _leftJoystickPosition += details.delta;
          } else {
            _rightJoystickPosition += details.delta;
          }
          _clampJoystickPosition(isLeft);
        });
      },
      onPanEnd: (details) {
        setState(() {
          if (isLeft) {
            _leftJoystickPosition = Offset.zero;
          } else {
            _rightJoystickPosition = Offset.zero;
          }
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            transform: Matrix4.translationValues(
              isLeft ? _leftJoystickPosition.dx : _rightJoystickPosition.dx,
              isLeft ? _leftJoystickPosition.dy : _rightJoystickPosition.dy,
              0,
            ),
          ),
        ),
      ),
    );
  }

  void _clampJoystickPosition(bool isLeft) {
    Offset position = isLeft ? _leftJoystickPosition : _rightJoystickPosition;
    double maxRadius = 30;

    if (position.distance > maxRadius) {
      position = position / position.distance * maxRadius;
    }

    _checkAndFireEvent(isLeft, position.dx <= -maxRadius, 'left');
    _checkAndFireEvent(isLeft, position.dx >= maxRadius, 'right');
    _checkAndFireEvent(isLeft, position.dy <= -maxRadius, 'top');
    _checkAndFireEvent(isLeft, position.dy >= maxRadius, 'bottom');

    if (isLeft) {
      _leftJoystickPosition = position;
    } else {
      _rightJoystickPosition = position;
    }
  }

  void _checkAndFireEvent(bool isLeft, bool condition, String direction) {
    if (condition) {
      _fireJoystickEvent(isLeft, direction);
    }
  }

  void _fireJoystickEvent(bool isLeft, String direction) {
    print('joystick reached maximum $direction position');
    if (isLeft) {
      switch (direction) {
        case 'left':
        case 'right':
        case 'top':
        case 'bottom':
      }
    } else {
      switch (direction) {
        case 'left':
        case 'right':
        case 'top':
        case 'bottom':
      }
    }
    // Here you can add additional logic to handle the event,
    // such as sending commands to the drone or updating UI elements
  }
}
