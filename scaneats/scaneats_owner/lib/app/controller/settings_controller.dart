import 'package:scaneats_owner/app/model/model.dart';
import 'package:scaneats_owner/app/ui/settings_screen/setting_screen_view/currencies_view.dart';
import 'package:scaneats_owner/app/ui/settings_screen/setting_screen_view/language_view.dart';
import 'package:scaneats_owner/app/ui/settings_screen/setting_screen_view/notification_view.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/ui/settings_screen/setting_screen_view/payment_view.dart';
import 'package:scaneats_owner/app/ui/settings_screen/setting_screen_view/them_view.dart';

class SettingsController extends GetxController {
  RxString title = "Settings".obs;

  Rx<SettingsItem> selectSettingWidget = SettingsItem(title: ['Company'], icon: "assets/icons/one.svg", widget: [const NotificationView()], selectIndex: 0).obs;
  final settinsAllPage = [
    // SettingsItem(title: ['Company'], icon: "assets/icons/one.svg", widget: [const CompanyDetailsView()], selectIndex: 0),
    SettingsItem(title: ['Notification'], icon: "assets/icons/bell.svg", widget: [const NotificationView()], selectIndex: 0),
    SettingsItem(title: ['Payment settings'], icon: "assets/icons/ic_payment.svg", widget: [const PaymentView()], selectIndex: 0),
    // SettingsItem(title: ['Branches'], icon: "assets/icons/three.svg", widget: [const BranchesView()], selectIndex: 0),
    SettingsItem(title: ['Theme'], icon: "assets/icons/seven.svg", widget: [const ThemView()], selectIndex: 0),
    SettingsItem(title: ['Currencies'], icon: "assets/icons/dollar_sign_2.svg", widget: [const CurrenciesView()], selectIndex: 0),
    // SettingsItem(title: ['Item Categories'], icon: "assets/icons/eight.svg", widget: [const ItemCategoryView()], selectIndex: 0),
    // SettingsItem(title: ['Item Attributes'], icon: "assets/icons/nine.svg", widget: [const ItemAttributeView()], selectIndex: 0),
    // SettingsItem(title: ['Taxes'], icon: "assets/icons/ten.svg", widget: [const TaxView()], selectIndex: 0),
    // SettingsItem(title: ['Roles & Permissions', 'View'], icon: "assets/icons/twelve.svg", widget: [const RoleScreen(), const PermissionScreen()]),
    SettingsItem(title: ['Languages'], icon: "assets/icons/threteen.svg", widget: [const LanguageView()], selectIndex: 0),
  ];
}
