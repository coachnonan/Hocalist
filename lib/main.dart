import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'components/ui_components.dart';
part 'features/screens.dart';
part 'theme/hocalist_theme.dart';

void main() {
  runApp(const HocalistApp());
}

class HocalistApp extends StatelessWidget {
  const HocalistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HocalistPrototype();
  }
}

enum UserRole { buyer, seller }

enum AppTextSize {
  medium('Medium', 1.0),
  large('Large', 1.15),
  extraLarge('Extra large', 1.3);

  const AppTextSize(this.label, this.scale);

  final String label;
  final double scale;
}

enum AppPage {
  welcome,
  chooseRole,
  buyerSignup,
  buyerBenefits,
  buyerProfile,
  buyerDashboard,
  hocatrends,
  hocatrendsSellers,
  recentActivity,
  createRequest,
  requestSuccess,
  buyerRequestDetail,
  offersReceived,
  sellerPublicProfile,
  buyerChats,
  buyerChat,
  finalizeDeal,
  meetingDetails,
  buyerConfirmation,
  dealRecovery,
  buyerReview,
  buyerWallet,
  buyerRewardsDetail,
  withdrawal,
  supportReviewStatus,
  buyerSupport,
  notifications,
  savedItems,
  safetyGuide,
  reportIssue,
  helpSupport,
  buyerSettings,
  editProfile,
  sellerSignup,
  sellerProfileSetup,
  sellerVerification,
  sellerDashboard,
  marketplace,
  sellerRequestDetail,
  sendOffer,
  offerSuccess,
  sellerOfferHistory,
  sellerOfferDetail,
  sellerChat,
  sellerBilling,
  sellerPaymentMethod,
  sellerNotifications,
  sellerProfile,
}

class HocalistPrototype extends StatefulWidget {
  const HocalistPrototype({super.key});

  @override
  State<HocalistPrototype> createState() => _HocalistPrototypeState();
}

class _HocalistPrototypeState extends State<HocalistPrototype> {
  static const _storage = _LocalSessionStore();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  UserRole role = UserRole.buyer;
  AppPage page = AppPage.welcome;
  final history = <AppPage>[];

  String buyerName = 'Maya Chen';
  String sellerName = 'Northside Tech';
  String requestTitle = 'iPad Air, 5th gen or newer';
  String requestBudget = '\$350 - \$480';
  String offerPrice = '\$420';
  bool requestPosted = false;
  bool sellerOfferSent = false;
  bool offerSelected = false;
  bool meetingConfirmed = false;
  bool dealFailed = false;
  bool requestReopened = false;
  bool dealCompleted = false;
  bool withdrawalRequested = false;
  bool reportSubmitted = false;
  bool darkMode = false;
  AppTextSize textSize = AppTextSize.medium;
  bool restoredSession = false;

  Color get roleAccent => role == UserRole.buyer
      ? darkMode
            ? HocalistTheme.darkBuyer
            : HocalistTheme.buyer
      : darkMode
      ? HocalistTheme.darkSeller
      : HocalistTheme.seller;
  Color get accent =>
      darkMode ? HocalistTheme.darkPrimary : HocalistTheme.primary;
  bool get publicHocatrends =>
      page == AppPage.hocatrends &&
      history.isNotEmpty &&
      history.last == AppPage.welcome;
  bool get signedIn =>
      !publicHocatrends &&
      !{
        AppPage.welcome,
        AppPage.chooseRole,
        AppPage.buyerSignup,
        AppPage.buyerBenefits,
        AppPage.sellerSignup,
      }.contains(page);
  bool get showGlobalBack =>
      signedIn && history.isNotEmpty && !_isBottomNavPage(page);

  List<_NavItem> get _buyerBottomNavItems => const [
    _NavItem(
      'Home',
      Icons.home_outlined,
      AppPage.buyerDashboard,
      selectedIcon: Icons.home,
      asset: 'assets/buyer_nav/buyer-nav-home.png',
    ),
    _NavItem(
      'Hocatrends',
      Icons.local_fire_department,
      AppPage.hocatrends,
      asset: 'assets/buyer_nav/buyer-nav-hocatrends.png',
    ),
    _NavItem(
      'Offers',
      Icons.sell_outlined,
      AppPage.offersReceived,
      asset: 'assets/buyer_nav/buyer-nav-offers.png',
    ),
    _NavItem(
      'Chats',
      Icons.chat_bubble_outline,
      AppPage.buyerChats,
      asset: 'assets/buyer_nav/buyer-nav-chats.png',
    ),
    _NavItem(
      'More',
      Icons.menu,
      AppPage.buyerSupport,
      asset: 'assets/buyer_nav/buyer-nav-more.png',
    ),
  ];

  List<_NavItem> get _sellerBottomNavItems => const [
    _NavItem('Home', Icons.home_outlined, AppPage.sellerDashboard),
    _NavItem('Browse', Icons.travel_explore_outlined, AppPage.marketplace),
    _NavItem('Offers', Icons.receipt_long_outlined, AppPage.sellerOfferHistory),
    _NavItem('Tools', Icons.storefront_outlined, AppPage.sellerBilling),
    _NavItem('Profile', Icons.storefront_outlined, AppPage.sellerProfile),
  ];

  bool _isBottomNavPage(AppPage target) {
    final items = role == UserRole.buyer
        ? _buyerBottomNavItems
        : _sellerBottomNavItems;
    return items.any((item) => item.page == target);
  }

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final data = await _storage.load();
    if (!mounted || data == null) return;
    setState(() {
      role = data.role;
      page = data.page;
      buyerName = data.buyerName;
      sellerName = data.sellerName;
      requestTitle = data.requestTitle;
      requestBudget = data.requestBudget;
      offerPrice = data.offerPrice;
      requestPosted = data.requestPosted;
      sellerOfferSent = data.sellerOfferSent;
      offerSelected = data.offerSelected;
      meetingConfirmed = data.meetingConfirmed;
      dealFailed = data.dealFailed;
      requestReopened = data.requestReopened;
      dealCompleted = data.dealCompleted;
      withdrawalRequested = data.withdrawalRequested;
      reportSubmitted = data.reportSubmitted;
      darkMode = data.darkMode;
      textSize = data.textSize;
      restoredSession = true;
    });
  }

  Future<void> _saveSession() {
    return _storage.save(
      _LocalSessionData(
        role: role,
        page: page,
        buyerName: buyerName,
        sellerName: sellerName,
        requestTitle: requestTitle,
        requestBudget: requestBudget,
        offerPrice: offerPrice,
        requestPosted: requestPosted,
        sellerOfferSent: sellerOfferSent,
        offerSelected: offerSelected,
        meetingConfirmed: meetingConfirmed,
        dealFailed: dealFailed,
        requestReopened: requestReopened,
        dealCompleted: dealCompleted,
        withdrawalRequested: withdrawalRequested,
        reportSubmitted: reportSubmitted,
        darkMode: darkMode,
        textSize: textSize,
      ),
    );
  }

  void showMessage(String message) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void updateThemeMode(bool value) {
    setState(() => darkMode = value);
    _saveSession();
    showMessage(value ? 'Dark mode enabled.' : 'Light mode enabled.');
  }

  void updateTextSize(AppTextSize value) {
    setState(() => textSize = value);
    _saveSession();
    showMessage('Text size set to ${value.label}.');
  }

  void go(AppPage next) {
    setState(() {
      history.add(page);
      page = next;
    });
    _saveSession();
  }

  void commit({
    required AppPage next,
    required String message,
    VoidCallback? update,
    bool resetHistory = false,
  }) {
    setState(() {
      update?.call();
      if (resetHistory) {
        history.clear();
      } else {
        history.add(page);
      }
      page = next;
    });
    _saveSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showMessage(message);
    });
  }

  void resetTo(AppPage next) {
    setState(() {
      history.clear();
      page = next;
    });
    _saveSession();
  }

  void submitBuyerRequest() {
    setState(() {
      requestPosted = true;
      history.clear();
      page = AppPage.buyerDashboard;
    });
    _saveSession();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showMessage('Request posted. You are back home.');
    });
  }

  void back() {
    if (history.isEmpty) return;
    setState(() => page = history.removeLast());
    _saveSession();
  }

  void updateBuyerName(String value) {
    setState(() => buyerName = value);
    _saveSession();
  }

  void updateSellerName(String value) {
    setState(() => sellerName = value);
    _saveSession();
  }

  void updateRequestTitle(String value) {
    setState(() => requestTitle = value);
    _saveSession();
  }

  void updateRequestBudget(String value) {
    setState(() => requestBudget = value);
    _saveSession();
  }

  void updateOfferPrice(String value) {
    setState(() => offerPrice = value);
    _saveSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hocalist',
      debugShowCheckedModeBanner: false,
      theme: HocalistTheme.light,
      darkTheme: HocalistTheme.dark,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      scaffoldMessengerKey: messengerKey,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final phoneScale = media.textScaler.scale(1);
        final effectiveScale = (phoneScale * textSize.scale).clamp(1.0, 1.6);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(effectiveScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Scaffold(
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: page == AppPage.welcome
                ? WelcomePageFrame(key: ValueKey(page), child: currentPage())
                : page == AppPage.buyerBenefits
                ? KeyedSubtree(key: ValueKey(page), child: currentPage())
                : {AppPage.buyerSignup, AppPage.sellerSignup}.contains(page)
                ? AuthPageFrame(key: ValueKey(page), child: currentPage())
                : AppFrame(
                    key: ValueKey(page),
                    compactBottom: page == AppPage.buyerDashboard,
                    header: signedIn
                        ? HocalistGlobalHeader(
                            role: role,
                            accent: roleAccent,
                            showSavedIndicator: restoredSession,
                            onNotifications: () => go(
                              role == UserRole.seller
                                  ? AppPage.sellerNotifications
                                  : AppPage.notifications,
                            ),
                          )
                        : null,
                    child: _TitleBackScope(
                      onBack: showGlobalBack ? back : null,
                      child: currentPage(),
                    ),
                  ),
          ),
        ),
        bottomNavigationBar: signedIn
            ? bottomNav()
            : {AppPage.welcome, AppPage.hocatrends}.contains(page)
            ? NoAccountHomeNavigation(
                selectedIndex: page == AppPage.hocatrends ? 1 : 0,
                onHome: () => resetTo(AppPage.welcome),
                onTrends: () => go(AppPage.hocatrends),
                onWinners: () => showMessage('Winners preview is coming soon.'),
                onSignup: () {
                  role = UserRole.buyer;
                  go(AppPage.buyerSignup);
                },
              )
            : null,
      ),
    );
  }

  Widget currentPage() {
    switch (page) {
      case AppPage.welcome:
        return WelcomePage(
          onStart: () {
            role = UserRole.buyer;
            go(AppPage.buyerSignup);
          },
          onBuyer: () {
            role = UserRole.buyer;
            go(AppPage.buyerSignup);
          },
          onSeller: () {
            role = UserRole.seller;
            go(AppPage.sellerSignup);
          },
        );
      case AppPage.chooseRole:
        return ChooseRolePage(
          onBuyer: () {
            role = UserRole.buyer;
            go(AppPage.buyerSignup);
          },
          onSeller: () {
            role = UserRole.seller;
            go(AppPage.sellerSignup);
          },
        );
      case AppPage.buyerSignup:
        return AccountAccessPage(
          role: UserRole.buyer,
          name: buyerName,
          onNameChanged: updateBuyerName,
          onRoleChanged: (nextRole) {
            setState(() => role = nextRole);
            resetTo(
              nextRole == UserRole.buyer
                  ? AppPage.buyerSignup
                  : AppPage.sellerSignup,
            );
          },
          onClose: () => resetTo(AppPage.welcome),
          onSignup: () => go(AppPage.buyerBenefits),
          onLogin: () => resetTo(AppPage.buyerDashboard),
        );
      case AppPage.buyerBenefits:
        return BuyerBenefitOnboardingPage(
          name: buyerName,
          onClose: () => resetTo(AppPage.welcome),
          onFinish: () => resetTo(AppPage.buyerDashboard),
        );
      case AppPage.buyerProfile:
        return FormStepPage(
          accent: accent,
          title: 'Set up buyer profile',
          subtitle: 'These details make local offers more relevant.',
          fields: const [
            MockFieldData('Primary city', 'Chicago, IL'),
            MockFieldData('Preferred pickup distance', 'Within 12 miles'),
            MockFieldData(
              'Notification preference',
              'Offer updates and meeting reminders',
            ),
          ],
          primaryLabel: 'Go to buyer dashboard',
          onPrimary: () => resetTo(AppPage.buyerDashboard),
        );
      case AppPage.buyerDashboard:
        return BuyerDashboard(
          name: buyerName,
          accent: accent,
          requestTitle: requestTitle,
          requestBudget: requestBudget,
          requestPosted: requestPosted,
          offerSelected: offerSelected,
          meetingConfirmed: meetingConfirmed,
          dealFailed: dealFailed,
          requestReopened: requestReopened,
          dealCompleted: dealCompleted,
          withdrawalRequested: withdrawalRequested,
          restoredSession: restoredSession,
          onCreate: () => go(AppPage.createRequest),
          onRequestDetails: () => go(AppPage.buyerRequestDetail),
          onOffers: () => go(AppPage.offersReceived),
          onRecentActivity: () => go(AppPage.recentActivity),
          onWallet: () => go(AppPage.buyerRewardsDetail),
        );
      case AppPage.recentActivity:
        return RecentActivityPage(onBack: back);
      case AppPage.hocatrends:
        return HocatrendsPage(
          accent: accent,
          onSeeSellers: () => go(AppPage.hocatrendsSellers),
        );
      case AppPage.hocatrendsSellers:
        return HocatrendsSellersPage(
          onBack: back,
          onChatSeller: () => go(AppPage.buyerChat),
        );
      case AppPage.createRequest:
        return CreateRequestPage(
          accent: accent,
          requestTitle: requestTitle,
          budget: requestBudget,
          onTitleChanged: updateRequestTitle,
          onBudgetChanged: updateRequestBudget,
          onBack: back,
          onNotifications: () => go(AppPage.notifications),
          onSubmit: submitBuyerRequest,
        );
      case AppPage.requestSuccess:
        return ResultPage(
          accent: accent,
          icon: Icons.check_circle_outline,
          title: 'Request posted',
          body:
              'Sellers nearby can now send offers. You can review the request or wait for new offer alerts.',
          primaryLabel: 'View request',
          onPrimary: () => go(AppPage.buyerRequestDetail),
          secondaryLabel: 'Back to dashboard',
          onSecondary: () => resetTo(AppPage.buyerDashboard),
        );
      case AppPage.buyerRequestDetail:
        return BuyerRequestDetailPage(
          accent: accent,
          requestTitle: requestTitle,
          budget: requestBudget,
          onBack: back,
          onNotifications: () => go(AppPage.notifications),
          onOffers: () => go(AppPage.offersReceived),
        );
      case AppPage.offersReceived:
        return OffersPage(
          accent: accent,
          requestPosted: requestPosted,
          offerSelected: offerSelected,
          onBack: back,
          onNotifications: () => go(AppPage.notifications),
          onProfile: () => go(AppPage.sellerPublicProfile),
          onChat: () => commit(
            next: AppPage.buyerChat,
            message: 'Seller selected. Chatroom opened.',
            update: () => offerSelected = true,
          ),
          onSelect: () => commit(
            next: AppPage.buyerChat,
            message: 'Seller selected. Chatroom opened.',
            update: () => offerSelected = true,
          ),
        );
      case AppPage.sellerPublicProfile:
        return SellerPublicProfilePage(
          accent: accent,
          onBack: back,
          onSelect: () => commit(
            next: AppPage.buyerChat,
            message: 'Seller selected. Chatroom opened.',
            update: () => offerSelected = true,
          ),
        );
      case AppPage.buyerChats:
        return BuyerChatsPage(
          onBack: back,
          onOpenChat: () => go(AppPage.buyerChat),
          onOffers: () => go(AppPage.offersReceived),
        );
      case AppPage.buyerChat:
        return ChatPage(
          accent: accent,
          title: 'Chat with Northside Tech',
          body:
              'Chat opens after you select a seller. Confirm item details and meeting expectations here.',
          onBack: back,
          onPrimary: () => commit(
            next: AppPage.finalizeDeal,
            message: 'Meetup accepted. Add public meeting details next.',
            update: () => offerSelected = true,
          ),
          primaryLabel: 'Accept to meet',
          onReport: () => go(AppPage.reportIssue),
        );
      case AppPage.finalizeDeal:
        return FinalizeDealPage(
          accent: accent,
          price: offerPrice,
          onContinue: () => go(AppPage.meetingDetails),
        );
      case AppPage.meetingDetails:
        return MeetingDetailsPage(
          accent: accent,
          onContinue: () => commit(
            next: AppPage.buyerConfirmation,
            message: 'Meeting details saved for both sides.',
            update: () => meetingConfirmed = true,
          ),
        );
      case AppPage.buyerConfirmation:
        return BuyerConfirmationPage(
          accent: accent,
          onReview: () => commit(
            next: AppPage.buyerReview,
            message: 'Deal marked completed. Review is ready.',
            update: () {
              dealCompleted = true;
              dealFailed = false;
            },
          ),
          onDealIssue: () => go(AppPage.dealRecovery),
          onReport: () => go(AppPage.reportIssue),
        );
      case AppPage.dealRecovery:
        return DealRecoveryPage(
          accent: accent,
          onReopen: () => commit(
            next: AppPage.buyerRequestDetail,
            message: 'Request reopened. Backup offers are available.',
            update: () {
              offerSelected = false;
              meetingConfirmed = false;
              dealFailed = true;
              requestReopened = true;
            },
          ),
          onBackup: () => commit(
            next: AppPage.offersReceived,
            message: 'Backup offers restored for comparison.',
            update: () {
              offerSelected = false;
              meetingConfirmed = false;
              dealFailed = true;
              requestReopened = true;
            },
          ),
          onReport: () => go(AppPage.reportIssue),
        );
      case AppPage.buyerReview:
        return BuyerReviewPage(
          accent: accent,
          onFinish: () => resetTo(AppPage.buyerWallet),
        );
      case AppPage.buyerWallet:
        return BuyerWalletPage(
          accent: accent,
          dealCompleted: dealCompleted,
          dealFailed: dealFailed,
          requestReopened: requestReopened,
          withdrawalRequested: withdrawalRequested,
          onWithdraw: () => go(AppPage.withdrawal),
        );
      case AppPage.buyerRewardsDetail:
        return BuyerRewardsDetailPage(
          accent: accent,
          onWallet: () => go(AppPage.buyerWallet),
        );
      case AppPage.withdrawal:
        return WithdrawalPage(
          accent: accent,
          onSubmit: () => commit(
            next: AppPage.supportReviewStatus,
            message: 'Support note queued for review.',
            update: () => withdrawalRequested = true,
            resetHistory: true,
          ),
        );
      case AppPage.supportReviewStatus:
        return BuyerSupportStatusPage(
          accent: accent,
          onWallet: () => go(AppPage.buyerWallet),
        );
      case AppPage.buyerSupport:
        return SupportPage(
          accent: accent,
          onNotifications: () => go(AppPage.notifications),
          onSaved: () => go(AppPage.savedItems),
          onSafety: () => go(AppPage.safetyGuide),
          onReport: () => go(AppPage.reportIssue),
          onHelp: () => go(AppPage.helpSupport),
          onEditProfile: () => go(AppPage.editProfile),
          onSettings: () => go(AppPage.buyerSettings),
          onLogout: () => resetTo(AppPage.welcome),
        );
      case AppPage.notifications:
        return NotificationsPage(
          accent: accent,
          sellerMode: false,
          requestPosted: requestPosted,
          sellerOfferSent: sellerOfferSent,
          offerSelected: offerSelected,
          meetingConfirmed: meetingConfirmed,
          dealCompleted: dealCompleted,
          withdrawalRequested: withdrawalRequested,
          reportSubmitted: reportSubmitted,
        );
      case AppPage.savedItems:
        return SavedItemsPage(accent: accent);
      case AppPage.safetyGuide:
        return SafetyGuidePage(accent: accent);
      case AppPage.reportIssue:
        return ReportIssuePage(
          accent: accent,
          submitted: reportSubmitted,
          onSubmit: () => commit(
            next: AppPage.reportIssue,
            message: 'Report submitted to the demo admin queue.',
            update: () => reportSubmitted = true,
            resetHistory: true,
          ),
        );
      case AppPage.helpSupport:
        return HelpSupportPage(accent: accent);
      case AppPage.buyerSettings:
        return SettingsPage(
          accent: accent,
          role: role,
          darkMode: darkMode,
          textSize: textSize,
          onEditProfile: () => go(AppPage.editProfile),
          onThemeChanged: updateThemeMode,
          onTextSizeChanged: updateTextSize,
        );
      case AppPage.editProfile:
        return ProfileEditPage(
          accent: accent,
          role: role,
          name: role == UserRole.buyer ? buyerName : sellerName,
          onNameChanged: role == UserRole.buyer
              ? updateBuyerName
              : updateSellerName,
          onDone: () => resetTo(
            role == UserRole.buyer
                ? AppPage.buyerSettings
                : AppPage.sellerProfile,
          ),
        );
      case AppPage.sellerSignup:
        return AccountAccessPage(
          role: UserRole.seller,
          name: sellerName,
          onNameChanged: updateSellerName,
          onRoleChanged: (nextRole) {
            setState(() => role = nextRole);
            resetTo(
              nextRole == UserRole.buyer
                  ? AppPage.buyerSignup
                  : AppPage.sellerSignup,
            );
          },
          onClose: () => resetTo(AppPage.welcome),
          onSignup: () => go(AppPage.sellerProfileSetup),
          onLogin: () => resetTo(AppPage.sellerDashboard),
        );
      case AppPage.sellerProfileSetup:
        return FormStepPage(
          accent: accent,
          title: 'Set up seller profile',
          subtitle: 'Your profile helps buyers trust your offers.',
          fields: const [
            MockFieldData(
              'Business category',
              'Electronics, tablets, accessories',
            ),
            MockFieldData('Service radius', '15 miles'),
            MockFieldData(
              'Pickup availability',
              'Weekdays and Saturday afternoon',
            ),
          ],
          primaryLabel: 'Start verification',
          onPrimary: () => go(AppPage.sellerVerification),
        );
      case AppPage.sellerVerification:
        return SellerVerificationPage(
          accent: accent,
          onFinish: () => resetTo(AppPage.sellerDashboard),
        );
      case AppPage.sellerDashboard:
        return SellerDashboard(
          sellerName: sellerName,
          accent: accent,
          sellerOfferSent: sellerOfferSent,
          offerSelected: offerSelected,
          meetingConfirmed: meetingConfirmed,
          restoredSession: restoredSession,
          onBrowse: () => go(AppPage.marketplace),
          onBilling: () => go(AppPage.sellerBilling),
          onHistory: () => go(AppPage.sellerOfferHistory),
        );
      case AppPage.marketplace:
        return MarketplacePage(
          accent: accent,
          onOpen: () => go(AppPage.sellerRequestDetail),
        );
      case AppPage.sellerRequestDetail:
        return SellerRequestDetailPage(
          accent: accent,
          onOffer: () => go(AppPage.sendOffer),
        );
      case AppPage.sendOffer:
        return SendOfferPage(
          accent: accent,
          price: offerPrice,
          onPriceChanged: updateOfferPrice,
          onSubmit: () => commit(
            next: AppPage.offerSuccess,
            message: 'Offer saved on this device.',
            update: () => sellerOfferSent = true,
          ),
        );
      case AppPage.offerSuccess:
        return ResultPage(
          accent: accent,
          icon: Icons.outgoing_mail,
          title: 'Offer sent',
          body:
              'The buyer can now compare your offer and choose whether to open chat.',
          primaryLabel: 'View offer',
          onPrimary: () => go(AppPage.sellerOfferDetail),
          secondaryLabel: 'Offer history',
          onSecondary: () => resetTo(AppPage.sellerOfferHistory),
        );
      case AppPage.sellerOfferHistory:
        return SellerOfferHistoryPage(
          accent: accent,
          sellerOfferSent: sellerOfferSent,
          offerSelected: offerSelected,
          onOpen: () => go(AppPage.sellerOfferDetail),
        );
      case AppPage.sellerOfferDetail:
        return SellerOfferDetailPage(
          accent: accent,
          onChat: () => go(AppPage.sellerChat),
        );
      case AppPage.sellerChat:
        return ChatPage(
          accent: accent,
          title: 'Chat with Maya',
          body:
              'The buyer selected your offer. Confirm meeting details before handing over the item.',
          onBack: back,
          onPrimary: () => go(AppPage.finalizeDeal),
          primaryLabel: 'Review deal details',
        );
      case AppPage.sellerBilling:
        return SellerBillingPage(
          accent: accent,
          onPayment: () => go(AppPage.sellerPaymentMethod),
        );
      case AppPage.sellerPaymentMethod:
        return SellerPaymentPage(
          accent: accent,
          onDone: () => resetTo(AppPage.sellerBilling),
        );
      case AppPage.sellerNotifications:
        return NotificationsPage(
          accent: accent,
          sellerMode: true,
          requestPosted: requestPosted,
          sellerOfferSent: sellerOfferSent,
          offerSelected: offerSelected,
          meetingConfirmed: meetingConfirmed,
          dealCompleted: dealCompleted,
          withdrawalRequested: withdrawalRequested,
          reportSubmitted: reportSubmitted,
        );
      case AppPage.sellerProfile:
        return SellerProfilePage(
          accent: accent,
          onNotifications: () => go(AppPage.sellerNotifications),
          onSafety: () => go(AppPage.safetyGuide),
          onHelp: () => go(AppPage.helpSupport),
          onEditProfile: () => go(AppPage.editProfile),
          onSettings: () => go(AppPage.buyerSettings),
          onLogout: () => resetTo(AppPage.welcome),
        );
    }
  }

  Widget bottomNav() {
    final items = role == UserRole.buyer
        ? _buyerBottomNavItems
        : _sellerBottomNavItems;
    final selected = role == UserRole.buyer
        ? _buyerSelectedNavIndex(page, items)
        : items.indexWhere((item) => item.page == page);

    if (role == UserRole.buyer) {
      return _BuyerBottomNavigation(
        items: items,
        selectedIndex: selected < 0 ? 0 : selected,
        onSelected: (index) => resetTo(items[index].page),
      );
    }

    return NavigationBar(
      selectedIndex: selected < 0 ? 0 : selected,
      indicatorColor: HocalistTheme.primary.withValues(alpha: 0.13),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 72,
      onDestinationSelected: (index) => resetTo(items[index].page),
      destinations: items.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon, size: 28, color: HocalistTheme.muted),
          selectedIcon: Icon(
            item.selectedIcon ?? item.icon,
            size: 30,
            color: HocalistTheme.primary,
          ),
          label: item.label,
        );
      }).toList(),
    );
  }

  int _buyerSelectedNavIndex(AppPage page, List<_NavItem> items) {
    if ({AppPage.createRequest, AppPage.recentActivity}.contains(page)) {
      return 0;
    }
    if (page == AppPage.hocatrendsSellers) {
      return items.indexWhere((item) => item.page == AppPage.hocatrends);
    }
    if ({
      AppPage.buyerChat,
      AppPage.finalizeDeal,
      AppPage.meetingDetails,
      AppPage.buyerConfirmation,
      AppPage.dealRecovery,
    }.contains(page)) {
      return items.indexWhere((item) => item.page == AppPage.buyerChats);
    }
    if ({
      AppPage.buyerSupport,
      AppPage.buyerSettings,
      AppPage.editProfile,
      AppPage.buyerWallet,
      AppPage.buyerRewardsDetail,
      AppPage.withdrawal,
      AppPage.supportReviewStatus,
      AppPage.notifications,
      AppPage.savedItems,
      AppPage.safetyGuide,
      AppPage.reportIssue,
      AppPage.helpSupport,
    }.contains(page)) {
      return items.indexWhere((item) => item.page == AppPage.buyerSupport);
    }
    return items.indexWhere((item) => item.page == page);
  }
}

class _BuyerBottomNavigation extends StatelessWidget {
  const _BuyerBottomNavigation({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: HocalistTheme.primary.withValues(alpha: 0.08)),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: _BuyerBottomNavItem(
                  item: items[index],
                  selected: index == selectedIndex,
                  onTap: () => onSelected(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BuyerBottomNavItem extends StatelessWidget {
  const _BuyerBottomNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? HocalistTheme.primary : HocalistTheme.muted;
    return InkWell(
      onTap: onTap,
      child: Semantics(
        selected: selected,
        label: item.label,
        button: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: selected ? 60 : 46,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? HocalistTheme.roleSurface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: item.asset == null
                    ? Icon(
                        selected ? item.selectedIcon ?? item.icon : item.icon,
                        size: selected ? 25 : 23,
                        color: color,
                      )
                    : ImageIcon(
                        AssetImage(item.asset!),
                        size: selected ? 25 : 23,
                        color: color,
                      ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 18,
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected
                          ? HocalistTheme.primary
                          : HocalistTheme.muted,
                      fontSize: HocalistTheme.smallSize,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalSessionData {
  const _LocalSessionData({
    required this.role,
    required this.page,
    required this.buyerName,
    required this.sellerName,
    required this.requestTitle,
    required this.requestBudget,
    required this.offerPrice,
    required this.requestPosted,
    required this.sellerOfferSent,
    required this.offerSelected,
    required this.meetingConfirmed,
    required this.dealFailed,
    required this.requestReopened,
    required this.dealCompleted,
    required this.withdrawalRequested,
    required this.reportSubmitted,
    required this.darkMode,
    required this.textSize,
  });

  final UserRole role;
  final AppPage page;
  final String buyerName;
  final String sellerName;
  final String requestTitle;
  final String requestBudget;
  final String offerPrice;
  final bool requestPosted;
  final bool sellerOfferSent;
  final bool offerSelected;
  final bool meetingConfirmed;
  final bool dealFailed;
  final bool requestReopened;
  final bool dealCompleted;
  final bool withdrawalRequested;
  final bool reportSubmitted;
  final bool darkMode;
  final AppTextSize textSize;
}

class _LocalSessionStore {
  const _LocalSessionStore();

  static const _hasSession = 'hocalist.hasSession';
  static const _role = 'hocalist.role';
  static const _page = 'hocalist.page';
  static const _buyerName = 'hocalist.buyerName';
  static const _sellerName = 'hocalist.sellerName';
  static const _requestTitle = 'hocalist.requestTitle';
  static const _requestBudget = 'hocalist.requestBudget';
  static const _offerPrice = 'hocalist.offerPrice';
  static const _requestPosted = 'hocalist.requestPosted';
  static const _sellerOfferSent = 'hocalist.sellerOfferSent';
  static const _offerSelected = 'hocalist.offerSelected';
  static const _meetingConfirmed = 'hocalist.meetingConfirmed';
  static const _dealFailed = 'hocalist.dealFailed';
  static const _requestReopened = 'hocalist.requestReopened';
  static const _dealCompleted = 'hocalist.dealCompleted';
  static const _withdrawalRequested = 'hocalist.withdrawalRequested';
  static const _reportSubmitted = 'hocalist.reportSubmitted';
  static const _darkMode = 'hocalist.darkMode';
  static const _textSize = 'hocalist.textSize';

  Future<_LocalSessionData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_hasSession) ?? false)) return null;
    return _LocalSessionData(
      role: _parseRole(prefs.getString(_role)),
      page: _parsePage(prefs.getString(_page)),
      buyerName: prefs.getString(_buyerName) ?? 'Maya Chen',
      sellerName: prefs.getString(_sellerName) ?? 'Northside Tech',
      requestTitle:
          prefs.getString(_requestTitle) ?? 'iPad Air, 5th gen or newer',
      requestBudget: prefs.getString(_requestBudget) ?? '\$350 - \$480',
      offerPrice: prefs.getString(_offerPrice) ?? '\$420',
      requestPosted: prefs.getBool(_requestPosted) ?? false,
      sellerOfferSent: prefs.getBool(_sellerOfferSent) ?? false,
      offerSelected: prefs.getBool(_offerSelected) ?? false,
      meetingConfirmed: prefs.getBool(_meetingConfirmed) ?? false,
      dealFailed: prefs.getBool(_dealFailed) ?? false,
      requestReopened: prefs.getBool(_requestReopened) ?? false,
      dealCompleted: prefs.getBool(_dealCompleted) ?? false,
      withdrawalRequested: prefs.getBool(_withdrawalRequested) ?? false,
      reportSubmitted: prefs.getBool(_reportSubmitted) ?? false,
      darkMode: prefs.getBool(_darkMode) ?? false,
      textSize: _parseTextSize(prefs.getString(_textSize)),
    );
  }

  Future<void> save(_LocalSessionData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSession, true);
    await prefs.setString(_role, data.role.name);
    await prefs.setString(_page, data.page.name);
    await prefs.setString(_buyerName, data.buyerName);
    await prefs.setString(_sellerName, data.sellerName);
    await prefs.setString(_requestTitle, data.requestTitle);
    await prefs.setString(_requestBudget, data.requestBudget);
    await prefs.setString(_offerPrice, data.offerPrice);
    await prefs.setBool(_requestPosted, data.requestPosted);
    await prefs.setBool(_sellerOfferSent, data.sellerOfferSent);
    await prefs.setBool(_offerSelected, data.offerSelected);
    await prefs.setBool(_meetingConfirmed, data.meetingConfirmed);
    await prefs.setBool(_dealFailed, data.dealFailed);
    await prefs.setBool(_requestReopened, data.requestReopened);
    await prefs.setBool(_dealCompleted, data.dealCompleted);
    await prefs.setBool(_withdrawalRequested, data.withdrawalRequested);
    await prefs.setBool(_reportSubmitted, data.reportSubmitted);
    await prefs.setBool(_darkMode, data.darkMode);
    await prefs.setString(_textSize, data.textSize.name);
  }

  UserRole _parseRole(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.buyer,
    );
  }

  AppPage _parsePage(String? value) {
    return AppPage.values.firstWhere(
      (page) => page.name == value,
      orElse: () => AppPage.welcome,
    );
  }

  AppTextSize _parseTextSize(String? value) {
    return AppTextSize.values.firstWhere(
      (size) => size.name == value,
      orElse: () => AppTextSize.medium,
    );
  }
}

class _NavItem {
  const _NavItem(
    this.label,
    this.icon,
    this.page, {
    this.selectedIcon,
    this.asset,
  });
  final String label;
  final IconData icon;
  final AppPage page;
  final IconData? selectedIcon;
  final String? asset;
}

class AppFrame extends StatelessWidget {
  const AppFrame({
    required this.child,
    this.compactBottom = false,
    this.header,
    super.key,
  });

  final Widget child;
  final bool compactBottom;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 56),
      children: [
        if (header != null) ...[header!, const SizedBox(height: 18)],
        child,
      ],
    );
  }
}

class WelcomePageFrame extends StatelessWidget {
  const WelcomePageFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 86),
      children: [child],
    );
  }
}

class AuthPageFrame extends StatelessWidget {
  const AuthPageFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      children: [child],
    );
  }
}
