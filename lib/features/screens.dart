part of '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    required this.onStart,
    required this.onBuyer,
    required this.onSeller,
    super.key,
  });

  final VoidCallback onStart;
  final VoidCallback onBuyer;
  final VoidCallback onSeller;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showAllFaqs = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NoAccountHomeHeader(),
        const SizedBox(height: 24),
        HomeRoleActionCard(
          title: 'I am buying',
          body: 'Get Paid To Buy And\nGet The Best Offers',
          buttonLabel: 'Post a request',
          icon: Icons.shopping_bag_outlined,
          color: HocalistTheme.actionBlue,
          surface: HocalistTheme.roleSurface,
          imageAsset: 'assets/home/buyer-home-card-full.png',
          aspectRatio: 786 / 460,
          onTap: widget.onBuyer,
        ),
        const SizedBox(height: 16),
        HomeRoleActionCard(
          title: 'I am selling',
          body: 'Target Real Customers\n& Beat The Competition.',
          buttonLabel: 'Browse requests',
          icon: Icons.storefront_outlined,
          color: HocalistTheme.sellerGreen,
          surface: HocalistTheme.sellerSurface,
          imageAsset: 'assets/home/seller-home-card.png',
          onTap: widget.onSeller,
        ),
        const SizedBox(height: 24),
        Text(
          'We Are The Better Option',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Our reverse marketplace works, plain and simple',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        const HomeBenefitPanel(compact: false),
        const SizedBox(height: 28),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            Text(
              'See How Hocalist Works',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Icon(
              Icons.play_circle_outline,
              color: HocalistTheme.actionBlue,
              size: 23,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Watch a quick 60-second overview',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: HocalistTheme.muted),
        ),
        const SizedBox(height: 18),
        const HocalistVideoPreview(),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Text(
                'Frequently Asked Questions',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 22),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => showAllFaqs = !showAllFaqs);
              },
              child: Text(showAllFaqs ? 'Collapse all' : 'View all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HomeFaqList(expandAll: showAllFaqs),
        const SizedBox(height: 36),
        HomeStartBanner(onCreateAccount: widget.onStart),
      ],
    );
  }
}

class ChooseRolePage extends StatelessWidget {
  const ChooseRolePage({
    required this.onBuyer,
    required this.onSeller,
    super.key,
  });

  final VoidCallback onBuyer;
  final VoidCallback onSeller;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'How will you use Hocalist?',
      subtitle:
          'This starts the right onboarding flow. You can switch later from profile.',
      children: [
        const ProcessStrip(),
        RoleCard(
          title: 'Buyer',
          body:
              'Post buying intent, review offers, select a seller, chat, confirm, and review.',
          color: HocalistTheme.buyer,
          icon: Icons.shopping_bag_outlined,
          onTap: onBuyer,
        ),
        RoleCard(
          title: 'Seller',
          body:
              'Create a seller profile, browse active requests, send offers, chat, and manage seller tools.',
          color: HocalistTheme.seller,
          icon: Icons.storefront_outlined,
          onTap: onSeller,
        ),
      ],
    );
  }
}

class AccountAccessPage extends StatefulWidget {
  const AccountAccessPage({
    required this.role,
    required this.name,
    required this.onNameChanged,
    required this.onRoleChanged,
    required this.onClose,
    required this.onSignup,
    required this.onLogin,
    super.key,
  });

  final UserRole role;
  final String name;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onClose;
  final VoidCallback onSignup;
  final VoidCallback onLogin;

  @override
  State<AccountAccessPage> createState() => _AccountAccessPageState();
}

class _AccountAccessPageState extends State<AccountAccessPage> {
  bool loginMode = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool imageUploaded = false;

  @override
  Widget build(BuildContext context) {
    final title = loginMode ? 'Log in to your account' : 'Create your account';
    final subtitle = loginMode
        ? 'Welcome back to Hocalist.'
        : 'Join Hocalist to get started.';
    final primaryLabel = loginMode ? 'Log in' : 'Create account';

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xffc8c9d9),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Close',
              onPressed: widget.onClose,
              icon: const Icon(
                Icons.close,
                color: HocalistTheme.muted,
                size: 32,
              ),
            ),
          ),
          _AccountHeroIcon(
            uploaded: imageUploaded,
            onTap: () {
              setState(() => imageUploaded = true);
            },
          ),
          const SizedBox(height: 22),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 30,
              color: HocalistTheme.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: HocalistTheme.muted),
          ),
          const SizedBox(height: 34),
          _AccountRoleToggle(
            role: widget.role,
            onChanged: widget.onRoleChanged,
          ),
          const SizedBox(height: 28),
          if (!loginMode) ...[
            _AccountInput(
              icon: Icons.person_outline,
              hint: widget.role == UserRole.buyer
                  ? 'Full name'
                  : 'Store or seller name',
              initialValue: widget.name,
              onChanged: widget.onNameChanged,
            ),
            const SizedBox(height: 14),
          ],
          const _AccountInput(
            icon: Icons.mail_outline,
            hint: 'Email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          if (!loginMode) ...[
            const _AccountInput(
              icon: Icons.phone_outlined,
              hint: 'Phone number (optional)',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
          ],
          _AccountInput(
            icon: Icons.lock_outline,
            hint: 'Password',
            obscureText: !passwordVisible,
            suffix: IconButton(
              tooltip: passwordVisible ? 'Hide password' : 'Show password',
              onPressed: () {
                setState(() => passwordVisible = !passwordVisible);
              },
              icon: const Icon(Icons.visibility_outlined),
            ),
          ),
          if (!loginMode) ...[
            const SizedBox(height: 14),
            _AccountInput(
              icon: Icons.lock_outline,
              hint: 'Confirm password',
              obscureText: !confirmPasswordVisible,
              suffix: IconButton(
                tooltip: confirmPasswordVisible
                    ? 'Hide confirm password'
                    : 'Show confirm password',
                onPressed: () {
                  setState(
                    () => confirmPasswordVisible = !confirmPasswordVisible,
                  );
                },
                icon: const Icon(Icons.visibility_outlined),
              ),
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: HocalistTheme.actionBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: loginMode ? widget.onLogin : widget.onSignup,
              child: Text(
                primaryLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _AccountDivider(),
          const SizedBox(height: 18),
          const _SocialAuthButton(
            label: 'Continue with Google',
            asset: 'assets/auth/social-google.png',
          ),
          const SizedBox(height: 12),
          const _SocialAuthButton(
            label: 'Continue with Apple',
            asset: 'assets/auth/social-apple.png',
          ),
          const SizedBox(height: 12),
          const _SocialAuthButton(
            label: 'Continue with Facebook',
            asset: 'assets/auth/social-facebook.png',
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                loginMode
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: HocalistTheme.muted),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() => loginMode = !loginMode);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Text(
                      loginMode ? 'Sign up' : 'Log in',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: HocalistTheme.actionBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountHeroIcon extends StatelessWidget {
  const _AccountHeroIcon({required this.uploaded, required this.onTap});

  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: uploaded ? 'Profile image added' : 'Upload profile image',
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              children: [
                ClipOval(
                  child: uploaded
                      ? Image.asset(
                          'assets/buyer_onboarding/buyer-avatar.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            color: HocalistTheme.roleSurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_outline,
                              color: HocalistTheme.actionBlue,
                              size: 74,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  right: 4,
                  bottom: 24,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: HocalistTheme.actionBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
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

class _AccountRoleToggle extends StatelessWidget {
  const _AccountRoleToggle({required this.role, required this.onChanged});

  final UserRole role;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AccountRoleButton(
            selected: role == UserRole.buyer,
            icon: Icons.shopping_bag_outlined,
            label: 'I am buying',
            onTap: () => onChanged(UserRole.buyer),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _AccountRoleButton(
            selected: role == UserRole.seller,
            icon: Icons.storefront_outlined,
            label: 'I am selling',
            onTap: () => onChanged(UserRole.seller),
          ),
        ),
      ],
    );
  }
}

class _AccountRoleButton extends StatelessWidget {
  const _AccountRoleButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? HocalistTheme.actionBlue : HocalistTheme.muted;
    return Material(
      color: selected ? HocalistTheme.roleSurface : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xffaaa6ff)
                  : const Color(0xffdfe3ee),
              width: 1.3,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: selected
                        ? HocalistTheme.actionBlue
                        : HocalistTheme.text,
                    fontSize: 16,
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

class _AccountInput extends StatelessWidget {
  const _AccountInput({
    required this.icon,
    required this.hint,
    this.initialValue,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });

  final IconData icon;
  final String hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: HocalistTheme.muted, size: 28),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 22,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffdfe3ee)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: HocalistTheme.actionBlue),
        ),
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  const _AccountDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xffdfe3ee))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or continue with',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xffdfe3ee))),
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({required this.label, required this.asset});

  final String label;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: HocalistTheme.text,
          side: const BorderSide(color: Color(0xffdfe3ee)),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerBenefitOnboardingPage extends StatefulWidget {
  const BuyerBenefitOnboardingPage({
    required this.name,
    required this.onClose,
    required this.onFinish,
    super.key,
  });

  final String name;
  final VoidCallback onClose;
  final VoidCallback onFinish;

  @override
  State<BuyerBenefitOnboardingPage> createState() =>
      _BuyerBenefitOnboardingPageState();
}

class _BuyerBenefitOnboardingPageState
    extends State<BuyerBenefitOnboardingPage> {
  final benefitScrollController = ScrollController();
  bool showBenefitScrollCue = true;

  static const benefits = [
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-reward.png',
      'Earn rewards on every purchase',
      'Sellers pay you to have the chance to earn your business. Choose one to buy from and keep your earnings.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-tag.png',
      'Receive the best offers',
      'Sellers compete for your business so you get better deals.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-shield.png',
      'Post safely and privately',
      'Sellers only see a name, but can\'t contact you until you choose to talk to them.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-chat.png',
      'Chat and compare easily',
      'Chat with sellers, compare offers, and choose what\'s best for you.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-location.png',
      'Mileage logic for less driving',
      'Only sellers within the mileage distance you choose will be able to target you.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-medal.png',
      'Build your reputation for better offers',
      'Buying more means you\'re a prime customer, sellers get a notification when you post to offer you special deals.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-payment-shield.png',
      'We protect your choices & reward you for it',
      'Choose who to talk to, meet safely, and complete item payment on your terms outside the app.',
    ),
    _BuyerBenefitData(
      'assets/buyer_onboarding/benefit-review-dollar.png',
      'Reviewing Your Seller Pays Off',
      'Get extra commissions when reviewing a seller; honesty pays off every time.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    benefitScrollController.addListener(_updateBenefitScrollCue);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateBenefitScrollCue(),
    );
  }

  void _updateBenefitScrollCue() {
    if (!mounted || !benefitScrollController.hasClients) {
      return;
    }
    final position = benefitScrollController.position;
    final shouldShow = position.maxScrollExtent > 8 && position.pixels < 12;
    if (showBenefitScrollCue != shouldShow) {
      setState(() => showBenefitScrollCue = shouldShow);
    }
  }

  @override
  void dispose() {
    benefitScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.name.trim().isEmpty
        ? 'Jonathan'
        : widget.name.trim().split(RegExp(r'\s+')).first;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Close',
              onPressed: widget.onClose,
              icon: const Icon(
                Icons.close,
                color: HocalistTheme.muted,
                size: 31,
              ),
            ),
          ),
          _BuyerWelcomeHeader(name: firstName),
          const SizedBox(height: 8),
          const _BuyerVideoCard(
            asset: 'assets/buyer_onboarding/buyer-video-welcome.png',
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: benefitScrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'As a buyer, you will:',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: HocalistTheme.primary,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 12),
                      for (final item in benefits) ...[
                        _BuyerBenefitCard(data: item),
                        const SizedBox(height: 10),
                      ],
                      const _BuyerFairnessBanner(),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: HocalistTheme.actionBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: widget.onFinish,
                          child: Text(
                            'Jump to dashboard',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: showBenefitScrollCue ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const _BenefitScrollCue(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitScrollCue extends StatelessWidget {
  const _BenefitScrollCue();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00ffffff), Colors.white],
        ),
      ),
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff00036c).withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: HocalistTheme.actionBlue,
          size: 28,
          semanticLabel: 'More buyer benefits below',
        ),
      ),
    );
  }
}

class _BuyerWelcomeHeader extends StatelessWidget {
  const _BuyerWelcomeHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            'assets/buyer_onboarding/buyer-avatar.png',
            width: 58,
            height: 58,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $name 🎉',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: HocalistTheme.text,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'With your Hocalist buyer account, you get paid to buy and enjoy the best offers.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: HocalistTheme.muted,
                  height: 1.28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuyerVideoCard extends StatelessWidget {
  const _BuyerVideoCard({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 158),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            asset,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _BuyerBenefitCard extends StatelessWidget {
  const _BuyerBenefitCard({required this.data});

  final _BuyerBenefitData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffe2e3f3)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BuyerBenefitIcon(asset: data.iconAsset, size: 72, imageSize: 68),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HocalistTheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HocalistTheme.muted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerFairnessBanner extends StatelessWidget {
  const _BuyerFairnessBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: const Color(0xffeef7f1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const _BuyerBenefitIcon(
            asset: 'assets/buyer_onboarding/benefit-green-shield.png',
            size: 58,
            imageSize: 54,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fair, transparent, and built for you.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HocalistTheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We\'re here to give you more value every time you buy.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerBenefitIcon extends StatelessWidget {
  const _BuyerBenefitIcon({
    required this.asset,
    required this.size,
    required this.imageSize,
  });

  final String asset;
  final double size;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Image.asset(
          asset,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _BuyerBenefitData {
  const _BuyerBenefitData(this.iconAsset, this.title, this.body);

  final String iconAsset;
  final String title;
  final String body;
}

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({
    required this.name,
    required this.accent,
    required this.requestTitle,
    required this.requestBudget,
    required this.requestPosted,
    required this.offerSelected,
    required this.meetingConfirmed,
    required this.dealFailed,
    required this.requestReopened,
    required this.dealCompleted,
    required this.withdrawalRequested,
    required this.restoredSession,
    required this.onCreate,
    required this.onOffers,
    required this.onWallet,
    super.key,
  });

  final String name;
  final Color accent;
  final String requestTitle;
  final String requestBudget;
  final bool requestPosted;
  final bool offerSelected;
  final bool meetingConfirmed;
  final bool dealFailed;
  final bool requestReopened;
  final bool dealCompleted;
  final bool withdrawalRequested;
  final bool restoredSession;
  final VoidCallback onCreate;
  final VoidCallback onOffers;
  final VoidCallback onWallet;

  @override
  Widget build(BuildContext context) {
    final firstName = name.trim().isEmpty
        ? 'Alex'
        : name.trim().split(RegExp(r'\s+')).first;
    final activeRequests = [
      _DashboardRequestData(
        requestPosted ? requestTitle : 'iPad Air 5, 256GB',
        'Posted on May 13',
        requestPosted ? '2 offers received' : '2 offers received',
      ),
      const _DashboardRequestData(
        'MacBook Pro M2',
        'Posted on May 12',
        '4 offers received',
      ),
      const _DashboardRequestData(
        'Dining table set',
        'Posted on May 11',
        '3 offers received',
      ),
      const _DashboardRequestData(
        'Weekend cleaning service',
        'Posted on May 10',
        '1 offer received',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BuyerDashboardHeader(accent: accent),
        const SizedBox(height: 22),
        _BuyerDashboardHero(name: firstName),
        const SizedBox(height: 22),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _RewardSummaryCard(
                  title: 'Total rewards earned',
                  amount: '\$128.45',
                  detail: 'From 42 completed purchases',
                  infoTitle: 'Total rewards earned',
                  infoBody:
                      'This is the total reward amount you have earned from completed purchases in this preview account.',
                  icon: Icons.emoji_events_outlined,
                  iconColor: HocalistTheme.actionBlue,
                  actionLabel: 'View all rewards',
                  onTap: onWallet,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: _PendingRewardsCard()),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _PostNewRequestPanel(onTap: onCreate),
        const SizedBox(height: 18),
        for (final request in activeRequests.take(4)) ...[
          _ActiveRequestCard(data: request, onTap: onOffers),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        _DashboardSectionHeader(
          title: 'Recent activity',
          action: 'View all',
          onTap: onOffers,
        ),
        const SizedBox(height: 12),
        _RecentActivityPanel(onTap: onOffers),
        const SizedBox(height: 22),
        const _KeepEarningBanner(),
      ],
    );
  }
}

class _BuyerDashboardHeader extends StatelessWidget {
  const _BuyerDashboardHeader({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final logoWidth = constraints.maxWidth < 360 ? 112.0 : 126.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Hocalist Reverse Marketplace',
              image: true,
              child: SizedBox(
                width: logoWidth,
                height: 62,
                child: Image.asset(
                  'assets/brand/hocalist-wordmark.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  filterQuality: FilterQuality.high,
                  excludeFromSemantics: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: HocalistTheme.roleSurface,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: accent,
                              size: 22,
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                'Buyer mode',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(color: accent, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          tooltip: 'Notifications',
                          constraints: const BoxConstraints.tightFor(
                            width: 42,
                            height: 42,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: HocalistTheme.primary,
                            size: 30,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 7,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Color(0xffff1d25),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BuyerDashboardHero extends StatelessWidget {
  const _BuyerDashboardHero({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final giftWidth = constraints.maxWidth < 360 ? 112.0 : 138.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Good morning, $name! '),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.waving_hand_outlined,
                            color: Color(0xffffb300),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: HocalistTheme.primary,
                      fontSize: 26,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You\'re earning rewards while sellers compete for your business.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: HocalistTheme.muted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: giftWidth,
              height: 104,
              child: Image.asset(
                'assets/buyer_dashboard/dashboard-gift-art.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RewardSummaryCard extends StatelessWidget {
  const _RewardSummaryCard({
    required this.title,
    required this.amount,
    required this.detail,
    required this.infoTitle,
    required this.infoBody,
    required this.icon,
    required this.iconColor,
    this.actionLabel,
    this.onTap,
  });

  final String title;
  final String amount;
  final String detail;
  final String infoTitle;
  final String infoBody;
  final IconData icon;
  final Color iconColor;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: HocalistTheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
              _RewardInfoButton(
                title: infoTitle,
                body: infoBody,
                color: HocalistTheme.muted,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: HocalistTheme.actionBlue,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              _DashboardCircleIcon(
                icon: icon,
                color: iconColor,
                background: HocalistTheme.roleSurface,
                size: 44,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            detail,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: HocalistTheme.muted),
          ),
          if (actionLabel != null) ...[
            const Spacer(),
            const SizedBox(height: 12),
            _DashboardPillButton(label: actionLabel!, onTap: onTap),
          ],
        ],
      ),
    );
  }
}

class _PendingRewardsCard extends StatelessWidget {
  const _PendingRewardsCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Pending rewards',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: HocalistTheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
              const _RewardInfoButton(
                title: 'Pending rewards',
                body:
                    'Pending rewards are earned but not ready for payout yet. This preview shows the next payout target and date.',
                color: HocalistTheme.muted,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$24.80',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: HocalistTheme.primary,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              const _DashboardCircleIcon(
                icon: Icons.calendar_month_outlined,
                color: HocalistTheme.sellerGreen,
                background: Color(0xffdbf4e9),
                size: 44,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Pay date: May 20, 2025',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: HocalistTheme.muted),
          ),
          const Spacer(),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: 0.992,
              backgroundColor: HocalistTheme.roleSurface,
              valueColor: const AlwaysStoppedAnimation<Color>(
                HocalistTheme.actionBlue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$24.80 of \$25.00',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: HocalistTheme.primary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$0.20 until next payout',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: HocalistTheme.muted),
          ),
        ],
      ),
    );
  }
}

class _RewardInfoButton extends StatelessWidget {
  const _RewardInfoButton({
    required this.title,
    required this.body,
    required this.color,
  });

  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: '$title info',
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: HocalistTheme.primary,
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: HocalistTheme.muted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: Icon(Icons.info_outline, color: color, size: 17),
    );
  }
}

class _PostNewRequestPanel extends StatelessWidget {
  const _PostNewRequestPanel({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xfffbfaff),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffa997ff), width: 1.2),
            color: const Color(0xfffdfcff),
          ),
          child: Row(
            children: [
              const _DashboardCircleIcon(
                icon: Icons.add,
                color: Colors.white,
                background: HocalistTheme.actionBlue,
                size: 50,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post a new request',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: HocalistTheme.actionBlue,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Need something else? Post another product or service.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HocalistTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: HocalistTheme.actionBlue,
                size: 27,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  const _ActiveRequestCard({required this.data, required this.onTap});

  final _DashboardRequestData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            const _DashboardCircleIcon(
              icon: Icons.assignment_outlined,
              color: HocalistTheme.sellerGreen,
              background: Color(0xffe5f7ea),
              size: 62,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My active request',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: HocalistTheme.sellerGreen,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: HocalistTheme.primary,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${data.date}  •  ${data.offerCount}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: HocalistTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 136),
              child: _DashboardPillButton(label: 'View offers', onTap: onTap),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardSectionHeader extends StatelessWidget {
  const _DashboardSectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: HocalistTheme.primary,
              fontSize: 22,
            ),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}

class _RecentActivityPanel extends StatelessWidget {
  const _RecentActivityPanel({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActivityData(
        Icons.chat_bubble_outline,
        HocalistTheme.actionBlue,
        HocalistTheme.roleSurface,
        'Northside Tech sent you a new offer',
        '2 minutes ago',
        '\$420',
        HocalistTheme.sellerGreen,
      ),
      _ActivityData(
        Icons.check_circle_outline,
        HocalistTheme.sellerGreen,
        const Color(0xffe5f7ea),
        'Loop Resale accepted your request',
        '1 hour ago',
        '\$390',
        HocalistTheme.sellerGreen,
      ),
      _ActivityData(
        Icons.star,
        const Color(0xffffb300),
        const Color(0xfffff5dc),
        'You earned a new review',
        'Yesterday',
        '★★★★★',
        const Color(0xffffb300),
      ),
      _ActivityData(
        Icons.account_balance_wallet_outlined,
        HocalistTheme.actionBlue,
        HocalistTheme.roleSurface,
        'Rewards will be paid on May 20',
        '2 days ago',
        '\$24.80',
        HocalistTheme.actionBlue,
      ),
    ];

    return _DashboardCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _ActivityRow(data: items[index], onTap: onTap),
            if (index != items.length - 1)
              const Divider(height: 1, indent: 74, color: Color(0xffe5e7f3)),
          ],
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.data, required this.onTap});

  final _ActivityData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _DashboardCircleIcon(
              icon: data.icon,
              color: data.iconColor,
              background: data.background,
              size: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: HocalistTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.time,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: HocalistTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              data.trailing,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: data.trailingColor,
                fontSize: data.trailing.contains('★') ? 18 : 17,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right,
              color: HocalistTheme.muted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _KeepEarningBanner extends StatelessWidget {
  const _KeepEarningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
      decoration: BoxDecoration(
        color: HocalistTheme.roleSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const _DashboardCircleIcon(
            icon: Icons.workspace_premium_outlined,
            color: HocalistTheme.actionBlue,
            background: Color(0xffe6e3ff),
            size: 58,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep earning more rewards',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HocalistTheme.actionBlue,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sellers pay to reach you. Buy from any seller within 5 days to earn rewards from all of them.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HocalistTheme.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 116,
            height: 82,
            child: Image.asset(
              'assets/buyer_dashboard/reward-network-art.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: HocalistTheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xffe5e6f2)),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: padding, child: child),
    );
  }
}

class _DashboardCircleIcon extends StatelessWidget {
  const _DashboardCircleIcon({
    required this.icon,
    required this.color,
    required this.background,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class _DashboardPillButton extends StatelessWidget {
  const _DashboardPillButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HocalistTheme.roleSurface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: HocalistTheme.actionBlue,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                color: HocalistTheme.actionBlue,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardRequestData {
  const _DashboardRequestData(this.title, this.date, this.offerCount);

  final String title;
  final String date;
  final String offerCount;
}

class _ActivityData {
  const _ActivityData(
    this.icon,
    this.iconColor,
    this.background,
    this.title,
    this.time,
    this.trailing,
    this.trailingColor,
  );

  final IconData icon;
  final Color iconColor;
  final Color background;
  final String title;
  final String time;
  final String trailing;
  final Color trailingColor;
}

class CreateRequestPage extends StatelessWidget {
  const CreateRequestPage({
    required this.accent,
    required this.requestTitle,
    required this.budget,
    required this.onTitleChanged,
    required this.onBudgetChanged,
    required this.onSubmit,
    super.key,
  });

  final Color accent;
  final String requestTitle;
  final String budget;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onBudgetChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Post buying request',
      subtitle:
          'Create a request sellers can respond to. Categories and cities become admin-managed when the backend is connected.',
      children: [
        AlertBanner(
          accent: accent,
          title: 'Request-first flow',
          body:
              'This form creates buyer demand for sellers to answer. It is not checkout, escrow, shipping, or inventory purchase.',
          icon: Icons.rule_folder_outlined,
        ),
        AppCard(
          child: Column(
            children: [
              TextFormField(
                initialValue: 'Electronics / Tablets',
                decoration: InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: requestTitle,
                decoration: const InputDecoration(
                  labelText: 'What do you want to buy?',
                ),
                onChanged: onTitleChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: budget,
                decoration: const InputDecoration(labelText: 'Budget range'),
                onChanged: onBudgetChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Chicago, IL - within 12 miles',
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'This week',
                decoration: const InputDecoration(labelText: 'Timing'),
              ),
            ],
          ),
        ),
        LocationSearchPanel(
          accent: accent,
          title: 'Request location',
          locationValue: 'Chicago, IL',
          radiusValue: 'Within 12 miles',
          hint:
              'Sellers see approximate geography first. Exact meetup details stay private until chat.',
        ),
        UploadBox(accent: accent, label: 'Add reference photos'),
        PrimaryButton(
          label: 'Post request',
          icon: Icons.publish_outlined,
          color: accent,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

class BuyerRequestDetailPage extends StatelessWidget {
  const BuyerRequestDetailPage({
    required this.accent,
    required this.requestTitle,
    required this.budget,
    required this.onOffers,
    super.key,
  });

  final Color accent;
  final String requestTitle;
  final String budget;
  final VoidCallback onOffers;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Request detail',
      subtitle: 'Review status, request details, and incoming offers.',
      children: [
        RouteContextBanner(
          accent: accent,
          label: 'Buyer flow',
          text: 'Request -> offers -> seller selection -> chat',
        ),
        BuyerRequestCard(
          title: requestTitle,
          budget: budget,
          location: 'Chicago, IL',
          status: 'Active',
          onTap: onOffers,
        ),
        LocationSummaryCard(
          accent: accent,
          title: 'Buyer location preview',
          address: 'Chicago, IL - approximate buyer area',
          distance: 'Visible to verified nearby sellers within 12 miles',
          privacyNote:
              'Exact handoff address is not public and should only be shared inside selected-seller chat.',
        ),
        const InfoList(
          items: [
            'Seller visibility: open to verified sellers nearby',
            'Images: 2 reference photos',
            'Status: active, editable until seller selection',
          ],
        ),
        PrimaryButton(
          label: 'Review 2 offers',
          icon: Icons.local_offer_outlined,
          color: accent,
          onPressed: onOffers,
        ),
      ],
    );
  }
}

class OffersPage extends StatelessWidget {
  const OffersPage({
    required this.accent,
    required this.requestPosted,
    required this.offerSelected,
    required this.onProfile,
    required this.onSelect,
    super.key,
  });

  final Color accent;
  final bool requestPosted;
  final bool offerSelected;
  final VoidCallback onProfile;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Offers received',
      subtitle:
          'Compare the whole offer before selecting a seller. Chat opens only after selection.',
      children: [
        RouteContextBanner(
          accent: accent,
          label: 'Buyer flow',
          text: 'Compare offers before choosing one seller',
        ),
        AlertBanner(
          accent: accent,
          title: offerSelected
              ? 'Northside Tech selected'
              : requestPosted
              ? '2 offers ready to compare'
              : 'Sample offers',
          body: offerSelected
              ? 'Chat is open and deal details are waiting for confirmation.'
              : requestPosted
              ? 'These offers are tied to the request you posted on this device.'
              : 'Post a request first, or inspect these starter offers.',
          icon: offerSelected
              ? Icons.check_circle_outline
              : Icons.local_offer_outlined,
        ),
        SellerOfferCard(
          seller: 'Northside Tech',
          price: '\$420',
          detail: 'iPad Air 5, 256GB, keyboard case, public pickup Saturday.',
          status: 'Verified',
          accent: accent,
          onTap: onProfile,
        ),
        SellerOfferCard(
          seller: 'Loop Resale',
          price: '\$390',
          detail: 'iPad Air 5, 64GB, same-day pickup, no accessories.',
          status: 'Fast reply',
          accent: accent,
          onTap: onProfile,
        ),
        OfflinePaymentNotice(accent: accent),
        if (offerSelected)
          SecondaryButton(
            label: 'Open selected chat',
            color: accent,
            onPressed: onSelect,
          )
        else
          PrimaryButton(
            label: 'Select Northside Tech',
            icon: Icons.check,
            color: accent,
            onPressed: onSelect,
          ),
      ],
    );
  }
}

class SellerPublicProfilePage extends StatelessWidget {
  const SellerPublicProfilePage({
    required this.accent,
    required this.onSelect,
    super.key,
  });

  final Color accent;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Northside Tech',
      subtitle: 'Seller public profile and trust signals.',
      children: [
        RouteContextBanner(
          accent: accent,
          label: 'Buyer flow',
          text: 'Review seller details before opening chat',
        ),
        ProfileCard(
          accent: accent,
          title: '4.9 rating',
          body:
              '134 completed local deals. Verified seller. Electronics specialist.',
        ),
        const InfoList(
          items: [
            'Typical response: under 20 minutes',
            'Meetup preference: public pickup points',
            'Recent review: clear photos and fair pricing',
          ],
        ),
        LocationSummaryCard(
          accent: accent,
          title: 'Seller meetup area',
          address: 'Wicker Park public pickup points',
          distance: 'Usually within 4 miles of the buyer request area',
          privacyNote:
              'Meeting place selection should use map search after buyer selects this seller.',
        ),
        PrimaryButton(
          label: 'Select seller and open chat',
          icon: Icons.chat_bubble_outline,
          color: accent,
          onPressed: onSelect,
        ),
      ],
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({
    required this.accent,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
  });

  final Color accent;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: title,
      subtitle: '$body Item payment still happens outside Hocalist.',
      children: [
        RouteContextBanner(
          accent: accent,
          label: 'Selected chat',
          text: 'Only the selected buyer and seller can coordinate here',
        ),
        StatusTimeline(
          accent: accent,
          items: const [
            'Seller selected',
            'Chat opened for item and meeting details',
            'Choose a public meetup place with map search',
            'Offline payment reminder visible before finalizing',
          ],
        ),
        LocationSummaryCard(
          accent: accent,
          title: 'Suggested meetup area',
          address: 'Wicker Park public pickup point',
          distance: 'Map and address confirmation happen before meeting',
          privacyNote:
              'Use a public place and keep private addresses out of chat until both sides agree.',
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageBubble(
                text: 'Is Saturday pickup still good?',
                color: accent.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 8),
              const MessageBubble(
                text:
                    'Yes, public pickup works. I can bring the keyboard case too.',
                color: HocalistTheme.softSurface,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Type a message...',
                decoration: InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
        ),
        OfflinePaymentNotice(accent: accent),
        PrimaryButton(
          label: primaryLabel,
          icon: Icons.handshake_outlined,
          color: accent,
          onPressed: onPrimary,
        ),
      ],
    );
  }
}

class FinalizeDealPage extends StatelessWidget {
  const FinalizeDealPage({
    required this.accent,
    required this.price,
    required this.onContinue,
    super.key,
  });

  final Color accent;
  final String price;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Finalize deal',
      subtitle:
          'Confirm the item, price, and offline payment boundary before meeting.',
      children: [
        DealSummary(
          accent: accent,
          title: 'iPad Air deal',
          price: price,
          detail: 'iPad Air 5, keyboard case, pickup Saturday.',
        ),
        LocationSummaryCard(
          accent: accent,
          title: 'Meetup location to confirm',
          address: 'Wicker Park public pickup point',
          distance: '4.2 miles from seller profile area',
          privacyNote:
              'Future Google Maps integration should confirm address, distance, and safe public-place suggestions here.',
        ),
        OfflinePaymentNotice(accent: accent),
        PrimaryButton(
          label: 'Add meeting details',
          icon: Icons.event_available_outlined,
          color: accent,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class MeetingDetailsPage extends StatelessWidget {
  const MeetingDetailsPage({
    required this.accent,
    required this.onContinue,
    super.key,
  });

  final Color accent;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Meeting details',
      subtitle:
          'Pick a public meeting place, confirm the address, and keep payment offline.',
      children: [
        LocationSearchPanel(
          accent: accent,
          title: 'Meeting place',
          locationValue: 'Wicker Park public pickup point',
          radiusValue: '4.2 miles from seller',
          hint:
              'This is the future Google Maps handoff point: search, select, and confirm an address both sides can see.',
        ),
        AppCard(
          child: Column(
            children: [
              TextFormField(
                initialValue: 'Saturday, 2:30 PM',
                decoration: const InputDecoration(labelText: 'Date and time'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Inspect item before paying offline',
                decoration: const InputDecoration(labelText: 'Safety note'),
              ),
            ],
          ),
        ),
        PrimaryButton(
          label: 'Confirm meeting',
          icon: Icons.event_available_outlined,
          color: accent,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class BuyerConfirmationPage extends StatelessWidget {
  const BuyerConfirmationPage({
    required this.accent,
    required this.onReview,
    required this.onDealIssue,
    required this.onReport,
    super.key,
  });

  final Color accent;
  final VoidCallback onReview;
  final VoidCallback onDealIssue;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Confirm outcome',
      subtitle: 'After the meeting, the buyer records the outcome.',
      children: [
        ActionChoice(
          icon: Icons.check_circle_outline,
          title: 'Deal completed',
          body: 'Item inspected, offline payment handled outside Hocalist.',
          color: accent,
          onTap: onReview,
        ),
        ActionChoice(
          icon: Icons.replay_outlined,
          title: 'Deal failed or seller unavailable',
          body:
              'Return to valid backup offers, reopen the request, or report a safety issue.',
          color: HocalistTheme.seller,
          onTap: onDealIssue,
        ),
        ActionChoice(
          icon: Icons.report_problem_outlined,
          title: 'Report an issue',
          body: 'Use this if the item, seller, or meeting was unsafe.',
          color: HocalistTheme.danger,
          onTap: onReport,
        ),
      ],
    );
  }
}

class DealRecoveryPage extends StatelessWidget {
  const DealRecoveryPage({
    required this.accent,
    required this.onReopen,
    required this.onBackup,
    required this.onReport,
    super.key,
  });

  final Color accent;
  final VoidCallback onReopen;
  final VoidCallback onBackup;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Recover deal',
      subtitle:
          'If a selected seller is unavailable, the buyer can keep the request alive without starting over.',
      children: [
        AlertBanner(
          accent: HocalistTheme.danger,
          title: 'Selected deal needs action',
          body:
              'Use recovery when the seller stops responding, the item is unavailable, the meeting fails, or the buyer changes direction.',
          icon: Icons.warning_amber_outlined,
        ),
        StatusTimeline(
          accent: accent,
          items: const [
            'Keep previous valid offers available',
            'Let the buyer compare backup sellers',
            'Reopen the request if no backup offer fits',
            'Keep safety reporting separate from normal deal failure',
          ],
        ),
        ActionChoice(
          icon: Icons.local_offer_outlined,
          title: 'Compare backup offers',
          body:
              'Return to the offer list and choose another valid seller if the offer still fits.',
          color: accent,
          onTap: onBackup,
        ),
        ActionChoice(
          icon: Icons.refresh_outlined,
          title: 'Reopen request',
          body:
              'Move the request back to open status so sellers can respond again.',
          color: HocalistTheme.primary,
          onTap: onReopen,
        ),
        ActionChoice(
          icon: Icons.report_problem_outlined,
          title: 'Report safety issue',
          body:
              'Use this only for unsafe behavior, fraud concern, or a serious meeting problem.',
          color: HocalistTheme.danger,
          onTap: onReport,
        ),
      ],
    );
  }
}

class BuyerReviewPage extends StatelessWidget {
  const BuyerReviewPage({
    required this.accent,
    required this.onFinish,
    super.key,
  });

  final Color accent;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Review seller',
      subtitle: 'This helps future buyers compare offers safely.',
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  5,
                  (_) => Icon(Icons.star, color: accent),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Clear photos, fair price, easy public pickup.',
                decoration: InputDecoration(labelText: 'Review'),
              ),
            ],
          ),
        ),
        PrimaryButton(
          label: 'Submit review',
          icon: Icons.rate_review_outlined,
          color: accent,
          onPressed: onFinish,
        ),
      ],
    );
  }
}

class BuyerWalletPage extends StatelessWidget {
  const BuyerWalletPage({
    required this.accent,
    required this.dealCompleted,
    required this.dealFailed,
    required this.requestReopened,
    required this.withdrawalRequested,
    required this.onWithdraw,
    super.key,
  });

  final Color accent;
  final bool dealCompleted;
  final bool dealFailed;
  final bool requestReopened;
  final bool withdrawalRequested;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Buyer deal history',
      subtitle:
          'Review selected-seller outcomes, recovery states, and support notes. No item payment is processed here.',
      children: [
        MetricRow(
          accent: accent,
          values: [
            Metric(withdrawalRequested ? '1' : '0', 'In review'),
            Metric(dealCompleted ? '1' : '0', 'Completed'),
            Metric(requestReopened ? '1' : '0', 'Reopened'),
          ],
        ),
        if (dealCompleted)
          AlertBanner(
            accent: accent,
            title: 'Deal completion recorded',
            body:
                'Your record reflects the completed iPad Air deal. Item payment still happened offline.',
            icon: Icons.check_circle_outline,
          ),
        if (withdrawalRequested)
          AlertBanner(
            accent: accent,
            title: 'Support review requested',
            body:
                'Support review is pending. This prototype keeps the note local until admin tools are connected.',
            icon: Icons.pending_actions_outlined,
          ),
        if (dealFailed || requestReopened)
          AlertBanner(
            accent: HocalistTheme.danger,
            title: 'Recovery path recorded',
            body:
                'A failed or unresponsive selected seller does not erase the request. The buyer can return to backup offers.',
            icon: Icons.restore_page_outlined,
          ),
        RecordCard(
          title: 'iPad Air deal',
          meta: dealCompleted
              ? 'Completed locally, payment handled offline'
              : requestReopened
              ? 'Reopened after selected seller issue'
              : 'Pending confirmation',
          amount: dealCompleted
              ? 'Done'
              : requestReopened
              ? 'Reopened'
              : 'Open',
        ),
        const RecordCard(
          title: 'Espresso machine request',
          meta: 'Saved deal-history example',
          amount: 'Saved',
        ),
        PrimaryButton(
          label: 'Ask support to review deal',
          icon: Icons.support_agent_outlined,
          color: accent,
          onPressed: onWithdraw,
        ),
      ],
    );
  }
}

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({
    required this.accent,
    required this.onSubmit,
    super.key,
  });

  final Color accent;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return FormStepPage(
      accent: accent,
      title: 'Ask support to review deal',
      subtitle:
          'This saves a local support note only. It does not create a payout, refund, escrow, or item-payment workflow.',
      fields: const [
        MockFieldData('Deal or request', 'Espresso machine request'),
        MockFieldData('Reason', 'Review deal-history status'),
        MockFieldData('Notes', 'Confirm this local support note is accurate'),
      ],
      primaryLabel: 'Submit support note',
      onPrimary: onSubmit,
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({
    required this.accent,
    required this.onNotifications,
    required this.onSaved,
    required this.onSafety,
    required this.onReport,
    required this.onHelp,
    required this.onSettings,
    super.key,
  });

  final Color accent;
  final VoidCallback onNotifications;
  final VoidCallback onSaved;
  final VoidCallback onSafety;
  final VoidCallback onReport;
  final VoidCallback onHelp;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Support and safety',
      subtitle: 'Saved items, notifications, safety guide, help, and reports.',
      children: [
        AlertBanner(
          accent: accent,
          title: 'Safety first',
          body:
              'Pay for the item offline only after meeting publicly and inspecting the item.',
          icon: Icons.health_and_safety_outlined,
        ),
        MenuCard(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          body:
              'Offer updates, chat messages, meeting reminders, and system alerts.',
          color: accent,
          onTap: onNotifications,
        ),
        MenuCard(
          icon: Icons.bookmark_border,
          title: 'Saved favorites and requests',
          body: 'Saved sellers, watched requests, and empty states.',
          color: accent,
          onTap: onSaved,
        ),
        MenuCard(
          icon: Icons.shield_outlined,
          title: 'Safety guide',
          body: 'Meetup, payment, inspection, and reporting guidance.',
          color: accent,
          onTap: onSafety,
        ),
        MenuCard(
          icon: Icons.report_problem_outlined,
          title: 'Report user or deal',
          body: 'Report reason, notes, screenshots, and submission status.',
          color: HocalistTheme.danger,
          onTap: onReport,
        ),
        MenuCard(
          icon: Icons.support_agent_outlined,
          title: 'Help and support',
          body: 'FAQ, contact support, and loading/error states.',
          color: accent,
          onTap: onHelp,
        ),
        PrimaryButton(
          label: 'Account settings',
          icon: Icons.settings_outlined,
          color: accent,
          onPressed: onSettings,
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.accent,
    required this.role,
    required this.darkMode,
    required this.onEditProfile,
    required this.onThemeChanged,
    required this.onLogout,
    super.key,
  });

  final Color accent;
  final UserRole role;
  final bool darkMode;
  final VoidCallback onEditProfile;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final isSeller = role == UserRole.seller;
    final mutedStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted);

    return ScreenBlock(
      title: 'Account settings',
      subtitle: isSeller
          ? 'Manage seller profile, request visibility, alerts, safety, and saved local data.'
          : 'Manage buyer profile, request privacy, alerts, safety, and saved local data.',
      children: [
        SettingsProfileHeader(accent: accent, role: role),
        PrimaryButton(
          label: isSeller ? 'Edit seller profile' : 'Edit buyer profile',
          icon: Icons.edit_outlined,
          color: accent,
          onPressed: onEditProfile,
        ),
        SettingsSection(
          title: isSeller
              ? 'Seller profile controls'
              : 'Buyer request controls',
          children: isSeller
              ? [
                  SettingsActionTile(
                    icon: Icons.storefront_outlined,
                    title: 'Public seller profile',
                    body:
                        'Store name, category, verification badge, ratings, and public trust details.',
                    status: 'Preview',
                    accent: accent,
                  ),
                  SettingsActionTile(
                    icon: Icons.travel_explore_outlined,
                    title: 'Service area and meetup radius',
                    body:
                        'Where your offers appear and where you can meet buyers.',
                    status: '15 mi',
                    accent: accent,
                  ),
                  SettingsActionTile(
                    icon: Icons.workspace_premium_outlined,
                    title: 'Plan and credit visibility',
                    body:
                        'Seller platform access remains mock-only until Phase 2 billing.',
                    status: 'Mock',
                    accent: accent,
                  ),
                ]
              : [
                  SettingsActionTile(
                    icon: Icons.assignment_outlined,
                    title: 'Request privacy defaults',
                    body:
                        'Show item need, budget, and approximate area before seller selection.',
                    status: 'Limited',
                    accent: accent,
                  ),
                  SettingsActionTile(
                    icon: Icons.location_on_outlined,
                    title: 'Preferred buyer area',
                    body:
                        'Set city and pickup radius used by new request drafts.',
                    status: '12 mi',
                    accent: accent,
                  ),
                  SettingsActionTile(
                    icon: Icons.bookmark_border,
                    title: 'Saved sellers and backups',
                    body:
                        'Keep backup offers and saved sellers available during deal recovery.',
                    status: 'Ready',
                    accent: accent,
                  ),
                ],
        ),
        SettingsSection(
          title: 'Profile and access',
          children: [
            SettingsActionTile(
              icon: Icons.person_outline,
              title: 'Personal information',
              body: 'Name, email, phone, and preferred contact method.',
              status: 'Review',
              accent: accent,
            ),
            SettingsActionTile(
              icon: Icons.location_on_outlined,
              title: 'Local marketplace area',
              body:
                  'Approximate city and pickup radius. Exact meeting details stay in chat.',
              status: 'Chicago',
              accent: accent,
            ),
            SettingsActionTile(
              icon: Icons.lock_outline,
              title: 'Password and sign-in',
              body: 'Password, saved session, and future device security.',
              status: 'Protected',
              accent: accent,
            ),
          ],
        ),
        SettingsSection(
          title: 'Theme',
          children: [
            SettingsPreferenceRow(
              icon: darkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              title: darkMode ? 'Dark mode' : 'Light mode',
              body:
                  'Choose the app appearance for this device. This mock preference is saved locally.',
              enabled: darkMode,
              accent: accent,
              onChanged: onThemeChanged,
            ),
          ],
        ),
        SettingsSection(
          title: 'Notifications',
          children: [
            SettingsPreferenceRow(
              icon: Icons.local_offer_outlined,
              title: 'Offer updates',
              body: 'New offers, selected seller, and backup offer activity.',
              enabled: true,
              accent: accent,
            ),
            SettingsPreferenceRow(
              icon: Icons.chat_bubble_outline,
              title: 'Chat and meeting reminders',
              body: 'Private chat, meetup notes, and completion reminders.',
              enabled: true,
              accent: accent,
            ),
            SettingsPreferenceRow(
              icon: Icons.campaign_outlined,
              title: 'Product and launch updates',
              body: 'Early-access messages, feature notices, and support tips.',
              enabled: false,
              accent: accent,
            ),
          ],
        ),
        SettingsSection(
          title: 'Privacy and safety',
          children: [
            SettingsActionTile(
              icon: Icons.visibility_off_outlined,
              title: 'Public request privacy',
              body:
                  'Show approximate location only until a seller is selected.',
              status: 'Limited',
              accent: accent,
            ),
            SettingsActionTile(
              icon: Icons.shield_outlined,
              title: 'Blocked users and reports',
              body:
                  'Review safety reports, blocked accounts, and support status.',
              status: '0 open',
              accent: accent,
            ),
            SettingsActionTile(
              icon: Icons.health_and_safety_outlined,
              title: 'Offline payment safety',
              body:
                  'Hocalist does not process, hold, ship, or guarantee item payment.',
              status: 'Guide',
              accent: accent,
            ),
          ],
        ),
        SettingsSection(
          title: 'Local data',
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: accent.withValues(alpha: 0.12),
                      foregroundColor: accent,
                      child: const Icon(Icons.offline_pin_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress saved on this device',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'This Stage 2 prototype stores demo flow progress locally for review.',
                            style: mutedStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SoftChip(
                      label: 'Mock settings',
                      color: accent.withValues(alpha: 0.12),
                      foreground: accent,
                    ),
                    const SoftChip(
                      label: 'No live account deletion',
                      color: Color(0xffffeeee),
                      foreground: HocalistTheme.danger,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        AlertBanner(
          accent: HocalistTheme.danger,
          title: 'Account removal is not live',
          body:
              'Delete-account and export-data actions need backend, auth, and support workflows before release.',
          icon: Icons.warning_amber_outlined,
        ),
        PrimaryButton(
          label: 'Save mock preferences',
          icon: Icons.check_circle_outline,
          color: accent,
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Mock settings saved for review.'),
                ),
              );
          },
        ),
        SecondaryButton(label: 'Log out', color: accent, onPressed: onLogout),
      ],
    );
  }
}

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({
    required this.accent,
    required this.role,
    required this.name,
    required this.onNameChanged,
    required this.onDone,
    super.key,
  });

  final Color accent;
  final UserRole role;
  final String name;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final isSeller = role == UserRole.seller;
    return ScreenBlock(
      title: isSeller ? 'Edit seller profile' : 'Edit buyer profile',
      subtitle: isSeller
          ? 'Update the seller details buyers use to judge trust, location fit, and response expectations.'
          : 'Update the buyer details sellers use to understand request fit and safe meetup preferences.',
      children: [
        AlertBanner(
          accent: accent,
          title: 'Phase 1 local profile',
          body:
              'These profile edits are saved in the local prototype session only. Backend profile storage is deferred.',
          icon: Icons.info_outline,
        ),
        AppCard(
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  labelText: isSeller ? 'Store or seller name' : 'Full name',
                ),
                onChanged: onNameChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: isSeller
                    ? 'Electronics, tablets, accessories'
                    : 'Electronics, home goods, local pickup',
                decoration: InputDecoration(
                  labelText: isSeller
                      ? 'Seller categories'
                      : 'Preferred request categories',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: isSeller
                    ? 'Verified seller, public pickup preferred'
                    : 'Prefers public meetup points and verified sellers',
                decoration: const InputDecoration(labelText: 'Profile note'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        LocationSearchPanel(
          accent: accent,
          title: isSeller ? 'Service area' : 'Default request area',
          locationValue: isSeller ? 'Chicago north side' : 'Chicago, IL',
          radiusValue: isSeller ? 'Within 15 miles' : 'Within 12 miles',
          hint: isSeller
              ? 'Seller service area is mock-only until Google Maps and backend profile storage are connected.'
              : 'Buyer default request area is approximate until a seller is selected.',
        ),
        PrimaryButton(
          label: 'Save profile edits',
          icon: Icons.check_circle_outline,
          color: accent,
          onPressed: onDone,
        ),
      ],
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({
    required this.accent,
    required this.sellerMode,
    required this.requestPosted,
    required this.sellerOfferSent,
    required this.offerSelected,
    required this.meetingConfirmed,
    required this.dealCompleted,
    required this.withdrawalRequested,
    required this.reportSubmitted,
    super.key,
  });

  final Color accent;
  final bool sellerMode;
  final bool requestPosted;
  final bool sellerOfferSent;
  final bool offerSelected;
  final bool meetingConfirmed;
  final bool dealCompleted;
  final bool withdrawalRequested;
  final bool reportSubmitted;

  @override
  Widget build(BuildContext context) {
    final title = sellerMode ? 'Seller notifications' : 'Notifications';
    final subtitle = sellerMode
        ? 'Buyer selections, messages, seller-tool credits, and verification alerts.'
        : 'Offer updates, chat messages, meeting reminders, and safety alerts.';

    return ScreenBlock(
      title: title,
      subtitle: subtitle,
      children: [
        AlertBanner(
          accent: accent,
          title: sellerMode
              ? offerSelected
                    ? 'Offer selected'
                    : 'Seller inbox ready'
              : sellerOfferSent || requestPosted
              ? 'New offer received'
              : 'Notification center ready',
          body: sellerMode
              ? offerSelected
                    ? 'Maya selected your iPad Air offer. Chat is now open.'
                    : 'Selections, messages, seller-tool alerts, and verification updates appear here.'
              : sellerOfferSent || requestPosted
              ? 'Northside Tech sent an offer for your iPad Air request.'
              : 'Post a request to create offer, chat, meeting, deal-history, and safety alerts.',
          icon: sellerMode
              ? Icons.check_circle_outline
              : Icons.local_offer_outlined,
        ),
        if (requestPosted && !sellerMode)
          NotificationTile(
            accent: accent,
            icon: Icons.publish_outlined,
            title: 'Request posted',
            body: 'Your buying request is active for nearby verified sellers.',
            time: 'Just now',
          ),
        if (sellerOfferSent && sellerMode)
          NotificationTile(
            accent: accent,
            icon: Icons.outgoing_mail,
            title: 'Offer sent',
            body: 'Your iPad Air offer is live in the buyer comparison view.',
            time: 'Just now',
          ),
        if (offerSelected)
          NotificationTile(
            accent: accent,
            icon: Icons.check_circle_outline,
            title: sellerMode ? 'Buyer selected you' : 'Seller selected',
            body: sellerMode
                ? 'Maya selected your offer and opened the chatroom.'
                : 'Northside Tech is selected. Continue through chat and meeting details.',
            time: 'Just now',
          ),
        NotificationTile(
          accent: accent,
          icon: Icons.chat_bubble_outline,
          title: 'Chat message',
          body: sellerMode
              ? 'Buyer asked if Saturday pickup still works.'
              : 'Seller confirmed public pickup and keyboard case.',
          time: '4 min ago',
        ),
        NotificationTile(
          accent: accent,
          icon: Icons.event_available_outlined,
          title: 'Meeting reminder',
          body: meetingConfirmed
              ? 'Confirmed for Saturday, 2:30 PM at Wicker Park public pickup point.'
              : 'Meeting reminders appear after both sides confirm details.',
          time: meetingConfirmed ? 'Today' : 'Pending',
        ),
        if (dealCompleted)
          NotificationTile(
            accent: accent,
            icon: Icons.task_alt_outlined,
            title: 'Deal completed',
            body:
                'The app recorded completion; item payment stayed outside Hocalist.',
            time: 'Today',
          ),
        if (withdrawalRequested && !sellerMode)
          NotificationTile(
            accent: accent,
            icon: Icons.support_agent_outlined,
            title: 'Support review in progress',
            body: 'Support will review this local note in a later phase.',
            time: 'Today',
          ),
        if (reportSubmitted)
          NotificationTile(
            accent: HocalistTheme.danger,
            icon: Icons.report_problem_outlined,
            title: 'Report submitted',
            body: 'The report is queued for admin moderation review.',
            time: 'Today',
          ),
        NotificationTile(
          accent: accent,
          icon: sellerMode
              ? Icons.storefront_outlined
              : Icons.fact_check_outlined,
          title: sellerMode
              ? 'Seller access credits low'
              : 'Deal history pending',
          body: sellerMode
              ? '42 credits remain. Packages are managed by admin configuration.'
              : 'Your buyer deal history is pending confirmation. Item payment remains offline.',
          time: 'Yesterday',
        ),
        EmptyStatePanel(
          accent: accent,
          title: 'All caught up',
          body:
              'Older notifications will appear here after backend history is connected.',
        ),
      ],
    );
  }
}

class SavedItemsPage extends StatelessWidget {
  const SavedItemsPage({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Saved favorites',
      subtitle: 'Saved sellers, watched requests, and empty-state treatment.',
      children: [
        BuyerRequestCard(
          title: 'Saved request: compact espresso machine',
          budget: 'Up to \$220',
          location: 'Pickup preferred',
          status: 'Watching',
          onTap: () {},
        ),
        SellerOfferCard(
          seller: 'Favorite seller: Northside Tech',
          price: '4.9',
          detail: 'Verified electronics seller saved from a previous offer.',
          status: 'Favorite',
          accent: accent,
          onTap: () {},
        ),
        EmptyStatePanel(
          accent: accent,
          title: 'No saved searches yet',
          body:
              'When a buyer saves filters or a seller saves request searches, they will appear in this state.',
        ),
      ],
    );
  }
}

class SafetyGuidePage extends StatelessWidget {
  const SafetyGuidePage({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Safety guide',
      subtitle: 'Visible guidance from the Stitch safety screens.',
      children: [
        AlertBanner(
          accent: accent,
          title: 'Offline payment only',
          body:
              'Hocalist does not hold money, ship items, provide escrow, or guarantee payment.',
          icon: Icons.info_outline,
        ),
        const InfoList(
          items: [
            'Meet in a public location with good lighting.',
            'Inspect the item before paying or handing it over.',
            'Do not share verification codes, passwords, or private banking details.',
            'Use report tools if the item, user, or meeting feels unsafe.',
          ],
        ),
        LoadingStatePanel(accent: accent),
      ],
    );
  }
}

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({
    required this.accent,
    required this.submitted,
    required this.onSubmit,
    super.key,
  });

  final Color accent;
  final bool submitted;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (submitted) {
      return ScreenBlock(
        title: 'Report submitted',
        subtitle: 'The issue is saved for admin moderation review.',
        children: [
          AlertBanner(
            accent: HocalistTheme.danger,
            title: 'Admin review pending',
            body:
                'Your report stays attached to this session until the admin backend is connected.',
            icon: Icons.admin_panel_settings_outlined,
          ),
          const InfoList(
            items: [
              'Reason: Item did not match offer',
              'Evidence: 1 attached photo',
              'Status: pending admin review',
            ],
          ),
        ],
      );
    }

    return ScreenBlock(
      title: 'Report user or deal',
      subtitle: 'Choose a reason, add notes, and attach evidence.',
      children: [
        AlertBanner(
          accent: HocalistTheme.danger,
          title: 'Reports are reviewed by admin',
          body:
              'This report is saved on this device now and will move to admin moderation when backend storage is connected.',
          icon: Icons.report_problem_outlined,
        ),
        AppCard(
          child: Column(
            children: [
              TextFormField(
                initialValue: 'Item did not match offer',
                decoration: const InputDecoration(labelText: 'Report reason'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue:
                    'Seller photos did not match the item shown at pickup.',
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Describe the issue',
                ),
              ),
            ],
          ),
        ),
        UploadBox(accent: HocalistTheme.danger, label: 'Attach evidence'),
        PrimaryButton(
          label: 'Submit report',
          icon: Icons.outgoing_mail,
          color: HocalistTheme.danger,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Help and support',
      subtitle: 'FAQ, support contact, loading, and error states.',
      children: [
        const InfoList(
          items: [
            'How buyer requests work',
            'How sellers send offers',
            'Why item payment is offline',
            'How to report unsafe behavior',
          ],
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact support',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'I need help with my selected offer.',
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
        ),
        ErrorStatePanel(
          accent: accent,
          title: 'Could not load older tickets',
          body:
              'Retry state for support history once backend data is connected.',
        ),
      ],
    );
  }
}

class SellerVerificationPage extends StatelessWidget {
  const SellerVerificationPage({
    required this.accent,
    required this.onFinish,
    super.key,
  });

  final Color accent;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Seller verification',
      subtitle:
          'Show verification states before a seller starts sending offers.',
      children: [
        StatusTimeline(
          accent: accent,
          items: const [
            'Profile complete',
            'Identity pending',
            'Ready to browse requests',
          ],
        ),
        PrimaryButton(
          label: 'Enter seller dashboard',
          icon: Icons.verified_user_outlined,
          color: accent,
          onPressed: onFinish,
        ),
      ],
    );
  }
}

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({
    required this.sellerName,
    required this.accent,
    required this.sellerOfferSent,
    required this.offerSelected,
    required this.meetingConfirmed,
    required this.restoredSession,
    required this.onBrowse,
    required this.onBilling,
    required this.onHistory,
    super.key,
  });

  final String sellerName;
  final Color accent;
  final bool sellerOfferSent;
  final bool offerSelected;
  final bool meetingConfirmed;
  final bool restoredSession;
  final VoidCallback onBrowse;
  final VoidCallback onBilling;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: sellerName,
      subtitle: 'Find ready buyers and send focused offers.',
      children: [
        DashboardHero(
          accent: accent,
          title: 'Demand you can act on',
          body:
              'Browse buyer requests, check fit, then spend mock seller credits only when you choose to send an offer.',
          icon: Icons.travel_explore_outlined,
          actionLabel: 'Browse requests',
          onAction: onBrowse,
        ),
        AlertBanner(
          accent: accent,
          title: sellerOfferSent
              ? restoredSession
                    ? 'Offer restored on this device'
                    : 'Offer saved on this device'
              : 'Ready for buyer demand',
          body: sellerOfferSent
              ? offerSelected
                    ? 'Your offer was selected. The chat and deal workflow are active.'
                    : 'Your latest offer appears in offer history and buyer comparison while you review the flow.'
              : 'Browse active requests and send an offer to see the seller state update.',
          icon: sellerOfferSent
              ? Icons.offline_pin_outlined
              : Icons.search_outlined,
        ),
        if (meetingConfirmed)
          AlertBanner(
            accent: accent,
            title: 'Meeting confirmed',
            body:
                'Bring the item Saturday at 2:30 PM. Payment is handled offline at pickup.',
            icon: Icons.event_available_outlined,
          ),
        SectionLabel(
          title: 'High-fit requests',
          action: sellerOfferSent ? 'Offer sent' : 'Ready to browse',
        ),
        BuyerRequestCard(
          title: 'Buyer wants iPad Air this week',
          budget: '\$350 - \$480',
          location: '4.2 miles away',
          status: 'High fit',
          onTap: onBrowse,
        ),
        PrimaryButton(
          label: 'Browse buyer requests',
          icon: Icons.search,
          color: accent,
          onPressed: onBrowse,
        ),
        SecondaryButton(
          label: 'Offer history',
          color: accent,
          onPressed: onHistory,
        ),
        SecondaryButton(
          label: 'Seller tools',
          color: accent,
          onPressed: onBilling,
        ),
      ],
    );
  }
}

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({
    required this.accent,
    required this.onOpen,
    super.key,
  });

  final Color accent;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Request marketplace',
      subtitle:
          'Filter active buyer demand before sending an offer. Values here are prototype examples, not backend business rules.',
      children: [
        TextFormField(
          initialValue: 'tablet, espresso, furniture',
          decoration: const InputDecoration(labelText: 'Search requests'),
        ),
        const SizedBox(height: 12),
        LocationSearchPanel(
          accent: accent,
          title: 'Search by location',
          locationValue: 'Chicago, IL',
          radiusValue: 'Within 15 miles',
          hint:
              'Future Google Maps search: sellers can search a city, area, or map pin before browsing buyer requests.',
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                'Nearby',
                'Electronics',
                'Budget matched',
                'New today',
                'Saved',
              ].map((label) {
                return SoftChip(
                  label: label,
                  color: accent.withValues(alpha: 0.12),
                  foreground: accent,
                );
              }).toList(),
        ),
        AlertBanner(
          accent: accent,
          title: 'Seller tools only',
          body:
              'Credits are seller-tool examples in this prototype. Hocalist does not process buyer item payments.',
          icon: Icons.storefront_outlined,
        ),
        ResponsiveCardGrid(
          children: [
            BuyerRequestCard(
              title: 'Looking for a used iPad Air',
              budget: '\$350 - \$480',
              location: 'Wicker Park',
              status: 'New',
              onTap: onOpen,
            ),
            BuyerRequestCard(
              title: 'Need office bookshelf',
              budget: 'Up to \$160',
              location: 'Logan Square',
              status: 'Saved',
              onTap: onOpen,
            ),
          ],
        ),
        SectionLabel(title: 'Other request states', action: 'Mock-only'),
        ResponsiveCardGrid(
          children: [
            EmptyStatePanel(
              accent: accent,
              title: 'No requests found nearby',
              body:
                  'Try expanding the location radius, changing the category, or saving this search for later.',
            ),
            ErrorStatePanel(
              accent: accent,
              title: 'Expired request',
              body:
                  'This buyer request is no longer accepting offers. Sellers should choose another active request.',
            ),
          ],
        ),
      ],
    );
  }
}

class SellerRequestDetailPage extends StatelessWidget {
  const SellerRequestDetailPage({
    required this.accent,
    required this.onOffer,
    super.key,
  });

  final Color accent;
  final VoidCallback onOffer;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Buyer request detail',
      subtitle:
          'Review the request, budget, location, and timing before offering.',
      children: [
        RouteContextBanner(
          accent: accent,
          label: 'Seller flow',
          text: 'Browse request -> check fit -> send offer',
        ),
        BuyerRequestCard(
          title: 'Looking for a used iPad Air',
          budget: '\$350 - \$480',
          location: 'Wicker Park',
          status: '12 offers max',
          onTap: onOffer,
        ),
        LocationSummaryCard(
          accent: accent,
          title: 'Request geography',
          address: 'Wicker Park area, Chicago',
          distance: '4.2 miles from Northside Tech service area',
          privacyNote:
              'Seller sees approximate buyer area until the buyer selects an offer and chat opens.',
        ),
        const InfoList(
          items: [
            'Buyer prefers pickup this week',
            'Reference photos attached',
            'Seller credits required: shown from admin-managed rules',
          ],
        ),
        PrimaryButton(
          label: 'Send offer',
          icon: Icons.send_outlined,
          color: accent,
          onPressed: onOffer,
        ),
      ],
    );
  }
}

class SendOfferPage extends StatelessWidget {
  const SendOfferPage({
    required this.accent,
    required this.price,
    required this.onPriceChanged,
    required this.onSubmit,
    super.key,
  });

  final Color accent;
  final String price;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Send offer',
      subtitle: 'Price, terms, message, availability, and item photos.',
      children: [
        AppCard(
          child: Column(
            children: [
              TextFormField(
                initialValue: price,
                decoration: const InputDecoration(labelText: 'Offer price'),
                onChanged: onPriceChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Saturday afternoon',
                decoration: const InputDecoration(labelText: 'Availability'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Wicker Park public pickup points',
                decoration: const InputDecoration(
                  labelText: 'Meetup or service area',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'Great condition iPad Air with keyboard case.',
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
        ),
        LocationSummaryCard(
          accent: accent,
          title: 'Offer location preview',
          address: 'Seller can meet near Wicker Park',
          distance:
              'Public place selection happens if buyer chooses this offer',
          privacyNote:
              'Do not expose exact private addresses before seller selection.',
        ),
        UploadBox(accent: accent, label: 'Attach item photos'),
        PrimaryButton(
          label: 'Send offer',
          icon: Icons.outgoing_mail,
          color: accent,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

class SellerOfferHistoryPage extends StatelessWidget {
  const SellerOfferHistoryPage({
    required this.accent,
    required this.sellerOfferSent,
    required this.offerSelected,
    required this.onOpen,
    super.key,
  });

  final Color accent;
  final bool sellerOfferSent;
  final bool offerSelected;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Offer history',
      subtitle: 'Track open, selected, and retracted offers.',
      children: [
        AlertBanner(
          accent: accent,
          title: sellerOfferSent ? 'Latest offer saved' : 'Offer history ready',
          body: sellerOfferSent
              ? 'This list is now reacting to the offer you sent in this walkthrough.'
              : 'Send an offer from marketplace to update this history.',
          icon: Icons.history_outlined,
        ),
        SellerOfferCard(
          seller: 'Maya Chen',
          price: '\$420',
          detail: sellerOfferSent
              ? 'iPad Air request. Your newly submitted offer is visible here.'
              : 'iPad Air request. Buyer selected this offer.',
          status: offerSelected
              ? 'Selected'
              : sellerOfferSent
              ? 'Open'
              : 'Selected',
          accent: accent,
          onTap: onOpen,
        ),
        SellerOfferCard(
          seller: 'Owen Patel',
          price: '\$155',
          detail: 'Office bookshelf request.',
          status: 'Open',
          accent: accent,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class SellerOfferDetailPage extends StatelessWidget {
  const SellerOfferDetailPage({
    required this.accent,
    required this.onChat,
    super.key,
  });

  final Color accent;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Seller offer detail',
      subtitle: 'Offer state, buyer request, and next action.',
      children: [
        RouteContextBanner(
          accent: accent,
          label: 'Seller flow',
          text: 'Track offer status and open chat after selection',
        ),
        SellerOfferCard(
          seller: 'Maya Chen',
          price: '\$420',
          detail: 'Selected by buyer. Chat is now open.',
          status: 'Selected',
          accent: accent,
          onTap: onChat,
        ),
        const InfoList(
          items: [
            'Offer can no longer be retracted after buyer selection',
            'Chatroom created',
            'Deal details pending confirmation',
          ],
        ),
        PrimaryButton(
          label: 'Open chat',
          icon: Icons.chat_bubble_outline,
          color: accent,
          onPressed: onChat,
        ),
      ],
    );
  }
}

class SellerBillingPage extends StatelessWidget {
  const SellerBillingPage({
    required this.accent,
    required this.onPayment,
    super.key,
  });

  final Color accent;
  final VoidCallback onPayment;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Seller tools and credits',
      subtitle:
          'Phase 1 shows seller access tools only. Live plans, prices, and payment setup are deferred.',
      children: [
        MetricRow(
          accent: accent,
          values: const [
            Metric('42', 'Credits'),
            Metric('Mock', 'Plan'),
            Metric('Active', 'Status'),
          ],
        ),
        const InfoList(
          items: [
            'Seller plan name and pricing are admin-managed mock values',
            'Credit package examples are mock-only until owner-approved',
            'Credit usage rules come from admin configuration',
          ],
        ),
        PrimaryButton(
          label: 'Review seller access placeholder',
          icon: Icons.storefront_outlined,
          color: accent,
          onPressed: onPayment,
        ),
      ],
    );
  }
}

class SellerPaymentPage extends StatelessWidget {
  const SellerPaymentPage({
    required this.accent,
    required this.onDone,
    super.key,
  });

  final Color accent;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return FormStepPage(
      accent: accent,
      title: 'Seller access placeholder',
      subtitle:
          'Mock seller tools setup only. No live prices, card collection, or buyer item payment processing.',
      fields: const [
        MockFieldData('Status', 'Mock setup only'),
        MockFieldData('Seller contact', 'seller-tools@northsidetech.example'),
        MockFieldData('Plan label', 'Admin-managed mock value'),
      ],
      primaryLabel: 'Save mock seller-tools note',
      onPrimary: onDone,
    );
  }
}

class SellerProfilePage extends StatelessWidget {
  const SellerProfilePage({
    required this.accent,
    required this.onNotifications,
    required this.onSafety,
    required this.onHelp,
    required this.onEditProfile,
    required this.onSettings,
    required this.onLogout,
    super.key,
  });

  final Color accent;
  final VoidCallback onNotifications;
  final VoidCallback onSafety;
  final VoidCallback onHelp;
  final VoidCallback onEditProfile;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: 'Seller profile',
      subtitle: 'Private setup and public seller profile preview.',
      children: [
        ProfileCard(
          accent: accent,
          title: 'Northside Tech',
          body: '4.9 rating, 134 completed deals, verified electronics seller.',
        ),
        PrimaryButton(
          label: 'Edit seller profile',
          icon: Icons.edit_outlined,
          color: accent,
          onPressed: onEditProfile,
        ),
        MenuCard(
          icon: Icons.notifications_outlined,
          title: 'Seller notifications',
          body:
              'Buyer selections, chat, meeting changes, credits, and seller-tool alerts.',
          color: accent,
          onTap: onNotifications,
        ),
        MenuCard(
          icon: Icons.shield_outlined,
          title: 'Safety guide',
          body: 'Seller meetup, item handoff, and report guidance.',
          color: accent,
          onTap: onSafety,
        ),
        MenuCard(
          icon: Icons.support_agent_outlined,
          title: 'Help and support',
          body: 'Seller FAQ, access-tool support, and issue escalation.',
          color: accent,
          onTap: onHelp,
        ),
        MenuCard(
          icon: Icons.settings_outlined,
          title: 'Account settings',
          body: 'Contact, notifications, privacy, and logout.',
          color: accent,
          onTap: onSettings,
        ),
        SecondaryButton(label: 'Log out', color: accent, onPressed: onLogout),
      ],
    );
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({
    required this.accent,
    required this.icon,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
    super.key,
  });

  final Color accent;
  final IconData icon;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: title,
      subtitle: body,
      children: [
        AppCard(
          child: Center(child: Icon(icon, color: accent, size: 56)),
        ),
        PrimaryButton(
          label: primaryLabel,
          icon: Icons.arrow_forward,
          color: accent,
          onPressed: onPrimary,
        ),
        SecondaryButton(
          label: secondaryLabel,
          color: accent,
          onPressed: onSecondary,
        ),
      ],
    );
  }
}

class FormStepPage extends StatelessWidget {
  const FormStepPage({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
  });

  final Color accent;
  final String title;
  final String subtitle;
  final List<MockFieldData> fields;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: title,
      subtitle: subtitle,
      children: [
        AppCard(
          child: Column(
            children: fields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  initialValue: field.value,
                  decoration: InputDecoration(labelText: field.label),
                ),
              );
            }).toList(),
          ),
        ),
        PrimaryButton(
          label: primaryLabel,
          icon: Icons.arrow_forward,
          color: accent,
          onPressed: onPrimary,
        ),
      ],
    );
  }
}
