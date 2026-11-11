import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Live camera preview that reports the text of every QR code it reads.
///
/// Owns the camera controller, so nothing outside this file depends on the scanner plugin.
class OtpScannerCamera extends StatefulWidget {
  const OtpScannerCamera({required this.onCodeDetected, required this.onCameraFailed, super.key});

  final ValueChanged<String> onCodeDetected;

  /// Called once when the camera cannot start.
  final void Function({required bool isPermissionDenied}) onCameraFailed;

  @override
  State<OtpScannerCamera> createState() => _OtpScannerCameraState();
}

class _OtpScannerCameraState extends State<OtpScannerCamera> {
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode]);
  bool _failureReported = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_reportFailure);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_reportFailure)
      ..dispose();
    super.dispose();
  }

  void _reportFailure() {
    final error = _controller.value.error;
    if (error == null || _failureReported) return;
    _failureReported = true;
    widget.onCameraFailed(isPermissionDenied: error.errorCode == MobileScannerErrorCode.permissionDenied);
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        widget.onCodeDetected(value);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The presenter is told about a failed camera through [_reportFailure] and the view
    // shows the reason from its state, so the plugin's own error view stays empty.
    return MobileScanner(
      controller: _controller,
      onDetect: _onDetect,
      errorBuilder: (context, error) => const SizedBox.expand(),
    );
  }
}
