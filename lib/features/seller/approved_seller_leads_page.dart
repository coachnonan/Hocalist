import 'package:flutter/material.dart';

import '../../theme/seller_ui_foundation.dart';
import 'seller_schedule_controls.dart';

@immutable
class SellerOfferPlace {
  const SellerOfferPlace({
    required this.name,
    required this.address,
    this.placeId,
  });

  final String name;
  final String address;
  final String? placeId;
}

typedef SellerOfferPlacePicker =
    Future<SellerOfferPlace?> Function(BuildContext context);

@immutable
class SellerOfferPresentation {
  const SellerOfferPresentation.approvedPrototype()
    : planLabel = 'Your Pro Plan',
      initialBid = r'$1.90',
      winningBid = r'$4.75',
      higherOffersAllowed = false,
      defaultPrice = '550';

  final String planLabel;
  final String initialBid;
  final String winningBid;
  final bool higherOffersAllowed;
  final String defaultPrice;
}

class ApprovedSellerLeadsPage extends StatefulWidget {
  const ApprovedSellerLeadsPage({
    super.key,
    this.onChooseSpecificLocation,
    this.offerPresentation = const SellerOfferPresentation.approvedPrototype(),
  });

  final SellerOfferPlacePicker? onChooseSpecificLocation;
  final SellerOfferPresentation offerPresentation;

  @override
  State<ApprovedSellerLeadsPage> createState() =>
      _ApprovedSellerLeadsPageState();
}

class _ApprovedSellerLeadsPageState extends State<ApprovedSellerLeadsPage> {
  Future<void> _openOffer(_SellerLead lead) async {
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990B1231),
      builder: (context) => _SendOfferSheet(
        lead: lead,
        presentation: widget.offerPresentation,
        onChooseSpecificLocation: widget.onChooseSpecificLocation,
      ),
    );
    if (!mounted || submitted != true) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('sellerOfferSubmittedNotice'),
          content: Text('Offer sent to ${lead.name}. You are still in Leads.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SellerResponsivePage(
      builder: (context, metrics) {
        return CustomScrollView(
          key: const Key('sellerLeadsScroll'),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                metrics.pageHorizontalPadding(14),
                metrics.spacing(12),
                metrics.pageHorizontalPadding(14),
                metrics.spacing(14),
              ),
              sliver: SliverList.list(
                children: [
                  const _LeadsHeader(),
                  SizedBox(height: metrics.spacing(10)),
                  const _SearchField(),
                  SizedBox(height: metrics.spacing(10)),
                  const _FilterRow(),
                  SizedBox(height: metrics.spacing(11)),
                  const _TargetingNotice(),
                  SizedBox(height: metrics.spacing(12)),
                  for (final lead in _leads) ...[
                    _LeadCard(
                      key: Key('sellerLeadCard${lead.initials}'),
                      lead: lead,
                      onPrepareOffer: () => _openOffer(lead),
                    ),
                    SizedBox(height: metrics.spacing(12)),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LeadsHeader extends StatelessWidget {
  const _LeadsHeader();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 34),
        Expanded(
          child: Column(
            children: [
              Text(
                'Find Customers',
                style: sellerText(metrics, 25, weight: FontWeight.w800),
              ),
              SizedBox(height: metrics.geometry(3)),
              Text(
                'Curated buyers looking for what you offer',
                textAlign: TextAlign.center,
                style: sellerText(metrics, 13, color: SellerUiColors.body),
              ),
            ],
          ),
        ),
        IconButton(
          key: const Key('sellerLeadsFilter'),
          tooltip: 'Filter leads',
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_outlined),
          color: SellerUiColors.primaryBright,
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return TextField(
      key: const Key('sellerLeadsSearch'),
      style: sellerInputText(metrics),
      decoration: InputDecoration(
        hintText: 'Search by product, service, brand, or keyword...',
        hintStyle: sellerInputPlaceholder(metrics),
        prefixIcon: const Icon(Icons.search, color: SellerUiColors.body),
        contentPadding: EdgeInsets.symmetric(vertical: metrics.geometry(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.geometry(11)),
          borderSide: const BorderSide(color: SellerUiColors.lavenderBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(metrics.geometry(11)),
          borderSide: const BorderSide(color: SellerUiColors.primaryBright),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in const [
            (Icons.grid_view_outlined, 'Category'),
            (Icons.location_on_outlined, 'Location'),
            (Icons.paid_outlined, 'Budget'),
            (Icons.swap_vert, 'Sort'),
          ]) ...[
            Container(
              constraints: BoxConstraints(minHeight: metrics.geometry(44)),
              padding: EdgeInsets.symmetric(horizontal: metrics.geometry(11)),
              decoration: BoxDecoration(
                border: Border.all(color: SellerUiColors.line),
                borderRadius: BorderRadius.circular(metrics.geometry(10)),
              ),
              child: Row(
                children: [
                  Icon(
                    item.$1,
                    size: metrics.artSize(18),
                    color: SellerUiColors.body,
                  ),
                  SizedBox(width: metrics.geometry(6)),
                  Text(
                    item.$2,
                    style: sellerText(metrics, 12, weight: FontWeight.w700),
                  ),
                  SizedBox(width: metrics.geometry(5)),
                  Icon(Icons.keyboard_arrow_down, size: metrics.artSize(17)),
                ],
              ),
            ),
            SizedBox(width: metrics.geometry(8)),
          ],
        ],
      ),
    );
  }
}

class _TargetingNotice extends StatelessWidget {
  const _TargetingNotice();

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      padding: EdgeInsets.all(metrics.spacing(10)),
      decoration: BoxDecoration(
        color: SellerUiColors.lavender,
        borderRadius: BorderRadius.circular(metrics.geometry(10)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: SellerUiColors.primaryBright),
          SizedBox(width: metrics.spacing(8)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: const [
                  TextSpan(
                    text: 'No targeting fee is charged yet.\n',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: 'You only pay after the customer accepts your offer.',
                  ),
                ],
              ),
              style: sellerText(metrics, 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  const _LeadCard({
    required this.lead,
    required this.onPrepareOffer,
    super.key,
  });

  final _SellerLead lead;
  final VoidCallback onPrepareOffer;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      padding: EdgeInsets.all(metrics.spacing(11)),
      decoration: BoxDecoration(
        color: SellerUiColors.white,
        border: Border.all(color: SellerUiColors.line),
        borderRadius: BorderRadius.circular(metrics.geometry(12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0B1231),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: metrics.artSize(26),
                backgroundColor: lead.avatarColor,
                child: Text(
                  lead.initials,
                  style: sellerText(
                    metrics,
                    20,
                    weight: FontWeight.w800,
                    color: lead.initialColor,
                  ),
                ),
              ),
              SizedBox(width: metrics.spacing(9)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lead.name}  ✓',
                      style: sellerText(metrics, 18, weight: FontWeight.w800),
                    ),
                    SizedBox(height: metrics.geometry(2)),
                    Text(
                      '${lead.city}  •  ${lead.distance}',
                      style: sellerText(
                        metrics,
                        12,
                        color: SellerUiColors.body,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: metrics.geometry(8),
                  vertical: metrics.geometry(5),
                ),
                decoration: BoxDecoration(
                  color: SellerUiColors.greenSurface,
                  borderRadius: BorderRadius.circular(metrics.geometry(7)),
                ),
                child: Text(
                  '${lead.match}% Match',
                  style: sellerText(
                    metrics,
                    11,
                    weight: FontWeight.w800,
                    color: SellerUiColors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: metrics.spacing(10)),
          Text(
            lead.request,
            style: sellerText(metrics, 17, weight: FontWeight.w800),
          ),
          Text(
            lead.description,
            style: sellerText(metrics, 12, color: SellerUiColors.body),
          ),
          SizedBox(height: metrics.spacing(8)),
          Row(
            children: [
              Icon(
                Icons.sell_outlined,
                size: metrics.artSize(17),
                color: SellerUiColors.body,
              ),
              SizedBox(width: metrics.geometry(6)),
              Text(
                'Budget range',
                style: sellerText(metrics, 10, color: SellerUiColors.body),
              ),
              const Spacer(),
              Text(
                lead.budget,
                style: sellerText(
                  metrics,
                  16,
                  weight: FontWeight.w800,
                  color: SellerUiColors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: metrics.spacing(9)),
          const Divider(height: 1, color: SellerUiColors.line),
          SizedBox(height: metrics.spacing(9)),
          Row(
            children: [
              Expanded(
                child: _LeadFact(
                  key: Key('sellerVerifiedFact${lead.initials}'),
                  icon: Icons.verified_user_outlined,
                  title: '${lead.purchases} verified',
                  value: 'Great buyer',
                ),
              ),
              Expanded(
                child: _LeadFact(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Last purchase',
                  value: lead.lastPurchase,
                ),
              ),
              Expanded(
                child: _LeadFact(
                  icon: Icons.groups_outlined,
                  title: 'Preferred meet',
                  value: lead.meeting,
                ),
              ),
            ],
          ),
          SizedBox(height: metrics.spacing(10)),
          Row(
            children: [
              Expanded(
                child: _BidButton(
                  label: 'Send Low Bid',
                  icon: Icons.bolt,
                  onTap: onPrepareOffer,
                ),
              ),
              SizedBox(width: metrics.geometry(7)),
              Expanded(
                child: _BidButton(
                  label: 'Send High Bid',
                  icon: Icons.rocket_launch_outlined,
                  onTap: onPrepareOffer,
                ),
              ),
              SizedBox(width: metrics.geometry(7)),
              Expanded(
                child: SellerPrimaryButton(
                  label: 'Prepare offer',
                  compact: true,
                  fontSize: 12,
                  onPressed: onPrepareOffer,
                  leading: Icon(
                    Icons.description_outlined,
                    key: Key('sellerPrepareOfferIcon${lead.initials}'),
                    color: Colors.white,
                    size: metrics.artSize(17),
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

class _LeadFact extends StatelessWidget {
  const _LeadFact({
    required this.icon,
    required this.title,
    required this.value,
    super.key,
  });
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: metrics.artSize(17),
          color: SellerUiColors.primaryBright,
        ),
        SizedBox(width: metrics.geometry(5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sellerText(metrics, 9, color: SellerUiColors.body),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sellerText(metrics, 10, weight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BidButton extends StatelessWidget {
  const _BidButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, metrics.geometry(48)),
        padding: EdgeInsets.symmetric(horizontal: metrics.geometry(3)),
        side: const BorderSide(color: SellerUiColors.primaryBright),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.geometry(9)),
        ),
      ),
      icon: Icon(icon, size: metrics.artSize(16)),
      label: Text(
        label,
        maxLines: 1,
        style: sellerText(
          metrics,
          10,
          weight: FontWeight.w800,
          color: SellerUiColors.primaryBright,
        ),
      ),
    );
  }
}

class _SendOfferSheet extends StatefulWidget {
  const _SendOfferSheet({
    required this.lead,
    required this.presentation,
    this.onChooseSpecificLocation,
  });

  final _SellerLead lead;
  final SellerOfferPresentation presentation;
  final SellerOfferPlacePicker? onChooseSpecificLocation;

  @override
  State<_SendOfferSheet> createState() => _SendOfferSheetState();
}

class _SendOfferSheetState extends State<_SendOfferSheet> {
  late final TextEditingController _priceController;
  late final TextEditingController _messageController;
  _MeetupChoice _meetupChoice = _MeetupChoice.business;
  SellerOfferPlace? _specificLocation;
  DateTime _meetingDate = DateTime(2025, 5, 22);
  TimeOfDay _meetingTime = const TimeOfDay(hour: 15, minute: 0);
  String? _priceError;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final firstName = widget.lead.name.split(' ').first;
    final product = widget.lead.request
        .replaceFirst('Looking for ', '')
        .replaceFirst('Need ', '');
    _priceController = TextEditingController(
      text: widget.presentation.defaultPrice,
    );
    _messageController = TextEditingController(
      text:
          'Hi $firstName, I have a like-new $product 256GB in space gray. '
          'Includes original charger and box. Let me know if you have any questions!',
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _chooseSpecificLocation() async {
    final picker = widget.onChooseSpecificLocation;
    if (picker == null) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          key: const Key('sellerPlacesConnectionDialog'),
          title: const Text('Location search is not connected yet'),
          content: const Text(
            'Google Places will open from this row after the location service '
            'is connected. No location permission or API request is being made yet.',
          ),
          actions: [
            TextButton(
              key: const Key('sellerPlacesConnectionClose'),
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        ),
      );
      return;
    }

    final place = await picker(context);
    if (!mounted || place == null) return;
    setState(() {
      _specificLocation = place;
      _meetupChoice = _MeetupChoice.specific;
    });
  }

  Future<void> _pickSchedule() async {
    final selection = await showSellerSchedulePicker(
      context: context,
      initialDate: _meetingDate,
      initialTime: _meetingTime,
    );
    if (!mounted || selection == null) return;
    setState(() {
      _meetingDate = selection.date;
      _meetingTime = selection.time;
    });
  }

  Future<void> _submit() async {
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      setState(() => _priceError = 'Enter a valid offer price.');
      return;
    }
    setState(() {
      _priceError = null;
      _submitting = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  String get _formattedDate {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[_meetingDate.weekday - 1]}, '
        '${months[_meetingDate.month - 1]} ${_meetingDate.day}, ${_meetingDate.year}';
  }

  String get _formattedTime {
    final hour = _meetingTime.hourOfPeriod == 0
        ? 12
        : _meetingTime.hourOfPeriod;
    final minute = _meetingTime.minute.toString().padLeft(2, '0');
    final period = _meetingTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final metrics = ApprovedReplicaMetrics.resolve(
      availableWidth: media.size.width.clamp(
        320,
        ApprovedReplicaMetrics.supportedViewportMaxWidth,
      ),
      textScaler: media.textScaler,
    );
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Material(
        key: const Key('sellerSendOfferBottomSheet'),
        color: SellerUiColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: ApprovedReplicaScope(
          metrics: metrics,
          child: Column(
            children: [
              SizedBox(height: metrics.geometry(10)),
              Container(
                width: metrics.geometry(62),
                height: metrics.geometry(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFC6C1DD),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('sellerSendOfferScroll'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    metrics.pageHorizontalPadding(16),
                    metrics.spacing(10),
                    metrics.pageHorizontalPadding(16),
                    metrics.spacing(16) + media.viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: metrics.artSize(25),
                            backgroundColor: widget.lead.avatarColor,
                            child: Text(
                              widget.lead.initials,
                              style: sellerText(
                                metrics,
                                18,
                                weight: FontWeight.w800,
                                color: widget.lead.initialColor,
                              ),
                            ),
                          ),
                          SizedBox(width: metrics.spacing(9)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.lead.name}  ✓',
                                  style: sellerText(
                                    metrics,
                                    18,
                                    weight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  widget.lead.request,
                                  style: sellerText(metrics, 12),
                                ),
                                Text(
                                  '${widget.lead.city}  •  ${widget.lead.distance}',
                                  style: sellerText(
                                    metrics,
                                    11,
                                    color: SellerUiColors.body,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            key: const Key('sellerSendOfferClose'),
                            tooltip: 'Close offer',
                            onPressed: () => Navigator.pop(context, false),
                            icon: const Icon(Icons.close),
                            color: SellerUiColors.ink,
                          ),
                        ],
                      ),
                      SizedBox(height: metrics.spacing(8)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _OfferPlanChip(
                          label: widget.presentation.planLabel,
                        ),
                      ),
                      SizedBox(height: metrics.spacing(8)),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compactHeader = constraints.maxWidth < 400;
                          final bidCard = _OfferBidCard(
                            initialBid: widget.presentation.initialBid,
                            winningBid: widget.presentation.winningBid,
                            compact: compactHeader,
                          );
                          if (constraints.maxWidth < 300) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  key: const Key('sellerSendOfferHeading'),
                                  'Send your offer',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: sellerText(
                                    metrics,
                                    20,
                                    weight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: metrics.spacing(8)),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: bidCard,
                                ),
                              ],
                            );
                          }
                          if (compactHeader) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    key: const Key('sellerSendOfferHeading'),
                                    'Send your offer',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: sellerText(
                                      metrics,
                                      20,
                                      weight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: bidCard,
                                ),
                              ],
                            );
                          }
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: Text(
                                  key: const Key('sellerSendOfferHeading'),
                                  'Send your offer',
                                  textAlign: TextAlign.center,
                                  style: sellerText(
                                    metrics,
                                    25,
                                    weight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: bidCard,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: metrics.spacing(14)),
                      _OfferSection(
                        number: '1',
                        title: 'Your price offer',
                        subtitle: 'Enter the total price you’re offering.',
                        child: TextField(
                          key: const Key('sellerOfferPrice'),
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: sellerInputText(metrics, size: 14),
                          onChanged: (_) {
                            if (_priceError != null) {
                              setState(() => _priceError = null);
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              key: const Key('sellerOfferCurrencyPrefix'),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: SellerUiColors.line),
                                ),
                              ),
                              child: Text(
                                r'$',
                                style: sellerText(
                                  metrics,
                                  16,
                                  weight: FontWeight.w800,
                                ),
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: metrics.geometry(48),
                              maxWidth: metrics.geometry(48),
                              minHeight: metrics.geometry(52),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: metrics.spacing(12),
                              vertical: metrics.spacing(13),
                            ),
                            errorText: _priceError,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: metrics.spacing(10)),
                      Padding(
                        padding: EdgeInsets.only(left: metrics.geometry(40)),
                        child: Wrap(
                          spacing: metrics.spacing(20),
                          runSpacing: metrics.spacing(7),
                          children: [
                            _OfferInlineNotice(
                              icon: Icons.info_outline,
                              text: 'Buyer’s budget: ${widget.lead.budget}',
                              color: SellerUiColors.green,
                            ),
                            if (!widget.presentation.higherOffersAllowed)
                              const _OfferInlineNotice(
                                key: Key('sellerHigherOfferWarning'),
                                icon: Icons.info_outline,
                                text: 'Buyer is not open to higher offers.',
                                color: Color(0xFFFF4A19),
                              ),
                          ],
                        ),
                      ),
                      const Divider(height: 28, color: SellerUiColors.line),
                      _OfferSection(
                        number: '2',
                        title: 'Place of meet up',
                        subtitle: 'Where would you like to meet?',
                        child: Column(
                          children: [
                            _OfferChoice(
                              key: const Key('sellerMeetupBusiness'),
                              selected: _meetupChoice == _MeetupChoice.business,
                              icon: Icons.storefront_outlined,
                              title: 'My business / Store',
                              subtitle: 'Meet at my business location',
                              onTap: () => setState(
                                () => _meetupChoice = _MeetupChoice.business,
                              ),
                            ),
                            _OfferChoice(
                              key: const Key('sellerMeetupBuyer'),
                              selected: _meetupChoice == _MeetupChoice.buyer,
                              icon: Icons.location_on_outlined,
                              title: 'Buyer’s location',
                              subtitle: 'I’ll travel to the buyer',
                              onTap: () => setState(
                                () => _meetupChoice = _MeetupChoice.buyer,
                              ),
                            ),
                            _SpecificLocationLauncher(
                              key: const Key('sellerOfferSpecificLocation'),
                              title: 'Choose a specific location',
                              subtitle: _specificLocation?.name ?? '',
                              selected: _meetupChoice == _MeetupChoice.specific,
                              onTap: _chooseSpecificLocation,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 28, color: SellerUiColors.line),
                      _OfferSection(
                        number: '3',
                        title: 'Time you can meet',
                        subtitle: 'Select the date and time you’re available.',
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _OfferPicker(
                                  key: const Key('sellerOfferDate'),
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Date',
                                  value: _formattedDate,
                                  onTap: _pickSchedule,
                                ),
                              ),
                              SizedBox(width: metrics.geometry(8)),
                              Expanded(
                                child: _OfferPicker(
                                  key: const Key('sellerOfferTime'),
                                  icon: Icons.schedule_outlined,
                                  label: 'Time',
                                  value: _formattedTime,
                                  onTap: _pickSchedule,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: metrics.spacing(14)),
                      _OfferSection(
                        number: '4',
                        title: 'How it works',
                        subtitle: '',
                        child: Container(
                          padding: EdgeInsets.all(metrics.spacing(10)),
                          decoration: BoxDecoration(
                            color: SellerUiColors.lavender,
                            borderRadius: BorderRadius.circular(
                              metrics.geometry(9),
                            ),
                          ),
                          child: Column(
                            children: const [
                              _OfferHowItWorksRow(
                                icon: Icons.edit_note_outlined,
                                text: 'Send your offer to the buyer.',
                              ),
                              _OfferHowItWorksRow(
                                icon: Icons.phone_outlined,
                                text:
                                    'If the buyer accepts your offer and chooses to share verified contact information, your initial bid is charged and you’ll receive access to their contact details.',
                              ),
                              _OfferHowItWorksRow(
                                icon: Icons.emoji_events_outlined,
                                text:
                                    'If the buyer confirms the purchase with their Hocalist PIN, you’ll only pay the remaining balance needed to complete your winning bid.',
                              ),
                              _OfferHowItWorksRow(
                                icon: Icons.refresh,
                                text:
                                    'If the buyer never confirms a purchase with any seller, your initial bid is automatically reduced to just \$1.00.',
                                showBottomGap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: metrics.spacing(14)),
                      _OfferSection(
                        number: '5',
                        title: 'Add a message (optional)',
                        subtitle:
                            'Introduce yourself or add details about your offer.',
                        child: _OfferMessageField(
                          controller: _messageController,
                        ),
                      ),
                      SizedBox(height: metrics.spacing(10)),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compactAction = constraints.maxWidth < 360;
                          return SellerPrimaryButton(
                            key: const Key('sellerSendOfferSubmit'),
                            label: _submitting ? 'Sending…' : 'Send Offer',
                            onPressed: _submitting ? null : _submit,
                            fontSize: compactAction ? 12 : 14,
                            trailing: Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                              size: metrics.artSize(compactAction ? 17 : 19),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: metrics.spacing(12)),
                      OutlinedButton.icon(
                        key: const Key('sellerSendOfferCancel'),
                        onPressed: _submitting
                            ? null
                            : () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(metrics.geometry(44)),
                          foregroundColor: SellerUiColors.red,
                          side: const BorderSide(color: SellerUiColors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              metrics.geometry(12),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Cancel'),
                      ),
                    ],
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

class _OfferSection extends StatelessWidget {
  const _OfferSection({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String number;
  final String title;
  final String subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: metrics.geometry(32),
              height: metrics.geometry(32),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: SellerUiColors.primaryBright,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: sellerText(
                  metrics,
                  14,
                  weight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: metrics.geometry(8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: sellerText(metrics, 17, weight: FontWeight.w800),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: sellerText(
                        metrics,
                        11,
                        color: SellerUiColors.body,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: metrics.spacing(8)),
        Padding(
          padding: EdgeInsets.only(left: metrics.geometry(40)),
          child: child,
        ),
      ],
    );
  }
}

enum _MeetupChoice { business, buyer, specific }

class _OfferPlanChip extends StatelessWidget {
  const _OfferPlanChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      key: const Key('sellerOfferPlanChip'),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.geometry(11),
        vertical: metrics.geometry(8),
      ),
      decoration: BoxDecoration(
        color: SellerUiColors.lavender,
        borderRadius: BorderRadius.circular(metrics.geometry(9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: metrics.artSize(17),
            color: SellerUiColors.primaryBright,
          ),
          SizedBox(width: metrics.geometry(6)),
          Text(
            label,
            style: sellerText(
              metrics,
              11,
              weight: FontWeight.w800,
              color: SellerUiColors.primaryBright,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferBidCard extends StatelessWidget {
  const _OfferBidCard({
    required this.initialBid,
    required this.winningBid,
    this.compact = false,
  });

  final String initialBid;
  final String winningBid;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      key: const Key('sellerOfferBidCard'),
      padding: EdgeInsets.symmetric(
        horizontal: metrics.geometry(compact ? 8 : 12),
        vertical: metrics.geometry(compact ? 7 : 9),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2A0),
        borderRadius: BorderRadius.circular(metrics.geometry(9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Initial bid $initialBid',
            style: sellerText(
              metrics,
              compact ? 9.5 : 11,
              weight: FontWeight.w800,
            ),
          ),
          SizedBox(height: metrics.geometry(3)),
          Text(
            'Winning Bid $winningBid',
            style: sellerText(
              metrics,
              compact ? 9.5 : 11,
              weight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferInlineNotice extends StatelessWidget {
  const _OfferInlineNotice({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: metrics.artSize(16), color: color),
        SizedBox(width: metrics.geometry(6)),
        Text(
          text,
          style: sellerText(metrics, 12, weight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _OfferChoice extends StatelessWidget {
  const _OfferChoice({
    super.key,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Semantics(
      button: true,
      selected: selected,
      excludeSemantics: true,
      label: '$title. $subtitle',
      child: Container(
        margin: EdgeInsets.only(bottom: metrics.geometry(7)),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? SellerUiColors.primaryBright
                : SellerUiColors.line,
          ),
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
          child: Padding(
            padding: EdgeInsets.all(metrics.geometry(9)),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: SellerUiColors.primaryBright,
                ),
                SizedBox(width: metrics.geometry(7)),
                Icon(icon, color: SellerUiColors.body),
                SizedBox(width: metrics.geometry(8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: sellerText(metrics, 12, weight: FontWeight.w800),
                      ),
                      Text(
                        subtitle,
                        style: sellerText(
                          metrics,
                          10,
                          color: SellerUiColors.body,
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
    );
  }
}

class _SpecificLocationLauncher extends StatelessWidget {
  const _SpecificLocationLauncher({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Semantics(
      button: true,
      selected: selected,
      excludeSemantics: true,
      label: subtitle.isEmpty ? title : '$title. $subtitle',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? SellerUiColors.primaryBright
                : SellerUiColors.line,
          ),
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
          child: Padding(
            padding: EdgeInsets.all(metrics.geometry(10)),
            child: Row(
              children: [
                Icon(
                  Icons.map_outlined,
                  color: SellerUiColors.body,
                  size: metrics.artSize(21),
                ),
                SizedBox(width: metrics.geometry(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: sellerText(metrics, 12, weight: FontWeight.w800),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: sellerText(
                            metrics,
                            10,
                            color: SellerUiColors.body,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: metrics.geometry(8)),
                Icon(
                  Icons.chevron_right,
                  color: SellerUiColors.ink,
                  size: metrics.artSize(22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferPicker extends StatelessWidget {
  const _OfferPicker({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '$label. $value',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: SellerUiColors.line),
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
          child: Padding(
            padding: EdgeInsets.all(metrics.geometry(10)),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: metrics.artSize(17),
                  color: SellerUiColors.body,
                ),
                SizedBox(width: metrics.geometry(7)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: sellerText(
                          metrics,
                          9,
                          color: SellerUiColors.body,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: sellerText(metrics, 10, weight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferMessageField extends StatelessWidget {
  const _OfferMessageField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Stack(
          children: [
            TextField(
              key: const Key('sellerOfferMessage'),
              controller: controller,
              minLines: 3,
              maxLines: 5,
              maxLength: 250,
              style: sellerInputText(metrics, size: 13),
              decoration: InputDecoration(
                hintText: 'Add details about your offer',
                hintStyle: sellerInputPlaceholder(metrics),
                counterText: '',
                contentPadding: EdgeInsets.fromLTRB(
                  metrics.spacing(12),
                  metrics.spacing(11),
                  metrics.spacing(12),
                  metrics.spacing(28),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            Positioned(
              right: metrics.spacing(10),
              bottom: metrics.spacing(7),
              child: IgnorePointer(
                child: Text(
                  '${value.text.characters.length}/250',
                  key: const Key('sellerOfferMessageCounter'),
                  style: sellerText(metrics, 11, color: SellerUiColors.body),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfferHowItWorksRow extends StatelessWidget {
  const _OfferHowItWorksRow({
    required this.icon,
    required this.text,
    this.showBottomGap = true,
  });

  final IconData icon;
  final String text;
  final bool showBottomGap;

  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: showBottomGap ? metrics.geometry(10) : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: SellerUiColors.primaryBright,
            size: metrics.artSize(18),
          ),
          SizedBox(width: metrics.geometry(9)),
          Expanded(
            child: Text(text, style: sellerText(metrics, 11, height: 1.35)),
          ),
        ],
      ),
    );
  }
}

class _SellerLead {
  const _SellerLead({
    required this.name,
    required this.initials,
    required this.city,
    required this.distance,
    required this.request,
    required this.description,
    required this.budget,
    required this.match,
    required this.purchases,
    required this.lastPurchase,
    required this.meeting,
    required this.avatarColor,
    required this.initialColor,
  });
  final String name,
      initials,
      city,
      distance,
      request,
      description,
      budget,
      lastPurchase,
      meeting;
  final int match, purchases;
  final Color avatarColor, initialColor;
}

const _leads = [
  _SellerLead(
    name: 'James M.',
    initials: 'JM',
    city: 'Yonkers, NY',
    distance: '2.1 mi',
    request: 'Looking for iPad Air (5th gen)',
    description: 'Looking for a 64GB or 256GB. Good condition or like new.',
    budget: r'$350 – $500',
    match: 95,
    purchases: 12,
    lastPurchase: 'MacBook Air',
    meeting: 'Public place',
    avatarColor: Color(0xFFF0EDFF),
    initialColor: SellerUiColors.primaryBright,
  ),
  _SellerLead(
    name: 'Alicia C.',
    initials: 'AC',
    city: 'New Rochelle, NY',
    distance: '4.7 mi',
    request: 'Need iPad Pro 11-inch',
    description: 'Looking for 128GB or higher. Works perfectly.',
    budget: r'$550 – $750',
    match: 92,
    purchases: 8,
    lastPurchase: 'iPhone 14 Pro',
    meeting: 'Seller business',
    avatarColor: Color(0xFFFFF0DF),
    initialColor: SellerUiColors.amber,
  ),
  _SellerLead(
    name: 'Robert W.',
    initials: 'RW',
    city: 'Mount Vernon, NY',
    distance: '3.3 mi',
    request: 'iPad 10th Gen',
    description: 'Prefer 64GB. New or gently used is fine.',
    budget: r'$300 – $400',
    match: 89,
    purchases: 6,
    lastPurchase: 'AirPods Pro',
    meeting: 'Your home',
    avatarColor: Color(0xFFE3F7E9),
    initialColor: SellerUiColors.green,
  ),
];
