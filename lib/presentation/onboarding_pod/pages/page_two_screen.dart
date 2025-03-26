
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../../../routes/app_router_constants.dart';

class Slider_Second extends StatefulWidget {
  final VoidCallback onNext;

  const Slider_Second({required this.onNext, super.key});

  @override
  _SliderSecondState createState() => _SliderSecondState();
}

class _SliderSecondState extends State<Slider_Second> {

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final List<double> _audioWaveform = [];
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  final TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender="Male";
  bool _isLoading=true;
  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  // Initialize recorder and request permissions
  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Microphone Permission Required"),
          content: const Text(
              "This app requires microphone access to record audio. Please grant permission."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      await _recorder.openRecorder();
      await _player.openPlayer();
      _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
    } else {
      await openAppSettings();
    }
  }

  // Start recording and capture waveform
  Future<void> _startRecording() async {
    final directory = await getTemporaryDirectory();
    _audioPath = '${directory.path}/audio_recording.aac';
    _audioWaveform.clear();

    _recorder.onProgress!.listen((event) {
      final amplitude = event.decibels ?? 0;
      setState(() {
        _audioWaveform.add(amplitude);
        if (_audioWaveform.length > 100) {
          _audioWaveform.removeAt(0); // Limit waveform buffer size
        }
      });
    });

    await _recorder.startRecorder(toFile: _audioPath, codec: Codec.aacADTS);

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print("Error stopping recorder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to stop recording: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Play the recorded audio
  Future<void> _playRecording() async {
    if (_audioPath != null && !_isPlaying) {
      await _player.startPlayer(
        fromURI: _audioPath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
      setState(() {
        _isPlaying = true;
      });
    }
  }

  // Stop playing the recording
  Future<void> _stopPlaying() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.02), // Top
                // Step Indicator and Skip Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.goNamed(MyAppRouteConstants.onboardHardware);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    Column(
                      children: [
                        const Text(
                          "Step 2 of 5",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            fontFamily: 'Avenir',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: size.height * 0.005),
                        SizedBox(
                          width: size.width * 0.2,
                          child: LinearProgressIndicator(
                            value: 2 / 5,
                            backgroundColor: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(Color(0xff303030)),
                            minHeight: 3,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(MyAppRouteConstants.dashboard);
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xff303030),
                          fontSize: 16,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                 ]
                ),

                const SizedBox(height: 14),

                // Title
                const Text(
                  "Setup your\nchild's profile",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Avenir",
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Name Input
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEC34E),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 1.7,
                        offset: Offset(0, 3),
                        color: Color(0xffeae3db),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: nameController,
                    onChanged: (val){

                      if (val.isNotEmpty &&
                          selectedGender != null &&
                          selectedDate != null){
                        setState(() {
                          _isLoading=false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Enter child's name",
                      hintStyle: const TextStyle(
                        color:  Color(0xff303030),
                        fontFamily: 'Avenir',
                        fontSize: 18
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text(
                      "Pronunciation",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Color(0xff303030),
                        fontFamily: 'Avenir',
                      ),
                    ),
                    GestureDetector(
                      onTap: _isRecording ? _stopRecording : _startRecording,
                      child: Row(
                        children: [
                          Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: _isRecording ? Colors.red : Colors.black45,
                          ),
                          const SizedBox(width: 1),
                          Text(
                            _isRecording ? "stop recording" : "record myself",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                GestureDetector(
                  onTap: _isPlaying ? _stopPlaying : _playRecording,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.2,
                            offset: const Offset(0, 5),
                            color: const Color(0xFFF37844).withOpacity(0.6),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF37844),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Play/Stop Icon
                            Padding(
                              padding:
                              const EdgeInsets.only(left:  10),
                              child: Icon(
                                _isPlaying
                                    ? Icons.stop
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            // Audio Waveform
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomPaint(
                                    painter: WaveformPainter(_audioWaveform),
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Gender Section

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Avenir",
                        color: Color(0xff303030),
                      ),
                    ),
                    Container(
                      width: size.width * 0.48,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffeae3db),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffeae3db),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 3,
                                offset: Offset(0, 0.5),
                                color: Color(0xffeae3db),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Gender Option for Male
                              Expanded(
                                flex: selectedGender == "Male"
                                    ? 1
                                    : 1, // Adjust flex based on selection
                                child: _buildGenderOption(
                                  emoji: '👦',
                                  isSelected: selectedGender == "Male",
                                  onSelect: () {
                                    setState(() {
                                      selectedGender = "Male";
                                    });
                                  },
                                ),
                              ),
                              // Gender Option for Female
                              Expanded(
                                flex: selectedGender == "Female"
                                    ? 1
                                    : 1, // Adjust flex based on selection
                                child: _buildGenderOption(
                                  emoji: '👧',
                                  isSelected: selectedGender == "Female",
                                  onSelect: () {
                                    setState(() {
                                      selectedGender = "Female";
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Date of Birth
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Date of birth",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Avenir",
                        color:  Color(0xff303030),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                          if (nameController.text.isNotEmpty &&
                              selectedGender != null &&
                              selectedDate != null){
                            setState(() {
                              _isLoading=false;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: size.width * 0.48,
                        height: size.height * 0.055,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 3,
                              offset: Offset(0, 0.5),
                              color: Color(0xffeae3db),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Select date"
                                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: selectedDate == null
                                    ? const Color(0xff303030)
                                    : Colors.black,
                              ),
                            ),
                            const Icon(

                              Icons.calendar_today_rounded,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Create Profile Button
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.2,
                          offset: const Offset(0, 4),
                          color:  !_isLoading
                              ? const Color(0xffFEC34E)
                              : const Color(0xfff3e4c6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isLoading
                            ? const Color(0xffFEC34E)
                            : const Color(0xffffedca),
                        disabledBackgroundColor:const Color(0xffffedca),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                        // shadowColor: Colors.black87,
                      ),
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            selectedGender == null ||
                            selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please complete all fields."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          widget.onNext();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Create profile and continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Avenir",
                            color:  !_isLoading? Color(0xff303030):Color(0xff303030).withOpacity(0.4),
                          ),
                        ),
                      ),
                      ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }
}

Widget _buildGenderOption({
  required String emoji,
  required bool isSelected,
  required VoidCallback onSelect,
}) {
  return GestureDetector(
    onTap: onSelect,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: !isSelected
            ?       const Color(0xffeae3db)
            : Colors.white, // White for selected, grey for unselected
        borderRadius: BorderRadius.circular(15),

      ),
      child: Text(
        emoji,
        style: TextStyle(
          fontSize: 28,
          fontWeight: isSelected
              ? FontWeight.bold
              : FontWeight.normal, // Bold for selected
          color: isSelected
              ? Colors.black
              : Colors.black54, // Darker color for selected
        ),
      ),
    ),
  );
}

// Custom painter for the waveform
class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;

  WaveformPainter(this.amplitudes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final spacing = size.width / (amplitudes.length + 1);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * spacing;
      final y =
      (amplitudes[i] / 2).clamp(0, size.height / 2); // Normalize amplitude
      canvas.drawLine(
        Offset(x, midY - y),
        Offset(x, midY + y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
