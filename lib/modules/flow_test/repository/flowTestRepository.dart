import 'package:new_boilerplate/modules/flow_test/api/flowTestApi.dart';

class FlowTestRepository {
  final flowTestProvider = FlowTestApi();

  getflowTestData() => flowTestProvider.getFlowTestData();
}
