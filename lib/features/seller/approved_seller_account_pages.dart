import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/input_foundation.dart';
import '../../theme/seller_ui_foundation.dart';

enum SellerProfilePhotoAction { camera, gallery, remove }

class ApprovedSellerProfilePage extends StatelessWidget {
  const ApprovedSellerProfilePage({
    required this.sellerName,
    required this.onBack,
    required this.onEditProfile,
    this.onProfilePhotoAction,
    super.key,
  });

  final String sellerName;
  final VoidCallback onBack;
  final VoidCallback onEditProfile;
  final ValueChanged<SellerProfilePhotoAction>? onProfilePhotoAction;

  @override
  Widget build(BuildContext context) {
    return _SellerSubpageBlock(
      key: const Key('approvedSellerProfilePage'),
      title: 'Seller Profile',
      subtitle: 'Review the trust and service details buyers can see.',
      onBack: onBack,
      children: [
        _SellerProfileSummary(
          sellerName: sellerName,
          onProfilePhotoAction: onProfilePhotoAction,
        ),
        const _SellerSubpageSection(
          title: 'Public details',
          children: [
            _SellerSubpageRow(
              icon: Icons.category_outlined,
              title: 'Seller categories',
              body: 'Electronics, tablets, and accessories.',
              status: 'Visible to buyers',
            ),
            _SellerSubpageRow(
              icon: Icons.travel_explore_outlined,
              title: 'Service area',
              body: 'Chicago north side and nearby public meetup locations.',
              status: 'Within 15 miles',
            ),
            _SellerSubpageRow(
              icon: Icons.verified_user_outlined,
              title: 'Trust details',
              body: 'Verification, ratings, and completed-deal history.',
              status: 'Verified seller',
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) => FilledButton.icon(
              key: const Key('sellerProfileEdit'),
              onPressed: onEditProfile,
              style: _sellerFilledButtonStyle(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit profile'),
            ),
          ),
        ),
      ],
    );
  }
}

class ApprovedSellerSettingsPage extends StatelessWidget {
  const ApprovedSellerSettingsPage({
    required this.darkMode,
    required this.textSizeLabel,
    required this.onBack,
    required this.onEditProfile,
    required this.onThemeChanged,
    required this.onAccessibility,
    super.key,
  });

  final bool darkMode;
  final String textSizeLabel;
  final VoidCallback onBack;
  final VoidCallback onEditProfile;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onAccessibility;

  @override
  Widget build(BuildContext context) {
    return _SellerSubpageBlock(
      key: const Key('approvedSellerSettingsPage'),
      title: 'Account Settings',
      subtitle: 'Manage your Seller account, preferences, and privacy.',
      onBack: onBack,
      children: [
        _SellerSubpageSection(
          title: 'Account',
          children: [
            _SellerSubpageRow(
              icon: Icons.storefront_outlined,
              title: 'Seller information',
              body: 'Review and update your Seller profile information.',
              onTap: onEditProfile,
            ),
            const _SellerSubpageRow(
              icon: Icons.lock_outline,
              title: 'Password & security',
              body:
                  'Password changes require connected account authentication.',
              status: 'Not currently available',
            ),
          ],
        ),
        _SellerSubpageSection(
          title: 'Preferences',
          children: [
            _SellerPreferenceSwitch(
              icon: darkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              title: 'Appearance',
              body: darkMode
                  ? 'Dark theme is active.'
                  : 'Light theme is active.',
              value: darkMode,
              onChanged: onThemeChanged,
            ),
            _SellerSubpageRow(
              icon: Icons.accessibility_new,
              title: 'Accessibility',
              body: 'Text size, font readability, and button visibility.',
              status: textSizeLabel,
              onTap: onAccessibility,
            ),
          ],
        ),
        const _SellerSubpageSection(
          title: 'Marketplace privacy',
          children: [
            _SellerSubpageRow(
              icon: Icons.visibility_outlined,
              title: 'Public Seller visibility',
              body:
                  'Buyers see trust and service details without private contact information.',
              status: 'Limited profile',
            ),
            _SellerSubpageRow(
              icon: Icons.location_on_outlined,
              title: 'Service-area privacy',
              body:
                  'Only your approximate service area is shown before a meeting is confirmed.',
              status: 'Approximate location',
            ),
          ],
        ),
        const _SellerSubpageSection(
          title: 'Account management',
          children: [
            _SellerSubpageRow(
              icon: Icons.manage_accounts_outlined,
              title: 'No account-management actions available',
              body:
                  'Delete and export actions remain hidden until secure account services support them.',
            ),
          ],
        ),
      ],
    );
  }
}

class ApprovedSellerEditProfilePage extends StatelessWidget {
  const ApprovedSellerEditProfilePage({
    required this.name,
    required this.onNameChanged,
    required this.onBack,
    required this.onDone,
    this.onProfilePhotoAction,
    super.key,
  });

  final String name;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onBack;
  final VoidCallback onDone;
  final ValueChanged<SellerProfilePhotoAction>? onProfilePhotoAction;

  @override
  Widget build(BuildContext context) {
    return _SellerSubpageBlock(
      key: const Key('approvedSellerEditProfilePage'),
      title: 'Edit Profile',
      subtitle: 'Keep your Seller information accurate and concise.',
      onBack: onBack,
      children: [
        _SellerSubpageSection(
          title: 'Profile picture',
          children: [
            _SellerProfilePhotoEditor(
              sellerName: name,
              onProfilePhotoAction: onProfilePhotoAction,
            ),
          ],
        ),
        _SellerSubpageSection(
          title: 'Seller information',
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Builder(
                builder: (context) {
                  final metrics = ApprovedReplicaScope.of(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SellerProfileField(
                        initialValue: name,
                        label: 'Store or seller name',
                        textInputAction: TextInputAction.next,
                        onChanged: onNameChanged,
                      ),
                      SizedBox(
                        height: metrics.spacing(
                          HocalistInputTokens.relatedFieldSpacing,
                        ),
                      ),
                      const _SellerProfileField(
                        initialValue: 'northside.tech@example.com',
                        label: 'Email',
                        readOnly: true,
                        helperText:
                            'Email changes require account verification.',
                      ),
                      SizedBox(height: metrics.spacing(14)),
                      const _SellerProfileField(
                        initialValue: 'Electronics, tablets, accessories',
                        label: 'Seller categories',
                      ),
                      SizedBox(height: metrics.spacing(14)),
                      const _SellerProfileField(
                        initialValue: 'Chicago north side',
                        label: 'Service area',
                        helperText:
                            'Your exact meetup location remains private until confirmed in chat.',
                      ),
                      SizedBox(height: metrics.spacing(14)),
                      const _SellerProfileField(
                        initialValue:
                            'Verified seller; public pickup preferred.',
                        label: 'Profile note',
                        maxLines: 2,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) {
              final metrics = ApprovedReplicaScope.of(context);
              return SizedBox(
                height: metrics.geometry(48),
                child: FilledButton.icon(
                  key: const Key('sellerSaveProfile'),
                  onPressed: onDone,
                  style: _sellerFilledButtonStyle(context),
                  icon: Icon(
                    Icons.check_circle_outline,
                    size: metrics.artSize(20),
                  ),
                  label: const Text('Save profile'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ApprovedSellerNotificationPreferencesPage extends StatefulWidget {
  const ApprovedSellerNotificationPreferencesPage({
    required this.onBack,
    super.key,
  });

  final VoidCallback onBack;

  @override
  State<ApprovedSellerNotificationPreferencesPage> createState() =>
      _ApprovedSellerNotificationPreferencesPageState();
}

class _ApprovedSellerNotificationPreferencesPageState
    extends State<ApprovedSellerNotificationPreferencesPage> {
  static const _leadsKey = 'hocalist.seller.notifications.leads';
  static const _offersKey = 'hocalist.seller.notifications.offers';
  static const _messagesKey = 'hocalist.seller.notifications.messages';
  static const _meetingsKey = 'hocalist.seller.notifications.meetings';
  static const _safetyKey = 'hocalist.seller.notifications.safety';

  bool leads = true;
  bool offers = true;
  bool messages = true;
  bool meetings = true;
  bool safety = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      leads = preferences.getBool(_leadsKey) ?? true;
      offers = preferences.getBool(_offersKey) ?? true;
      messages = preferences.getBool(_messagesKey) ?? true;
      meetings = preferences.getBool(_meetingsKey) ?? true;
      safety = preferences.getBool(_safetyKey) ?? true;
    });
  }

  Future<void> _update(String key, bool value, VoidCallback apply) async {
    setState(apply);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return _SellerSubpageBlock(
      key: const Key('approvedSellerNotificationsPage'),
      title: 'Notification Preferences',
      subtitle:
          'Choose the Seller updates you want. Preferences are saved on this device.',
      onBack: widget.onBack,
      children: [
        _SellerSubpageSection(
          title: 'Seller notifications',
          children: [
            _SellerPreferenceSwitch(
              icon: Icons.person_search_outlined,
              title: 'New leads',
              body: 'New buyer requests that match your Seller profile.',
              value: leads,
              onChanged: (value) =>
                  _update(_leadsKey, value, () => leads = value),
            ),
            _SellerPreferenceSwitch(
              icon: Icons.local_offer_outlined,
              title: 'Offer updates',
              body: 'Offer changes, buyer selections, and deal updates.',
              value: offers,
              onChanged: (value) =>
                  _update(_offersKey, value, () => offers = value),
            ),
            _SellerPreferenceSwitch(
              icon: Icons.chat_bubble_outline,
              title: 'Messages & chats',
              body: 'Messages from buyers and active conversation updates.',
              value: messages,
              onChanged: (value) =>
                  _update(_messagesKey, value, () => messages = value),
            ),
            _SellerPreferenceSwitch(
              icon: Icons.event_available_outlined,
              title: 'Meetings',
              body:
                  'Meeting reminders, confirmations, and reschedule requests.',
              value: meetings,
              onChanged: (value) =>
                  _update(_meetingsKey, value, () => meetings = value),
            ),
            _SellerPreferenceSwitch(
              icon: Icons.health_and_safety_outlined,
              title: 'Account & safety alerts',
              body: 'Security, verification, and important safety notices.',
              value: safety,
              onChanged: (value) =>
                  _update(_safetyKey, value, () => safety = value),
            ),
          ],
        ),
        const _SellerSubpageSection(
          title: 'Delivery',
          children: [
            _SellerSubpageRow(
              icon: Icons.notifications_active_outlined,
              title: 'Device delivery',
              body:
                  'Delivery still depends on operating-system permissions and connected notification services.',
              status: 'Preference storage is active',
            ),
          ],
        ),
      ],
    );
  }
}

class _SellerSubpageBlock extends StatelessWidget {
  const _SellerSubpageBlock({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaMetrics.resolve(
      availableWidth: MediaQuery.sizeOf(context).width,
      textScaler: MediaQuery.textScalerOf(context),
    );
    return ApprovedReplicaScope(
      metrics: metrics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: metrics.artSize(44),
                height: metrics.artSize(44),
                child: IconButton(
                  key: const Key('sellerSubpageBack'),
                  tooltip: 'Back',
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back,
                    color: SellerUiColors.ink,
                    size: metrics.artSize(23),
                  ),
                ),
              ),
              SizedBox(width: metrics.spacing(6)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: metrics.spacing(3)),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: sellerText(metrics, 16, weight: FontWeight.w800),
                      ),
                      SizedBox(height: metrics.spacing(3)),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: sellerText(
                          metrics,
                          12,
                          color: SellerUiColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: metrics.spacing(6)),
              SizedBox(width: metrics.artSize(44)),
            ],
          ),
          SizedBox(height: metrics.spacing(18)),
          ...children.expand(
            (child) => <Widget>[child, SizedBox(height: metrics.spacing(16))],
          ),
        ],
      ),
    );
  }
}

class _SellerSubpageSection extends StatelessWidget {
  const _SellerSubpageSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: metrics.spacing(2)),
          child: Text(
            title.toUpperCase(),
            style: sellerText(
              metrics,
              11,
              weight: FontWeight.w800,
              color: SellerUiColors.muted,
              letterSpacing: .8,
            ),
          ),
        ),
        SizedBox(height: metrics.spacing(7)),
        Material(
          color: SellerUiColors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: SellerUiColors.line),
            borderRadius: BorderRadius.circular(metrics.geometry(11)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  Divider(
                    height: 1,
                    indent: metrics.geometry(52),
                    color: SellerUiColors.line,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SellerSubpageRow extends StatelessWidget {
  const _SellerSubpageRow({
    required this.icon,
    required this.title,
    required this.body,
    this.status,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: metrics.spacing(12),
            vertical: metrics.spacing(11),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: metrics.artSize(34),
                height: metrics.artSize(34),
                decoration: const BoxDecoration(
                  color: SellerUiColors.lavender,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: SellerUiColors.primaryBright,
                  size: metrics.artSize(18),
                ),
              ),
              SizedBox(width: metrics.spacing(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: sellerText(metrics, 14, weight: FontWeight.w700),
                    ),
                    SizedBox(height: metrics.spacing(3)),
                    Text(
                      body,
                      style: sellerText(
                        metrics,
                        12,
                        color: SellerUiColors.muted,
                      ),
                    ),
                    if (status != null) ...[
                      SizedBox(height: metrics.spacing(5)),
                      Text(
                        status!,
                        style: sellerText(
                          metrics,
                          11,
                          weight: FontWeight.w700,
                          color: onTap == null
                              ? SellerUiColors.muted
                              : SellerUiColors.primaryBright,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                SizedBox(width: metrics.spacing(8)),
                Padding(
                  padding: EdgeInsets.only(top: metrics.spacing(7)),
                  child: Icon(
                    Icons.chevron_right,
                    color: SellerUiColors.muted,
                    size: metrics.artSize(20),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerPreferenceSwitch extends StatelessWidget {
  const _SellerPreferenceSwitch({
    required this.icon,
    required this.title,
    required this.body,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: SellerUiColors.primaryBright,
      contentPadding: EdgeInsets.symmetric(
        horizontal: metrics.spacing(12),
        vertical: metrics.spacing(4),
      ),
      secondary: Container(
        width: metrics.artSize(34),
        height: metrics.artSize(34),
        decoration: const BoxDecoration(
          color: SellerUiColors.lavender,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: SellerUiColors.primaryBright,
          size: metrics.artSize(18),
        ),
      ),
      title: Text(
        title,
        style: sellerText(metrics, 14, weight: FontWeight.w700),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: metrics.spacing(3)),
        child: Text(
          body,
          style: sellerText(metrics, 12, color: SellerUiColors.muted),
        ),
      ),
    );
  }
}

class _SellerProfileSummary extends StatelessWidget {
  const _SellerProfileSummary({
    required this.sellerName,
    this.onProfilePhotoAction,
  });

  final String sellerName;
  final ValueChanged<SellerProfilePhotoAction>? onProfilePhotoAction;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    final initial = sellerName.trim().isEmpty ? 'S' : sellerName.trim()[0];
    Future<void> changePhoto() => _showSellerProfilePhotoOptions(
      context,
      onSelected: onProfilePhotoAction,
    );
    return Container(
      padding: EdgeInsets.all(metrics.spacing(14)),
      decoration: BoxDecoration(
        color: SellerUiColors.lavender,
        border: Border.all(color: SellerUiColors.lavenderBorder),
        borderRadius: BorderRadius.circular(metrics.geometry(14)),
      ),
      child: Row(
        children: [
          _SellerProfileAvatar(
            initial: initial,
            metrics: metrics,
            onChangePhoto: changePhoto,
            actionKey: const Key('sellerProfilePhotoAction'),
          ),
          SizedBox(width: metrics.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sellerText(metrics, 17, weight: FontWeight.w800),
                ),
                SizedBox(height: metrics.spacing(3)),
                Text(
                  'Electronics seller',
                  style: sellerText(metrics, 12, color: SellerUiColors.body),
                ),
                SizedBox(height: metrics.spacing(6)),
                Wrap(
                  spacing: metrics.spacing(6),
                  runSpacing: metrics.spacing(4),
                  children: [
                    _SellerStatusChip(
                      icon: Icons.verified_outlined,
                      label: 'Verified',
                      metrics: metrics,
                    ),
                    _SellerStatusChip(
                      icon: Icons.star_outline,
                      label: '4.9 rating',
                      metrics: metrics,
                    ),
                  ],
                ),
                SizedBox(height: metrics.spacing(4)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    key: const Key('sellerProfileChangePhoto'),
                    onPressed: changePhoto,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: metrics.spacing(4),
                        vertical: metrics.spacing(4),
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: Icon(
                      Icons.photo_camera_outlined,
                      size: metrics.artSize(15),
                    ),
                    label: Text(
                      'Change profile picture',
                      style: sellerText(
                        metrics,
                        12,
                        weight: FontWeight.w700,
                        color: SellerUiColors.primaryBright,
                      ),
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

class _SellerProfilePhotoEditor extends StatelessWidget {
  const _SellerProfilePhotoEditor({
    required this.sellerName,
    this.onProfilePhotoAction,
  });

  final String sellerName;
  final ValueChanged<SellerProfilePhotoAction>? onProfilePhotoAction;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    final initial = sellerName.trim().isEmpty ? 'S' : sellerName.trim()[0];
    Future<void> changePhoto() => _showSellerProfilePhotoOptions(
      context,
      onSelected: onProfilePhotoAction,
    );
    return Padding(
      padding: EdgeInsets.all(metrics.spacing(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SellerProfileAvatar(
            initial: initial,
            metrics: metrics,
            onChangePhoto: changePhoto,
            actionKey: const Key('sellerEditProfilePhotoAction'),
          ),
          SizedBox(width: metrics.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Seller photo',
                  style: sellerText(metrics, 14, weight: FontWeight.w800),
                ),
                SizedBox(height: metrics.spacing(3)),
                Text(
                  'Use a clear photo that buyers can recognize.',
                  style: sellerText(metrics, 12, color: SellerUiColors.muted),
                ),
                SizedBox(height: metrics.spacing(5)),
                TextButton.icon(
                  key: const Key('sellerEditProfileChangePhoto'),
                  onPressed: changePhoto,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: metrics.spacing(4),
                      vertical: metrics.spacing(4),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    Icons.photo_camera_outlined,
                    size: metrics.artSize(15),
                  ),
                  label: Text(
                    'Change profile picture',
                    style: sellerText(
                      metrics,
                      12,
                      weight: FontWeight.w700,
                      color: SellerUiColors.primaryBright,
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

class _SellerProfileAvatar extends StatelessWidget {
  const _SellerProfileAvatar({
    required this.initial,
    required this.metrics,
    required this.onChangePhoto,
    required this.actionKey,
  });

  final String initial;
  final ApprovedReplicaMetrics metrics;
  final VoidCallback onChangePhoto;
  final Key actionKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: metrics.artSize(62),
      height: metrics.artSize(62),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CircleAvatar(
              backgroundColor: SellerUiColors.primaryBright,
              child: Text(
                initial.toUpperCase(),
                style: sellerText(
                  metrics,
                  20,
                  weight: FontWeight.w800,
                  color: SellerUiColors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: -metrics.spacing(2),
            bottom: -metrics.spacing(2),
            child: Material(
              color: SellerUiColors.white,
              shape: const CircleBorder(),
              elevation: 1,
              child: IconButton(
                key: actionKey,
                tooltip: 'Change profile picture',
                onPressed: onChangePhoto,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.all(metrics.spacing(6)),
                constraints: BoxConstraints.tightFor(
                  width: metrics.artSize(32),
                  height: metrics.artSize(32),
                ),
                icon: Icon(
                  Icons.photo_camera_outlined,
                  color: SellerUiColors.primaryBright,
                  size: metrics.artSize(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showSellerProfilePhotoOptions(
  BuildContext context, {
  ValueChanged<SellerProfilePhotoAction>? onSelected,
}) async {
  final metrics = ApprovedReplicaScope.of(context);
  final selected = await showModalBottomSheet<SellerProfilePhotoAction>(
    context: context,
    backgroundColor: SellerUiColors.white,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          metrics.spacing(20),
          metrics.spacing(10),
          metrics.spacing(20),
          metrics.spacing(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: metrics.artSize(42),
                height: metrics.geometry(4),
                decoration: BoxDecoration(
                  color: SellerUiColors.lavenderBorder,
                  borderRadius: BorderRadius.circular(metrics.geometry(10)),
                ),
              ),
            ),
            SizedBox(height: metrics.spacing(14)),
            Text(
              'Change profile picture',
              style: sellerText(metrics, 18, weight: FontWeight.w800),
            ),
            SizedBox(height: metrics.spacing(4)),
            Text(
              'Choose how you want to update your Seller photo.',
              style: sellerText(metrics, 12, color: SellerUiColors.muted),
            ),
            SizedBox(height: metrics.spacing(12)),
            _SellerPhotoOption(
              metrics: metrics,
              optionKey: const Key('sellerPhotoTakePhoto'),
              icon: Icons.photo_camera_outlined,
              title: 'Take a photo',
              subtitle: 'Use your device camera',
              onTap: () => Navigator.of(
                sheetContext,
              ).pop(SellerProfilePhotoAction.camera),
            ),
            _SellerPhotoOption(
              metrics: metrics,
              optionKey: const Key('sellerPhotoChooseGallery'),
              icon: Icons.photo_library_outlined,
              title: 'Choose from photo library',
              subtitle: 'Select a photo already on your device',
              onTap: () => Navigator.of(
                sheetContext,
              ).pop(SellerProfilePhotoAction.gallery),
            ),
            _SellerPhotoOption(
              metrics: metrics,
              optionKey: const Key('sellerPhotoRemove'),
              icon: Icons.delete_outline,
              title: 'Remove current photo',
              subtitle: 'Show your Seller initials instead',
              isDestructive: true,
              onTap: () => Navigator.of(
                sheetContext,
              ).pop(SellerProfilePhotoAction.remove),
            ),
          ],
        ),
      );
    },
  );

  if (selected != null) {
    onSelected?.call(selected);
  }
}

class _SellerPhotoOption extends StatelessWidget {
  const _SellerPhotoOption({
    required this.metrics,
    required this.optionKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final ApprovedReplicaMetrics metrics;
  final Key optionKey;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? SellerUiColors.red
        : SellerUiColors.primaryBright;
    return Padding(
      padding: EdgeInsets.only(bottom: metrics.spacing(8)),
      child: Material(
        color: isDestructive
            ? SellerUiColors.red.withValues(alpha: 0.05)
            : SellerUiColors.lavender.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(metrics.geometry(12)),
        child: InkWell(
          key: optionKey,
          onTap: onTap,
          borderRadius: BorderRadius.circular(metrics.geometry(12)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.spacing(12),
              vertical: metrics.spacing(11),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: metrics.artSize(22)),
                SizedBox(width: metrics.spacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: sellerText(
                          metrics,
                          13,
                          weight: FontWeight.w800,
                          color: isDestructive ? color : SellerUiColors.ink,
                        ),
                      ),
                      SizedBox(height: metrics.spacing(2)),
                      Text(
                        subtitle,
                        style: sellerText(
                          metrics,
                          11,
                          color: SellerUiColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: SellerUiColors.muted,
                  size: metrics.artSize(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SellerStatusChip extends StatelessWidget {
  const _SellerStatusChip({
    required this.icon,
    required this.label,
    required this.metrics,
  });

  final IconData icon;
  final String label;
  final ApprovedReplicaMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.spacing(7),
        vertical: metrics.spacing(4),
      ),
      decoration: BoxDecoration(
        color: SellerUiColors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: metrics.artSize(13), color: SellerUiColors.primary),
          SizedBox(width: metrics.spacing(4)),
          Text(label, style: sellerText(metrics, 10, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SellerProfileField extends StatelessWidget {
  const _SellerProfileField({
    required this.initialValue,
    required this.label,
    this.helperText,
    this.maxLines = 1,
    this.readOnly = false,
    this.textInputAction,
    this.onChanged,
  });

  final String initialValue;
  final String label;
  final String? helperText;
  final int maxLines;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Semantics(
      textField: true,
      label: label,
      readOnly: readOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: sellerText(metrics, 13, weight: FontWeight.w700)),
          SizedBox(height: metrics.spacing(6)),
          TextFormField(
            initialValue: initialValue,
            readOnly: readOnly,
            maxLines: maxLines,
            textInputAction:
                textInputAction ??
                (maxLines == 1
                    ? TextInputAction.next
                    : TextInputAction.newline),
            onChanged: onChanged,
            style: sellerText(metrics, 13, weight: FontWeight.w700),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: SellerUiColors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: metrics.spacing(12),
                vertical: metrics.spacing(12),
              ),
              constraints: BoxConstraints(
                minHeight: metrics.geometry(maxLines == 1 ? 48 : 72),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(metrics.geometry(9)),
                borderSide: const BorderSide(color: SellerUiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(metrics.geometry(9)),
                borderSide: const BorderSide(
                  color: SellerUiColors.primaryBright,
                  width: 1.5,
                ),
              ),
            ),
          ),
          if (helperText != null) ...[
            SizedBox(height: metrics.spacing(6)),
            Text(
              helperText!,
              style: sellerText(metrics, 11, color: SellerUiColors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

ButtonStyle _sellerFilledButtonStyle(BuildContext context) {
  final metrics = ApprovedReplicaScope.of(context);
  return FilledButton.styleFrom(
    backgroundColor: SellerUiColors.primaryBright,
    foregroundColor: SellerUiColors.white,
    minimumSize: Size(0, metrics.geometry(44)),
    padding: EdgeInsets.symmetric(
      horizontal: metrics.spacing(16),
      vertical: metrics.spacing(9),
    ),
    textStyle: sellerText(metrics, 14, weight: FontWeight.w700),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(metrics.geometry(12)),
    ),
  );
}
