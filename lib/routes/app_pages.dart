import 'package:excel_demo/binding/form_binding.dart';
import 'package:excel_demo/screens/FormView.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => const FormView(),
        binding: FormBinding()),
  ];
}
