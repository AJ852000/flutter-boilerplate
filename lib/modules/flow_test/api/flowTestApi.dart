import 'package:dio/dio.dart';
import 'package:new_boilerplate/constant/apiConstant.dart';
import 'package:new_boilerplate/utils/methods/apiClient.dart';

class FlowTestApi {
  final ApiClient _apiClient = ApiClient();

  Future<Response?> getFlowTestData() async {
    Response? response;
    try {
      response = await _apiClient.get(flowTestApiUrl);
    } on DioException catch (e) {
      return e.response;
    }
    return response;
  }
}
