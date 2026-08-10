import 'package:flutter/material.dart';

import '../../theme/accessibility_visuals.dart';
import '../../theme/buyer_ui_foundation.dart';
import 'approved_replica_metrics.dart';

const _approvedPrimary = BuyerUiTokens.trendsText;
const _approvedAction = BuyerUiTokens.trendsAction;
const _approvedMuted = BuyerUiTokens.muted;
const _approvedGreen = Color(0xff15952e);
const _approvedGold = BuyerUiTokens.rewardGold;
const _approvedBorder = BuyerUiTokens.border;
const _approvedAssetRoot = 'assets/approved_trends_notifications';

Color _pageText(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge?.color ?? _approvedPrimary;

Color _pageMuted(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall?.color ?? _approvedMuted;

Color _pageSurface(BuildContext context) =>
    Theme.of(context).colorScheme.surface;

ApprovedReplicaMetrics _replicaMetrics(BuildContext context) {
  return ApprovedReplicaScope.maybeOf(context) ??
      ApprovedReplicaMetrics.resolve(
        availableWidth: MediaQuery.sizeOf(context).width,
        textScaler: MediaQuery.textScalerOf(context),
      );
}

double _pickedSellerFontSize(
  ApprovedReplicaMetrics metrics,
  double referencePixels,
) {
  final scaled = metrics.fontSize(referencePixels);
  if (metrics.screenshotLocked) return scaled;
  final readableFloor = switch (referencePixels) {
    <= 11 => 10.0,
    <= 13 => 10.5,
    <= 14.5 => 11.5,
    _ => 12.0,
  };
  return scaled < readableFloor ? readableFloor : scaled;
}

double _sellerDimension(
  ApprovedReplicaMetrics metrics,
  double referencePixels, {
  required double floor,
}) {
  final scaled = metrics.geometry(referencePixels);
  if (metrics.screenshotLocked) return scaled;
  return scaled < floor ? floor : scaled;
}

class _ApprovedReplicaSurface extends StatelessWidget {
  const _ApprovedReplicaSurface({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaMetrics.resolve(
      availableWidth: MediaQuery.sizeOf(context).width,
      textScaler: MediaQuery.textScalerOf(context),
    );
    return ApprovedReplicaScope(
      metrics: metrics,
      child: Center(
        child: ConstrainedBox(
          key: const ValueKey('approved-replica-content'),
          constraints: BoxConstraints(maxWidth: metrics.contentMaxWidth),
          child: Builder(builder: builder),
        ),
      ),
    );
  }
}

Widget _approvedAsset(
  String name, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  String? semanticLabel,
}) {
  return Image.asset(
    '$_approvedAssetRoot/$name',
    width: width,
    height: height,
    fit: fit,
    filterQuality: FilterQuality.high,
    semanticLabel: semanticLabel,
    excludeFromSemantics: semanticLabel == null,
    gaplessPlayback: true,
    errorBuilder: (context, error, stackTrace) {
      return SizedBox(
        width: width,
        height: height,
        child: semanticLabel == null
            ? null
            : Semantics(
                label: '$semanticLabel unavailable',
                child: const SizedBox.shrink(),
              ),
      );
    },
  );
}

/// Screenshot-approved Hocatrends body. The app shell continues to own its
/// global header, scrolling, and buyer bottom navigation.
class ApprovedHocatrendsPage extends StatelessWidget {
  const ApprovedHocatrendsPage({
    required this.accent,
    required this.onSeeSellers,
    super.key,
  });

  final Color accent;
  final VoidCallback onSeeSellers;

  @override
  Widget build(BuildContext context) {
    return _ApprovedReplicaSurface(
      builder: (context) {
        final metrics = _replicaMetrics(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ApprovedTrendsHero(accent: accent),
            SizedBox(height: metrics.geometry(8)),
            const _ApprovedSavingsNotice(),
            SizedBox(height: metrics.geometry(10)),
            _ApprovedSearchField(accent: accent),
            SizedBox(height: metrics.geometry(6)),
            _ApprovedCompetitiveHeader(accent: accent),
            SizedBox(height: metrics.geometry(6)),
            for (var index = 0; index < _trendCategories.length; index++) ...[
              _ApprovedTrendCard(
                item: _trendCategories[index],
                accent: accent,
                onSeeSellers: onSeeSellers,
              ),
              if (index != _trendCategories.length - 1)
                SizedBox(height: metrics.geometry(8)),
            ],
          ],
        );
      },
    );
  }
}

class _ApprovedTrendsHero extends StatelessWidget {
  const _ApprovedTrendsHero({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _replicaMetrics(context);
        final stack = metrics.accessibilityReflow || constraints.maxWidth < 220;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: metrics.geometry(4),
              runSpacing: metrics.geometry(1),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Saving',
                  style: BuyerTypography.style(
                    context,
                    metrics,
                    BuyerTextRole.displayTitle,
                    color: _pageText(context),
                    height: metrics.lineHeight(
                      referenceFontSize: 20,
                      referenceLineHeight: 21,
                    ),
                  ),
                ),
                Text(
                  'Opportunities',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: accent,
                    fontSize: metrics.fontSize(20),
                    fontWeight: FontWeight.w800,
                    height: metrics.lineHeight(
                      referenceFontSize: 20,
                      referenceLineHeight: 21,
                    ),
                  ),
                ),
                _approvedAsset(
                  'transparent/trend-up.png',
                  width: metrics.geometry(19),
                  height: metrics.geometry(18),
                ),
              ],
            ),
            SizedBox(height: metrics.geometry(6)),
            Text(
              'Explore verified sellers offering\ndiscounts on products & services.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _pageMuted(context),
                fontSize: metrics.fontSize(12),
                fontWeight: FontWeight.w500,
                height: metrics.lineHeight(
                  referenceFontSize: 12,
                  referenceLineHeight: 16.2,
                ),
              ),
            ),
          ],
        );
        final art = _approvedAsset(
          'saving-gift.png',
          width: metrics.geometry(stack ? 128 : 98),
          height: metrics.geometry(stack ? 100 : 78),
          semanticLabel: 'Gift box and savings coin',
        );

        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              SizedBox(height: metrics.geometry(4)),
              Align(alignment: Alignment.centerRight, child: art),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: copy),
            SizedBox(width: metrics.geometry(4)),
            art,
          ],
        );
      },
    );
  }
}

class _ApprovedSavingsNotice extends StatelessWidget {
  const _ApprovedSavingsNotice();

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      padding: metrics.geometryInsets(const EdgeInsets.fromLTRB(10, 9, 12, 9)),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : const Color(0xfff5f2ff),
        borderRadius: BorderRadius.circular(metrics.geometry(10)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stack =
              metrics.accessibilityReflow && constraints.maxWidth < 370;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skip the Rewards & save on current offers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _pageText(context),
                  fontSize: metrics.fontSize(12),
                  fontWeight: FontWeight.w800,
                  height: metrics.lineHeight(
                    referenceFontSize: 12,
                    referenceLineHeight: 14.4,
                  ),
                ),
              ),
              SizedBox(height: metrics.geometry(3)),
              Text(
                'Hocatrends shows exclusive offers and discounts created by sellers for other buyers.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _pageMuted(context),
                  fontSize: metrics.fontSize(10.5),
                  height: metrics.lineHeight(
                    referenceFontSize: 10.5,
                    referenceLineHeight: 13.125,
                  ),
                ),
              ),
            ],
          );
          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _approvedAsset(
                  'transparent/trend-shield.png',
                  width: metrics.geometry(42),
                  height: metrics.geometry(42),
                ),
                SizedBox(height: metrics.geometry(6)),
                copy,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _approvedAsset(
                'transparent/trend-shield.png',
                width: metrics.geometry(42),
                height: metrics.geometry(42),
              ),
              SizedBox(width: metrics.geometry(10)),
              Expanded(child: copy),
            ],
          );
        },
      ),
    );
  }
}

class _ApprovedSearchField extends StatelessWidget {
  const _ApprovedSearchField({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        final metrics = _replicaMetrics(context);
        return Semantics(
          textField: true,
          label: 'Search products or services',
          child: Container(
            constraints: BoxConstraints(minHeight: metrics.geometry(42)),
            padding: metrics.geometryInsets(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            decoration: BoxDecoration(
              color: _pageSurface(context),
              borderRadius: BorderRadius.circular(metrics.geometry(9)),
              border: Border.all(
                color: const Color(0xffdedcef),
                width: metrics.geometry(1),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0c0b1047),
                  blurRadius: metrics.geometry(8),
                  offset: Offset(0, metrics.geometry(3)),
                ),
              ],
            ),
            child: Row(
              children: [
                _approvedAsset(
                  'transparent/trend-search.png',
                  width: metrics.geometry(22),
                  height: metrics.geometry(24),
                ),
                SizedBox(width: metrics.geometry(9)),
                Expanded(
                  child: Text(
                    'Search products or services',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _pageMuted(context),
                      fontSize: metrics.fontSize(13),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: metrics.geometry(8)),
                _approvedAsset(
                  'transparent/trend-filter.png',
                  width: metrics.geometry(23),
                  height: metrics.geometry(24),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ApprovedCompetitiveHeader extends StatelessWidget {
  const _ApprovedCompetitiveHeader({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        final metrics = _replicaMetrics(context);
        final title = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _approvedAsset(
              'transparent/competitive-flame.png',
              width: metrics.geometry(16),
              height: metrics.geometry(22),
            ),
            SizedBox(width: metrics.geometry(5)),
            Flexible(
              child: Text(
                'Most Competitive Categories Today',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _pageText(context),
                  fontSize: metrics.fontSize(11.5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(width: metrics.geometry(4)),
            _approvedAsset(
              'transparent/trend-info.png',
              width: metrics.geometry(13),
              height: metrics.geometry(15),
            ),
          ],
        );
        final action = TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: accent,
            minimumSize: Size(metrics.geometry(44), metrics.geometry(36)),
            padding: metrics.geometryInsets(
              const EdgeInsets.symmetric(horizontal: 3),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: TextStyle(
              fontFamily: BuyerTypography.fontFamily,
              fontSize: metrics.fontSize(11.5),
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('How it works'),
        );
        return Row(
          children: [
            Expanded(child: title),
            SizedBox(width: metrics.geometry(4)),
            action,
          ],
        );
      },
    );
  }
}

class _ApprovedTrendCard extends StatelessWidget {
  const _ApprovedTrendCard({
    required this.item,
    required this.accent,
    required this.onSeeSellers,
  });

  final _ApprovedTrendData item;
  final Color accent;
  final VoidCallback onSeeSellers;

  @override
  Widget build(BuildContext context) {
    final accessibility = hocalistAccessibilityVisualsOf(context);
    final metrics = _replicaMetrics(context);
    return LayoutBuilder(
      builder: (context, _) {
        return Container(
          key: ValueKey('approved-trend-card-${item.rank}'),
          constraints: BoxConstraints(minHeight: metrics.geometry(84)),
          padding: metrics.geometryInsets(
            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          decoration: BoxDecoration(
            color: _pageSurface(context),
            borderRadius: BorderRadius.circular(metrics.geometry(9)),
            border: Border.all(
              color: _approvedBorder,
              width: metrics.geometry(1),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0c0b1047),
                blurRadius: metrics.geometry(8),
                offset: Offset(0, metrics.geometry(3)),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackAction =
                  constraints.maxWidth < 220 || metrics.accessibilityReflow;
              final imageSize = metrics.geometry(58);
              final details = _ApprovedTrendDetails(item: item, accent: accent);
              final leading = Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ApprovedRankBadge(item: item),
                  SizedBox(width: metrics.geometry(6)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(metrics.geometry(6)),
                    child: _approvedAsset(
                      item.image,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                      semanticLabel: item.title,
                    ),
                  ),
                ],
              );
              final button = _ApprovedTrendAction(
                background: accessibility.backgroundOr(accent),
                foreground: accessibility.foregroundOr(Colors.white),
                radius: metrics.geometry(accessibility.radiusOr(7)),
                borderWidth: accessibility.usesHighContrastButton
                    ? metrics.geometry(accessibility.buttonBorderWidth)
                    : 0,
                onPressed: onSeeSellers,
              );

              if (stackAction) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leading,
                        SizedBox(width: metrics.geometry(10)),
                        Expanded(child: details),
                      ],
                    ),
                    SizedBox(height: metrics.geometry(6)),
                    button,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading,
                  SizedBox(width: metrics.geometry(8)),
                  Expanded(child: details),
                  SizedBox(width: metrics.geometry(6)),
                  SizedBox(width: metrics.geometry(78), child: button),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ApprovedTrendAction extends StatelessWidget {
  const _ApprovedTrendAction({
    required this.background,
    required this.foreground,
    required this.radius,
    required this.borderWidth,
    required this.onPressed,
  });

  final Color background;
  final Color foreground;
  final double radius;
  final double borderWidth;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          height: metrics.geometry(44),
          child: Center(
            child: Container(
              width: double.infinity,
              height: metrics.geometry(30),
              alignment: Alignment.center,
              padding: metrics.geometryInsets(
                const EdgeInsets.symmetric(horizontal: 8),
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(radius),
                border: borderWidth > 0
                    ? Border.all(color: foreground, width: borderWidth)
                    : null,
              ),
              child: Text(
                'See Sellers',
                maxLines: 1,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontSize: metrics.fontSize(11),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedRankBadge extends StatelessWidget {
  const _ApprovedRankBadge({required this.item});

  final _ApprovedTrendData item;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      width: metrics.geometry(24),
      height: metrics.geometry(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: item.rankColor,
        borderRadius: BorderRadius.circular(metrics.geometry(6)),
      ),
      child: Text(
        '${item.rank}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: _approvedPrimary,
          fontSize: metrics.fontSize(12),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ApprovedTrendDetails extends StatelessWidget {
  const _ApprovedTrendDetails({required this.item, required this.accent});

  final _ApprovedTrendData item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final progressColor = item.medium ? _approvedGold : accent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _pageText(context),
            fontSize: metrics.fontSize(11),
            fontWeight: FontWeight.w800,
            height: metrics.lineHeight(
              referenceFontSize: 11,
              referenceLineHeight: 11.55,
            ),
          ),
        ),
        SizedBox(height: metrics.geometry(1)),
        Row(
          children: [
            Flexible(
              child: Text(
                'Competition: ${item.competition}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _pageText(context),
                  fontSize: metrics.fontSize(8),
                  fontWeight: FontWeight.w600,
                  height: metrics.lineHeight(
                    referenceFontSize: 8,
                    referenceLineHeight: 8.8,
                  ),
                ),
              ),
            ),
            SizedBox(width: metrics.geometry(2)),
            _approvedAsset(
              item.medium
                  ? 'transparent/trend-medium.png'
                  : 'transparent/trend-hot.png',
              width: metrics.geometry(item.medium ? 10 : 9),
              height: metrics.geometry(10),
            ),
          ],
        ),
        SizedBox(height: metrics.geometry(2)),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(metrics.geometry(999)),
                child: LinearProgressIndicator(
                  value: item.percent / 100,
                  minHeight: metrics.geometry(3),
                  backgroundColor: const Color(0xffe8e8ef),
                  valueColor: AlwaysStoppedAnimation(progressColor),
                ),
              ),
            ),
            SizedBox(width: metrics.geometry(4)),
            Text(
              '${item.percent}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _approvedAction,
                fontSize: metrics.fontSize(8),
                fontWeight: FontWeight.w800,
                height: metrics.lineHeight(
                  referenceFontSize: 8,
                  referenceLineHeight: 9.6,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: metrics.geometry(1)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _approvedAsset(
              'transparent/trend-people.png',
              width: metrics.geometry(10),
              height: metrics.geometry(11),
            ),
            SizedBox(width: metrics.geometry(3)),
            Expanded(
              child: Text(
                item.sellerCopy,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _pageMuted(context),
                  fontSize: metrics.fontSize(9.5),
                  height: metrics.lineHeight(
                    referenceFontSize: 9.5,
                    referenceLineHeight: 10.925,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ApprovedTrendData {
  const _ApprovedTrendData({
    required this.rank,
    required this.title,
    required this.competition,
    required this.percent,
    required this.sellerCopy,
    required this.image,
    required this.rankColor,
    this.medium = false,
  });

  final int rank;
  final String title;
  final String competition;
  final int percent;
  final String sellerCopy;
  final String image;
  final Color rankColor;
  final bool medium;
}

const _trendCategories = [
  _ApprovedTrendData(
    rank: 1,
    title: 'iPad Air',
    competition: 'Very High',
    percent: 96,
    sellerCopy: '23 sellers are actively competing for iPad buyers.',
    image: 'trend-ipad-air.png',
    rankColor: Color(0xffffb900),
  ),
  _ApprovedTrendData(
    rank: 2,
    title: 'Gaming Laptops',
    competition: 'High',
    percent: 82,
    sellerCopy: '17 sellers are actively competing for laptop buyers.',
    image: 'trend-gaming-laptop.png',
    rankColor: Color(0xffeef0fa),
  ),
  _ApprovedTrendData(
    rank: 3,
    title: 'Pressure Washing',
    competition: 'High',
    percent: 74,
    sellerCopy: '14 businesses are actively competing for new customers.',
    image: 'trend-pressure-washer.png',
    rankColor: Color(0xffff6c20),
  ),
  _ApprovedTrendData(
    rank: 4,
    title: 'Living Room Furniture',
    competition: 'Medium',
    percent: 58,
    sellerCopy: '9 sellers are actively competing for furniture buyers.',
    image: 'trend-living-room.png',
    rankColor: Color(0xffeef0fa),
    medium: true,
  ),
  _ApprovedTrendData(
    rank: 5,
    title: 'Used SUVs',
    competition: 'Medium',
    percent: 46,
    sellerCopy: '6 dealerships are actively competing for SUV buyers.',
    image: 'trend-used-suv.png',
    rankColor: Color(0xffeef0fa),
    medium: true,
  ),
];

/// Screenshot-approved seller results opened from the Hocatrends iPad card.
class ApprovedHocatrendsPickedSellersPage extends StatefulWidget {
  const ApprovedHocatrendsPickedSellersPage({
    required this.onBack,
    required this.onChatSeller,
    this.onNotifications,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onChatSeller;
  final VoidCallback? onNotifications;

  @override
  State<ApprovedHocatrendsPickedSellersPage> createState() =>
      _ApprovedHocatrendsPickedSellersPageState();
}

class _ApprovedHocatrendsPickedSellersPageState
    extends State<ApprovedHocatrendsPickedSellersPage> {
  bool filtersOn = false;
  bool gridView = false;
  String sortLabel = 'Best deal';

  void _message(String value) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return _ApprovedReplicaSurface(
      builder: (context) {
        final metrics = _replicaMetrics(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ApprovedSellerHeader(
              onBack: widget.onBack,
              onNotifications: widget.onNotifications,
            ),
            SizedBox(height: metrics.geometry(12)),
            const _ApprovedSellerProductSummary(),
            SizedBox(height: metrics.geometry(12)),
            _ApprovedSellerControls(
              filtersOn: filtersOn,
              sortLabel: sortLabel,
              gridView: gridView,
              onFilters: () {
                setState(() => filtersOn = !filtersOn);
                _message(filtersOn ? 'Filters enabled.' : 'Filters cleared.');
              },
              onSort: (value) {
                setState(() => sortLabel = value);
                _message('Sorted by $value.');
              },
              onView: (value) {
                setState(() => gridView = value);
                _message(value ? 'Grid view selected.' : 'List view selected.');
              },
            ),
            if (filtersOn) ...[
              SizedBox(height: metrics.geometry(10)),
              Wrap(
                spacing: metrics.geometry(8),
                runSpacing: metrics.geometry(8),
                children: const [
                  _ApprovedFilterChip(label: 'Verified sellers'),
                  _ApprovedFilterChip(label: 'Within 6 mi'),
                  _ApprovedFilterChip(label: 'Saves \$125+'),
                ],
              ),
            ],
            SizedBox(height: metrics.geometry(10)),
            LayoutBuilder(
              builder: (context, constraints) {
                final useGrid = gridView && metrics.availableWidth >= 620;
                if (useGrid) {
                  return Wrap(
                    spacing: metrics.geometry(12),
                    runSpacing: metrics.geometry(12),
                    children: [
                      for (final seller in _approvedSellers)
                        SizedBox(
                          width:
                              (constraints.maxWidth - metrics.geometry(12)) / 2,
                          child: _ApprovedSellerCard(
                            seller: seller,
                            onChat: widget.onChatSeller,
                          ),
                        ),
                    ],
                  );
                }
                return Column(
                  children: [
                    for (
                      var index = 0;
                      index < _approvedSellers.length;
                      index++
                    ) ...[
                      _ApprovedSellerCard(
                        seller: _approvedSellers[index],
                        onChat: widget.onChatSeller,
                      ),
                      if (index != _approvedSellers.length - 1)
                        SizedBox(height: metrics.geometry(8)),
                    ],
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ApprovedSellerHeader extends StatelessWidget {
  const _ApprovedSellerHeader({
    required this.onBack,
    required this.onNotifications,
  });

  final VoidCallback onBack;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ApprovedBitmapButton(
          tooltip: 'Back to Hocatrends',
          onPressed: onBack,
          asset: 'transparent/seller-back.png',
          size: metrics.geometry(44),
          imageWidth: metrics.geometry(18),
          imageHeight: metrics.geometry(18),
        ),
        SizedBox(width: metrics.geometry(8)),
        Expanded(
          child: Column(
            children: [
              Text(
                'iPad Air Sellers',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: _pageText(context),
                  fontSize: _pickedSellerFontSize(metrics, 16),
                  fontWeight: FontWeight.w800,
                  height: metrics.lineHeight(
                    referenceFontSize: 16,
                    referenceLineHeight: 19.2,
                  ),
                ),
              ),
              SizedBox(height: metrics.geometry(3)),
              Text(
                '23 sellers are offering deals',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _pageMuted(context),
                  fontSize: _pickedSellerFontSize(metrics, 12),
                  height: metrics.lineHeight(
                    referenceFontSize: 12,
                    referenceLineHeight: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: metrics.geometry(8)),
        _ApprovedBitmapButton(
          tooltip: 'Notifications',
          onPressed: onNotifications,
          asset: 'transparent/seller-notification.png',
          size: metrics.geometry(44),
          imageWidth: metrics.geometry(22),
          imageHeight: metrics.geometry(24),
        ),
      ],
    );
  }
}

class _ApprovedBitmapButton extends StatelessWidget {
  const _ApprovedBitmapButton({
    required this.tooltip,
    required this.onPressed,
    required this.asset,
    required this.size,
    required this.imageWidth,
    required this.imageHeight,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final String asset;
  final double size;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: _approvedAsset(asset, width: imageWidth, height: imageHeight),
        ),
      );
    }
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      padding: EdgeInsets.all(_replicaMetrics(context).geometry(5)),
      icon: _approvedAsset(asset, width: imageWidth, height: imageHeight),
    );
  }
}

class _ApprovedSellerProductSummary extends StatelessWidget {
  const _ApprovedSellerProductSummary();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        final metrics = _replicaMetrics(context);
        final image = _approvedAsset(
          'seller-ipad-air.png',
          width: metrics.geometry(63),
          height: metrics.geometry(80),
          semanticLabel: 'iPad Air',
        );
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'iPad Air',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: _pageText(context),
                fontSize: _pickedSellerFontSize(metrics, 18),
                fontWeight: FontWeight.w800,
                height: metrics.lineHeight(
                  referenceFontSize: 18,
                  referenceLineHeight: 21.6,
                ),
              ),
            ),
            SizedBox(height: metrics.geometry(6)),
            Text(
              'Category: Tablets',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _pageMuted(context),
                fontSize: _pickedSellerFontSize(metrics, 13),
                height: metrics.lineHeight(
                  referenceFontSize: 13,
                  referenceLineHeight: 16.25,
                ),
              ),
            ),
            SizedBox(height: metrics.geometry(10)),
            Container(
              padding: metrics.geometryInsets(
                const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              ),
              decoration: BoxDecoration(
                color: const Color(0xfff2efff),
                borderRadius: BorderRadius.circular(metrics.geometry(9)),
              ),
              child: Wrap(
                spacing: metrics.geometry(5),
                runSpacing: metrics.geometry(4),
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _approvedAsset(
                    'transparent/seller-competition.png',
                    width: metrics.geometry(10),
                    height: metrics.geometry(11),
                  ),
                  Text(
                    'Competition: Very High',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _approvedAction,
                      fontSize: _pickedSellerFontSize(metrics, 11),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _approvedAsset(
                    'transparent/trend-hot.png',
                    width: metrics.geometry(11),
                    height: metrics.geometry(13),
                  ),
                ],
              ),
            ),
          ],
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image,
            SizedBox(width: metrics.geometry(20)),
            Expanded(child: copy),
          ],
        );
      },
    );
  }
}

class _ApprovedSellerControls extends StatelessWidget {
  const _ApprovedSellerControls({
    required this.filtersOn,
    required this.sortLabel,
    required this.gridView,
    required this.onFilters,
    required this.onSort,
    required this.onView,
  });

  final bool filtersOn;
  final String sortLabel;
  final bool gridView;
  final VoidCallback onFilters;
  final ValueChanged<String> onSort;
  final ValueChanged<bool> onView;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final border = Border.all(
      color: _approvedBorder,
      width: metrics.geometry(1),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final reflow =
            constraints.maxWidth < 220 || metrics.accessibilityReflow;
        final filter = SizedBox(
          width: _sellerDimension(metrics, 78, floor: 72),
          height: _sellerDimension(metrics, 38, floor: 36),
          child: OutlinedButton(
            onPressed: onFilters,
            style: OutlinedButton.styleFrom(
              foregroundColor: _pageText(context),
              backgroundColor: filtersOn
                  ? const Color(0xfff1efff)
                  : _pageSurface(context),
              padding: metrics.geometryInsets(
                const EdgeInsets.symmetric(horizontal: 4),
              ),
              side: BorderSide(
                color: _approvedBorder,
                width: metrics.geometry(1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(metrics.geometry(7)),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _approvedAsset(
                  'transparent/seller-filter.png',
                  width: metrics.geometry(18),
                  height: metrics.geometry(18),
                ),
                SizedBox(width: metrics.geometry(4)),
                Text(
                  'Filters',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: _pickedSellerFontSize(metrics, 11),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
        final sort = PopupMenuButton<String>(
          onSelected: onSort,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Best deal', child: Text('Best deal')),
            PopupMenuItem(value: 'Lowest price', child: Text('Lowest price')),
            PopupMenuItem(value: 'Top rated', child: Text('Top rated')),
          ],
          child: Container(
            constraints: BoxConstraints(
              minHeight: _sellerDimension(metrics, 38, floor: 36),
            ),
            padding: metrics.geometryInsets(
              const EdgeInsets.symmetric(horizontal: 10),
            ),
            decoration: BoxDecoration(
              color: _pageSurface(context),
              border: border,
              borderRadius: BorderRadius.circular(metrics.geometry(7)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Sort by: $sortLabel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _pageText(context),
                      fontSize: _pickedSellerFontSize(metrics, 11),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _approvedAsset(
                  'transparent/seller-sort-down.png',
                  width: metrics.geometry(14),
                  height: metrics.geometry(11),
                ),
              ],
            ),
          ),
        );
        final toggle = Container(
          height: _sellerDimension(metrics, 38, floor: 36),
          decoration: BoxDecoration(
            color: _pageSurface(context),
            border: border,
            borderRadius: BorderRadius.circular(metrics.geometry(7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ApprovedViewChoice(
                tooltip: 'List view',
                selected: !gridView,
                asset: 'transparent/seller-list.png',
                onTap: () => onView(false),
              ),
              _ApprovedViewChoice(
                tooltip: 'Grid view',
                selected: gridView,
                asset: 'transparent/seller-grid.png',
                onTap: () => onView(true),
              ),
            ],
          ),
        );

        if (reflow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: filter),
                  SizedBox(width: metrics.geometry(9)),
                  toggle,
                ],
              ),
              SizedBox(height: metrics.geometry(9)),
              sort,
            ],
          );
        }

        return Row(
          children: [
            filter,
            SizedBox(width: metrics.geometry(9)),
            Expanded(child: sort),
            SizedBox(width: metrics.geometry(9)),
            toggle,
          ],
        );
      },
    );
  }
}

class _ApprovedViewChoice extends StatelessWidget {
  const _ApprovedViewChoice({
    required this.tooltip,
    required this.selected,
    required this.asset,
    required this.onTap,
  });

  final String tooltip;
  final bool selected;
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.geometry(6)),
        child: Container(
          width: metrics.artSize(35),
          height: metrics.geometry(32),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xfff1efff) : Colors.transparent,
            borderRadius: BorderRadius.circular(metrics.geometry(6)),
          ),
          child: _approvedAsset(
            asset,
            width: metrics.geometry(17),
            height: metrics.geometry(18),
          ),
        ),
      ),
    );
  }
}

class _ApprovedFilterChip extends StatelessWidget {
  const _ApprovedFilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      padding: metrics.geometryInsets(
        const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      ),
      decoration: BoxDecoration(
        color: const Color(0xfff1efff),
        borderRadius: BorderRadius.circular(metrics.geometry(999)),
      ),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: _approvedAction,
          fontSize: _pickedSellerFontSize(metrics, 11),
        ),
      ),
    );
  }
}

class _ApprovedSellerCard extends StatelessWidget {
  const _ApprovedSellerCard({required this.seller, required this.onChat});

  final _ApprovedSellerData seller;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      key: ValueKey('approved-seller-card-${seller.name}'),
      padding: EdgeInsets.all(_sellerDimension(metrics, 8, floor: 8)),
      decoration: BoxDecoration(
        color: _pageSurface(context),
        borderRadius: BorderRadius.circular(metrics.geometry(8)),
        border: Border.all(color: _approvedBorder, width: metrics.geometry(1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0d0b1047),
            blurRadius: metrics.geometry(8),
            offset: Offset(0, metrics.geometry(3)),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stack =
              constraints.maxWidth < 220 || metrics.accessibilityReflow;
          final identity = _ApprovedSellerIdentity(seller: seller);
          final commerce = _ApprovedSellerCommerce(
            seller: seller,
            onChat: onChat,
            fullWidth: stack,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (stack) ...[
                identity,
                SizedBox(height: metrics.geometry(10)),
                _ApprovedSellerBadge(seller: seller),
                SizedBox(height: metrics.geometry(10)),
                commerce,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: identity),
                    SizedBox(width: metrics.geometry(8)),
                    SizedBox(
                      width: _sellerDimension(metrics, 138, floor: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: _ApprovedSellerBadge(seller: seller),
                          ),
                          SizedBox(height: metrics.geometry(4)),
                          commerce,
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: metrics.geometry(6)),
              Divider(
                height: metrics.geometry(1),
                thickness: metrics.geometry(1),
                color: _approvedBorder,
              ),
              SizedBox(height: metrics.geometry(6)),
              _ApprovedSellerStats(seller: seller),
            ],
          );
        },
      ),
    );
  }
}

class _ApprovedSellerIdentity extends StatelessWidget {
  const _ApprovedSellerIdentity({required this.seller});

  final _ApprovedSellerData seller;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _approvedAsset(
          seller.avatar,
          width: _sellerDimension(metrics, 49, floor: 44),
          height: _sellerDimension(metrics, 52, floor: 47),
          semanticLabel: '${seller.name} profile photo',
        ),
        SizedBox(width: metrics.geometry(8)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      seller.name,
                      maxLines: metrics.accessibilityReflow ? 2 : 1,
                      softWrap: metrics.accessibilityReflow,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _pageText(context),
                        fontSize: _pickedSellerFontSize(metrics, 16),
                        fontWeight: FontWeight.w800,
                        height: metrics.lineHeight(
                          referenceFontSize: 16,
                          referenceLineHeight: 17.92,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: metrics.geometry(4)),
                  _approvedAsset(
                    'transparent/seller-verified.png',
                    width: metrics.geometry(11),
                    height: metrics.geometry(12),
                  ),
                ],
              ),
              SizedBox(height: metrics.geometry(6)),
              Row(
                children: [
                  _approvedAsset(
                    'transparent/seller-star.png',
                    width: metrics.geometry(11),
                    height: metrics.geometry(12),
                  ),
                  Text(
                    seller.rating,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _pageMuted(context),
                      fontSize: _pickedSellerFontSize(metrics, 11),
                    ),
                  ),
                ],
              ),
              SizedBox(height: metrics.geometry(5)),
              Text(
                '${seller.location}  •  ${seller.distance}',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _pageMuted(context),
                  fontSize: _pickedSellerFontSize(metrics, 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ApprovedSellerBadge extends StatelessWidget {
  const _ApprovedSellerBadge({required this.seller});

  final _ApprovedSellerData seller;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Container(
      constraints: BoxConstraints(minHeight: metrics.geometry(20)),
      padding: metrics.geometryInsets(
        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      ),
      decoration: BoxDecoration(
        color: seller.badgeColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(metrics.geometry(6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _approvedAsset(
            seller.badgeIcon,
            width: metrics.geometry(10),
            height: metrics.geometry(11),
          ),
          SizedBox(width: metrics.geometry(4)),
          Flexible(
            child: Text(
              seller.badge,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: seller.badgeColor,
                fontSize: _pickedSellerFontSize(metrics, 9),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovedSellerCommerce extends StatelessWidget {
  const _ApprovedSellerCommerce({
    required this.seller,
    required this.onChat,
    required this.fullWidth,
  });

  final _ApprovedSellerData seller;
  final VoidCallback onChat;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final accessibility = hocalistAccessibilityVisualsOf(context);
    final metrics = _replicaMetrics(context);
    final values = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          seller.price,
          maxLines: 1,
          softWrap: false,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _pageText(context),
            fontSize: _pickedSellerFontSize(metrics, 16),
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          seller.savings,
          maxLines: 1,
          softWrap: false,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _approvedGreen,
            fontSize: _pickedSellerFontSize(metrics, 11),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
    final chat = SizedBox(
      height: _sellerDimension(metrics, 30, floor: 29),
      child: FilledButton(
        onPressed: onChat,
        style: FilledButton.styleFrom(
          backgroundColor: accessibility.backgroundOr(_approvedAction),
          foregroundColor: accessibility.foregroundOr(Colors.white),
          padding: metrics.geometryInsets(
            const EdgeInsets.symmetric(horizontal: 2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              metrics.geometry(accessibility.radiusOr(9)),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _approvedAsset(
              'transparent/seller-chat.png',
              width: metrics.geometry(13),
              height: metrics.geometry(13),
            ),
            SizedBox(width: metrics.geometry(3)),
            Flexible(
              child: Text(
                'Chat Seller',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: _pickedSellerFontSize(metrics, 10.5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (fullWidth) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          values,
          SizedBox(height: metrics.geometry(9)),
          chat,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: values),
        SizedBox(width: metrics.geometry(3)),
        SizedBox(width: _sellerDimension(metrics, 80, floor: 72), child: chat),
      ],
    );
  }
}

class _ApprovedSellerStats extends StatelessWidget {
  const _ApprovedSellerStats({required this.seller});

  final _ApprovedSellerData seller;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: _pageMuted(context),
      fontSize: _pickedSellerFontSize(metrics, 9.5),
      height: metrics.lineHeight(
        referenceFontSize: 10,
        referenceLineHeight: 11.5,
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final deals = _ApprovedIconText(
          icon: 'transparent/seller-deals.png',
          label: seller.deals,
          style: style,
        );
        final response = _ApprovedIconText(
          icon: 'transparent/seller-response.png',
          label: seller.response,
          style: style,
        );
        if (constraints.maxWidth < 220 || metrics.accessibilityReflow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              deals,
              SizedBox(height: metrics.geometry(8)),
              response,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: metrics.geometry(112), child: deals),
            SizedBox(width: metrics.geometry(16)),
            Expanded(child: response),
          ],
        );
      },
    );
  }
}

class _ApprovedIconText extends StatelessWidget {
  const _ApprovedIconText({
    required this.icon,
    required this.label,
    required this.style,
  });

  final String icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _approvedAsset(
          icon,
          width: metrics.geometry(9),
          height: metrics.geometry(10),
        ),
        SizedBox(width: metrics.geometry(5)),
        Expanded(
          child: Text(
            label,
            maxLines: metrics.accessibilityReflow ? 2 : 1,
            softWrap: metrics.accessibilityReflow,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _ApprovedSellerData {
  const _ApprovedSellerData({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.location,
    required this.distance,
    required this.price,
    required this.savings,
    required this.badge,
    required this.badgeIcon,
    required this.badgeColor,
    required this.deals,
    required this.response,
  });

  final String name;
  final String avatar;
  final String rating;
  final String location;
  final String distance;
  final String price;
  final String savings;
  final String badge;
  final String badgeIcon;
  final Color badgeColor;
  final String deals;
  final String response;
}

const _approvedSellers = [
  _ApprovedSellerData(
    name: 'Northside Tech',
    avatar: 'seller-northside-tech.png',
    rating: '4.9 (128 reviews)',
    location: 'Yonkers, NY',
    distance: '2.1 mi',
    price: '\$820',
    savings: 'Save \$180',
    badge: 'Top Rated Seller',
    badgeIcon: 'transparent/badge-trophy.png',
    badgeColor: _approvedAction,
    deals: '230+ deals completed',
    response: 'Usually responds in a few hours',
  ),
  _ApprovedSellerData(
    name: 'Gadget Hub',
    avatar: 'seller-gadget-hub.png',
    rating: '4.7 (96 reviews)',
    location: 'Yonkers, NY',
    distance: '3.4 mi',
    price: '\$835',
    savings: 'Save \$165',
    badge: 'Great Deal',
    badgeIcon: 'transparent/badge-deal.png',
    badgeColor: _approvedGreen,
    deals: '150+ deals completed',
    response: 'Responds within 2 hours',
  ),
  _ApprovedSellerData(
    name: 'Prime Tech Solutions',
    avatar: 'seller-prime-tech.png',
    rating: '4.6 (78 reviews)',
    location: 'Yonkers, NY',
    distance: '4.7 mi',
    price: '\$845',
    savings: 'Save \$155',
    badge: 'Fast Responder',
    badgeIcon: 'transparent/badge-fast.png',
    badgeColor: Color(0xff1769ff),
    deals: '120+ deals completed',
    response: 'Usually responds in a few hours',
  ),
  _ApprovedSellerData(
    name: 'Tech World NY',
    avatar: 'seller-tech-world.png',
    rating: '4.5 (64 reviews)',
    location: 'Yonkers, NY',
    distance: '5.2 mi',
    price: '\$860',
    savings: 'Save \$140',
    badge: 'Good Value',
    badgeIcon: 'transparent/badge-value.png',
    badgeColor: Color(0xffdf8500),
    deals: '90+ deals completed',
    response: 'Responds within 3 hours',
  ),
  _ApprovedSellerData(
    name: 'Digital Depot',
    avatar: 'seller-digital-depot.png',
    rating: '4.4 (52 reviews)',
    location: 'Yonkers, NY',
    distance: '6.0 mi',
    price: '\$875',
    savings: 'Save \$125',
    badge: 'Trusted Seller',
    badgeIcon: 'transparent/badge-trusted.png',
    badgeColor: _approvedAction,
    deals: '110+ deals completed',
    response: 'Usually responds in a few hours',
  ),
];

/// Screenshot-approved buyer notification history (the existing Recent
/// activity destination) with the current back callback and working filters.
class ApprovedBuyerNotificationsPage extends StatefulWidget {
  const ApprovedBuyerNotificationsPage({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<ApprovedBuyerNotificationsPage> createState() =>
      _ApprovedBuyerNotificationsPageState();
}

class _ApprovedBuyerNotificationsPageState
    extends State<ApprovedBuyerNotificationsPage> {
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    final visible = selected == 'All'
        ? _approvedActivities
        : _approvedActivities.where((item) => item.category == selected);
    return _ApprovedReplicaSurface(
      builder: (context) {
        final metrics = _replicaMetrics(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _ApprovedBitmapButton(
                  tooltip: 'Back to home',
                  onPressed: widget.onBack,
                  asset: 'activity-back.png',
                  size: metrics.geometry(44),
                  imageWidth: metrics.geometry(18),
                  imageHeight: metrics.geometry(18),
                ),
                SizedBox(width: metrics.geometry(4)),
                Expanded(
                  child: Text(
                    'Recent activity',
                    textAlign: TextAlign.center,
                    style: BuyerTypography.style(
                      context,
                      metrics,
                      BuyerTextRole.pageTitle,
                      color: _pageText(context),
                      height: metrics.lineHeight(
                        referenceFontSize: 16,
                        referenceLineHeight: 19.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: metrics.geometry(44)),
              ],
            ),
            SizedBox(height: metrics.geometry(20)),
            _ApprovedActivityTabs(
              selected: selected,
              onChanged: (value) => setState(() => selected = value),
            ),
            SizedBox(height: metrics.geometry(20)),
            for (final item in visible) ...[
              _ApprovedActivityRow(item: item),
              if (item != visible.last)
                Divider(
                  height: metrics.geometry(1),
                  thickness: metrics.geometry(1),
                  color: _approvedBorder,
                ),
            ],
          ],
        );
      },
    );
  }
}

class _ApprovedActivityTabs extends StatelessWidget {
  const _ApprovedActivityTabs({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const tabs = ['All', 'Offers', 'Rewards', 'Reviews', 'Payouts'];

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final scroll =
            constraints.maxWidth < 220 || metrics.accessibilityReflow;
        final children = [
          for (final tab in tabs)
            _ApprovedActivityTab(
              label: tab,
              selected: selected == tab,
              onTap: () => onChanged(tab),
              expand: !scroll,
            ),
        ];
        final content = scroll
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisSize: MainAxisSize.min, children: children),
              )
            : Row(children: children);
        return Container(
          constraints: BoxConstraints(minHeight: metrics.geometry(29)),
          decoration: BoxDecoration(
            color: _pageSurface(context),
            border: Border.all(
              color: _approvedBorder,
              width: metrics.geometry(1),
            ),
            borderRadius: BorderRadius.circular(metrics.geometry(7)),
          ),
          child: content,
        );
      },
    );
  }
}

class _ApprovedActivityTab extends StatelessWidget {
  const _ApprovedActivityTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.expand,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final metrics = _replicaMetrics(context);
    final child = Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.geometry(6)),
        child: Container(
          constraints: BoxConstraints(
            minWidth: expand ? 0 : metrics.geometry(72),
            minHeight: metrics.geometry(26),
          ),
          padding: metrics.geometryInsets(
            const EdgeInsets.symmetric(horizontal: 6),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _approvedAction : Colors.transparent,
            borderRadius: BorderRadius.circular(metrics.geometry(6)),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? Colors.white : _pageMuted(context),
              fontSize: metrics.fontSize(10.5),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
    return expand ? Expanded(child: child) : child;
  }
}

class _ApprovedActivityRow extends StatelessWidget {
  const _ApprovedActivityRow({required this.item});

  final _ApprovedActivityData item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _replicaMetrics(context);
        final tight = constraints.maxWidth < 220 || metrics.accessibilityReflow;
        final trailing = item.stars
            ? Wrap(
                spacing: metrics.geometry(1),
                children: List.generate(
                  5,
                  (_) => _approvedAsset(
                    'activity-rating-star.png',
                    width: metrics.geometry(17),
                    height: metrics.geometry(17),
                  ),
                ),
              )
            : Text(
                item.value!,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: item.valueColor,
                  fontSize: metrics.fontSize(16),
                  fontWeight: FontWeight.w800,
                ),
              );
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _pageText(context),
                fontSize: metrics.fontSize(12.5),
                fontWeight: FontWeight.w800,
                height: metrics.lineHeight(
                  referenceFontSize: 12.5,
                  referenceLineHeight: 15.625,
                ),
              ),
            ),
            SizedBox(height: metrics.geometry(3)),
            Text(
              item.time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _pageMuted(context),
                fontSize: metrics.fontSize(10.5),
                height: metrics.lineHeight(
                  referenceFontSize: 10.5,
                  referenceLineHeight: 12.6,
                ),
              ),
            ),
            if (tight) ...[SizedBox(height: metrics.geometry(5)), trailing],
          ],
        );
        return Padding(
          key: ValueKey('approved-activity-${item.time}'),
          padding: EdgeInsets.symmetric(vertical: metrics.geometry(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _approvedAsset(
                item.icon,
                width: metrics.geometry(44),
                height: metrics.geometry(44),
              ),
              SizedBox(width: metrics.geometry(16)),
              Expanded(child: copy),
              if (!tight) ...[
                SizedBox(width: metrics.geometry(8)),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: metrics.geometry(104)),
                  child: FittedBox(fit: BoxFit.scaleDown, child: trailing),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ApprovedActivityData {
  const _ApprovedActivityData({
    required this.category,
    required this.icon,
    required this.title,
    required this.time,
    this.value,
    this.valueColor = _approvedGreen,
    this.stars = false,
  });

  final String category;
  final String icon;
  final String title;
  final String time;
  final String? value;
  final Color valueColor;
  final bool stars;
}

const _approvedActivities = [
  _ApprovedActivityData(
    category: 'Offers',
    icon: 'activity-chat.png',
    title: 'Northside Tech sent you a new offer',
    time: '2 minutes ago',
    value: '\$420',
  ),
  _ApprovedActivityData(
    category: 'Offers',
    icon: 'activity-check.png',
    title: 'Loop Resale accepted your request',
    time: '1 hour ago',
    value: '\$390',
  ),
  _ApprovedActivityData(
    category: 'Reviews',
    icon: 'activity-star.png',
    title: 'You earned a new review',
    time: 'Yesterday',
    stars: true,
  ),
  _ApprovedActivityData(
    category: 'Payouts',
    icon: 'activity-wallet.png',
    title: 'Rewards will be paid on May 20',
    time: '2 days ago',
    value: '\$24.80',
    valueColor: _approvedAction,
  ),
  _ApprovedActivityData(
    category: 'Rewards',
    icon: 'activity-check.png',
    title: 'Tech World NY confirmed your purchase',
    time: '3 days ago',
    value: '+ \$8.60',
  ),
  _ApprovedActivityData(
    category: 'Offers',
    icon: 'activity-chat.png',
    title: 'Gadget Hub sent you a new offer',
    time: '4 days ago',
    value: '\$350',
  ),
  _ApprovedActivityData(
    category: 'Reviews',
    icon: 'activity-star.png',
    title: 'You earned a new review',
    time: '5 days ago',
    stars: true,
  ),
  _ApprovedActivityData(
    category: 'Payouts',
    icon: 'activity-wallet.png',
    title: 'Rewards will be paid on May 13',
    time: '6 days ago',
    value: '\$19.40',
    valueColor: _approvedAction,
  ),
];
