import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/presentation/pages/login_screen.dart';

class QRScanScreen extends ConsumerStatefulWidget {
  const QRScanScreen({super.key});

  @override
  ConsumerState<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends ConsumerState<QRScanScreen> {
  /// для сканирования qr кода
  //MobileScannerController controller = MobileScannerController();

  // Временная константа для restaurantId
  static const String hardcodedRestaurantId = 'rest_12345';
  bool isScanning = false;

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  void _navigateToLogin(String restaurantId) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(restaurantId: restaurantId),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Для входа в приложение отсканируйте QR-код',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              // if (isScanning)
              //   SizedBox(
              //     height: 300,
              //     width: 300,
              //     child: MobileScanner(
              //       controller: controller,
              //       onDetect: (BarcodeCapture capture) {
              //         final String? restaurantId = capture.barcodes.first.rawValue;
              //         if (restaurantId != null && mounted) {
              //           Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => LoginScreen(restaurantId: restaurantId),
              //             ),
              //           );
              //         }
              //       },
              //     ),
              //   )
              // else
              //   ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         isScanning = true;
              //       });
              //     },
              //     child: const Text('Сканировать QR-код'),
              //   ),
              ElevatedButton(
                onPressed: () {
                  AppLogger.logInfo('Simulating QR scan with ID: $hardcodedRestaurantId');
                  _navigateToLogin(hardcodedRestaurantId); // Переход с захардкодленным ID
                },
                child: const Text('Сканировать QR-код'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}