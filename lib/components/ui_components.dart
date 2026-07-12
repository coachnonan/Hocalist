part of '../main.dart';

class HocalistBrandTitle extends StatelessWidget {
  const HocalistBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Hocalist',
      image: true,
      child: Container(
        height: 38,
        constraints: const BoxConstraints(maxWidth: 132),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: HocalistTheme.primary.withValues(alpha: 0.14),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          'assets/brand/hocalist-wordmark.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}

class MockFieldData {
  const MockFieldData(this.label, this.value);
  final String label;
  final String value;
}

class AppPreviewPanel extends StatelessWidget {
  const AppPreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: HocalistTheme.buyer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Buyer request',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SoftChip(
                label: '2 offers',
                color: HocalistTheme.roleSurface,
                foreground: HocalistTheme.buyer,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'iPad Air, 5th gen or newer',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '\$350 - \$480 - pickup within 12 miles',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
          const Divider(height: 22),
          Row(
            children: [
              const Icon(
                Icons.storefront_outlined,
                color: HocalistTheme.seller,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Northside Tech - \$420',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: HocalistTheme.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProcessStrip extends StatelessWidget {
  const ProcessStrip({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.edit_note_outlined,
        'Post a request',
        'Tell nearby sellers what you need.',
      ),
      (
        Icons.local_offer_outlined,
        'Compare offers',
        'Review price, condition, and timing.',
      ),
      (
        Icons.chat_bubble_outline,
        'Select and chat',
        'Choose a seller before private chat opens.',
      ),
      (
        Icons.handshake_outlined,
        'Meet and pay offline',
        'Arrange the handoff; item payment stays outside Hocalist.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 2 : 1;
        final width = columns == 2
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
        return Semantics(
          label: 'How Hocalist works in four steps',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(items.length, (index) {
              final item = items[index];
              return SizedBox(
                width: width,
                child: AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: HocalistTheme.roleSurface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              item.$1,
                              color: HocalistTheme.primary,
                              size: 22,
                            ),
                            Positioned(
                              right: -8,
                              top: -8,
                              child: CircleAvatar(
                                radius: 9,
                                backgroundColor: HocalistTheme.primary,
                                foregroundColor: Colors.white,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$2,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.$3,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HocalistTheme.darkMuted
                                        : HocalistTheme.muted,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class ResponsiveCardGrid extends StatelessWidget {
  const ResponsiveCardGrid({
    required this.children,
    this.breakpoint = 680,
    super.key,
  });

  final List<Widget> children;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= breakpoint ? 2 : 1;
        final width = columns == 2
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class DashboardHero extends StatelessWidget {
  const DashboardHero({
    required this.accent,
    required this.title,
    required this.body,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final Color accent;
  final String title;
  final String body;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: accent.withValues(alpha: 0.12),
            foregroundColor: accent,
            child: Icon(icon),
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: actionLabel,
            icon: Icons.arrow_forward,
            color: accent,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({required this.title, required this.action, super.key});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          Text(action, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class RouteContextBanner extends StatelessWidget {
  const RouteContextBanner({
    required this.accent,
    required this.label,
    required this.text,
    super.key,
  });

  final Color accent;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.09),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.route_outlined, color: accent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: accent),
                  ),
                  TextSpan(
                    text: text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenBlock extends StatelessWidget {
  const ScreenBlock({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
        ),
        const SizedBox(height: 18),
        ...children.expand((child) => [child, const SizedBox(height: 12)]),
      ],
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.onTap, super.key});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.foreground = Colors.white,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: HocalistTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  const RoleCard({
    required this.title,
    required this.body,
    required this.color,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final String body;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            foregroundColor: color,
            child: Icon(icon),
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            foregroundColor: color,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: HocalistTheme.muted),
        ],
      ),
    );
  }
}

class LocationSearchPanel extends StatelessWidget {
  const LocationSearchPanel({
    required this.accent,
    required this.title,
    required this.locationValue,
    required this.radiusValue,
    required this.hint,
    super.key,
  });

  final Color accent;
  final String title;
  final String locationValue;
  final String radiusValue;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: accent.withValues(alpha: 0.12),
                foregroundColor: accent,
                child: const Icon(Icons.travel_explore_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              MapOptionsButton(
                accent: accent,
                title: title,
                address: locationValue,
                distance: radiusValue,
                note: hint,
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: locationValue,
            decoration: const InputDecoration(
              labelText: 'City, area, address, or map pin',
              prefixIcon: Icon(Icons.place_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: radiusValue,
            decoration: const InputDecoration(
              labelText: 'Search radius or distance',
              prefixIcon: Icon(Icons.radar_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hint,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
        ],
      ),
    );
  }
}

class LocationSummaryCard extends StatelessWidget {
  const LocationSummaryCard({
    required this.accent,
    required this.title,
    required this.address,
    required this.distance,
    required this.privacyNote,
    super.key,
  });

  final Color accent;
  final String title;
  final String address;
  final String distance;
  final String privacyNote;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: accent.withValues(alpha: 0.12),
                foregroundColor: accent,
                child: const Icon(Icons.location_on_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              MapOptionsButton(
                accent: accent,
                title: title,
                address: address,
                distance: distance,
                note: privacyNote,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SoftChip(
                label: distance,
                color: accent.withValues(alpha: 0.12),
                foreground: accent,
              ),
              const SoftChip(
                label: 'Approximate until selected',
                color: HocalistTheme.roleSurface,
                foreground: HocalistTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            privacyNote,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
        ],
      ),
    );
  }
}

class MapOptionsButton extends StatelessWidget {
  const MapOptionsButton({
    required this.accent,
    required this.title,
    required this.address,
    required this.distance,
    required this.note,
    super.key,
  });

  final Color accent;
  final String title;
  final String address;
  final String distance;
  final String note;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Map options',
      icon: const Icon(Icons.more_horiz),
      color: accent,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    MapPreviewSurface(accent: accent),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SoftChip(
                          label: distance,
                          color: accent.withValues(alpha: 0.12),
                          foreground: accent,
                        ),
                        const SoftChip(
                          label: 'Future Google Maps',
                          color: Color(0xffeff4ff),
                          foreground: HocalistTheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      note,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HocalistTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Close',
                            color: accent,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MapPreviewSurface extends StatelessWidget {
  const MapPreviewSurface({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffeaf1f4),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _MapPreviewPainter(accent: accent)),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: HocalistTheme.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: HocalistTheme.text.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(Icons.location_pin, color: accent, size: 30),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: HocalistTheme.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Google Maps preview placeholder',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreviewPainter extends CustomPainter {
  const _MapPreviewPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.82)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final thinRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final radiusPaint = Paint()
      ..color = accent.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final radiusBorderPaint = Paint()
      ..color = accent.withValues(alpha: 0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.46),
      size.shortestSide * 0.36,
      radiusPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.46),
      size.shortestSide * 0.36,
      radiusBorderPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.25),
      Offset(size.width * 0.92, size.height * 0.18),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.85),
      Offset(size.width * 0.82, size.height * 0.28),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.58),
      Offset(size.width * 0.95, size.height * 0.72),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.02),
      Offset(size.width * 0.22, size.height * 0.96),
      thinRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPreviewPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({
    required this.accent,
    required this.role,
    super.key,
  });

  final Color accent;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final isSeller = role == UserRole.seller;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: accent.withValues(alpha: 0.14),
                foregroundColor: accent,
                child: const Icon(Icons.person_outline, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSeller ? 'Northside Tech profile' : 'Maya Chen profile',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSeller
                          ? 'Seller profile, service area, request alerts, and local progress.'
                          : 'Buyer profile, request privacy, offer alerts, and local progress.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HocalistTheme.muted,
                      ),
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
                label: 'Verified email',
                color: accent.withValues(alpha: 0.12),
                foreground: accent,
              ),
              const SoftChip(
                label: 'Approximate location',
                color: Color(0xffeff4ff),
                foreground: HocalistTheme.primary,
              ),
              const SoftChip(
                label: 'Offline item payment',
                color: HocalistTheme.roleSurface,
                foreground: HocalistTheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(title: title, action: 'Settings'),
        AppCard(
          child: Column(
            children: children.indexed.map((entry) {
              final index = entry.$1;
              final child = entry.$2;
              final isLast = index == children.length - 1;
              return Column(
                children: [child, if (!isLast) const Divider(height: 24)],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.status,
    required this.accent,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final String status;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: accent.withValues(alpha: 0.12),
          foregroundColor: accent,
          child: Icon(icon),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SoftChip(
                    label: status,
                    color: accent.withValues(alpha: 0.1),
                    foreground: accent,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: HocalistTheme.muted),
      ],
    );
  }
}

class SettingsPreferenceRow extends StatelessWidget {
  const SettingsPreferenceRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.enabled,
    required this.accent,
    this.onChanged,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool enabled;
  final Color accent;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: accent.withValues(alpha: 0.12),
          foregroundColor: accent,
          child: Icon(icon),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                body,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Switch(value: enabled, activeThumbColor: accent, onChanged: onChanged),
      ],
    );
  }
}

class AlertBanner extends StatelessWidget {
  const AlertBanner({
    required this.accent,
    required this.title,
    required this.body,
    required this.icon,
    super.key,
  });

  final Color accent;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.11),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: accent),
                ),
                const SizedBox(height: 4),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.accent,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    super.key,
  });

  final Color accent;
  final IconData icon;
  final String title;
  final String body;
  final String time;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: accent.withValues(alpha: 0.12),
            foregroundColor: accent,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        time,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
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

class EmptyStatePanel extends StatelessWidget {
  const EmptyStatePanel({
    required this.accent,
    required this.title,
    required this.body,
    super.key,
  });

  final Color accent;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, color: accent, size: 36),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
          ),
        ],
      ),
    );
  }
}

class LoadingStatePanel extends StatelessWidget {
  const LoadingStatePanel({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(color: accent, strokeWidth: 3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Loading updated safety content from admin-managed settings...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorStatePanel extends StatelessWidget {
  const ErrorStatePanel({
    required this.accent,
    required this.title,
    required this.body,
    super.key,
  });

  final Color accent;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: HocalistTheme.danger),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Retry',
                  color: accent,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModePill extends StatelessWidget {
  const ModePill({required this.role, required this.accent, super.key});

  final UserRole role;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SoftChip(
      label: role == UserRole.buyer ? 'Buyer mode' : 'Seller mode',
      color: accent.withValues(alpha: 0.12),
      foreground: accent,
    );
  }
}

class SoftChip extends StatelessWidget {
  const SoftChip({
    required this.label,
    required this.color,
    required this.foreground,
    super.key,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}

class Metric {
  const Metric(this.value, this.label);
  final String value;
  final String label;
}

class MetricRow extends StatelessWidget {
  const MetricRow({required this.accent, required this.values, super.key});

  final Color accent;
  final List<Metric> values;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values.map((metric) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.value,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: accent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric.label,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class BuyerRequestCard extends StatelessWidget {
  const BuyerRequestCard({
    required this.title,
    required this.budget,
    required this.location,
    required this.status,
    required this.onTap,
    super.key,
  });

  final String title;
  final String budget;
  final String location;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                child: SoftChip(
                  label: 'Buyer request',
                  color: HocalistTheme.roleSurface,
                  foreground: HocalistTheme.buyer,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    status,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  budget,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HocalistTheme.primary,
                  ),
                ),
              ),
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: HocalistTheme.muted,
              ),
              Flexible(
                child: Text(
                  location,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SellerOfferCard extends StatelessWidget {
  const SellerOfferCard({
    required this.seller,
    required this.price,
    required this.detail,
    required this.status,
    required this.accent,
    required this.onTap,
    super.key,
  });

  final String seller;
  final String price;
  final String detail;
  final String status;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  seller,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                price,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xffffba35)),
              const SizedBox(width: 4),
              Text('4.9 rating', style: Theme.of(context).textTheme.labelLarge),
              const Spacer(),
              SoftChip(
                label: status,
                color: accent.withValues(alpha: 0.12),
                foreground: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.accent,
    required this.title,
    required this.body,
    super.key,
  });

  final Color accent;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: accent.withValues(alpha: 0.12),
            foregroundColor: accent,
            child: const Icon(Icons.verified_user_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  body,
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

class UploadBox extends StatelessWidget {
  const UploadBox({required this.accent, required this.label, super.key});

  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.06),
          border: Border.all(color: accent.withValues(alpha: 0.22)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: accent),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: accent),
            ),
            Text(
              'Uploads are saved as part of this local review flow.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class OfflinePaymentNotice extends StatelessWidget {
  const OfflinePaymentNotice({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.health_and_safety_outlined, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Offline payment reminder: Hocalist does not process, hold, ship, escrow, or guarantee item payment. Buyer and seller finalize item payment outside the app.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class DealSummary extends StatelessWidget {
  const DealSummary({
    required this.accent,
    required this.title,
    required this.price,
    required this.detail,
    super.key,
  });

  final Color accent;
  final String title;
  final String price;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
          const Divider(height: 24),
          Row(
            children: [
              const Text('Agreed item price'),
              const Spacer(),
              Text(
                price,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.text, required this.color, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: color == HocalistTheme.softSurface
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(text),
      ),
    );
  }
}

class ActionChoice extends StatelessWidget {
  const ActionChoice({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            foregroundColor: color,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  body,
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

class RecordCard extends StatelessWidget {
  const RecordCard({
    required this.title,
    required this.meta,
    required this.amount,
    super.key,
  });

  final String title;
  final String meta;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  meta,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: HocalistTheme.muted),
                ),
              ],
            ),
          ),
          Text(amount, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class InfoList extends StatelessWidget {
  const InfoList({required this.items, super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                const Icon(Icons.chevron_right, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(item)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({required this.accent, required this.items, super.key});

  final Color accent;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: accent, size: 19),
                const SizedBox(width: 10),
                Expanded(child: Text(item)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
