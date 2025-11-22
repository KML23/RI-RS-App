import 'package:get/get.dart';

import '../modules/appointment/bindings/appointment_binding.dart';
import '../modules/appointment/views/appointment_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/education/bindings/education_binding.dart';
import '../modules/education/views/education_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/medication/bindings/medication_binding.dart';
import '../modules/medication/views/medication_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/symtom_checker/bindings/symtom_checker_binding.dart';
import '../modules/symtom_checker/views/symtom_checker_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MEDICATION,
      page: () => const MedicationView(),
      binding: MedicationBinding(),
    ),
    GetPage(
      name: _Paths.SYMTOM_CHECKER,
      page: () => const SymtomCheckerView(),
      binding: SymtomCheckerBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENT,
      page: () => const AppointmentView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION,
      page: () => const EducationView(),
      binding: EducationBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
  ];
}
