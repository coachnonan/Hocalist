import 'package:flutter/material.dart';

import '../../theme/seller_ui_foundation.dart';
import 'seller_bottom_navigation.dart';

class SellerAppShell extends StatelessWidget {
  const SellerAppShell({
    required this.selected,
    required this.navigation,
    required this.onNotifications,
    required this.child,
    super.key,
  });

  final SellerNavDestination selected;
  final SellerNavigationCallbacks navigation;
  final VoidCallback onNotifications;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SellerUiColors.white,
      child: SafeArea(
        child: Column(
          children: [
            SellerAppHeader(onNotifications: onNotifications),
            const Divider(height: 1, color: SellerUiColors.line),
            Expanded(child: child),
            SellerBottomNavigation(
              navigationKey: const Key('sellerAppBottomNavigation'),
              selected: selected,
              callbacks: navigation,
            ),
          ],
        ),
      ),
    );
  }
}

class SellerAppHeader extends StatelessWidget {
  const SellerAppHeader({required this.onNotifications, super.key});

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = ApprovedReplicaMetrics.resolve(
          availableWidth: constraints.maxWidth.clamp(
            0,
            ApprovedReplicaMetrics.supportedViewportMaxWidth,
          ),
          textScaler: MediaQuery.textScalerOf(context),
        );
        return ApprovedReplicaScope(
          metrics: metrics,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ApprovedReplicaMetrics.tabletContentMaxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: metrics.pageHorizontalPadding(14),
                  vertical: metrics.spacing(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      SellerAssets.brandWordmark,
                      width: metrics.artSize(104),
                      fit: BoxFit.contain,
                      semanticLabel: 'Hocalist Reverse Marketplace',
                    ),
                    const Spacer(),
                    if (!metrics.accessibilityReflow)
                      _SellerModePill(metrics: metrics),
                    SizedBox(width: metrics.geometry(5)),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          key: const Key('sellerNotifications'),
                          tooltip: 'Notifications',
                          onPressed: onNotifications,
                          constraints: BoxConstraints(
                            minWidth: metrics.geometry(44),
                            minHeight: metrics.geometry(44),
                          ),
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            size: metrics.geometry(27),
                            color: SellerUiColors.ink,
                          ),
                        ),
                        Positioned(
                          right: metrics.geometry(7),
                          top: metrics.geometry(5),
                          child: Container(
                            width: metrics.geometry(7),
                            height: metrics.geometry(7),
                            decoration: const BoxDecoration(
                              color: SellerUiColors.red,
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
          ),
        );
      },
    );
  }
}

class _SellerModePill extends StatelessWidget {
  const _SellerModePill({required this.metrics});
  final ApprovedReplicaMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('sellerModePill'),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.geometry(11),
        vertical: metrics.geometry(7),
      ),
      decoration: BoxDecoration(
        color: SellerUiColors.lavender,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user,
            size: metrics.geometry(17),
            color: SellerUiColors.primaryBright,
          ),
          SizedBox(width: metrics.geometry(6)),
          Text(
            'Seller mode',
            style: sellerText(
              metrics,
              12,
              weight: FontWeight.w700,
              color: SellerUiColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
