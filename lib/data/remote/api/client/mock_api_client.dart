import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/remote/api/client/api_client.dart';

final mockApiClient = ApiClient(Dio(), baseUrl: "");
