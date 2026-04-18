// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:indapur_citizen/config/exported_path.dart' as _i307;
import 'package:indapur_citizen/config/register_module.dart' as _i679;
import 'package:indapur_citizen/view/about_us/controller/about_controller.dart'
    as _i544;
import 'package:indapur_citizen/view/complaint/controller/complaint_controller.dart'
    as _i747;
import 'package:indapur_citizen/view/complaint/controller/get_summary.dart'
    as _i822;
import 'package:indapur_citizen/view/home_view/controller/add_complaint_controller.dart'
    as _i673;
import 'package:indapur_citizen/view/home_view/controller/delete_account_controller.dart'
    as _i361;
import 'package:indapur_citizen/view/home_view/controller/get_notification.dart'
    as _i576;
import 'package:indapur_citizen/view/home_view/controller/home_controller.dart'
    as _i232;
import 'package:indapur_citizen/view/links/controller/link_controller.dart'
    as _i283;
import 'package:indapur_citizen/view/navigator/controller/navigator_controller.dart'
    as _i713;
import 'package:indapur_citizen/view/onboarding/controller/onboarding_controller.dart'
    as _i458;
import 'package:indapur_citizen/view/onboarding/controller/splash_controller.dart'
    as _i976;
import 'package:indapur_citizen/view/profile/controller/profile_controller.dart'
    as _i1058;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i307.LanguageController>(
      () => registerModule.languageController,
    );
    gh.lazySingleton<_i544.GetAbout>(() => _i544.GetAbout());
    gh.lazySingleton<_i747.ComplaintController>(
      () => _i747.ComplaintController(),
    );
    gh.lazySingleton<_i822.GetSummary>(() => _i822.GetSummary());
    gh.lazySingleton<_i673.AddComplaintsController>(
      () => _i673.AddComplaintsController(),
    );
    gh.lazySingleton<_i361.DeleteAccountController>(
      () => _i361.DeleteAccountController(),
    );
    gh.lazySingleton<_i576.GetNotification>(() => _i576.GetNotification());
    gh.lazySingleton<_i232.HomeController>(() => _i232.HomeController());
    gh.lazySingleton<_i283.GetLinks>(() => _i283.GetLinks());
    gh.lazySingleton<_i713.BottomNavigationPageController>(
      () => _i713.BottomNavigationPageController(),
    );
    gh.lazySingleton<_i458.OnboardingController>(
      () => _i458.OnboardingController(),
    );
    gh.lazySingleton<_i976.SplashController>(() => _i976.SplashController());
    gh.lazySingleton<_i1058.ProfileController>(
      () => _i1058.ProfileController(),
    );
    return this;
  }
}

class _$RegisterModule extends _i679.RegisterModule {}
