import 'package:flutter_riverpod_template/data/remote/api/client/api_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
ApiConfig app(Ref ref) {
  return ApiConfig('', apiKey: '');
}
