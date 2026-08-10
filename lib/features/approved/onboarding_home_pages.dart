import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/accessibility_visuals.dart';
import '../../theme/buyer_ui_foundation.dart';
import 'approved_replica_metrics.dart';
import 'buyer_bottom_navigation.dart';

const _approvedAssetRoot = 'assets/approved_onboarding_home';
const _navy = BuyerUiTokens.text;
const _blue = BuyerUiTokens.action;
const _muted = BuyerUiTokens.muted;
const _green = Color(0xff078b2d);
const _line = BuyerUiTokens.border;
const _lavender = BuyerUiTokens.softSurface;

enum ApprovedAccountRole { buyer, seller }

class ApprovedAccountCreationPage extends StatefulWidget {
  const ApprovedAccountCreationPage({
    required this.role,
    required this.name,
    required this.onNameChanged,
    required this.onRoleChanged,
    required this.onClose,
    required this.onSignup,
    required this.onLogin,
    this.onGoogle,
    this.onApple,
    this.onFacebook,
    this.onUploadProfile,
    super.key,
  });

  final ApprovedAccountRole role;
  final String name;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<ApprovedAccountRole> onRoleChanged;
  final VoidCallback onClose;
  final VoidCallback onSignup;
  final VoidCallback onLogin;
  final VoidCallback? onGoogle;
  final VoidCallback? onApple;
  final VoidCallback? onFacebook;
  final VoidCallback? onUploadProfile;

  @override
  State<ApprovedAccountCreationPage> createState() =>
      _ApprovedAccountCreationPageState();
}

class _ApprovedAccountCreationPageState
    extends State<ApprovedAccountCreationPage> {
  bool _loginMode = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final accessibilityReflow = metrics.accessibilityReflow;
    final loginMode = _loginMode;

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: metrics.geometryInsets(
            const EdgeInsets.fromLTRB(22, 6, 22, 16),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: metrics.innerContentMaxWidth(
                  referenceHorizontalInset: 22,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    key: const ValueKey('approved-account-modal-header'),
                    height: metrics.geometry(103),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: metrics.geometry(38),
                            height: metrics.geometry(4),
                            decoration: BoxDecoration(
                              color: const Color(0xffc8c9d9),
                              borderRadius: BorderRadius.circular(
                                metrics.geometry(99),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: metrics.geometry(4),
                          right: 0,
                          child: _ApprovedAssetButton(
                            tooltip: 'Close',
                            asset: 'account-close.png',
                            size: 36,
                            onTap: widget.onClose,
                          ),
                        ),
                        Positioned(
                          top: metrics.geometry(29),
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Semantics(
                              button: true,
                              label: 'Upload profile image',
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: widget.onUploadProfile,
                                child: Image.asset(
                                  '$_approvedAssetRoot/account-profile-add.png',
                                  width: metrics.geometry(74),
                                  height: metrics.geometry(74),
                                  filterQuality: FilterQuality.high,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: metrics.geometry(8)),
                  Text(
                    loginMode
                        ? 'Log in to your account'
                        : 'Create your account',
                    textAlign: TextAlign.center,
                    style: _text(
                      context,
                      size: 22,
                      weight: FontWeight.w800,
                      color: _navy,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: metrics.geometry(5)),
                  Text(
                    loginMode
                        ? 'Welcome back to Hocalist.'
                        : 'Join Hocalist to get started.',
                    textAlign: TextAlign.center,
                    style: _text(context, size: 12.5, color: _muted),
                  ),
                  SizedBox(height: metrics.geometry(23)),
                  _ApprovedRoleSelector(
                    role: widget.role,
                    stacked: accessibilityReflow,
                    onChanged: widget.onRoleChanged,
                  ),
                  SizedBox(height: metrics.geometry(23)),
                  if (!loginMode) ...[
                    _ApprovedField(
                      key: const ValueKey('approved-account-name-field'),
                      iconAsset: 'account-person.png',
                      hint: widget.role == ApprovedAccountRole.buyer
                          ? 'Full name'
                          : 'Store or seller name',
                      initialValue: widget.name,
                      onChanged: widget.onNameChanged,
                    ),
                    SizedBox(height: metrics.geometry(9)),
                  ],
                  const _ApprovedField(
                    key: ValueKey('approved-account-email-field'),
                    iconAsset: 'account-mail.png',
                    hint: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: metrics.geometry(9)),
                  if (!loginMode) ...[
                    const _ApprovedField(
                      key: ValueKey('approved-account-phone-field'),
                      iconAsset: 'account-phone.png',
                      hint: 'Phone number (optional)',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: metrics.geometry(9)),
                  ],
                  _ApprovedField(
                    key: const ValueKey('approved-account-password-field'),
                    iconAsset: 'account-lock.png',
                    hint: 'Password',
                    obscureText: !_passwordVisible,
                    suffix: _ApprovedFieldAssetButton(
                      key: const ValueKey('approved-account-password-eye'),
                      tooltip: _passwordVisible
                          ? 'Hide password'
                          : 'Show password',
                      asset: 'account-eye.png',
                      onTap: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  if (!loginMode) ...[
                    SizedBox(height: metrics.geometry(9)),
                    _ApprovedField(
                      key: const ValueKey(
                        'approved-account-confirm-password-field',
                      ),
                      iconAsset: 'account-lock.png',
                      hint: 'Confirm password',
                      obscureText: !_confirmPasswordVisible,
                      suffix: _ApprovedFieldAssetButton(
                        key: const ValueKey(
                          'approved-account-confirm-password-eye',
                        ),
                        tooltip: _confirmPasswordVisible
                            ? 'Hide confirm password'
                            : 'Show confirm password',
                        asset: 'account-eye.png',
                        onTap: () => setState(
                          () => _confirmPasswordVisible =
                              !_confirmPasswordVisible,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: metrics.geometry(15)),
                  _ApprovedPrimaryButton(
                    key: const ValueKey('approved-account-primary-action'),
                    label: loginMode ? 'Log in' : 'Create account',
                    onTap: loginMode ? widget.onLogin : widget.onSignup,
                  ),
                  SizedBox(height: metrics.geometry(14)),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: _line)),
                      Padding(
                        padding: metrics.geometryInsets(
                          const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: Text(
                          'or continue with',
                          style: _text(context, size: 11, color: _muted),
                        ),
                      ),
                      const Expanded(child: Divider(color: _line)),
                    ],
                  ),
                  SizedBox(height: metrics.geometry(11)),
                  _ApprovedSocialButton(
                    key: const ValueKey('approved-account-google-action'),
                    label: 'Continue with Google',
                    asset: 'social-google.png',
                    onTap: widget.onGoogle,
                  ),
                  SizedBox(height: metrics.geometry(5)),
                  _ApprovedSocialButton(
                    key: const ValueKey('approved-account-apple-action'),
                    label: 'Continue with Apple',
                    asset: 'social-apple.png',
                    onTap: widget.onApple,
                  ),
                  SizedBox(height: metrics.geometry(5)),
                  _ApprovedSocialButton(
                    key: const ValueKey('approved-account-facebook-action'),
                    label: 'Continue with Facebook',
                    asset: 'social-facebook.png',
                    onTap: widget.onFacebook,
                  ),
                  SizedBox(height: metrics.geometry(8)),
                  Wrap(
                    key: const ValueKey('approved-account-login-row'),
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        loginMode
                            ? 'Don\'t have an account? '
                            : 'Already have an account? ',
                        style: _text(context, size: 11.5, color: _muted),
                      ),
                      TextButton(
                        onPressed: () =>
                            setState(() => _loginMode = !loginMode),
                        style: TextButton.styleFrom(
                          minimumSize: metrics.geometrySize(const Size(44, 36)),
                          padding: metrics.geometryInsets(
                            const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(
                          loginMode ? 'Sign up' : 'Log in',
                          style: _text(
                            context,
                            size: 11.5,
                            weight: FontWeight.w800,
                            color: _blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedRoleSelector extends StatelessWidget {
  const _ApprovedRoleSelector({
    required this.role,
    required this.stacked,
    required this.onChanged,
  });

  final ApprovedAccountRole role;
  final bool stacked;
  final ValueChanged<ApprovedAccountRole> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final buyer = _ApprovedRoleButton(
      label: 'I am buying',
      iconAsset: 'account-role-buyer.png',
      selected: role == ApprovedAccountRole.buyer,
      onTap: () => onChanged(ApprovedAccountRole.buyer),
    );
    final seller = _ApprovedRoleButton(
      label: 'I am selling',
      iconAsset: 'account-role-seller.png',
      selected: role == ApprovedAccountRole.seller,
      onTap: () => onChanged(ApprovedAccountRole.seller),
    );
    if (stacked) {
      return Column(
        children: [
          buyer,
          SizedBox(height: metrics.geometry(10)),
          seller,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: buyer),
        SizedBox(width: metrics.geometry(8)),
        Expanded(child: seller),
      ],
    );
  }
}

class _ApprovedRoleButton extends StatelessWidget {
  const _ApprovedRoleButton({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? const Color(0xfff7f6ff) : Colors.white,
        borderRadius: BorderRadius.circular(metrics.geometry(10)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(metrics.geometry(10)),
          child: Container(
            key: ValueKey('approved-account-role-$label'),
            constraints: BoxConstraints(minHeight: metrics.geometry(42)),
            padding: metrics.geometryInsets(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(metrics.geometry(10)),
              border: Border.all(
                color: selected
                    ? const Color(0xffaaa6ff)
                    : const Color(0xffdfe3ee),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  '$_approvedAssetRoot/$iconAsset',
                  width: metrics.geometry(22),
                  height: metrics.geometry(22),
                ),
                SizedBox(width: metrics.geometry(8)),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: _text(
                      context,
                      size: 12.5,
                      weight: FontWeight.w800,
                      color: selected ? _blue : _navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedField extends StatelessWidget {
  const _ApprovedField({
    required this.iconAsset,
    required this.hint,
    this.initialValue,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    super.key,
  });

  final String iconAsset;
  final String hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: _text(context, size: 12, color: _navy),
      decoration: InputDecoration(
        isDense: true,
        constraints: BoxConstraints(minHeight: metrics.geometry(44)),
        hintText: hint,
        hintStyle: _text(context, size: 12, color: _muted),
        prefixIcon: Padding(
          padding: EdgeInsets.all(metrics.geometry(10)),
          child: Image.asset(
            '$_approvedAssetRoot/$iconAsset',
            width: metrics.geometry(20),
            height: metrics.geometry(20),
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: metrics.geometry(42),
          minHeight: metrics.geometry(42),
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: metrics.geometry(42),
          minHeight: metrics.geometry(42),
        ),
        suffixIcon: suffix,
        contentPadding: metrics.geometryInsets(
          const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.geometry(10)),
          borderSide: BorderSide(
            color: const Color(0xffdfe3ee),
            width: metrics.geometry(1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.geometry(10)),
          borderSide: BorderSide(color: _blue, width: metrics.geometry(1.5)),
        ),
      ),
    );
  }
}

class _ApprovedFieldAssetButton extends StatelessWidget {
  const _ApprovedFieldAssetButton({
    required this.tooltip,
    required this.asset,
    required this.onTap,
    super.key,
  });

  final String tooltip;
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: SizedBox(
          width: metrics.geometry(36),
          height: metrics.geometry(36),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(metrics.geometry(4)),
                child: Image.asset(
                  '$_approvedAssetRoot/$asset',
                  bundle: DefaultAssetBundle.of(context),
                  width: metrics.geometry(28),
                  height: metrics.geometry(28),
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedSocialButton extends StatelessWidget {
  const _ApprovedSocialButton({
    required this.label,
    required this.asset,
    required this.onTap,
    super.key,
  });

  final String label;
  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap ?? () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: _navy,
          minimumSize: Size.fromHeight(metrics.geometry(42)),
          side: BorderSide(
            color: const Color(0xffdfe3ee),
            width: metrics.geometry(1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.geometry(99)),
          ),
        ),
        icon: Image.asset(
          '$_approvedAssetRoot/$asset',
          width: metrics.geometry(18),
          height: metrics.geometry(18),
        ),
        label: Text(
          label,
          style: _text(
            context,
            size: 11.5,
            weight: FontWeight.w700,
            color: _navy,
          ),
        ),
      ),
    );
  }
}

class ApprovedBuyerBenefitsPage extends StatefulWidget {
  const ApprovedBuyerBenefitsPage({
    required this.name,
    required this.onClose,
    required this.onFinish,
    this.initialStep = 0,
    super.key,
  });

  final String name;
  final VoidCallback onClose;
  final VoidCallback onFinish;
  final int initialStep;

  @override
  State<ApprovedBuyerBenefitsPage> createState() =>
      _ApprovedBuyerBenefitsPageState();
}

class _ApprovedBuyerBenefitsPageState extends State<ApprovedBuyerBenefitsPage> {
  static const _videoPreviewDuration = Duration(seconds: 8);

  final _benefitsScrollController = ScrollController();
  Timer? _videoPreviewTimer;
  int _videoIndex = 0;
  bool _showScrollCue = true;

  static const _firstBenefits = [
    _ApprovedBenefit(
      'benefit-reward.png',
      'Earn rewards on every purchase',
      'Sellers pay you to have the chance to earn your business. Choose one to buy from and keep your earnings.',
    ),
    _ApprovedBenefit(
      'benefit-tag.png',
      'Receive the best offers',
      'Sellers compete for your business so you get better deals.',
    ),
    _ApprovedBenefit(
      'benefit-shield.png',
      'Post safely and privately',
      'Sellers only see a name, but can\'t contact you until you choose to talk to them.',
    ),
    _ApprovedBenefit(
      'benefit-chat.png',
      'Chat and compare easily',
      'Chat with sellers, compare offers, and choose what\'s best for you.',
    ),
  ];

  static const _secondBenefits = [
    _ApprovedBenefit(
      'benefit-location.png',
      'Mileage logic for less driving',
      'Only sellers within the mileage distance you choose will be able to target you.',
    ),
    _ApprovedBenefit(
      'benefit-medal.png',
      'Build your reputation for better offers',
      'Buying more means you\'re a prime customer, sellers get a notification when you post to offer you special deals.',
    ),
    _ApprovedBenefit(
      'benefit-payment-shield.png',
      'We protect your choices & reward you for it',
      'Choose who to talk to, meet safely, and complete item payment on your terms outside the app.',
    ),
    _ApprovedBenefit(
      'benefit-review-dollar.png',
      'Reviewing Your Seller Pays Off',
      'Get extra commissions when reviewing a seller; honesty pays off every time.',
    ),
  ];

  static const _videoPreviews = [
    'buyer-video-welcome.png',
    'buyer-video-payment.png',
  ];

  @override
  void initState() {
    super.initState();
    _benefitsScrollController.addListener(_updateScrollCue);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollCue());
    _videoPreviewTimer = Timer(_videoPreviewDuration, _showSecondVideo);
  }

  void _showSecondVideo() {
    if (!mounted || _videoIndex == _videoPreviews.length - 1) return;
    setState(() => _videoIndex = 1);
  }

  void _updateScrollCue() {
    if (!mounted || !_benefitsScrollController.hasClients) return;
    final position = _benefitsScrollController.position;
    final shouldShow =
        position.maxScrollExtent > 8 &&
        position.pixels < position.maxScrollExtent - 8;
    if (_showScrollCue != shouldShow) {
      setState(() => _showScrollCue = shouldShow);
    }
  }

  @override
  void dispose() {
    _videoPreviewTimer?.cancel();
    _benefitsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final firstName = widget.name.trim().isEmpty
        ? 'Jonathan'
        : widget.name.trim().split(RegExp(r'\s+')).first;
    final videoPreview = _videoPreviews[_videoIndex];
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: metrics.geometryInsets(
            const EdgeInsets.fromLTRB(26, 18, 26, 14),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: metrics.innerContentMaxWidth(
                  referenceHorizontalInset: 26,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _ApprovedAssetButton(
                      tooltip: 'Close',
                      asset: 'account-close.png',
                      size: 36,
                      onTap: widget.onClose,
                    ),
                  ),
                  SizedBox(height: metrics.geometry(5)),
                  _ApprovedBuyerWelcome(name: firstName),
                  SizedBox(height: metrics.geometry(14)),
                  Center(
                    child: SizedBox(
                      key: const ValueKey('approved-benefits-video'),
                      width: metrics.geometry(272),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          metrics.geometry(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: metrics.geometry(12),
                              color: Colors.black,
                              padding: EdgeInsets.only(
                                left: metrics.geometry(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: List.generate(
                                  3,
                                  (index) => Container(
                                    width: metrics.geometry(6),
                                    height: metrics.geometry(6),
                                    margin: EdgeInsets.only(
                                      right: metrics.geometry(4),
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffa9a9a9),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 240),
                              child: Semantics(
                                key: ValueKey(videoPreview),
                                image: true,
                                label:
                                    'Buyer welcome video ${_videoIndex + 1} of ${_videoPreviews.length} preview',
                                child: Image.asset(
                                  '$_approvedAssetRoot/$videoPreview',
                                  fit: BoxFit.fitWidth,
                                  filterQuality: FilterQuality.high,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: metrics.geometry(14)),
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          key: const ValueKey('approved-benefits-scroll'),
                          controller: _benefitsScrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom: metrics.geometry(42),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'As a buyer, you will:',
                                style: _text(
                                  context,
                                  size: 16,
                                  weight: FontWeight.w800,
                                  color: _navy,
                                ),
                              ),
                              SizedBox(height: metrics.geometry(7)),
                              for (final benefit in _firstBenefits) ...[
                                _ApprovedBenefitCard(benefit: benefit),
                                SizedBox(height: metrics.geometry(6)),
                              ],
                              for (final benefit in _secondBenefits) ...[
                                _ApprovedBenefitCard(benefit: benefit),
                                SizedBox(height: metrics.geometry(6)),
                              ],
                              const _ApprovedFairnessBanner(),
                              SizedBox(height: metrics.geometry(20)),
                              _ApprovedPrimaryButton(
                                key: const ValueKey(
                                  'approved-benefits-primary',
                                ),
                                label: 'Jump to dashboard',
                                referenceHeight: 54,
                                onTap: widget.onFinish,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              opacity: _showScrollCue ? 1 : 0,
                              duration: const Duration(milliseconds: 180),
                              child: const _ApprovedBenefitsScrollCue(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedBenefitsScrollCue extends StatelessWidget {
  const _ApprovedBenefitsScrollCue();

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      height: metrics.geometry(42),
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00ffffff), Colors.white],
        ),
      ),
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: _blue,
        size: metrics.geometry(24),
        semanticLabel: 'More Buyer benefits below',
      ),
    );
  }
}

class _ApprovedBuyerWelcome extends StatelessWidget {
  const _ApprovedBuyerWelcome({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stack = _replicaMetrics(context).accessibilityReflow;
        final avatar = Image.asset(
          '$_approvedAssetRoot/buyer-avatar.png',
          key: const ValueKey('approved-benefits-avatar'),
          width: metrics.geometry(70),
          height: metrics.geometry(70),
        );
        final copy = Column(
          crossAxisAlignment: stack
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $name  🎉',
              textAlign: stack ? TextAlign.center : TextAlign.left,
              style: _text(
                context,
                size: 18,
                weight: FontWeight.w800,
                color: _navy,
                height: 1.15,
              ),
            ),
            SizedBox(height: metrics.geometry(3)),
            Text(
              'With your Hocalist buyer account, you get paid to buy and enjoy the best offers.',
              textAlign: stack ? TextAlign.center : TextAlign.left,
              style: _text(context, size: 11.5, color: _muted, height: 1.28),
            ),
          ],
        );
        if (stack) {
          return Column(
            children: [
              avatar,
              SizedBox(height: metrics.geometry(10)),
              copy,
            ],
          );
        }
        return Row(
          children: [
            avatar,
            SizedBox(width: metrics.geometry(12)),
            Expanded(child: copy),
          ],
        );
      },
    );
  }
}

class _ApprovedBenefitCard extends StatelessWidget {
  const _ApprovedBenefitCard({required this.benefit});

  final _ApprovedBenefit benefit;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      key: ValueKey('approved-benefit-${benefit.asset}'),
      constraints: BoxConstraints(minHeight: metrics.geometry(64)),
      padding: metrics.geometryInsets(const EdgeInsets.fromLTRB(9, 7, 9, 7)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line, width: metrics.geometry(1)),
        borderRadius: BorderRadius.circular(metrics.geometry(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              '$_approvedAssetRoot/${benefit.asset}',
              width: metrics.geometry(44),
              height: metrics.geometry(44),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: metrics.geometry(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: _text(
                    context,
                    size: 11,
                    weight: FontWeight.w700,
                    color: _navy,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: metrics.geometry(1)),
                Text(
                  benefit.body,
                  style: _text(context, size: 9.5, color: _muted, height: 1.22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovedFairnessBanner extends StatelessWidget {
  const _ApprovedFairnessBanner();

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      key: const ValueKey('approved-benefits-fairness-banner'),
      padding: metrics.geometryInsets(
        const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xffeef7f1),
        borderRadius: BorderRadius.circular(metrics.geometry(9)),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              '$_approvedAssetRoot/benefit-green-shield.png',
              width: metrics.geometry(34),
              height: metrics.geometry(34),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: metrics.geometry(9)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fair, transparent, and built for you.',
                  style: _text(
                    context,
                    size: 11,
                    weight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                SizedBox(height: metrics.geometry(1)),
                Text(
                  'We\'re here to give you more value every time you buy.',
                  style: _text(context, size: 9.5, color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovedBenefit {
  const _ApprovedBenefit(this.asset, this.title, this.body);

  final String asset;
  final String title;
  final String body;
}

class _ApprovedPrimaryButton extends StatelessWidget {
  const _ApprovedPrimaryButton({
    required this.label,
    required this.onTap,
    this.referenceHeight = 50,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final double referenceHeight;

  @override
  Widget build(BuildContext context) {
    final accessibility = hocalistAccessibilityVisualsOf(context);
    final metrics = _replicaMetrics(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: accessibility.backgroundOr(_blue),
          foregroundColor: accessibility.foregroundOr(Colors.white),
          minimumSize: Size.fromHeight(metrics.geometry(referenceHeight)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              accessibility.radiusOr(metrics.geometry(16)),
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: _text(
            context,
            size: 14,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ApprovedAssetButton extends StatelessWidget {
  const _ApprovedAssetButton({
    required this.tooltip,
    required this.asset,
    required this.size,
    required this.onTap,
  });

  final String tooltip;
  final String asset;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      constraints: BoxConstraints.tightFor(
        width: metrics.geometry(size),
        height: metrics.geometry(size),
      ),
      padding: EdgeInsets.zero,
      icon: ClipOval(
        child: Image.asset(
          '$_approvedAssetRoot/$asset',
          bundle: DefaultAssetBundle.of(context),
          width: metrics.geometry(size - 8),
          height: metrics.geometry(size - 8),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ApprovedNoAccountHomePage extends StatefulWidget {
  const ApprovedNoAccountHomePage({
    required this.onStart,
    required this.onBuyer,
    required this.onSeller,
    this.onNotifications,
    this.onHome,
    this.onTrends,
    this.onWinners,
    this.onSignup,
    super.key,
  });

  final VoidCallback onStart;
  final VoidCallback onBuyer;
  final VoidCallback onSeller;
  final VoidCallback? onNotifications;
  final VoidCallback? onHome;
  final VoidCallback? onTrends;
  final VoidCallback? onWinners;
  final VoidCallback? onSignup;

  @override
  State<ApprovedNoAccountHomePage> createState() =>
      _ApprovedNoAccountHomePageState();
}

class _ApprovedNoAccountHomePageState extends State<ApprovedNoAccountHomePage> {
  int _openFaq = 0;

  static const _benefits = [
    _ApprovedHomeBenefit(
      'home-benefit-reward.png',
      'Buyers Earn Commissions From Sellers Targeting',
      'You get rewards every time you buy through the app.',
    ),
    _ApprovedHomeBenefit(
      'home-benefit-target.png',
      'Businesses Don\'t Waste Money On Ads Just To Reach People',
      'Sellers target real buyers who are actively looking.',
    ),
    _ApprovedHomeBenefit(
      'home-benefit-handshake.png',
      'A System designed to give both sides & Better Outcome',
      'Fair, transparent, and built to create more value for everyone.',
    ),
    _ApprovedHomeBenefit(
      'home-benefit-shield.png',
      'Safe, private, and in your control',
      'You decide who to talk to and complete the deal on your terms.',
    ),
  ];

  static const _faqs = [
    _ApprovedFaq(
      'faq-question.png',
      'What is Hocalist?',
      'Hocalist is a reverse marketplace where buyers post what they need and sellers compete for the opportunity to earn your business.',
    ),
    _ApprovedFaq(
      'faq-gift.png',
      'Does Hocalist sell the items I buy?',
      'No. Buyers choose sellers and arrange the item handoff directly after selection.',
    ),
    _ApprovedFaq(
      'faq-store.png',
      'Why pay through Hocalist?',
      'Seller payments are for seller tools, credits, and access. Item payment stays outside Hocalist.',
    ),
    _ApprovedFaq(
      'faq-buyer.png',
      'What Incentive do I get as a buyer?',
      'Buyers can earn rewards when sellers target and win their business through the app.',
    ),
    _ApprovedFaq(
      'faq-target.png',
      'What Incentive do I get as a seller?',
      'Sellers can target real buyers who are actively looking instead of spending broadly on ads.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Material(
      color: const Color(0xfffbfcff),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: metrics.geometryInsets(
                  const EdgeInsets.fromLTRB(16, 10, 16, 24),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: metrics.innerContentMaxWidth(
                        referenceHorizontalInset: 16,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ApprovedHeader(
                          onNotifications: widget.onNotifications ?? () {},
                        ),
                        SizedBox(height: metrics.geometry(16)),
                        _ApprovedImageAction(
                          semanticLabel:
                              'I am buying. Get paid to buy and get the best offers. Post a request.',
                          asset: 'home-buyer-card.png',
                          aspectRatio: 786 / 460,
                          onTap: widget.onBuyer,
                        ),
                        SizedBox(height: metrics.geometry(14)),
                        _ApprovedImageAction(
                          semanticLabel:
                              'I am selling. Target real customers and beat the competition. Browse requests.',
                          asset: 'home-seller-card.png',
                          aspectRatio: 786 / 303,
                          onTap: widget.onSeller,
                        ),
                        SizedBox(height: metrics.geometry(20)),
                        Text(
                          'We Are The Better Option',
                          style: _text(
                            context,
                            size: 14,
                            weight: FontWeight.w800,
                            color: _navy,
                          ),
                        ),
                        SizedBox(height: metrics.geometry(4)),
                        Text(
                          'Our reverse marketplace works, plain and simple',
                          style: _text(context, size: 10, color: _navy),
                        ),
                        SizedBox(height: metrics.geometry(14)),
                        _ApprovedHomeBenefits(benefits: _benefits),
                        SizedBox(height: metrics.geometry(22)),
                        Text(
                          'See How Hocalist Works',
                          style: _text(
                            context,
                            size: 20,
                            weight: FontWeight.w800,
                            color: _navy,
                          ),
                        ),
                        SizedBox(height: metrics.geometry(4)),
                        Text(
                          'Watch a quick 60-second overview',
                          style: _text(context, size: 13.5, color: _navy),
                        ),
                        SizedBox(height: metrics.geometry(10)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            metrics.geometry(8),
                          ),
                          child: Image.asset(
                            '$_approvedAssetRoot/home-video.png',
                            bundle: DefaultAssetBundle.of(context),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        SizedBox(height: metrics.geometry(20)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Frequently Asked Questions',
                                style: _text(
                                  context,
                                  size: 19,
                                  weight: FontWeight.w800,
                                  color: _navy,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => setState(() => _openFaq = -2),
                              child: Text(
                                'View all',
                                style: _text(
                                  context,
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: _blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: metrics.geometry(6)),
                        _ApprovedFaqPanel(
                          faqs: _faqs,
                          openFaq: _openFaq,
                          onTap: (index) => setState(
                            () => _openFaq = _openFaq == index ? -1 : index,
                          ),
                        ),
                        SizedBox(height: metrics.geometry(28)),
                        _ApprovedStartBanner(onTap: widget.onStart),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _ApprovedBottomNav(
              items: [
                _ApprovedNavItem(
                  'Home',
                  'nav-home.png',
                  widget.onHome ?? () {},
                ),
                _ApprovedNavItem(
                  'Hocatrends',
                  'nav-hocatrends.png',
                  widget.onTrends ?? () {},
                ),
                _ApprovedNavItem(
                  'Winners',
                  'nav-winners.png',
                  widget.onWinners ?? () {},
                ),
                _ApprovedNavItem(
                  'Sign Up',
                  'nav-signup.png',
                  widget.onSignup ?? widget.onStart,
                ),
              ],
              selectedIndex: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovedHeader extends StatelessWidget {
  const _ApprovedHeader({
    required this.onNotifications,
    this.buyerMode = false,
  });

  final VoidCallback onNotifications;
  final bool buyerMode;

  @override
  Widget build(BuildContext context) {
    if (buyerMode) {
      return BuyerTopLevelHeader(onNotifications: onNotifications);
    }

    final metrics = _replicaMetrics(context);
    final logo = Image.asset(
      'assets/brand/hocalist-wordmark.png',
      width: metrics.geometry(buyerMode ? 88 : 104),
      height: metrics.geometry(buyerMode ? 54 : 62),
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      filterQuality: FilterQuality.high,
    );
    final notification = _ApprovedAssetButton(
      tooltip: 'Notifications',
      asset: 'notification.png',
      size: buyerMode ? 44 : 40,
      onTap: onNotifications,
    );
    final modePill = Container(
      constraints: BoxConstraints(minHeight: metrics.geometry(38)),
      padding: metrics.geometryInsets(
        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),
      decoration: BoxDecoration(
        color: _lavender,
        borderRadius: BorderRadius.circular(metrics.geometry(99)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            '$_approvedAssetRoot/buyer-mode-check.png',
            bundle: DefaultAssetBundle.of(context),
            width: metrics.geometry(22),
            height: metrics.geometry(22),
          ),
          SizedBox(width: metrics.geometry(6)),
          Text(
            'Buyer mode',
            style: _text(
              context,
              size: 12,
              weight: FontWeight.w800,
              color: _blue,
              height: 1.05,
            ),
          ),
        ],
      ),
    );

    if (buyerMode && metrics.accessibilityReflow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [logo, const Spacer(), notification]),
          Align(alignment: Alignment.centerRight, child: modePill),
        ],
      );
    }

    return Row(
      children: [
        logo,
        const Spacer(),
        if (buyerMode) ...[modePill, SizedBox(width: metrics.geometry(8))],
        notification,
      ],
    );
  }
}

class _ApprovedImageAction extends StatelessWidget {
  const _ApprovedImageAction({
    required this.semanticLabel,
    required this.asset,
    required this.aspectRatio,
    required this.onTap,
  });

  final String semanticLabel;
  final String asset;
  final double aspectRatio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        key: ValueKey('approved-home-$asset'),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(metrics.geometry(8)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Image.asset(
              '$_approvedAssetRoot/$asset',
              bundle: DefaultAssetBundle.of(context),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedHomeBenefits extends StatelessWidget {
  const _ApprovedHomeBenefits({required this.benefits});

  final List<_ApprovedHomeBenefit> benefits;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Column(
      children: [
        for (var index = 0; index < benefits.length; index++) ...[
          Container(
            key: ValueKey('approved-home-benefit-${benefits[index].asset}'),
            constraints: BoxConstraints(minHeight: metrics.geometry(51)),
            padding: metrics.geometryInsets(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(metrics.geometry(12)),
              border: Border.all(
                color: const Color(0xffe8ebf5),
                width: metrics.geometry(1),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1000036c),
                  blurRadius: metrics.geometry(14),
                  offset: Offset(0, metrics.geometry(5)),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    '$_approvedAssetRoot/${benefits[index].asset}',
                    bundle: DefaultAssetBundle.of(context),
                    width: metrics.geometry(34),
                    height: metrics.geometry(34),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: metrics.geometry(11)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefits[index].title,
                        style: _text(
                          context,
                          size: 9.5,
                          weight: FontWeight.w700,
                          color: _navy,
                          height: 1.12,
                        ),
                      ),
                      SizedBox(height: metrics.geometry(2)),
                      Text(
                        benefits[index].body,
                        style: _text(
                          context,
                          size: 8.5,
                          color: _muted,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (index != benefits.length - 1)
            SizedBox(height: metrics.geometry(7)),
        ],
      ],
    );
  }
}

class _ApprovedFaqPanel extends StatelessWidget {
  const _ApprovedFaqPanel({
    required this.faqs,
    required this.openFaq,
    required this.onTap,
  });

  final List<_ApprovedFaq> faqs;
  final int openFaq;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      decoration: _panelDecoration(context),
      child: Column(
        children: [
          for (var index = 0; index < faqs.length; index++) ...[
            InkWell(
              onTap: () => onTap(index),
              child: Padding(
                padding: metrics.geometryInsets(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        '$_approvedAssetRoot/${faqs[index].asset}',
                        bundle: DefaultAssetBundle.of(context),
                        width: metrics.geometry(28),
                        height: metrics.geometry(28),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: metrics.geometry(10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faqs[index].question,
                            style: _text(
                              context,
                              size: 12.5,
                              weight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                          if (openFaq == index || openFaq == -2) ...[
                            SizedBox(height: metrics.geometry(6)),
                            Text(
                              faqs[index].answer,
                              style: _text(
                                context,
                                size: 11.5,
                                color: _muted,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      openFaq == index || openFaq == -2
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: _navy,
                      size: metrics.geometry(24),
                    ),
                  ],
                ),
              ),
            ),
            if (index != faqs.length - 1)
              Divider(
                height: metrics.geometry(1),
                indent: metrics.geometry(48),
                color: const Color(0xffedf0f8),
              ),
          ],
        ],
      ),
    );
  }
}

class _ApprovedStartBanner extends StatelessWidget {
  const _ApprovedStartBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accessibility = hocalistAccessibilityVisualsOf(context);
    final metrics = _replicaMetrics(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = _replicaMetrics(context).accessibilityReflow;
        final copy = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ready to start earning?',
                style: _text(
                  context,
                  size: 15,
                  weight: FontWeight.w800,
                  color: _blue,
                ),
              ),
              SizedBox(height: metrics.geometry(4)),
              Text(
                'Join thousands of buyers earning rewards every day on Hocalist.',
                style: _text(context, size: 12, color: _navy),
              ),
            ],
          ),
        );
        final action = FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: accessibility.backgroundOr(_blue),
            foregroundColor: accessibility.foregroundOr(Colors.white),
            minimumSize: Size(0, metrics.geometry(48)),
            padding: EdgeInsets.symmetric(
              horizontal: metrics.geometry(12),
              vertical: metrics.geometry(10),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                accessibility.radiusOr(metrics.geometry(99)),
              ),
            ),
          ),
          child: Text(
            'Create Free Account',
            textAlign: TextAlign.center,
            style: _text(
              context,
              size: 12,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        );
        return Container(
          padding: EdgeInsets.all(metrics.geometry(14)),
          decoration: BoxDecoration(
            color: _lavender,
            borderRadius: BorderRadius.circular(metrics.geometry(8)),
          ),
          child: stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          '$_approvedAssetRoot/ready-gift.png',
                          bundle: DefaultAssetBundle.of(context),
                          width: metrics.geometry(74),
                          height: metrics.geometry(74),
                        ),
                        SizedBox(width: metrics.geometry(10)),
                        copy,
                      ],
                    ),
                    SizedBox(height: metrics.geometry(10)),
                    action,
                  ],
                )
              : Row(
                  children: [
                    Image.asset(
                      '$_approvedAssetRoot/ready-gift.png',
                      bundle: DefaultAssetBundle.of(context),
                      width: metrics.geometry(70),
                      height: metrics.geometry(70),
                    ),
                    SizedBox(width: metrics.geometry(10)),
                    copy,
                    SizedBox(width: metrics.geometry(10)),
                    action,
                  ],
                ),
        );
      },
    );
  }
}

class _ApprovedBottomNav extends StatelessWidget {
  const _ApprovedBottomNav({required this.items, required this.selectedIndex});

  final List<_ApprovedNavItem> items;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Center(
      child: SizedBox(
        width: metrics.contentMaxWidth,
        child: Container(
          key: const ValueKey('approved-bottom-navigation'),
          constraints: BoxConstraints(minHeight: metrics.geometry(78)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: const Color(0xffedf0f8),
                width: metrics.geometry(1),
              ),
            ),
          ),
          child: Row(
            children: [
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: index == selectedIndex,
                    label: items[index].label,
                    child: InkWell(
                      onTap: items[index].onTap,
                      child: Container(
                        margin: metrics.geometryInsets(
                          const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: metrics.geometry(6),
                        ),
                        decoration: BoxDecoration(
                          color: index == selectedIndex
                              ? _lavender
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                            metrics.geometry(8),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              '$_approvedAssetRoot/${items[index].asset}',
                              bundle: DefaultAssetBundle.of(context),
                              width: metrics.geometry(28),
                              height: metrics.geometry(28),
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: metrics.geometry(3)),
                            Text(
                              items[index].label,
                              maxLines: metrics.accessibilityReflow ? 2 : 1,
                              textAlign: TextAlign.center,
                              style: _text(
                                context,
                                size: 11,
                                weight: index == selectedIndex
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: index == selectedIndex ? _blue : _muted,
                              ),
                            ),
                          ],
                        ),
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

class _ApprovedHomeBenefit {
  const _ApprovedHomeBenefit(this.asset, this.title, this.body);
  final String asset;
  final String title;
  final String body;
}

class _ApprovedFaq {
  const _ApprovedFaq(this.asset, this.question, this.answer);
  final String asset;
  final String question;
  final String answer;
}

class _ApprovedNavItem {
  const _ApprovedNavItem(this.label, this.asset, this.onTap);
  final String label;
  final String asset;
  final VoidCallback onTap;
}

ApprovedReplicaMetrics _replicaMetrics(BuildContext context) {
  return ApprovedReplicaScope.maybeOf(context) ??
      ApprovedReplicaMetrics.resolve(
        availableWidth: MediaQuery.sizeOf(context).width,
        textScaler: MediaQuery.textScalerOf(context),
      );
}

BoxDecoration _panelDecoration(BuildContext context) {
  final metrics = _replicaMetrics(context);
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(metrics.geometry(8)),
    border: Border.all(
      color: const Color(0xffe8ebf5),
      width: metrics.geometry(1),
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0x1000036c),
        blurRadius: metrics.geometry(14),
        offset: Offset(0, metrics.geometry(5)),
      ),
    ],
  );
}

class ApprovedBuyerHomePage extends StatelessWidget {
  const ApprovedBuyerHomePage({
    required this.name,
    required this.requestTitle,
    required this.requestPosted,
    required this.onCreate,
    required this.onRequestDetails,
    required this.onOffers,
    required this.onRecentActivity,
    required this.onWallet,
    this.onNotifications,
    this.onHome,
    this.onTrends,
    this.onOffersTab,
    this.onChats,
    this.onMore,
    super.key,
  });

  final String name;
  final String requestTitle;
  final bool requestPosted;
  final VoidCallback onCreate;
  final VoidCallback onRequestDetails;
  final VoidCallback onOffers;
  final VoidCallback onRecentActivity;
  final VoidCallback onWallet;
  final VoidCallback? onNotifications;
  final VoidCallback? onHome;
  final VoidCallback? onTrends;
  final VoidCallback? onOffersTab;
  final VoidCallback? onChats;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final firstName = name.trim().isEmpty
        ? 'Alex'
        : name.trim().split(RegExp(r'\s+')).first;
    return LayoutBuilder(
      builder: (context, viewport) {
        final metrics = ApprovedReplicaMetrics.resolve(
          availableWidth: viewport.maxWidth,
          textScaler: MediaQuery.textScalerOf(context),
        );
        return ApprovedReplicaScope(
          metrics: metrics,
          child: Material(
            color: const Color(0xfffbfcff),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: metrics.geometryInsets(
                        const EdgeInsets.fromLTRB(18, 8, 18, 24),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: metrics.innerContentMaxWidth(
                              referenceHorizontalInset: 18,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _ApprovedHeader(
                                buyerMode: true,
                                onNotifications: onNotifications ?? () {},
                              ),
                              SizedBox(height: metrics.geometry(6)),
                              _ApprovedDashboardHero(name: firstName),
                              SizedBox(height: metrics.geometry(10)),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final stacked = metrics.accessibilityReflow;
                                  final cards = [
                                    _ApprovedRewardCard(
                                      onTap: onWallet,
                                      alignActionToBottom: !stacked,
                                    ),
                                    const _ApprovedPendingCard(),
                                  ];
                                  if (stacked) {
                                    return Column(
                                      children: [
                                        cards[0],
                                        SizedBox(height: metrics.geometry(10)),
                                        cards[1],
                                      ],
                                    );
                                  }
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: cards[0]),
                                      SizedBox(width: metrics.geometry(8)),
                                      Expanded(child: cards[1]),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: metrics.geometry(10)),
                              _ApprovedPostRequest(onTap: onCreate),
                              if (requestPosted) ...[
                                SizedBox(height: metrics.geometry(10)),
                                _ApprovedActiveRequest(
                                  title: requestTitle,
                                  onDetails: onRequestDetails,
                                  onOffers: onOffers,
                                ),
                              ],
                              SizedBox(height: metrics.geometry(8)),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Recent activity',
                                      style: _text(
                                        context,
                                        size: 14,
                                        weight: FontWeight.w800,
                                        color: _navy,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: onRecentActivity,
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: metrics.geometryInsets(
                                        const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'View all',
                                      style: _text(
                                        context,
                                        size: 13,
                                        weight: FontWeight.w700,
                                        color: _blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _ApprovedActivityPanel(onTap: onRecentActivity),
                              SizedBox(height: metrics.geometry(12)),
                              const _ApprovedKeepEarningBanner(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BuyerBottomNavigation(
                    selected: ApprovedBuyerNavSelection.home,
                    accentColor: _blue,
                    callbacks: ApprovedBuyerNavigation(
                      onHome: onHome ?? () {},
                      onHocatrends: onTrends ?? () {},
                      onOffers: onOffersTab ?? onOffers,
                      onChats: onChats ?? () {},
                      onMore: onMore ?? () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ApprovedDashboardHero extends StatelessWidget {
  const _ApprovedDashboardHero({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = metrics.accessibilityReflow;
        final copy = Column(
          crossAxisAlignment: stacked
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, $name! 👋',
              textAlign: stacked ? TextAlign.center : TextAlign.left,
              style: _text(
                context,
                size: 18,
                weight: FontWeight.w800,
                color: _navy,
                height: 1.15,
              ),
            ),
            SizedBox(height: metrics.geometry(4)),
            Text(
              'You\'re earning rewards while sellers compete for your business.',
              textAlign: stacked ? TextAlign.center : TextAlign.left,
              style: _text(context, size: 11.5, color: _muted, height: 1.3),
            ),
          ],
        );
        final art = Image.asset(
          '$_approvedAssetRoot/dashboard-gift.png',
          width: metrics.geometry(100),
          height: metrics.geometry(82),
          fit: BoxFit.contain,
        );
        if (stacked) {
          return Column(
            children: [
              copy,
              SizedBox(height: metrics.geometry(8)),
              art,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: copy),
            SizedBox(width: metrics.geometry(8)),
            art,
          ],
        );
      },
    );
  }
}

class _ApprovedRewardCard extends StatelessWidget {
  const _ApprovedRewardCard({
    required this.onTap,
    required this.alignActionToBottom,
  });

  final VoidCallback onTap;
  final bool alignActionToBottom;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return _ApprovedDashboardCard(
      key: const ValueKey('approved-total-rewards-card'),
      referenceHeight: 136,
      padding: EdgeInsets.all(metrics.geometry(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total rewards earned  ⓘ',
            style: _text(
              context,
              size: 10.5,
              weight: FontWeight.w700,
              color: _navy,
            ),
          ),
          SizedBox(height: metrics.geometry(4)),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$128.45',
                  style: _text(
                    context,
                    size: 23,
                    weight: FontWeight.w700,
                    color: _blue,
                  ),
                ),
              ),
              ClipOval(
                child: Image.asset(
                  '$_approvedAssetRoot/dashboard-trophy.png',
                  width: metrics.geometry(34),
                  height: metrics.geometry(34),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: metrics.geometry(5)),
          Text(
            'From 42 completed purchases',
            style: _text(context, size: 10.5, color: _muted),
          ),
          SizedBox(height: metrics.geometry(6)),
          if (alignActionToBottom) const Spacer(),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: _lavender,
              foregroundColor: _blue,
              minimumSize: Size.zero,
              padding: metrics.geometryInsets(
                const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View all rewards  ›',
              style: _text(
                context,
                size: 10.5,
                weight: FontWeight.w700,
                color: _blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovedPendingCard extends StatelessWidget {
  const _ApprovedPendingCard();

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return _ApprovedDashboardCard(
      key: const ValueKey('approved-pending-rewards-card'),
      referenceHeight: 136,
      padding: metrics.geometryInsets(const EdgeInsets.fromLTRB(10, 10, 10, 8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending rewards  ⓘ',
            style: _text(
              context,
              size: 10.5,
              weight: FontWeight.w700,
              color: _navy,
            ),
          ),
          SizedBox(height: metrics.geometry(3)),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$24.80',
                  style: _text(
                    context,
                    size: 23,
                    weight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
              ),
              ClipOval(
                child: Image.asset(
                  '$_approvedAssetRoot/dashboard-calendar.png',
                  width: metrics.geometry(34),
                  height: metrics.geometry(34),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: metrics.geometry(3)),
          Text(
            'Pay date: May 20, 2025',
            style: _text(context, size: 10.5, color: _muted),
          ),
          SizedBox(height: metrics.geometry(4)),
          ClipRRect(
            borderRadius: BorderRadius.circular(metrics.geometry(99)),
            child: LinearProgressIndicator(
              value: .992,
              minHeight: metrics.geometry(6),
              backgroundColor: _lavender,
              valueColor: AlwaysStoppedAnimation<Color>(_blue),
            ),
          ),
          SizedBox(height: metrics.geometry(2)),
          Text(
            '\$24.80 of \$25.00',
            style: _text(
              context,
              size: 10.5,
              weight: FontWeight.w700,
              color: _navy,
            ),
          ),
          Text(
            '\$0.20 until next payout',
            style: _text(context, size: 10, color: _muted),
          ),
        ],
      ),
    );
  }
}

class _ApprovedPostRequest extends StatelessWidget {
  const _ApprovedPostRequest({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Material(
      color: const Color(0xfffbfaff),
      borderRadius: BorderRadius.circular(metrics.geometry(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.geometry(8)),
        child: Container(
          key: const ValueKey('approved-dashboard-post-request'),
          padding: metrics.geometryInsets(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(metrics.geometry(8)),
            border: Border.all(
              color: const Color(0xffa997ff),
              width: metrics.geometry(1),
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  '$_approvedAssetRoot/dashboard-plus.png',
                  width: metrics.geometry(36),
                  height: metrics.geometry(36),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: metrics.geometry(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post a new request',
                      style: _text(
                        context,
                        size: 12.5,
                        weight: FontWeight.w800,
                        color: _blue,
                      ),
                    ),
                    SizedBox(height: metrics.geometry(2)),
                    Text(
                      'Need something else? Post another product or service.',
                      maxLines: metrics.screenshotLocked ? 1 : null,
                      style: _text(context, size: 10, color: _muted),
                    ),
                  ],
                ),
              ),
              Text('›', style: _text(context, size: 23, color: _blue)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApprovedActiveRequest extends StatelessWidget {
  const _ApprovedActiveRequest({
    required this.title,
    required this.onDetails,
    required this.onOffers,
  });

  final String title;
  final VoidCallback onDetails;
  final VoidCallback onOffers;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = metrics.accessibilityReflow;
        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My active request',
              style: _text(
                context,
                size: 10.5,
                weight: FontWeight.w700,
                color: _green,
              ),
            ),
            SizedBox(height: metrics.geometry(2)),
            Text(
              title,
              style: _text(
                context,
                size: 14,
                weight: FontWeight.w800,
                color: _navy,
              ),
            ),
            SizedBox(height: metrics.geometry(2)),
            Text(
              'Posted on May 13  •  2 offers received',
              maxLines: metrics.screenshotLocked ? 1 : null,
              style: _text(context, size: 9.5, color: _muted),
            ),
          ],
        );
        final action = TextButton(
          onPressed: onOffers,
          style: TextButton.styleFrom(
            backgroundColor: _lavender,
            minimumSize: Size.zero,
            padding: metrics.geometryInsets(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View offers  ›',
            style: _text(
              context,
              size: 10,
              weight: FontWeight.w700,
              color: _blue,
            ),
          ),
        );
        return _ApprovedDashboardCard(
          key: const ValueKey('approved-active-request-card'),
          padding: metrics.geometryInsets(
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          child: InkWell(
            onTap: onDetails,
            child: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              '$_approvedAssetRoot/dashboard-clipboard.png',
                              width: metrics.geometry(40),
                              height: metrics.geometry(40),
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: metrics.geometry(8)),
                          Expanded(child: details),
                        ],
                      ),
                      SizedBox(height: metrics.geometry(6)),
                      action,
                    ],
                  )
                : Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          '$_approvedAssetRoot/dashboard-clipboard.png',
                          width: metrics.geometry(40),
                          height: metrics.geometry(40),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: metrics.geometry(8)),
                      Expanded(child: details),
                      action,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ApprovedActivityPanel extends StatelessWidget {
  const _ApprovedActivityPanel({required this.onTap});

  final VoidCallback onTap;

  static const _items = [
    _ApprovedActivity(
      'activity-chat.png',
      'Northside Tech sent you a new offer',
      '2 minutes ago',
      '\$420',
      _green,
    ),
    _ApprovedActivity(
      'activity-check.png',
      'Loop Resale accepted your request',
      '1 hour ago',
      '\$390',
      _green,
    ),
    _ApprovedActivity(
      'activity-star.png',
      'You earned a new review',
      'Yesterday',
      '★★★★★',
      Color(0xffffb300),
    ),
    _ApprovedActivity(
      'activity-reward.png',
      'Rewards will be paid on May 20',
      '2 days ago',
      '\$24.80',
      _blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      key: const ValueKey('approved-dashboard-activity-panel'),
      decoration: _panelDecoration(context),
      child: Column(
        children: [
          for (var index = 0; index < _items.length; index++) ...[
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: metrics.geometryInsets(
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        '$_approvedAssetRoot/${_items[index].asset}',
                        width: metrics.geometry(30),
                        height: metrics.geometry(30),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: metrics.geometry(8)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _items[index].title,
                            style: _text(
                              context,
                              size: 10,
                              weight: FontWeight.w700,
                              color: _navy,
                            ),
                          ),
                          SizedBox(height: metrics.geometry(2)),
                          Text(
                            _items[index].time,
                            style: _text(context, size: 9, color: _muted),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: metrics.geometry(6)),
                    Text(
                      _items[index].value,
                      style: _text(
                        context,
                        size: _items[index].value.length > 5 ? 11 : 12,
                        weight: FontWeight.w700,
                        color: _items[index].color,
                      ),
                    ),
                    SizedBox(width: metrics.geometry(2)),
                    Text('›', style: _text(context, size: 20, color: _muted)),
                  ],
                ),
              ),
            ),
            if (index != _items.length - 1)
              Divider(
                height: metrics.geometry(1),
                indent: metrics.geometry(48),
                color: const Color(0xffedf0f8),
              ),
          ],
        ],
      ),
    );
  }
}

class _ApprovedKeepEarningBanner extends StatelessWidget {
  const _ApprovedKeepEarningBanner();

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      key: const ValueKey('approved-keep-earning-banner'),
      padding: EdgeInsets.all(metrics.geometry(10)),
      decoration: BoxDecoration(
        color: _lavender,
        borderRadius: BorderRadius.circular(metrics.geometry(8)),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              '$_approvedAssetRoot/dashboard-medal.png',
              width: metrics.geometry(40),
              height: metrics.geometry(40),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: metrics.geometry(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep earning more rewards',
                  style: _text(
                    context,
                    size: 10.5,
                    weight: FontWeight.w800,
                    color: _blue,
                  ),
                ),
                SizedBox(height: metrics.geometry(3)),
                Text(
                  'Sellers pay to reach you. Buy from any seller within 5 days to earn rewards from all of them.',
                  style: _text(context, size: 8.5, color: _muted, height: 1.25),
                ),
              ],
            ),
          ),
          Image.asset(
            '$_approvedAssetRoot/reward-network.png',
            width: metrics.geometry(84),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _ApprovedDashboardCard extends StatelessWidget {
  const _ApprovedDashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.referenceHeight,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final double? referenceHeight;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      height: metrics.screenshotLocked && referenceHeight != null
          ? metrics.geometry(referenceHeight!)
          : null,
      padding: padding,
      decoration: _panelDecoration(context),
      child: child,
    );
  }
}

class _ApprovedActivity {
  const _ApprovedActivity(
    this.asset,
    this.title,
    this.time,
    this.value,
    this.color,
  );

  final String asset;
  final String title;
  final String time;
  final String value;
  final Color color;
}

TextStyle _text(
  BuildContext context, {
  required double size,
  required Color color,
  FontWeight weight = FontWeight.w400,
  double? height,
}) {
  final metrics = _replicaMetrics(context);
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
    fontSize: metrics.fontSize(size),
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: 0,
  );
}
