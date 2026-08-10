import 'package:flutter/material.dart';

import '../features/approved/approved_replica_metrics.dart';

/// Shared Buyer colors. Page/flow accents remain explicit variants where the
/// approved screenshots do not support one universal blue or navy.
abstract final class BuyerUiTokens {
  static const text = Color(0xff0c123d);
  static const muted = Color(0xff59617f);
  static const border = Color(0xffe2e4ef);
  static const surface = Colors.white;
  static const softSurface = Color(0xfff1f0ff);
  static const activeSurface = Color(0xffeeedff);
  static const success = Color(0xff109b4e);
  static const rewardGold = Color(0xffffad00);

  static const action = Color(0xff1400c8);
  static const requestAction = Color(0xff1917ff);
  static const offersAction = Color(0xff0f0b7a);
  static const offerChatAction = Color(0xff1117e8);
  static const trendsAction = Color(0xff3518ef);

  static const requestText = Color(0xff10145b);
  static const offerChatText = Color(0xff080b62);
  static const trendsText = Color(0xff0b1047);
}

/// Canonical chrome for the signed-in top-level Buyer destinations.
///
/// The artwork intentionally uses the current client-requested Hocalist logo.
/// Top-level pages may share this contract without forcing it onto nested
/// pages that correctly use back navigation and a page title.
class BuyerTopLevelHeader extends StatelessWidget {
  const BuyerTopLevelHeader({required this.onNotifications, super.key});

  static const headerKey = ValueKey('buyer-top-level-header');
  static const logoKey = ValueKey('buyer-top-level-header-logo');
  static const modeKey = ValueKey('buyer-top-level-header-mode');
  static const notificationsKey = ValueKey(
    'buyer-top-level-header-notifications',
  );

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final metrics =
        ApprovedReplicaScope.maybeOf(context) ??
        ApprovedReplicaMetrics.resolve(
          availableWidth: media.size.width,
          textScaler: media.textScaler,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final reflow =
            metrics.accessibilityReflow &&
            (metrics.textScale >= 1.3 || constraints.maxWidth < 330);
        final logo = Semantics(
          image: true,
          label: 'Hocalist Reverse Marketplace',
          child: SizedBox(
            key: logoKey,
            width: metrics.artSize(88),
            height: metrics.artSize(54),
            child: Image.asset(
              'assets/brand/hocalist-wordmark.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            ),
          ),
        );
        final mode = Container(
          key: modeKey,
          constraints: BoxConstraints(minHeight: metrics.geometry(38)),
          padding: EdgeInsets.symmetric(
            horizontal: metrics.geometry(10),
            vertical: metrics.geometry(7),
          ),
          decoration: BoxDecoration(
            color: BuyerUiTokens.softSurface,
            borderRadius: BorderRadius.circular(metrics.geometry(99)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/approved_onboarding_home/buyer-mode-check.png',
                  width: metrics.artSize(22),
                  height: metrics.artSize(22),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  excludeFromSemantics: true,
                ),
              ),
              SizedBox(width: metrics.geometry(6)),
              Text(
                'Buyer mode',
                maxLines: 1,
                softWrap: false,
                style: BuyerTypography.style(
                  context,
                  metrics,
                  BuyerTextRole.badgeStatus,
                  color: BuyerUiTokens.action,
                  weight: FontWeight.w800,
                  height: 1.05,
                ).copyWith(fontSize: metrics.fontSize(12)),
              ),
            ],
          ),
        );
        final notification = Semantics(
          button: true,
          label: 'Notifications',
          child: InkResponse(
            key: notificationsKey,
            onTap: onNotifications,
            radius: metrics.artSize(24),
            child: SizedBox(
              width: metrics.artSize(44),
              height: metrics.artSize(44),
              child: ClipOval(
                child: Image.asset(
                  'assets/approved_onboarding_home/notification.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
        );

        if (reflow) {
          return Column(
            key: headerKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [logo, const Spacer(), notification]),
              SizedBox(height: metrics.spacing(4)),
              Align(alignment: Alignment.centerRight, child: mode),
            ],
          );
        }

        return SizedBox(
          key: headerKey,
          height: metrics.artSize(54),
          child: Row(
            children: [
              logo,
              const Spacer(),
              mode,
              SizedBox(width: metrics.geometry(8)),
              notification,
            ],
          ),
        );
      },
    );
  }
}

enum BuyerTextRole {
  displayTitle,
  pageTitle,
  sectionHeading,
  cardTitle,
  primaryBody,
  secondaryBody,
  metadata,
  buttonLabel,
  navigationLabel,
  numericEmphasis,
  badgeStatus,
}

abstract final class BuyerTypography {
  static const fontFamily = 'Nunito';

  static TextStyle style(
    BuildContext context,
    ApprovedReplicaMetrics metrics,
    BuyerTextRole role, {
    Color? color,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    final spec = _spec(role);
    final theme = Theme.of(context).textTheme;
    final base = switch (role) {
      BuyerTextRole.displayTitle => theme.displaySmall,
      BuyerTextRole.pageTitle => theme.headlineLarge,
      BuyerTextRole.sectionHeading => theme.headlineMedium,
      BuyerTextRole.cardTitle => theme.titleMedium,
      BuyerTextRole.primaryBody => theme.bodyMedium,
      BuyerTextRole.secondaryBody => theme.bodySmall,
      BuyerTextRole.metadata => theme.bodySmall,
      BuyerTextRole.buttonLabel => theme.labelLarge,
      BuyerTextRole.navigationLabel => theme.labelSmall,
      BuyerTextRole.numericEmphasis => theme.headlineMedium,
      BuyerTextRole.badgeStatus => theme.labelSmall,
    };
    return (base ?? const TextStyle()).copyWith(
      color: color ?? spec.color,
      fontFamily: fontFamily,
      fontSize: metrics.fontSize(spec.size),
      fontWeight: weight ?? spec.weight,
      height: height ?? spec.height,
      letterSpacing: letterSpacing ?? 0,
    );
  }

  static _BuyerTextSpec _spec(BuyerTextRole role) {
    return switch (role) {
      BuyerTextRole.displayTitle => const _BuyerTextSpec(
        size: 20,
        weight: FontWeight.w800,
        height: 1.12,
      ),
      BuyerTextRole.pageTitle => const _BuyerTextSpec(
        size: 16,
        weight: FontWeight.w800,
        height: 1.2,
      ),
      BuyerTextRole.sectionHeading => const _BuyerTextSpec(
        size: 16,
        weight: FontWeight.w800,
        height: 1.2,
      ),
      BuyerTextRole.cardTitle => const _BuyerTextSpec(
        size: 14,
        weight: FontWeight.w800,
        height: 1.22,
      ),
      BuyerTextRole.primaryBody => const _BuyerTextSpec(
        size: 13,
        weight: FontWeight.w500,
        height: 1.38,
      ),
      BuyerTextRole.secondaryBody => const _BuyerTextSpec(
        size: 12,
        weight: FontWeight.w500,
        height: 1.35,
        color: BuyerUiTokens.muted,
      ),
      BuyerTextRole.metadata => const _BuyerTextSpec(
        size: 11,
        weight: FontWeight.w500,
        height: 1.3,
        color: BuyerUiTokens.muted,
      ),
      BuyerTextRole.buttonLabel => const _BuyerTextSpec(
        size: 13,
        weight: FontWeight.w800,
        height: 1.15,
      ),
      BuyerTextRole.navigationLabel => const _BuyerTextSpec(
        size: 10.5,
        weight: FontWeight.w600,
        height: 1.15,
        color: BuyerUiTokens.muted,
      ),
      BuyerTextRole.numericEmphasis => const _BuyerTextSpec(
        size: 20,
        weight: FontWeight.w800,
        height: 1.08,
      ),
      BuyerTextRole.badgeStatus => const _BuyerTextSpec(
        size: 10.5,
        weight: FontWeight.w700,
        height: 1.15,
      ),
    };
  }
}

@immutable
class _BuyerTextSpec {
  const _BuyerTextSpec({
    required this.size,
    required this.weight,
    required this.height,
    this.color = BuyerUiTokens.text,
  });

  final double size;
  final FontWeight weight;
  final double height;
  final Color color;
}
