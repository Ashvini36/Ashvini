import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/constants.dart';
import 'package:emartconsumer/main.dart';
import 'package:emartconsumer/model/User.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:emartconsumer/services/helper.dart';
import 'package:emartconsumer/services/localDatabase.dart';
import 'package:emartconsumer/services/show_toast_dialog.dart';
import 'package:emartconsumer/theme/app_them_data.dart';
import 'package:emartconsumer/ui/Language/language_choose_screen.dart';
import 'package:emartconsumer/ui/QrCodeScanner/QrCodeScanner.dart';
import 'package:emartconsumer/ui/service_list_screen.dart';
import 'package:emartconsumer/ui/auth_screen/login_screen.dart';

import 'package:emartconsumer/ui/cartScreen/CartScreen.dart';
import 'package:emartconsumer/ui/chat_screen/inbox_driver_screen.dart';
import 'package:emartconsumer/ui/chat_screen/inbox_screen.dart';
import 'package:emartconsumer/ui/cuisinesScreen/CuisinesScreen.dart';
import 'package:emartconsumer/ui/dineInScreen/dine_in_screen.dart';
import 'package:emartconsumer/ui/dineInScreen/my_booking_screen.dart';
import 'package:emartconsumer/ui/gift_card/gift_card_screen.dart';
import 'package:emartconsumer/ui/home/HomeScreen.dart';
import 'package:emartconsumer/ui/home/favourite_item.dart';
import 'package:emartconsumer/ui/home/favourite_store.dart';
import 'package:emartconsumer/ui/mapView/MapViewScreen.dart';
import 'package:emartconsumer/ui/ordersScreen/OrdersScreen.dart';
import 'package:emartconsumer/ui/privacy_policy/privacy_policy.dart';
import 'package:emartconsumer/ui/profile/ProfileScreen.dart';
import 'package:emartconsumer/ui/referral_screen/referral_screen.dart';
import 'package:emartconsumer/ui/searchScreen/SearchScreen.dart';
import 'package:emartconsumer/ui/termsAndCondition/terms_and_codition.dart';
import 'package:emartconsumer/ui/wallet/walletScreen.dart';
import 'package:emartconsumer/userPrefrence.dart';
import 'package:emartconsumer/utils/DarkThemeProvider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DrawerSelection {
  Dashboard,
  Home,
  Wallet,
  dineIn,
  Cuisines,
  Search,
  Cart,
  referral,
  Profile,
  Orders,
  MyBooking,
  chooseLanguage,
  inbox,
  driver,
  Logout,
  termsCondition,
  privacyPolicy,
  LikedStore,
  LikedProduct,
  giftCard
}

class ContainerScreen extends StatefulWidget {
  final User? user;
  final Widget currentWidget;
  final String vendorId;
  final String appBarTitle;
  final DrawerSelection drawerSelection;

  ContainerScreen({Key? key, required this.user, currentWidget, vendorId, appBarTitle, this.drawerSelection = DrawerSelection.Home})
      : appBarTitle = appBarTitle ?? 'Home'.tr(),
        vendorId = vendorId ?? "",
        currentWidget = currentWidget ??
            HomeScreen(
              user: MyAppState.currentUser,
              vendorId: vendorId,
            ),
        super(key: key);

  @override
  _ContainerScreen createState() {
    return _ContainerScreen();
  }
}

class _ContainerScreen extends State<ContainerScreen> {
  var key = GlobalKey<ScaffoldState>();

  late CartDatabase cartDatabase;
  late String _appBarTitle;
  final fireStoreUtils = FireStoreUtils();

  late Widget _currentWidget;
  late DrawerSelection _drawerSelection;

  int cartCount = 0;
  bool? isWalletEnable;
  late User user;
  late StreamSubscription eventBusStream;

  @override
  void initState() {
    FireStoreUtils.getWalletSettingData();
    if (widget.user != null) {
      user = widget.user!;
    } else {
      user = User();
    }
    super.initState();
    //FireStoreUtils.walletSettingData().then((value) => isWalletEnable = value);
    _currentWidget = widget.currentWidget;
    _appBarTitle = widget.appBarTitle;
    _drawerSelection = widget.drawerSelection;
    //getKeyHash();
    /// On iOS, we request notification permissions, Does nothing and returns null on Android
    FireStoreUtils.firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    getTaxList();
  }

  getTaxList() async {
    await FireStoreUtils().getTaxList(sectionConstantModel!.id).then((value) {
      if (value != null) {
        taxList = value;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartDatabase = Provider.of<CartDatabase>(context);
  }


  DateTime? currentBackPressTime;
  bool canPopNow = false;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: (didPop) {
        final now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          setState(() {
            canPopNow = false;
          });
          ShowToastDialog.showToast("Double press to exit");
          return;
        } else {

          setState(() {
            canPopNow = true;
          });
        }
      },
      child: ChangeNotifierProvider.value(
        value: user,
        child: Consumer<User>(builder: (context, user, _) {
          return Scaffold(
            backgroundColor: isDarkMode(context) ? AppThemeData.surfaceDark : AppThemeData.surface,
            key: key,
            drawer: Drawer(
              child: Container(
                  color: isDarkMode(context) ? AppThemeData.grey900 : AppThemeData.grey50,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Consumer<User>(builder: (context, user, _) {
                              return DrawerHeader(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    displayCircleImage(user.profilePictureURL, 75, false),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  user.fullName(),
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Text(
                                                    user.email,
                                                    style: const TextStyle(color: Colors.white),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            !themeChange.darkTheme ? const Icon(Icons.light_mode_sharp) : const Icon(Icons.nightlight),
                                            Switch(
                                              // thumb color (round icon)
                                              splashRadius: 50.0,
                                              // activeThumbImage: const AssetImage('https://lists.gnu.org/archive/html/emacs-devel/2015-10/pngR9b4lzUy39.png'),
                                              // inactiveThumbImage: const AssetImage('http://wolfrosch.com/_img/works/goodies/icon/vim@2x'),

                                              value: themeChange.darkTheme,
                                              onChanged: (value) => setState(() => themeChange.darkTheme = value),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: AppThemeData.primary300,
                                ),
                              );
                            }),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.Dashboard,
                                title: Text(
                                  'Dashboard',
                                  style: TextStyle(color: isDarkMode(context) ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  pushAndRemoveUntil(context, const ServiceListScreen());
                                },
                                leading: Image.asset(
                                  'assets/images/dashboard.png',
                                  color: _drawerSelection == DrawerSelection.Cuisines
                                      ? AppThemeData.primary300
                                      : isDarkMode(context)
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade600,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.Home,
                                title: Text(
                                  'Stores',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.Home
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _drawerSelection = DrawerSelection.Home;
                                    _appBarTitle = 'Stores'.tr();
                                    _currentWidget = HomeScreen(
                                      user: MyAppState.currentUser,
                                    );
                                  });
                                },
                                leading: const Icon(CupertinoIcons.home),
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                  selected: _drawerSelection == DrawerSelection.Cuisines,
                                  leading: Image.asset(
                                    'assets/images/category.png',
                                    color: _drawerSelection == DrawerSelection.Cuisines
                                        ? AppThemeData.primary300
                                        : isDarkMode(context)
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade600,
                                    width: 24,
                                    height: 24,
                                  ),
                                  title: Text(
                                    'Categories',
                                    style: TextStyle(
                                        color: _drawerSelection == DrawerSelection.Cuisines
                                            ? AppThemeData.primary300
                                            : isDarkMode(context)
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                        fontFamily: AppThemeData.medium),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _drawerSelection = DrawerSelection.Cuisines;
                                      _appBarTitle = 'Categories'.tr();
                                      _currentWidget = const CuisinesScreen();
                                    });
                                  }),
                            ),
                            Visibility(
                              visible: sectionConstantModel!.dineInActive!,
                              child: ListTileTheme(
                                style: ListTileStyle.drawer,
                                selectedColor: AppThemeData.primary300,
                                child: ListTile(
                                    selected: _drawerSelection == DrawerSelection.dineIn,
                                    leading: const Icon(Icons.restaurant),
                                    title: Text(
                                      'Dine-in',
                                      style: TextStyle(
                                          color: _drawerSelection == DrawerSelection.dineIn
                                              ? AppThemeData.primary300
                                              : isDarkMode(context)
                                                  ? AppThemeData.grey50
                                                  : AppThemeData.grey900,
                                          fontFamily: AppThemeData.medium),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);

                                      setState(() {
                                        _drawerSelection = DrawerSelection.dineIn;
                                        _appBarTitle = 'Dine-In'.tr();
                                        _currentWidget = DineInScreen(
                                          user: MyAppState.currentUser!,
                                        );
                                      });
                                    }),
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                  selected: _drawerSelection == DrawerSelection.Search,
                                  title: Text(
                                    'Search',
                                    style: TextStyle(
                                        color: _drawerSelection == DrawerSelection.Search
                                            ? AppThemeData.primary300
                                            : isDarkMode(context)
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                        fontFamily: AppThemeData.medium),
                                  ),
                                  leading: const Icon(Icons.search),
                                  onTap: () async {
                                    push(context, const SearchScreen());
                                    // Navigator.pop(context);
                                    // setState(() {
                                    //   _drawerSelection = DrawerSelection.Search;
                                    //   _appBarTitle = 'search'.tr();
                                    //   _currentWidget = SearchScreen();
                                    // });
                                    // await Future.delayed(const Duration(seconds: 1), () {
                                    //   setState(() {});
                                    // });
                                  }),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.LikedStore,
                                title: Text(
                                  'Favourite Stores',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.LikedStore
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (MyAppState.currentUser == null) {
                                    push(context, const LoginScreen());
                                  } else {
                                    setState(() {
                                      _drawerSelection = DrawerSelection.LikedStore;
                                      _appBarTitle = 'Favourite Stores'.tr();
                                      _currentWidget = const FavouriteStoreScreen();
                                    });
                                  }
                                },
                                leading: const Icon(CupertinoIcons.heart),
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.LikedProduct,
                                title: Text(
                                  'Favourite Item',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.LikedProduct
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (MyAppState.currentUser == null) {
                                    push(context, const LoginScreen());
                                  } else {
                                    setState(() {
                                      _drawerSelection = DrawerSelection.LikedProduct;
                                      _appBarTitle = 'Favourite Item'.tr();
                                      _currentWidget = const FavouriteItemScreen();
                                    });
                                  }
                                },
                                leading: const Icon(CupertinoIcons.heart),
                              ),
                            ),
                            Visibility(
                              visible: UserPreference.getWalletData() ?? false,
                              child: ListTileTheme(
                                style: ListTileStyle.drawer,
                                selectedColor: AppThemeData.primary300,
                                child: ListTile(
                                  selected: _drawerSelection == DrawerSelection.Wallet,
                                  leading: const Icon(Icons.account_balance_wallet_outlined),
                                  title: Text(
                                    'Wallet',
                                    style: TextStyle(
                                        color: _drawerSelection == DrawerSelection.Wallet
                                            ? AppThemeData.primary300
                                            : isDarkMode(context)
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                        fontFamily: AppThemeData.medium),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (MyAppState.currentUser == null) {
                                      push(context, const LoginScreen());
                                    } else {
                                      setState(() {
                                        _drawerSelection = DrawerSelection.Wallet;
                                        _appBarTitle = 'Wallet'.tr();
                                        _currentWidget = const WalletScreen();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.Cart,
                                leading: const Icon(CupertinoIcons.cart),
                                title: Text(
                                  'Cart',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.Cart
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (MyAppState.currentUser == null) {
                                    push(context, const LoginScreen());
                                  } else {
                                    setState(() {
                                      _drawerSelection = DrawerSelection.Cart;
                                      _appBarTitle = 'Your Cart'.tr();
                                      _currentWidget = const CartScreen();
                                    });
                                  }
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                  selected: _drawerSelection == DrawerSelection.giftCard,
                                  title: Text('Gift Card').tr(),
                                  leading: Icon(Icons.card_giftcard),
                                  onTap: () async {
                                    key.currentState!.openEndDrawer();
                                    push(context, const GiftCardScreen());
                                  }),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.referral,
                                leading: Image.asset(
                                  'assets/images/refer.png',
                                  width: 28,
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  'Refer a friend',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.referral
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () async {
                                  if (MyAppState.currentUser == null) {
                                    Navigator.pop(context);
                                    push(context, const LoginScreen());
                                  } else {
                                    Navigator.pop(context);
                                    push(context, const ReferralScreen());
                                  }
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.Profile,
                                leading: const Icon(CupertinoIcons.person),
                                title: Text(
                                  'My Profile',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.Profile
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (MyAppState.currentUser == null) {
                                    push(context, const LoginScreen());
                                  } else {
                                    setState(() {
                                      _drawerSelection = DrawerSelection.Profile;
                                      _appBarTitle = 'My Profile'.tr();
                                      _currentWidget = const ProfileScreen();
                                    });
                                  }
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.Orders,
                                leading: Image.asset(
                                  'assets/images/truck.png',
                                  color: _drawerSelection == DrawerSelection.Orders
                                      ? AppThemeData.primary300
                                      : isDarkMode(context)
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade600,
                                  width: 24,
                                  height: 24,
                                ),
                                title: Text(
                                  'Orders',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.Orders
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (MyAppState.currentUser == null) {
                                    push(context, const LoginScreen());
                                  } else {
                                    setState(() {
                                      _drawerSelection = DrawerSelection.Orders;
                                      _appBarTitle = 'Orders'.tr();
                                      _currentWidget = OrdersScreen();
                                    });
                                  }
                                },
                              ),
                            ),
                            Visibility(
                              visible: sectionConstantModel!.dineInActive!,
                              child: ListTileTheme(
                                style: ListTileStyle.drawer,
                                selectedColor: AppThemeData.primary300,
                                child: ListTile(
                                  selected: _drawerSelection == DrawerSelection.MyBooking,
                                  leading: Image.asset(
                                    'assets/images/your_booking.png',
                                    color: _drawerSelection == DrawerSelection.MyBooking
                                        ? AppThemeData.primary300
                                        : isDarkMode(context)
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade600,
                                    width: 24,
                                    height: 24,
                                  ),
                                  title: Text(
                                    'Dine-In Bookings',
                                    style: TextStyle(
                                        color: _drawerSelection == DrawerSelection.MyBooking
                                            ? AppThemeData.primary300
                                            : isDarkMode(context)
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                        fontFamily: AppThemeData.medium),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (MyAppState.currentUser == null) {
                                      push(context, const LoginScreen());
                                    } else {
                                      setState(() {
                                        _drawerSelection = DrawerSelection.MyBooking;
                                        _appBarTitle = 'Dine-In Bookings'.tr();
                                        _currentWidget = const MyBookingScreen();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.chooseLanguage,
                                leading: Icon(
                                  Icons.language,
                                  color: _drawerSelection == DrawerSelection.chooseLanguage
                                      ? AppThemeData.primary300
                                      : isDarkMode(context)
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade600,
                                ),
                                title: Text(
                                  'Language',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.chooseLanguage
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _drawerSelection = DrawerSelection.chooseLanguage;
                                    _appBarTitle = 'Language'.tr();
                                    _currentWidget = LanguageChooseScreen(
                                      isContainer: true,
                                    );
                                  });
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.termsCondition,
                                leading: const Icon(Icons.policy),
                                title: Text(
                                  'Terms and Condition',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.termsCondition
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () async {
                                  push(context, const TermsAndCondition());
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.privacyPolicy,
                                leading: const Icon(Icons.privacy_tip),
                                title: Text(
                                  'Privacy policy',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.privacyPolicy
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () async {
                                  push(context, const PrivacyPolicyScreen());
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.inbox,
                                leading: const Icon(CupertinoIcons.chat_bubble_2_fill),
                                title: Text(
                                  'Store Inbox',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.inbox
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  if (MyAppState.currentUser == null) {
                                    Navigator.pop(context);
                                    push(context, const LoginScreen());
                                  } else {
                                    Navigator.pop(context);
                                    setState(() {
                                      _drawerSelection = DrawerSelection.inbox;
                                      _appBarTitle = 'Store Inbox'.tr();
                                      _currentWidget = const InboxScreen();
                                    });
                                  }
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.driver,
                                leading: const Icon(CupertinoIcons.chat_bubble_2_fill),
                                title: Text(
                                  'Driver Inbox',
                                  style: TextStyle(
                                      color: _drawerSelection == DrawerSelection.driver
                                          ? AppThemeData.primary300
                                          : isDarkMode(context)
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                      fontFamily: AppThemeData.medium),
                                ),
                                onTap: () {
                                  if (MyAppState.currentUser == null) {
                                    Navigator.pop(context);
                                    push(context, const LoginScreen());
                                  } else {
                                    Navigator.pop(context);
                                    setState(() {
                                      _drawerSelection = DrawerSelection.driver;
                                      _appBarTitle = 'Driver Inbox'.tr();
                                      _currentWidget = const InboxDriverScreen();
                                    });
                                  }
                                },
                              ),
                            ),
                            ListTileTheme(
                              style: ListTileStyle.drawer,
                              selectedColor: AppThemeData.primary300,
                              child: ListTile(
                                selected: _drawerSelection == DrawerSelection.Logout,
                                leading: const Icon(Icons.logout),
                                title: Text((MyAppState.currentUser == null) ? 'Log In'.tr() : 'Log Out'.tr()),
                                onTap: () async {
                                  if (MyAppState.currentUser == null) {
                                    pushAndRemoveUntil(context, const LoginScreen());
                                  } else {
                                    ShowToastDialog.showLoader("Please wait");
                                    //MyAppState.currentUser!.active = false;
                                    MyAppState.currentUser!.lastOnlineTimestamp = Timestamp.now();
                                    MyAppState.currentUser!.fcmToken = "";
                                    await FireStoreUtils.updateCurrentUser(MyAppState.currentUser!);
                                    await auth.FirebaseAuth.instance.signOut();
                                    MyAppState.currentUser = null;
                                    Provider.of<CartDatabase>(context, listen: false).deleteAllProducts();
                                    pushAndRemoveUntil(context, const LoginScreen());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("V : $appVersion"),
                      )
                    ],
                  )),
            ),
            appBar: _drawerSelection == DrawerSelection.Home
                ? null
                : AppBar(
                    elevation: _drawerSelection == DrawerSelection.Wallet ? 0 : 0,
                    centerTitle: _drawerSelection == DrawerSelection.Wallet ? true : false,
                    backgroundColor: isDarkMode(context)
                        ? _drawerSelection == DrawerSelection.Home
                            ? Colors.black
                            : Colors.black
                        : _drawerSelection == DrawerSelection.Home
                            ? Colors.black
                            : Colors.white,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          key.currentState!.openDrawer();
                        },
                        child: ClipOval(
                          child: Container(
                            color: isDarkMode(context) ? AppThemeData.grey700 : AppThemeData.grey200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.menu),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // iconTheme: IconThemeData(color: Colors.blue),
                    title: Text(
                      _appBarTitle,
                      style: TextStyle(
                          fontSize: 18,
                          color: _drawerSelection == DrawerSelection.Wallet || _drawerSelection == DrawerSelection.Home
                              ? Colors.white
                              : isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                          //isDarkMode(context) ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    actions: _drawerSelection == DrawerSelection.Wallet || _drawerSelection == DrawerSelection.MyBooking
                        ? []
                        : _drawerSelection == DrawerSelection.dineIn
                            ? [
                                IconButton(
                                    padding: const EdgeInsets.only(right: 20),
                                    visualDensity: const VisualDensity(horizontal: -4),
                                    tooltip: 'QrCode'.tr(),
                                    icon: Image(
                                      image: const AssetImage("assets/images/qrscan.png"),
                                      width: 20,
                                      color: isDarkMode(context) || _drawerSelection == DrawerSelection.Home ? Colors.white : Colors.black,
                                    ),
                                    onPressed: () {
                                      push(context, const QrCodeScanner(presectionList: []));
                                    }),
                                IconButton(
                                    visualDensity: const VisualDensity(horizontal: -4),
                                    padding: const EdgeInsets.only(right: 10),
                                    icon: Image(
                                      image: const AssetImage("assets/images/search.png"),
                                      width: 20,
                                      color: isDarkMode(context) || _drawerSelection == DrawerSelection.Home ? Colors.white : null,
                                    ),
                                    onPressed: () {
                                      push(context, const SearchScreen());
                                    }),
                                if (_currentWidget is! CartScreen || _currentWidget is! ProfileScreen)
                                  IconButton(
                                    visualDensity: const VisualDensity(horizontal: -4),
                                    padding: const EdgeInsets.only(right: 10),
                                    icon: Image(
                                      image: const AssetImage("assets/images/map.png"),
                                      width: 20,
                                      color: isDarkMode(context) || _drawerSelection == DrawerSelection.Home ? Colors.white : const Color(0xFF333333),
                                    ),
                                    onPressed: () => push(
                                      context,
                                      const MapViewScreen(isShowAppBar: true),
                                    ),
                                  )
                              ]
                            : [
                                IconButton(
                                    visualDensity: const VisualDensity(horizontal: -4),
                                    padding: const EdgeInsets.only(right: 10),
                                    icon: Image(
                                      image: const AssetImage("assets/images/search.png"),
                                      width: 20,
                                      color: isDarkMode(context) || _drawerSelection == DrawerSelection.Home ? Colors.white : null,
                                    ),
                                    onPressed: () {
                                      push(context, const SearchScreen());
                                    }),
                                if (_currentWidget is! CartScreen || _currentWidget is! ProfileScreen)
                                  IconButton(
                                      padding: const EdgeInsets.only(right: 20),
                                      visualDensity: const VisualDensity(horizontal: -4),
                                      tooltip: 'Cart'.tr(),
                                      icon: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Image(
                                            image: const AssetImage("assets/images/cart.png"),
                                            width: 20,
                                            color: isDarkMode(context) || _drawerSelection == DrawerSelection.Home ? Colors.white : null,
                                          ),
                                          StreamBuilder<List<CartProduct>>(
                                            stream: cartDatabase.watchProducts,
                                            builder: (context, snapshot) {
                                              cartCount = 0;
                                              if (snapshot.hasData) {
                                                for (var element in snapshot.data!) {
                                                  cartCount += element.quantity;
                                                }
                                              }
                                              return Visibility(
                                                visible: cartCount >= 1,
                                                child: Positioned(
                                                  right: -6,
                                                  top: -8,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppThemeData.primary300,
                                                    ),
                                                    constraints: const BoxConstraints(
                                                      minWidth: 12,
                                                      minHeight: 12,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        cartCount <= 99 ? '$cartCount' : '+99',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          // fontSize: 10,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        if (MyAppState.currentUser == null) {
                                          push(context, const LoginScreen());
                                        } else {
                                          setState(() {
                                            _drawerSelection = DrawerSelection.Cart;
                                            _appBarTitle = 'Your Cart'.tr();
                                            _currentWidget = const CartScreen();
                                          });
                                        }
                                      }),
                              ],
                  ),
            body: _currentWidget,
          );
        }),
      ),
    );
  }

// Widget _buildSearchField() => TextField(
//       controller: searchController,
//       onChanged: _searchScreenStateKey.currentState == null
//           ? (str) {
//               setState(() {});
//             }
//           : _searchScreenStateKey.currentState!.onSearchTextChanged,
//       textInputAction: TextInputAction.search,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.all(10),
//         isDense: true,
//         fillColor: isDarkMode(context) ? Colors.grey[700] : Colors.grey[200],
//         filled: true,
//         prefixIcon: const Icon(
//           CupertinoIcons.search,
//           color: Colors.black,
//         ),
//         suffixIcon: IconButton(
//             icon: const Icon(
//               CupertinoIcons.clear,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               setState(() {
//                 _searchScreenStateKey.currentState?.clearSearchQuery();
//               });
//             }),
//         focusedBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(10),
//             ),
//             borderSide: BorderSide(style: BorderStyle.none)),
//         enabledBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(10),
//             ),
//             borderSide: BorderSide(style: BorderStyle.none)),
//         hintText: tr('Search'),
//       ),
//     );
}
