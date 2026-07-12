part of '../main.dart';

class WelcomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 700;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: HocalistTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 190,
                    height: 82,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/brand/hocalist-wordmark.png',
                      fit: BoxFit.contain,
                      semanticLabel: 'Hocalist Reverse Marketplace',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      SoftChip(
                        label: 'Request-first marketplace',
                        color: Colors.white,
                        foreground: HocalistTheme.primary,
                      ),
                      SoftChip(
                        label: 'Item payment stays offline',
                        color: HocalistTheme.roleSurface,
                        foreground: HocalistTheme.buyer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Post what you want. Let sellers compete.',
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Buyers create requests, sellers send offers, chat opens after selection, and item payment happens offline.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (isTablet)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(child: AppPreviewPanel()),
                        const SizedBox(width: 18),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Get started',
                            icon: Icons.arrow_forward,
                            color: Colors.white,
                            foreground: HocalistTheme.primary,
                            onPressed: onStart,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    const AppPreviewPanel(),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Get started',
                      icon: Icons.arrow_forward,
                      color: Colors.white,
                      foreground: HocalistTheme.primary,
                      onPressed: onStart,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            ResponsiveCardGrid(
              breakpoint: 560,
              children: [
                RoleCard(
                  title: 'I am buying',
                  body: 'Create a buying request and compare offers.',
                  color: HocalistTheme.buyer,
                  icon: Icons.shopping_bag_outlined,
                  onTap: onBuyer,
                ),
                RoleCard(
                  title: 'I am selling',
                  body: 'Browse buyer requests and send offers.',
                  color: HocalistTheme.seller,
                  icon: Icons.storefront_outlined,
                  onTap: onSeller,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ProcessStrip(),
          ],
        );
      },
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

class SignupPage extends StatelessWidget {
  const SignupPage({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.nameLabel,
    required this.name,
    required this.onNameChanged,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
    super.key,
  });

  final Color accent;
  final String title;
  final String subtitle;
  final String nameLabel;
  final String name;
  final ValueChanged<String> onNameChanged;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return ScreenBlock(
      title: title,
      subtitle: subtitle,
      children: [
        AppCard(
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: nameLabel),
                onChanged: onNameChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: 'maya@example.com',
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '+1 312 555 0184',
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                initialValue: 'password',
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
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
    return ScreenBlock(
      title: 'Hi $name',
      subtitle:
          'Manage requests, compare offers, and keep deal payment offline.',
      children: [
        DashboardHero(
          accent: accent,
          title: requestPosted
              ? 'Active buying request'
              : 'Post your first request',
          body: requestPosted
              ? '$requestTitle is live for local sellers. Compare offers before choosing who to chat with.'
              : 'Tell sellers exactly what you want. Hocalist helps you compare offers, then you handle item payment offline.',
          icon: requestPosted
              ? Icons.assignment_turned_in_outlined
              : Icons.add_task_outlined,
          actionLabel: requestPosted ? 'Review offers' : 'Post request',
          onAction: requestPosted ? onOffers : onCreate,
        ),
        AlertBanner(
          accent: accent,
          title: requestPosted
              ? restoredSession
                    ? 'Request restored on this device'
                    : 'Request saved on this device'
              : 'Ready to post',
          body: requestPosted
              ? offerSelected
                    ? 'Your selected seller, chat, meeting, and deal history stay in place while you review the app.'
                    : 'Your request stays visible in offers, notifications, and seller marketplace screens on this device.'
              : 'Post a request to see offers, chat, notifications, and deal history react to your actions.',
          icon: requestPosted
              ? Icons.offline_pin_outlined
              : Icons.add_task_outlined,
        ),
        if (meetingConfirmed)
          AlertBanner(
            accent: accent,
            title: 'Meeting confirmed',
            body:
                'Saturday, 2:30 PM at Wicker Park public pickup point. Payment remains offline.',
            icon: Icons.event_available_outlined,
          ),
        if (dealFailed || requestReopened)
          AlertBanner(
            accent: HocalistTheme.danger,
            title: requestReopened ? 'Request reopened' : 'Deal needs action',
            body:
                'The selected deal can fail without ending the request. Backup offers stay available for comparison.',
            icon: Icons.replay_circle_filled_outlined,
          ),
        if (withdrawalRequested)
          AlertBanner(
            accent: accent,
            title: 'Support review pending',
            body:
                'The local support note is saved here until admin tools are connected.',
            icon: Icons.account_balance_outlined,
          ),
        SectionLabel(
          title: 'Current requests',
          action: requestPosted ? 'Offers waiting' : 'Draft ready',
        ),
        BuyerRequestCard(
          title: requestPosted ? requestTitle : 'Looking for a used iPad Air',
          budget: requestPosted ? requestBudget : '\$350 - \$480',
          location: 'Within 12 miles',
          status: dealCompleted
              ? 'Completed'
              : requestReopened
              ? 'Reopened'
              : offerSelected
              ? 'Seller selected'
              : requestPosted
              ? 'Active'
              : 'Draft',
          onTap: onOffers,
        ),
        BuyerRequestCard(
          title: 'Compact espresso machine',
          budget: 'Up to \$220',
          location: 'Pickup preferred',
          status: '5 offers',
          onTap: onOffers,
        ),
        PrimaryButton(
          label: 'Post a buying request',
          icon: Icons.add,
          color: accent,
          onPressed: onCreate,
        ),
        SecondaryButton(
          label: 'Open deal history',
          color: accent,
          onPressed: onWallet,
        ),
      ],
    );
  }
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
