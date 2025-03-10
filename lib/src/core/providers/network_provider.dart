import 'package:basic_template/src/core/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/network_service.dart'; 


final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(dio: ref.read(dioProvider));
});