import 'package:flutter_riverpod_template/data/api/api_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final appProvider = Provider<ApiConfig>((ref) => ApiConfig('', apiKey: ''));
