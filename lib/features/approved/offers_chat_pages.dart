import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/accessibility_visuals.dart';
import 'approved_replica_metrics.dart';

const _assetRoot = 'assets/approved_offers_chat';

const _navy = Color(0xff080b62);
const _blue = Color(0xff1117e8);
const _offersBlue = Color(0xff0f0b7a);
const _muted = Color(0xff555a7c);
const _line = Color(0xffe8e9f3);
const _lavender = Color(0xfff1efff);
const _green = Color(0xff109b4e);

/// Route callbacks needed by the approved buyer bottom navigation.
class ApprovedBuyerNavigation {
  const ApprovedBuyerNavigation({
    required this.onHome,
    required this.onHocatrends,
    required this.onOffers,
    required this.onChats,
    required this.onMore,
  });

  final VoidCallback onHome;
  final VoidCallback onHocatrends;
  final VoidCallback onOffers;
  final VoidCallback onChats;
  final VoidCallback onMore;
}

enum ApprovedBuyerNavSelection { home, hocatrends, offers, chats, more }

/// Approved offers-received replica. It owns the page header, scroll surface,
/// offer actions, and buyer bottom navigation so integration does not depend on
/// private widgets in the existing app shell.
class ApprovedOffersReceivedPage extends StatefulWidget {
  const ApprovedOffersReceivedPage({
    required this.onBack,
    required this.onNotifications,
    required this.onViewOffer,
    required this.onChat,
    required this.onFilter,
    required this.navigation,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onNotifications;
  final VoidCallback onViewOffer;
  final VoidCallback onChat;
  final VoidCallback onFilter;
  final ApprovedBuyerNavigation navigation;

  @override
  State<ApprovedOffersReceivedPage> createState() =>
      _ApprovedOffersReceivedPageState();
}

class _ApprovedOffersReceivedPageState
    extends State<ApprovedOffersReceivedPage> {
  String _sort = 'Best match';

  @override
  Widget build(BuildContext context) {
    return _ApprovedPageScaffold(
      onBack: widget.onBack,
      selection: ApprovedBuyerNavSelection.offers,
      accentColor: _offersBlue,
      navigation: widget.navigation,
      bodyKey: const Key('approved-offers-scroll'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
          sliver: SliverList.list(
            children: [
              _ApprovedGlobalHeader(onNotifications: widget.onNotifications),
              const SizedBox(height: 6),
              const _OffersHero(),
              const SizedBox(height: 8),
              const _OffersRewardsCard(),
              const SizedBox(height: 10),
              _OffersToolbar(
                value: _sort,
                onChanged: (value) => setState(() => _sort = value),
                onFilter: widget.onFilter,
              ),
              const SizedBox(height: 8),
              _ApprovedOfferCard(
                topMatch: true,
                seller: 'Northside Tech',
                initials: 'NT',
                reviews: '4.9 (128 reviews)',
                status: 'Verified seller',
                statusColor: _green,
                price: '\$420',
                description:
                    'iPad Air 5, 256GB, keyboard case, public pickup, Saturday.',
                firstFactAsset: 'offers-identity.png',
                firstFactTitle: 'Verified',
                firstFactBody: 'Identity verified',
                distance: '1.2 mi away',
                availability: 'Sat, May 17',
                onDetails: widget.onViewOffer,
                onChat: widget.onChat,
              ),
              const SizedBox(height: 8),
              _ApprovedOfferCard(
                seller: 'Loop Resale',
                initials: 'LR',
                reviews: '4.9 (86 reviews)',
                status: 'Fast responder',
                statusColor: _offersBlue,
                price: '\$390',
                description:
                    'iPad Air 5, 64GB, same-day pickup, no accessories.',
                firstFactAsset: 'offers-fast-reply.png',
                firstFactTitle: 'Fast reply',
                firstFactBody: 'Usually responds in minutes',
                distance: '0.8 mi away',
                availability: 'Today',
                onDetails: widget.onViewOffer,
                onChat: widget.onChat,
              ),
              const SizedBox(height: 8),
              const _SecurePrivateNotice(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Approved seller-offer detail replica. The unsafe protection claim in the
/// raster reference is intentionally replaced by the current offline-payment
/// boundary copy.
class ApprovedViewOfferPage extends StatelessWidget {
  const ApprovedViewOfferPage({
    required this.onBack,
    required this.onNotifications,
    required this.onSelectSeller,
    required this.onViewProfile,
    required this.navigation,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onNotifications;
  final VoidCallback onSelectSeller;
  final VoidCallback onViewProfile;
  final ApprovedBuyerNavigation navigation;

  @override
  Widget build(BuildContext context) {
    return _ApprovedPageScaffold(
      onBack: onBack,
      selection: ApprovedBuyerNavSelection.offers,
      navigation: navigation,
      bodyKey: const Key('approved-view-offer-scroll'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 14),
          sliver: SliverList.list(
            children: [
              _OfferDetailHeader(
                onBack: onBack,
                onNotifications: onNotifications,
              ),
              const SizedBox(height: 8),
              const _OfferSellerSummary(),
              const SizedBox(height: 8),
              const _OfferRewardWindow(),
              const SizedBox(height: 8),
              const _OfferDescription(),
              const SizedBox(height: 6),
              const _OfferPinNotice(),
              const SizedBox(height: 6),
              _AboutSeller(onViewProfile: onViewProfile),
              const SizedBox(height: 6),
              const _OfferOfflineNotice(),
              const SizedBox(height: 6),
              _SelectSellerPanel(onSelect: onSelectSeller),
            ],
          ),
        ),
      ],
    );
  }
}

/// Approved buyer/seller chat replica with the current mock action callbacks.
class ApprovedBuyerChatPage extends StatefulWidget {
  const ApprovedBuyerChatPage({
    required this.onBack,
    required this.onPrimary,
    required this.onCall,
    required this.onMore,
    required this.onRequestChange,
    required this.onChangeLocation,
    required this.onAttach,
    required this.onSend,
    required this.onLearnMore,
    required this.navigation,
    this.primaryLabel = 'Accept to meet',
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onPrimary;
  final VoidCallback onCall;
  final VoidCallback onMore;
  final VoidCallback onRequestChange;
  final VoidCallback onChangeLocation;
  final VoidCallback onAttach;
  final ValueChanged<String> onSend;
  final VoidCallback onLearnMore;
  final ApprovedBuyerNavigation navigation;
  final String primaryLabel;

  @override
  State<ApprovedBuyerChatPage> createState() => _ApprovedBuyerChatPageState();
}

class _ApprovedBuyerChatPageState extends State<ApprovedBuyerChatPage> {
  final _controller = TextEditingController();
  bool _detailsOpen = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _ApprovedPageScaffold(
      onBack: widget.onBack,
      selection: ApprovedBuyerNavSelection.chats,
      navigation: widget.navigation,
      bodyKey: const Key('approved-chat-scroll'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
          sliver: SliverList.list(
            children: [
              _ChatHeader(
                onBack: widget.onBack,
                onCall: widget.onCall,
                onMore: widget.onMore,
              ),
              const SizedBox(height: 8),
              const _ChatProductCard(),
              const SizedBox(height: 8),
              _FinalOfferCard(
                expanded: _detailsOpen,
                onToggle: () => setState(() => _detailsOpen = !_detailsOpen),
                onRequestChange: widget.onRequestChange,
                onChangeLocation: widget.onChangeLocation,
              ),
              const SizedBox(height: 8),
              _PrimaryButton(
                key: const Key('approved-accept-to-meet'),
                label: widget.primaryLabel,
                onPressed: widget.onPrimary,
                height: 44,
              ),
              const SizedBox(height: 12),
              const _DateDivider(),
              const SizedBox(height: 10),
              const _IncomingMessage(
                key: Key('approved-chat-message-incoming-1'),
                text: 'Hi! The iPad is in perfect condition like we discussed.',
                time: '9:30 AM',
              ),
              const SizedBox(height: 6),
              const _OutgoingMessage(
                key: Key('approved-chat-message-outgoing-1'),
                text: 'Looks good! I\'m ready to move forward thumbs up',
                time: '9:31 AM',
              ),
              const SizedBox(height: 6),
              const _IncomingMessage(
                key: Key('approved-chat-message-incoming-2'),
                text: 'Hi! The iPad is in perfect condition like we discussed.',
                time: '9:30 AM',
              ),
              const _ScreenshotLockedSpacer(
                key: Key('approved-chat-locked-lower-spacer'),
                height: 18,
              ),
              const SizedBox(height: 10),
              _ChatSafetyNotice(
                key: const Key('approved-chat-safety-notice'),
                onLearnMore: widget.onLearnMore,
              ),
              const SizedBox(height: 8),
              _MessageComposer(
                controller: _controller,
                onAttach: widget.onAttach,
                onSend: _send,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ApprovedPageScaffold extends StatelessWidget {
  const _ApprovedPageScaffold({
    required this.onBack,
    required this.selection,
    required this.navigation,
    required this.bodyKey,
    required this.slivers,
    this.accentColor = _blue,
  });

  final VoidCallback onBack;
  final ApprovedBuyerNavSelection selection;
  final ApprovedBuyerNavigation navigation;
  final Key bodyKey;
  final List<Widget> slivers;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.of(context);
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : media.size.width;
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : media.size.height;
        final metrics = ApprovedReplicaMetrics.resolve(
          availableWidth: availableWidth,
          textScaler: media.textScaler,
        );

        if (metrics.screenshotLocked) {
          final canvasSize = Size(
            ApprovedReplicaMetrics.referenceCanvasWidth,
            availableHeight / metrics.geometryScale,
          );
          return ColoredBox(
            color: Colors.white,
            child: Center(
              child: SizedBox(
                key: const Key('approved-replica-viewport'),
                width: metrics.contentMaxWidth,
                height: availableHeight,
                child: ClipRect(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox.fromSize(
                      key: const Key('approved-replica-canvas'),
                      size: canvasSize,
                      child: _buildScaffold(media, metrics, canvasSize),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final canvasSize = Size(metrics.contentMaxWidth, availableHeight);
        return ColoredBox(
          color: Colors.white,
          child: Center(
            child: SizedBox.fromSize(
              key: const Key('approved-replica-viewport'),
              size: canvasSize,
              child: _buildScaffold(media, metrics, canvasSize),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScaffold(
    MediaQueryData media,
    ApprovedReplicaMetrics metrics,
    Size canvasSize,
  ) {
    return ApprovedReplicaScope(
      metrics: metrics,
      child: MediaQuery(
        data: media.copyWith(
          size: Size(
            ApprovedReplicaMetrics.referenceCanvasWidth,
            canvasSize.height,
          ),
        ),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) onBack();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: CustomScrollView(key: bodyKey, slivers: slivers),
            ),
            bottomNavigationBar: _ApprovedBottomNavigation(
              selected: selection,
              callbacks: navigation,
              accentColor: accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _text(
  BuildContext context, {
  double size = 14,
  FontWeight weight = FontWeight.w600,
  Color color = _navy,
  double height = 1.25,
}) {
  return (Theme.of(context).textTheme.bodyMedium ?? const TextStyle()).copyWith(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: 0,
  );
}

bool _usesAccessibilityReflow(BuildContext context) {
  return ApprovedReplicaScope.of(context).accessibilityReflow;
}

class _ScreenshotLockedSpacer extends StatelessWidget {
  const _ScreenshotLockedSpacer({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ApprovedReplicaScope.of(context).screenshotLocked ? height : 0,
    );
  }
}

Widget _asset(
  String name, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  String? semanticLabel,
}) {
  return _ApprovedRasterAsset(
    asset: '$_assetRoot/$name',
    width: width,
    height: height,
    fit: fit,
    semanticLabel: semanticLabel,
  );
}

class _ApprovedRasterAsset extends StatefulWidget {
  const _ApprovedRasterAsset({
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticLabel,
    this.color,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;
  final Color? color;

  @override
  State<_ApprovedRasterAsset> createState() => _ApprovedRasterAssetState();
}

class _ApprovedRasterAssetState extends State<_ApprovedRasterAsset> {
  AssetBundle? _bundle;
  Future<ByteData>? _bytes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bundle = DefaultAssetBundle.of(context);
    if (_bundle != bundle) {
      _bundle = bundle;
      _bytes = bundle.load(widget.asset);
    }
  }

  @override
  void didUpdateWidget(covariant _ApprovedRasterAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _bytes = _bundle!.load(widget.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FutureBuilder<ByteData>(
        future: _bytes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget.withDetails(
              message: 'Missing approved asset: ${widget.asset}',
            );
          }
          final data = snapshot.data;
          if (data == null) {
            return const SizedBox.shrink();
          }
          return Image.memory(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            filterQuality: FilterQuality.high,
            semanticLabel: widget.semanticLabel,
            color: widget.color,
            colorBlendMode: widget.color == null ? null : BlendMode.srcIn,
            gaplessPlayback: true,
          );
        },
      ),
    );
  }
}

class _ApprovedGlobalHeader extends StatelessWidget {
  const _ApprovedGlobalHeader({required this.onNotifications});

  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context).scale(1);
        final stacked = scaler > 1.3;
        final compact = constraints.maxWidth < 320;
        final logo = Semantics(
          image: true,
          label: 'Hocalist Reverse Marketplace',
          child: _asset(
            'wordmark.png',
            width: compact ? 64 : (constraints.maxWidth < 350 ? 84 : 92),
            height: compact ? 38 : 48,
          ),
        );
        final mode = Container(
          height: compact ? 30 : 36,
          padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 10),
          decoration: BoxDecoration(
            color: _lavender,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _asset(
                'header-buyer.png',
                width: compact ? 17 : 21,
                height: compact ? 17 : 21,
              ),
              SizedBox(width: compact ? 4 : 5),
              Text(
                'Buyer mode',
                style: _text(
                  context,
                  size: compact ? 9 : 12,
                  weight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
        final notification = IconButton(
          key: const Key('approved-notifications'),
          tooltip: 'Notifications',
          onPressed: onNotifications,
          icon: _asset(
            'header-bell.png',
            width: compact ? 21 : 28,
            height: compact ? 21 : 28,
          ),
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [logo, const Spacer(), notification]),
              Align(alignment: Alignment.centerRight, child: mode),
            ],
          );
        }
        return SizedBox(
          height: compact ? 42 : 56,
          child: Row(
            children: [
              logo,
              const Spacer(),
              mode,
              const SizedBox(width: 4),
              notification,
            ],
          ),
        );
      },
    );
  }
}

class _OffersHero extends StatelessWidget {
  const _OffersHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 330;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offers received',
              style: _text(
                context,
                size: narrow ? 17 : 23,
                weight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Compare offers and choose the best seller for you.',
              style: _text(
                context,
                size: narrow ? 10 : 13,
                color: _muted,
                height: 1.3,
              ),
            ),
          ],
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 6, child: copy),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: _asset(
                'offers-envelope.png',
                height: narrow ? 70 : 96,
                semanticLabel: 'Offer arriving in an envelope',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OffersRewardsCard extends StatelessWidget {
  const _OffersRewardsCard();

  @override
  Widget build(BuildContext context) {
    final compact =
        MediaQuery.sizeOf(context).width <= 320 &&
        !_usesAccessibilityReflow(context);
    return _Surface(
      color: const Color(0xfffaf9ff),
      padding: EdgeInsets.all(compact ? 7 : 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = _usesAccessibilityReflow(context);
          final tight = constraints.maxWidth < 300;
          final total = _RewardsTotal(
            compact: constraints.maxWidth < 390,
            tight: tight,
          );
          final rules = _RewardRules(tight: tight);
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [total, const SizedBox(height: 10), rules],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: total),
              SizedBox(width: tight ? 5 : 8),
              Container(
                width: 1,
                height: tight ? 96 : 126,
                color: const Color(0xffdedff0),
              ),
              SizedBox(width: tight ? 5 : 8),
              Expanded(flex: 6, child: rules),
            ],
          );
        },
      ),
    );
  }
}

class _RewardsTotal extends StatelessWidget {
  const _RewardsTotal({required this.compact, required this.tight});
  final bool compact;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _asset(
          'rewards-gift.png',
          width: tight ? 38 : (compact ? 50 : 64),
          height: tight ? 52 : (compact ? 68 : 78),
        ),
        SizedBox(width: tight ? 4 : 7),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Your total rewards',
                      style: _text(context, size: tight ? 8 : 11),
                    ),
                  ),
                  SizedBox(width: tight ? 2 : 4),
                  _asset(
                    'info.png',
                    width: tight ? 11 : 15,
                    height: tight ? 11 : 15,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Wrap(
                spacing: 7,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '\$0.40',
                    style: _text(
                      context,
                      size: tight ? 21 : 27,
                      weight: FontWeight.w900,
                      color: _offersBlue,
                    ),
                  ),
                  _Pill(
                    label: 'From 2 sellers',
                    color: const Color(0xffe9e5ff),
                    compact: tight,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '\$0.20 from each seller',
                style: _text(
                  context,
                  size: tight ? 8 : 10,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tight ? 4 : 7,
                  vertical: tight ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: _lavender,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _asset(
                      'offers-heart.png',
                      width: tight ? 9 : 13,
                      height: tight ? 9 : 13,
                    ),
                    SizedBox(width: tight ? 2 : 4),
                    Flexible(
                      child: Text(
                        'You earn when you buy',
                        style: _text(
                          context,
                          size: tight ? 7 : 9,
                          weight: FontWeight.w800,
                          color: _offersBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardRules extends StatelessWidget {
  const _RewardRules({required this.tight});
  final bool tight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RewardRule(
          asset: 'offers-calendar.png',
          title: 'Buy from any seller within 5 days',
          body: 'To keep rewards from all sellers',
          tight: tight,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: tight ? 4 : 6),
          child: const Divider(height: 1, color: Color(0xffdedff0)),
        ),
        _RewardRule(
          asset: 'offers-gift.png',
          title: 'Rewards are added after purchase',
          body: 'Completed through the app',
          tight: tight,
        ),
      ],
    );
  }
}

class _RewardRule extends StatelessWidget {
  const _RewardRule({
    required this.asset,
    required this.title,
    required this.body,
    required this.tight,
  });
  final String asset;
  final String title;
  final String body;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _asset(asset, width: tight ? 26 : 34, height: tight ? 26 : 34),
        SizedBox(width: tight ? 4 : 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: _text(
                  context,
                  size: tight ? 8 : 10,
                  weight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                body,
                style: _text(
                  context,
                  size: tight ? 7 : 9,
                  weight: FontWeight.w500,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.compact = false});
  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 6,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: _text(
          context,
          size: compact ? 7 : 9,
          weight: FontWeight.w800,
          color: _navy,
        ),
      ),
    );
  }
}

class _OffersToolbar extends StatelessWidget {
  const _OffersToolbar({
    required this.value,
    required this.onChanged,
    required this.onFilter,
  });
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 320;
        return Row(
          children: [
            Text(
              'Sort by',
              style: _text(
                context,
                size: compact ? 9 : 12,
                weight: FontWeight.w800,
              ),
            ),
            SizedBox(width: compact ? 5 : 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                key: const Key('approved-offers-sort'),
                initialValue: value,
                isExpanded: true,
                icon: _asset(
                  'offers-sort-down.png',
                  width: compact ? 13 : 16,
                  height: compact ? 13 : 16,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  constraints: compact
                      ? const BoxConstraints(minHeight: 32)
                      : null,
                  visualDensity: compact
                      ? VisualDensity.compact
                      : VisualDensity.standard,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: compact ? 8 : 10,
                    vertical: compact ? 4 : 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _line),
                  ),
                ),
                style: _text(
                  context,
                  size: compact ? 9 : 11,
                  weight: FontWeight.w800,
                ),
                items: const ['Best match', 'Lowest price', 'Closest']
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (next) {
                  if (next != null) onChanged(next);
                },
              ),
            ),
            SizedBox(width: compact ? 5 : 8),
            OutlinedButton(
              key: const Key('approved-offers-filter'),
              onPressed: onFilter,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(compact ? 58 : 72, compact ? 32 : 44),
                tapTargetSize: compact
                    ? MaterialTapTargetSize.shrinkWrap
                    : MaterialTapTargetSize.padded,
                padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
                side: const BorderSide(color: _line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Filter',
                style: _text(
                  context,
                  size: compact ? 9 : 11,
                  weight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ApprovedOfferCard extends StatelessWidget {
  const _ApprovedOfferCard({
    required this.seller,
    required this.initials,
    required this.reviews,
    required this.status,
    required this.statusColor,
    required this.price,
    required this.description,
    required this.firstFactAsset,
    required this.firstFactTitle,
    required this.firstFactBody,
    required this.distance,
    required this.availability,
    required this.onDetails,
    required this.onChat,
    this.topMatch = false,
  });

  final String seller;
  final String initials;
  final String reviews;
  final String status;
  final Color statusColor;
  final String price;
  final String description;
  final String firstFactAsset;
  final String firstFactTitle;
  final String firstFactBody;
  final String distance;
  final String availability;
  final VoidCallback onDetails;
  final VoidCallback onChat;
  final bool topMatch;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      key: Key('approved-offer-card-$initials'),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topMatch)
            Container(
              padding: const EdgeInsets.fromLTRB(4, 0, 7, 0),
              decoration: const BoxDecoration(
                color: Color(0xffe5f5eb),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _asset('offers-top-match.png', width: 11, height: 11),
                  const SizedBox(width: 3),
                  Text(
                    'Top match',
                    style: _text(
                      context,
                      size: 8,
                      weight: FontWeight.w800,
                      color: _green,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                _OfferCardHeader(
                  seller: seller,
                  initials: initials,
                  reviews: reviews,
                  status: status,
                  statusColor: statusColor,
                  price: price,
                ),
                const SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 300;
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _asset(
                            'offer-thumbnail.png',
                            width: compact ? 38 : 50,
                            height: compact ? 25 : 33,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: compact ? 5 : 7),
                        Expanded(
                          child: Text(
                            description,
                            style: _text(
                              context,
                              size: compact ? 8 : 10,
                              weight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = !_usesAccessibilityReflow(context);
                    final facts = [
                      _OfferFact(
                        asset: firstFactAsset,
                        title: firstFactTitle,
                        body: firstFactBody,
                      ),
                      _OfferFact(
                        asset: 'offers-location.png',
                        title: distance,
                        body: 'from you',
                      ),
                      _OfferFact(
                        asset: 'offers-clock.png',
                        title: 'Available',
                        body: availability,
                      ),
                    ];
                    if (!columns) {
                      return Column(
                        children: [
                          for (final fact in facts)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: fact,
                            ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        for (var i = 0; i < facts.length; i++) ...[
                          Expanded(child: facts[i]),
                          if (i < facts.length - 1) const SizedBox(width: 5),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = _usesAccessibilityReflow(context);
                    final compact = constraints.maxWidth < 300;
                    final details = _PrimaryButton(
                      key: Key('approved-view-offer-$initials'),
                      label: 'View offer details',
                      onPressed: onDetails,
                      height: compact ? 30 : 44,
                      radius: 9,
                      backgroundColor: _offersBlue,
                    );
                    final chat = OutlinedButton(
                      key: Key('approved-chat-after-$initials'),
                      onPressed: onChat,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(0, compact ? 30 : 44),
                        tapTargetSize: compact
                            ? MaterialTapTargetSize.shrinkWrap
                            : MaterialTapTargetSize.padded,
                        side: const BorderSide(color: _line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(
                        'Chat after selection',
                        textAlign: TextAlign.center,
                        style: _text(
                          context,
                          size: compact ? 8 : 10,
                          weight: FontWeight.w700,
                          color: _muted,
                        ),
                      ),
                    );
                    if (stacked) {
                      return Column(
                        children: [
                          SizedBox(width: double.infinity, child: details),
                          const SizedBox(height: 6),
                          SizedBox(width: double.infinity, child: chat),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(flex: 5, child: details),
                        SizedBox(width: compact ? 5 : 7),
                        Expanded(flex: 3, child: chat),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCardHeader extends StatelessWidget {
  const _OfferCardHeader({
    required this.seller,
    required this.initials,
    required this.reviews,
    required this.status,
    required this.statusColor,
    required this.price,
  });
  final String seller;
  final String initials;
  final String reviews;
  final String status;
  final Color statusColor;
  final String price;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = _usesAccessibilityReflow(context);
        final tight = constraints.maxWidth < 300;
        final identity = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InitialsAvatar(initials: initials, size: tight ? 28 : 36),
            SizedBox(width: tight ? 5 : 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          seller,
                          style: _text(
                            context,
                            size: tight ? 11 : 14,
                            weight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _asset(
                        'detail-verified.png',
                        width: tight ? 13 : 16,
                        height: tight ? 13 : 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: 5,
                    runSpacing: 3,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _asset(
                        'detail-star.png',
                        width: tight ? 10 : 13,
                        height: tight ? 10 : 13,
                      ),
                      Text(
                        reviews,
                        style: _text(
                          context,
                          size: tight ? 7 : 9,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '•  $status',
                        style: _text(
                          context,
                          size: tight ? 7 : 9,
                          weight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
        final priceWidget = Column(
          crossAxisAlignment: compact
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: _text(
                context,
                size: tight ? 15 : 18,
                weight: FontWeight.w900,
                color: _offersBlue,
              ),
            ),
            Text(
              'Total price',
              style: _text(
                context,
                size: tight ? 7 : 9,
                weight: FontWeight.w500,
                color: _muted,
              ),
            ),
          ],
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [identity, const SizedBox(height: 8), priceWidget],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: identity),
            const SizedBox(width: 8),
            priceWidget,
          ],
        );
      },
    );
  }
}

class _OfferFact extends StatelessWidget {
  const _OfferFact({
    required this.asset,
    required this.title,
    required this.body,
  });
  final String asset;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 95;
        return Row(
          children: [
            _asset(asset, width: compact ? 17 : 26, height: compact ? 17 : 26),
            SizedBox(width: compact ? 3 : 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: _text(
                      context,
                      size: compact ? 7 : 9,
                      weight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: compact ? 1 : 2),
                  Text(
                    body,
                    maxLines: 3,
                    style: _text(
                      context,
                      size: compact ? 6 : 8,
                      weight: FontWeight.w500,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SecurePrivateNotice extends StatelessWidget {
  const _SecurePrivateNotice();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Container(
      key: const Key('approved-secure-private-notice'),
      padding: EdgeInsets.all(compact ? 5 : 9),
      decoration: BoxDecoration(
        color: const Color(0xfff1faf5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _asset(
            'offers-lock.png',
            width: compact ? 24 : 34,
            height: compact ? 24 : 34,
          ),
          SizedBox(width: compact ? 4 : 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & private',
                  style: _text(
                    context,
                    size: compact ? 8 : 11,
                    weight: FontWeight.w900,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Your information is safe. Chat opens only after you select a seller.',
                  style: _text(
                    context,
                    size: compact ? 6 : 9,
                    weight: FontWeight.w500,
                    color: _muted,
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

class _OfferDetailHeader extends StatelessWidget {
  const _OfferDetailHeader({
    required this.onBack,
    required this.onNotifications,
  });
  final VoidCallback onBack;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              key: const Key('approved-offer-back'),
              tooltip: 'Back',
              onPressed: onBack,
              icon: _asset('detail-back.png', width: 24, height: 24),
            ),
            Expanded(
              child: Center(
                child: _asset('wordmark.png', width: 84, height: 48),
              ),
            ),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _lavender,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _asset('header-buyer.png', width: 19, height: 19),
                  const SizedBox(width: 5),
                  Text(
                    'Buyer mode',
                    style: _text(
                      context,
                      size: 10,
                      weight: FontWeight.w800,
                      color: _blue,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: onNotifications,
              icon: _asset('header-bell.png', width: 25, height: 25),
            ),
          ],
        ),
        Text(
          'Offer details',
          style: _text(context, size: 21, weight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _OfferSellerSummary extends StatelessWidget {
  const _OfferSellerSummary();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return _Surface(
      padding: EdgeInsets.all(compact ? 7 : 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = _usesAccessibilityReflow(context);
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InitialsAvatar(initials: 'NT', size: compact ? 36 : 44),
                  SizedBox(width: compact ? 6 : 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Northside Tech',
                                style: _text(
                                  context,
                                  size: compact ? 13 : 15,
                                  weight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            _asset(
                              'detail-verified.png',
                              width: compact ? 14 : 17,
                              height: compact ? 14 : 17,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _asset(
                              'detail-star.png',
                              width: compact ? 11 : 14,
                              height: compact ? 11 : 14,
                            ),
                            Text(
                              '4.9 (128 reviews)',
                              style: _text(
                                context,
                                size: compact ? 8 : 9,
                                weight: FontWeight.w700,
                              ),
                            ),
                            _asset(
                              'detail-seller-shield.png',
                              width: compact ? 11 : 14,
                              height: compact ? 11 : 14,
                            ),
                            Text(
                              'Verified seller',
                              style: _text(
                                context,
                                size: compact ? 8 : 9,
                                weight: FontWeight.w700,
                                color: _green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$420',
                        style: _text(
                          context,
                          size: compact ? 16 : 19,
                          weight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Total price',
                        style: _text(
                          context,
                          size: compact ? 7 : 9,
                          weight: FontWeight.w500,
                          color: _muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: compact ? 6 : 10),
              LayoutBuilder(
                builder: (context, inner) {
                  final facts = const [
                    _DetailFact(
                      asset: 'detail-identity.png',
                      title: 'Identity verified',
                    ),
                    _DetailFact(
                      asset: 'detail-location.png',
                      title: '1.2 mi away',
                      body: 'from you',
                    ),
                    _DetailFact(
                      asset: 'detail-clock.png',
                      title: 'Available',
                      body: 'Sat, May 17',
                    ),
                  ];
                  if (narrow) {
                    return Column(
                      children: [
                        for (final fact in facts)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: fact,
                          ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      for (var i = 0; i < facts.length; i++) ...[
                        Expanded(child: facts[i]),
                        if (i < facts.length - 1)
                          const VerticalDivider(width: 14, color: _line),
                      ],
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailFact extends StatelessWidget {
  const _DetailFact({required this.asset, required this.title, this.body});
  final String asset;
  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 95;
        return Row(
          children: [
            _asset(asset, width: compact ? 26 : 32, height: compact ? 26 : 32),
            SizedBox(width: compact ? 3 : 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _text(
                      context,
                      size: compact ? 7 : 9,
                      weight: FontWeight.w800,
                    ),
                  ),
                  if (body != null)
                    Text(
                      body!,
                      style: _text(
                        context,
                        size: compact ? 7 : 9,
                        weight: FontWeight.w500,
                        color: _muted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfferRewardWindow extends StatelessWidget {
  const _OfferRewardWindow();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Container(
      padding: EdgeInsets.all(compact ? 6 : 9),
      decoration: BoxDecoration(
        color: const Color(0xfffff8eb),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = _usesAccessibilityReflow(context);
          final copy = Row(
            children: [
              _asset(
                'detail-gift.png',
                width: compact ? 42 : 52,
                height: compact ? 42 : 52,
              ),
              SizedBox(width: compact ? 6 : 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have 7 days left',
                      style: _text(
                        context,
                        size: compact ? 11 : 14,
                        weight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Buy from any seller within 7 days to get your rewards.',
                      style: _text(
                        context,
                        size: compact ? 8 : 10,
                        weight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final reward = Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 8 : 11,
              vertical: compact ? 5 : 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffffedc8),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                Text(
                  'Est. rewards',
                  style: _text(
                    context,
                    size: compact ? 7 : 9,
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$12.40',
                  style: _text(
                    context,
                    size: compact ? 15 : 18,
                    weight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          );
          if (stacked) {
            return Column(
              children: [
                copy,
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(child: reward),
                    const SizedBox(width: 6),
                    _asset('info.png', width: 21, height: 21),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              SizedBox(width: compact ? 5 : 8),
              reward,
              SizedBox(width: compact ? 4 : 6),
              _asset(
                'info.png',
                width: compact ? 16 : 20,
                height: compact ? 16 : 20,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OfferDescription extends StatelessWidget {
  const _OfferDescription();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return _Surface(
      padding: EdgeInsets.all(compact ? 7 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _asset(
                'detail-description.png',
                width: compact ? 24 : 29,
                height: compact ? 24 : 29,
              ),
              SizedBox(width: compact ? 4 : 6),
              Expanded(
                child: Text(
                  'Description Details',
                  style: _text(
                    context,
                    size: compact ? 11 : 14,
                    weight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 5 : 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = _usesAccessibilityReflow(context);
              final image = ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: _asset(
                  'ps5.png',
                  width: double.infinity,
                  height: stacked ? 176 : (compact ? 135 : 145),
                  fit: BoxFit.cover,
                ),
              );
              const copy = Column(
                children: [
                  _DescriptionBlock(
                    title: 'Your Request Description:',
                    body:
                        'I need to buy a PS5 console with a controller. I\'m a student and I\'m a bit short on cash.',
                  ),
                  SizedBox(height: 7),
                  _DescriptionBlock(
                    title: 'Seller\'s Pitch:',
                    body:
                        'Hi, I have a PS5 Disc Edition in excellent condition, gently used and works perfectly. I can meet you within your budget.',
                  ),
                ],
              );
              if (stacked) {
                return Column(
                  children: [image, const SizedBox(height: 8), copy],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: image),
                  const SizedBox(width: 8),
                  const Expanded(child: copy),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DescriptionBlock extends StatelessWidget {
  const _DescriptionBlock({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 6 : 8),
      decoration: BoxDecoration(
        color: const Color(0xfff8f7ff),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffecebfa)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: _text(
              context,
              size: compact ? 8 : 9,
              weight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 2 : 4),
          Text(
            body,
            style: _text(
              context,
              size: compact ? 7 : 9,
              weight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferPinNotice extends StatelessWidget {
  const _OfferPinNotice();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Container(
      padding: EdgeInsets.all(compact ? 6 : 8),
      decoration: BoxDecoration(
        color: const Color(0xfff5f1ff),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffdfd8ff)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = _usesAccessibilityReflow(context);
          final copy = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _asset(
                'detail-pin.png',
                width: compact ? 30 : 35,
                height: compact ? 39 : 46,
              ),
              SizedBox(width: compact ? 4 : 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller PIN for your rewards',
                      style: _text(
                        context,
                        size: compact ? 8 : 10,
                        weight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'When you meet the seller, show them your confirmation PIN to complete the transaction. If the PIN isn\'t verified, you won\'t receive your rewards. Your PIN expires 24 hours after accepting your seller\'s offer.',
                      style: _text(
                        context,
                        size: compact ? 6 : 8,
                        weight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final pin = Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 8 : 10,
              vertical: compact ? 5 : 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffe8e0ff),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '15230',
              textAlign: TextAlign.center,
              style: _text(
                context,
                size: compact ? 14 : 16,
                weight: FontWeight.w900,
                color: _blue,
              ),
            ),
          );
          if (stacked) {
            return Column(
              children: [
                copy,
                const SizedBox(height: 7),
                SizedBox(width: double.infinity, child: pin),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 8),
              pin,
            ],
          );
        },
      ),
    );
  }
}

class _AboutSeller extends StatelessWidget {
  const _AboutSeller({required this.onViewProfile});
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return _Surface(
      padding: EdgeInsets.all(compact ? 7 : 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = _usesAccessibilityReflow(context);
          final copy = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _asset(
                'detail-about.png',
                width: compact ? 28 : 34,
                height: compact ? 28 : 34,
              ),
              SizedBox(width: compact ? 5 : 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About the Seller',
                      style: _text(
                        context,
                        size: compact ? 10 : 12,
                        weight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Local seller with 230+ successful deals. Usually responds in a few hours.',
                      style: _text(
                        context,
                        size: compact ? 7 : 9,
                        weight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final button = TextButton(
            key: const Key('approved-view-profile'),
            onPressed: onViewProfile,
            style: TextButton.styleFrom(
              backgroundColor: _lavender,
              minimumSize: Size(compact ? 86 : 104, compact ? 38 : 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View profile',
              style: _text(
                context,
                size: compact ? 8 : 10,
                weight: FontWeight.w800,
                color: _blue,
              ),
            ),
          );
          if (stacked) {
            return Column(
              children: [
                copy,
                const SizedBox(height: 7),
                SizedBox(width: double.infinity, child: button),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 8),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _OfferOfflineNotice extends StatelessWidget {
  const _OfferOfflineNotice();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Container(
      padding: EdgeInsets.all(compact ? 3 : 7),
      decoration: BoxDecoration(
        color: const Color(0xfff6f4ff),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _asset(
            'detail-chat-notice.png',
            width: compact ? 20 : 29,
            height: compact ? 20 : 29,
          ),
          SizedBox(width: compact ? 4 : 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat opens only after you select this seller.',
                  style: _text(
                    context,
                    size: compact ? 7 : 10,
                    weight: FontWeight.w900,
                    color: _blue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your PIN protects reward completion during meetup. Item payment stays offline.',
                  style: _text(
                    context,
                    size: compact ? 5 : 8,
                    weight: FontWeight.w500,
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

class _SelectSellerPanel extends StatelessWidget {
  const _SelectSellerPanel({required this.onSelect});
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final compact =
        MediaQuery.sizeOf(context).width <= 320 &&
        !_usesAccessibilityReflow(context);
    return _Surface(
      padding: EdgeInsets.all(compact ? 4 : 6),
      child: Column(
        children: [
          Row(
            children: [
              _asset(
                'detail-select.png',
                width: compact ? 26 : 34,
                height: compact ? 32 : 42,
              ),
              SizedBox(width: compact ? 5 : 7),
              Expanded(
                child: _PrimaryButton(
                  key: const Key('approved-select-seller'),
                  label: 'Select this seller',
                  onPressed: onSelect,
                  height: compact ? 32 : 44,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 1 : 2),
          Text(
            'Selecting this seller will share your contact information.',
            textAlign: TextAlign.center,
            style: _text(
              context,
              size: compact ? 6 : 8,
              weight: FontWeight.w500,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.onBack,
    required this.onCall,
    required this.onMore,
  });
  final VoidCallback onBack;
  final VoidCallback onCall;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    final back = IconButton(
      key: const Key('approved-chat-back'),
      tooltip: 'Back',
      onPressed: onBack,
      constraints: BoxConstraints.tightFor(
        width: compact ? 36 : 48,
        height: compact ? 36 : 48,
      ),
      padding: EdgeInsets.all(compact ? 6 : 8),
      icon: _asset(
        'chat-back.png',
        width: compact ? 20 : 24,
        height: compact ? 20 : 24,
      ),
    );
    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: _asset(
            'john-avatar.png',
            width: compact ? 30 : 40,
            height: compact ? 30 : 40,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: -1,
          bottom: 0,
          child: Container(
            width: compact ? 9 : 11,
            height: compact ? 9 : 11,
            decoration: BoxDecoration(
              color: const Color(0xff12b759),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 3 : 6,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: _lavender,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _asset(
            'chat-verified.png',
            width: compact ? 10 : 14,
            height: compact ? 10 : 14,
          ),
          Text(
            'Verified Seller',
            style: _text(
              context,
              size: compact ? 6 : 9,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
    final call = IconButton(
      key: const Key('approved-call-seller'),
      tooltip: 'Call seller',
      onPressed: onCall,
      constraints: BoxConstraints.tightFor(
        width: compact ? 36 : 48,
        height: compact ? 36 : 48,
      ),
      padding: EdgeInsets.all(compact ? 7 : 8),
      icon: _asset(
        'chat-call.png',
        width: compact ? 21 : 25,
        height: compact ? 21 : 25,
      ),
    );
    final more = IconButton(
      key: const Key('approved-chat-more'),
      tooltip: 'Chat options',
      onPressed: onMore,
      constraints: BoxConstraints.tightFor(
        width: compact ? 36 : 48,
        height: compact ? 36 : 48,
      ),
      padding: EdgeInsets.all(compact ? 7 : 8),
      icon: _asset(
        'chat-more.png',
        width: compact ? 11 : 14,
        height: compact ? 22 : 27,
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = _usesAccessibilityReflow(context);
        final name = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John D.',
              style: _text(
                context,
                size: compact ? 11 : 14,
                weight: FontWeight.w900,
              ),
            ),
            Text(
              'Active now',
              style: _text(
                context,
                size: compact ? 8 : 10,
                weight: FontWeight.w500,
                color: _muted,
              ),
            ),
          ],
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  back,
                  avatar,
                  SizedBox(width: compact ? 4 : 7),
                  Expanded(child: name),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(width: compact ? 36 : 42),
                  Flexible(child: badge),
                  const Spacer(),
                  call,
                  more,
                ],
              ),
            ],
          );
        }
        return Row(
          children: [
            back,
            avatar,
            SizedBox(width: compact ? 3 : 7),
            Expanded(
              child: Wrap(
                spacing: compact ? 2 : 6,
                runSpacing: 3,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [name, badge],
              ),
            ),
            call,
            more,
          ],
        );
      },
    );
  }
}

class _ChatProductCard extends StatelessWidget {
  const _ChatProductCard();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return _Surface(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: _asset(
              'chat-ipad.png',
              width: compact ? 48 : 58,
              height: compact ? 58 : 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: compact ? 7 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'iPad Air 5th Gen 64GB',
                  style: _text(
                    context,
                    size: compact ? 12 : 15,
                    weight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$650',
                  style: _text(
                    context,
                    size: compact ? 16 : 19,
                    weight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _asset(
                      'chat-deal-shield.png',
                      width: compact ? 15 : 18,
                      height: compact ? 15 : 18,
                    ),
                    SizedBox(width: compact ? 4 : 6),
                    Expanded(
                      child: Text(
                        'Deal details recorded by Hocalist; item payment stays offline.',
                        style: _text(
                          context,
                          size: compact ? 7 : 9,
                          weight: FontWeight.w600,
                          color: _muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalOfferCard extends StatelessWidget {
  const _FinalOfferCard({
    required this.expanded,
    required this.onToggle,
    required this.onRequestChange,
    required this.onChangeLocation,
  });
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onRequestChange;
  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return _Surface(
      padding: EdgeInsets.all(compact ? 7 : 10),
      child: Column(
        children: [
          InkWell(
            key: const Key('approved-toggle-final-offer'),
            onTap: onToggle,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = _usesAccessibilityReflow(context);
                final tight = constraints.maxWidth < 300;
                final title = Row(
                  children: [
                    _asset(
                      'chat-final-offer.png',
                      width: tight ? 28 : 34,
                      height: tight ? 28 : 34,
                    ),
                    SizedBox(width: tight ? 5 : 7),
                    Expanded(
                      child: Text(
                        'Seller\'s Final Offer',
                        style: _text(
                          context,
                          size: tight ? 12 : 15,
                          weight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                );
                final detail = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      expanded ? 'Tap to close details' : 'Tap to view details',
                      style: _text(
                        context,
                        size: tight ? 7 : 9,
                        weight: FontWeight.w500,
                        color: _muted,
                      ),
                    ),
                    SizedBox(width: tight ? 3 : 5),
                    RotatedBox(
                      quarterTurns: expanded ? 2 : 0,
                      child: _asset(
                        'chat-chevron-down.png',
                        width: tight ? 15 : 19,
                        height: tight ? 15 : 19,
                      ),
                    ),
                  ],
                );
                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      title,
                      Align(alignment: Alignment.centerRight, child: detail),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: title),
                    SizedBox(width: tight ? 5 : 8),
                    detail,
                  ],
                );
              },
            ),
          ),
          if (expanded) ...[
            const Divider(height: 12, color: _line),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = _usesAccessibilityReflow(context);
                final compact = constraints.maxWidth < 300;
                const facts = [
                  _ChatOfferFact(
                    asset: 'chat-price.png',
                    title: 'Price',
                    body: '\$650',
                  ),
                  _ChatOfferFact(
                    asset: 'chat-location.png',
                    title: 'Pickup Location',
                    body: 'Yonkers, NY',
                  ),
                  _ChatOfferFact(
                    asset: 'chat-time.png',
                    title: 'Meet Time',
                    body: 'Today - 5:00 PM',
                  ),
                  _ChatOfferFact(
                    asset: 'chat-reward.png',
                    title: 'Close Deal To Earn',
                    body: '\$1.40',
                    bodyColor: _green,
                  ),
                ];
                if (stacked) {
                  return Column(
                    children: [
                      for (final fact in facts)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: fact,
                        ),
                    ],
                  );
                }
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: compact ? 5.2 : 4.8,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: facts,
                );
              },
            ),
            const SizedBox(height: 7),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = _usesAccessibilityReflow(context);
                final compact = constraints.maxWidth < 300;
                final request = OutlinedButton(
                  key: const Key('approved-request-change'),
                  onPressed: onRequestChange,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, compact ? 38 : 44),
                    side: const BorderSide(color: _line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Request Change',
                    style: _text(
                      context,
                      size: compact ? 9 : 11,
                      weight: FontWeight.w800,
                    ),
                  ),
                );
                final location = FilledButton(
                  key: const Key('approved-change-location'),
                  onPressed: onChangeLocation,
                  style: FilledButton.styleFrom(
                    minimumSize: Size(0, compact ? 38 : 44),
                    backgroundColor: _navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Change Location',
                    style: _text(
                      context,
                      size: compact ? 9 : 11,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                );
                if (stacked) {
                  return Column(
                    children: [
                      SizedBox(width: double.infinity, child: request),
                      const SizedBox(height: 6),
                      SizedBox(width: double.infinity, child: location),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: request),
                    SizedBox(width: compact ? 5 : 8),
                    Expanded(child: location),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatOfferFact extends StatelessWidget {
  const _ChatOfferFact({
    required this.asset,
    required this.title,
    required this.body,
    this.bodyColor = _navy,
  });
  final String asset;
  final String title;
  final String body;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 145;
        final enlargedText = MediaQuery.textScalerOf(context).scale(1) > 1;
        return Row(
          children: [
            _asset(asset, width: compact ? 28 : 34, height: compact ? 28 : 34),
            SizedBox(width: compact ? 4 : 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: _text(
                      context,
                      size: compact ? 7 : 9,
                      weight: FontWeight.w500,
                      color: _muted,
                    ),
                  ),
                  SizedBox(height: compact || enlargedText ? 1 : 2),
                  Text(
                    body,
                    style: _text(
                      context,
                      size: compact ? 9 : 11,
                      weight: FontWeight.w900,
                      color: bodyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xffd8d9e5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Today 9:30 AM',
            style: _text(
              context,
              size: compact ? 8 : 10,
              weight: FontWeight.w500,
              color: _muted,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xffd8d9e5))),
      ],
    );
  }
}

class _IncomingMessage extends StatelessWidget {
  const _IncomingMessage({required this.text, required this.time, super.key});
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: _asset(
                'john-avatar.png',
                width: compact ? 29 : 34,
                height: compact ? 29 : 34,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: -1,
              bottom: 0,
              child: Container(
                width: compact ? 8 : 10,
                height: compact ? 8 : 10,
                decoration: BoxDecoration(
                  color: const Color(0xff12b759),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: compact ? 4 : 6),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 270),
            padding: EdgeInsets.fromLTRB(
              compact ? 9 : 11,
              7,
              compact ? 8 : 10,
              5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10101054),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style: _text(
                      context,
                      size: compact ? 9 : 11,
                      weight: FontWeight.w500,
                      color: const Color(0xff111325),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: _text(
                    context,
                    size: compact ? 7 : 8,
                    weight: FontWeight.w500,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OutgoingMessage extends StatelessWidget {
  const _OutgoingMessage({required this.text, required this.time, super.key});
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: EdgeInsets.fromLTRB(compact ? 10 : 12, 8, compact ? 8 : 10, 5),
        decoration: const BoxDecoration(
          color: _navy,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: _text(
                  context,
                  size: compact ? 9 : 11,
                  weight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: _text(
                    context,
                    size: compact ? 7 : 8,
                    weight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                _asset(
                  'chat-checks.png',
                  width: compact ? 16 : 19,
                  height: compact ? 12 : 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatSafetyNotice extends StatelessWidget {
  const _ChatSafetyNotice({required this.onLearnMore, super.key});
  final VoidCallback onLearnMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xfff4f1ff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = _usesAccessibilityReflow(context);
          final copy = Row(
            children: [
              _asset('chat-safety.png', width: 30, height: 30),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Always be safe, meet in public crowded places with the person you expect.',
                  style: _text(
                    context,
                    size: 9,
                    weight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          );
          final link = TextButton(
            key: const Key('approved-safety-learn-more'),
            onPressed: onLearnMore,
            style: TextButton.styleFrom(
              minimumSize: const Size(72, 32),
              padding: const EdgeInsets.symmetric(horizontal: 6),
            ),
            child: Text(
              'Learn more',
              style: _text(
                context,
                size: 9,
                weight: FontWeight.w800,
                color: _blue,
              ),
            ),
          );
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                Align(alignment: Alignment.centerRight, child: link),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              link,
            ],
          );
        },
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.onAttach,
    required this.onSend,
  });
  final TextEditingController controller;
  final VoidCallback onAttach;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 320;
    return Row(
      children: [
        IconButton(
          key: const Key('approved-chat-attach'),
          tooltip: 'Attach',
          onPressed: onAttach,
          iconSize: compact ? 38 : 44,
          padding: EdgeInsets.zero,
          icon: _asset(
            'chat-plus.png',
            width: compact ? 34 : 40,
            height: compact ? 34 : 40,
          ),
        ),
        SizedBox(width: compact ? 4 : 6),
        Expanded(
          child: TextField(
            key: const Key('approved-chat-message'),
            controller: controller,
            minLines: 1,
            maxLines: 4,
            style: _text(
              context,
              size: compact ? 9 : 11,
              weight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Type a message...',
              hintStyle: _text(
                context,
                size: compact ? 9 : 11,
                weight: FontWeight.w500,
                color: const Color(0xff8c90a9),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: compact ? 10 : 12,
                vertical: compact ? 8 : 11,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: const BorderSide(color: _line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: const BorderSide(color: _line),
              ),
            ),
          ),
        ),
        SizedBox(width: compact ? 3 : 5),
        IconButton(
          key: const Key('approved-chat-send'),
          tooltip: 'Send message',
          onPressed: onSend,
          icon: _asset(
            'chat-send.png',
            width: compact ? 26 : 31,
            height: compact ? 26 : 31,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.radius = 12,
    this.backgroundColor = _blue,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final double height;
  final double radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final accessibility = hocalistAccessibilityVisualsOf(context);
    final compact =
        MediaQuery.sizeOf(context).width <= 320 &&
        !_usesAccessibilityReflow(context);
    final effectiveHeight = compact ? height.clamp(0, 38).toDouble() : height;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size(0, effectiveHeight),
        backgroundColor: accessibility.backgroundOr(backgroundColor),
        foregroundColor: accessibility.foregroundOr(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(accessibility.radiusOr(radius)),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: _text(
          context,
          size: effectiveHeight <= 38 ? 9 : 13,
          weight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials, required this.size});
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: _text(
          context,
          size: size * 0.38,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.color = Colors.white,
    super.key,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0c111354),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ApprovedBottomNavigation extends StatelessWidget {
  const _ApprovedBottomNavigation({
    required this.selected,
    required this.callbacks,
    this.accentColor = _blue,
  });
  final ApprovedBuyerNavSelection selected;
  final ApprovedBuyerNavigation callbacks;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        ApprovedBuyerNavSelection.home,
        'Home',
        'nav-home.png',
        callbacks.onHome,
      ),
      (
        ApprovedBuyerNavSelection.hocatrends,
        'Hocatrends',
        'nav-hocatrends.png',
        callbacks.onHocatrends,
      ),
      (
        ApprovedBuyerNavSelection.offers,
        'Offers',
        'nav-offers.png',
        callbacks.onOffers,
      ),
      (
        ApprovedBuyerNavSelection.chats,
        'Chats',
        'nav-chats.png',
        callbacks.onChats,
      ),
      (
        ApprovedBuyerNavSelection.more,
        'More',
        'nav-more.png',
        callbacks.onMore,
      ),
    ];
    return Container(
      key: const Key('approved-bottom-navigation'),
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 2),
        child: Row(
          children: [
            for (final item in items)
              Expanded(
                child: Semantics(
                  selected: item.$1 == selected,
                  button: true,
                  label: item.$2,
                  child: InkWell(
                    key: Key('approved-nav-${item.$2.toLowerCase()}'),
                    onTap: item.$4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.44,
                        vertical: 2.44,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: item.$1 == selected ? 43.875 : 36.56,
                            height: 25.59,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: item.$1 == selected
                                  ? _lavender
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(7.31),
                            ),
                            child: _ApprovedRasterAsset(
                              asset: '$_assetRoot/${item.$3}',
                              width: item.$1 == selected ? 18.28 : 15.84,
                              height: item.$1 == selected ? 18.28 : 15.84,
                              color: item.$1 == selected ? accentColor : _muted,
                            ),
                          ),
                          const SizedBox(height: 1.22),
                          SizedBox(
                            height: 10.97,
                            width: double.infinity,
                            child: _usesAccessibilityReflow(context)
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: _navLabel(context, item),
                                  )
                                : _navLabel(context, item),
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
    );
  }

  Widget _navLabel(
    BuildContext context,
    (ApprovedBuyerNavSelection, String, String, VoidCallback) item,
  ) {
    return Text(
      item.$2,
      maxLines: 1,
      softWrap: false,
      textAlign: TextAlign.center,
      style: _text(
        context,
        size: 6.7,
        weight: item.$1 == selected ? FontWeight.w800 : FontWeight.w600,
        color: item.$1 == selected ? accentColor : _muted,
        height: 1.18,
      ),
    );
  }
}
