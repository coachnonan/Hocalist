import 'package:flutter/material.dart';

import '../../theme/seller_ui_foundation.dart';

class ApprovedSellerTutorialPage extends StatelessWidget {
  const ApprovedSellerTutorialPage({
    required this.onContinue,
    required this.onClose,
    super.key,
  });

  final VoidCallback onContinue;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SellerResponsivePage(
      maxContentWidth: 760,
      builder: (context, metrics) {
        final horizontal = metrics.pageHorizontalPadding(34);
        return SingleChildScrollView(
          key: const Key('sellerTutorialScroll'),
          padding: EdgeInsets.fromLTRB(
            horizontal,
            metrics.spacing(24),
            horizontal,
            metrics.spacing(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TutorialProgress(onClose: onClose),
              SizedBox(height: metrics.spacing(14)),
              Transform.translate(
                offset: Offset(-metrics.geometry(9), 0),
                child: const _TutorialWelcome(),
              ),
              SizedBox(height: metrics.spacing(18)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: metrics.geometry(9)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(metrics.geometry(11)),
                  child: AspectRatio(
                    aspectRatio: 685 / 371,
                    child: Image.asset(
                      SellerAssets.tutorialVideo,
                      fit: BoxFit.cover,
                      semanticLabel: 'Seller tutorial video preview',
                    ),
                  ),
                ),
              ),
              SizedBox(height: metrics.spacing(14)),
              Text(
                'As a seller, you will:',
                style: sellerText(metrics, 18, weight: FontWeight.w800),
              ),
              SizedBox(height: metrics.spacing(9)),
              const _TutorialBenefit(
                asset: SellerAssets.tutorialTarget,
                title: 'Receive real buying opportunities',
                body:
                    'Every request comes from someone actively looking to purchase.',
              ),
              SizedBox(height: metrics.spacing(9)),
              const _TutorialBenefit(
                asset: SellerAssets.tutorialBuyer,
                title: 'Choose which buyers to pursue',
                body:
                    'Only pay for the opportunities you believe have the highest chance of becoming a sale.',
              ),
              SizedBox(height: metrics.spacing(9)),
              const _TutorialBenefit(
                asset: SellerAssets.tutorialGrowth,
                title: 'Grow through repeat business',
                body:
                    'Deliver a great experience and turn first-time buyers into loyal customers.',
              ),
              SizedBox(height: metrics.spacing(9)),
              const _TutorialBenefit(
                asset: SellerAssets.tutorialValue,
                title: 'Pay for buyers, not views',
                body:
                    'Stop wasting money on impressions. Invest in customers, not advertising.',
              ),
              SizedBox(height: metrics.spacing(10)),
              const _TutorialFairnessBanner(),
              SizedBox(height: metrics.spacing(10)),
              SellerPrimaryButton(
                key: const Key('sellerTutorialContinue'),
                label: 'Continue',
                onPressed: onContinue,
              ),
              SizedBox(height: metrics.spacing(9)),
              const _TutorialDots(),
            ],
          ),
        );
      },
    );
  }
}

class _TutorialProgress extends StatelessWidget {
  const _TutorialProgress({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return SizedBox(
      height: metrics.geometry(28),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: metrics.artSize(142)),
            child: Row(
              children: List.generate(
                5,
                (index) => Expanded(
                  child: Container(
                    height: metrics.geometry(4),
                    margin: EdgeInsets.symmetric(
                      horizontal: metrics.geometry(2),
                    ),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? SellerUiColors.primary
                          : const Color(0xFFDDDDEC),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: Offset(metrics.geometry(18), 0),
              child: IconButton(
                key: const Key('sellerTutorialClose'),
                onPressed: onClose,
                tooltip: 'Close tutorial',
                icon: Icon(
                  Icons.close,
                  size: metrics.geometry(26),
                  color: SellerUiColors.muted,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: metrics.geometry(44),
                  minHeight: metrics.geometry(44),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialWelcome extends StatelessWidget {
  const _TutorialWelcome();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    final portrait = ClipOval(
      child: Image.asset(
        SellerAssets.tutorialPortrait,
        width: metrics.artSize(82),
        height: metrics.artSize(82),
        fit: BoxFit.cover,
        semanticLabel: 'Jonathan seller portrait',
      ),
    );
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Jonathan',
          style: sellerText(metrics, 23, weight: FontWeight.w800),
        ),
        SizedBox(height: metrics.geometry(6)),
        Text(
          'With your Hocalist seller account, you get real buying opportunities and grow your business the smart way.',
          style: sellerText(
            metrics,
            14,
            color: SellerUiColors.body,
            height: 1.55,
          ),
        ),
      ],
    );

    if (metrics.accessibilityReflow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          portrait,
          SizedBox(height: metrics.spacing(12)),
          copy,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        portrait,
        SizedBox(width: metrics.spacing(16)),
        Expanded(child: copy),
      ],
    );
  }
}

class _TutorialBenefit extends StatelessWidget {
  const _TutorialBenefit({
    required this.asset,
    required this.title,
    required this.body,
  });

  final String asset;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: metrics.geometry(76)),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.geometry(13),
        vertical: metrics.geometry(9),
      ),
      decoration: BoxDecoration(
        color: SellerUiColors.white,
        border: Border.all(color: SellerUiColors.lavenderBorder),
        borderRadius: BorderRadius.circular(metrics.geometry(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              asset,
              width: metrics.artSize(56),
              height: metrics.artSize(56),
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
          SizedBox(width: metrics.spacing(13)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sellerText(
                    metrics,
                    13.5,
                    weight: FontWeight.w800,
                    color: SellerUiColors.primary,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: metrics.geometry(3)),
                Text(
                  body,
                  style: sellerText(
                    metrics,
                    11.5,
                    color: SellerUiColors.body,
                    height: 1.35,
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

class _TutorialFairnessBanner extends StatelessWidget {
  const _TutorialFairnessBanner();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: metrics.geometry(58)),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.geometry(16),
        vertical: metrics.geometry(8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FAF5),
        borderRadius: BorderRadius.circular(metrics.geometry(10)),
      ),
      child: Row(
        children: [
          Image.asset(
            SellerAssets.tutorialShield,
            width: metrics.artSize(48),
            height: metrics.artSize(48),
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
          SizedBox(width: metrics.spacing(12)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fair, transparent, and built for you.',
                  style: sellerText(metrics, 12.5, weight: FontWeight.w800),
                ),
                SizedBox(height: metrics.geometry(2)),
                Text(
                  'We’re here to give your business more value every time you connect.',
                  style: sellerText(
                    metrics,
                    11,
                    color: SellerUiColors.body,
                    height: 1.35,
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

class _TutorialDots extends StatelessWidget {
  const _TutorialDots();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Semantics(
      label: 'Tutorial page 1 of 3',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Container(
            width: metrics.geometry(8),
            height: metrics.geometry(8),
            margin: EdgeInsets.symmetric(horizontal: metrics.geometry(6)),
            decoration: BoxDecoration(
              color: index == 0
                  ? SellerUiColors.primary
                  : const Color(0xFFDDDDEC),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
