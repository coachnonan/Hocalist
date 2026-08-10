import 'package:flutter/material.dart';

import '../../theme/seller_ui_foundation.dart';
import 'approved_seller_reschedule_dialog.dart';

class ApprovedSellerMeetsPage extends StatefulWidget {
  const ApprovedSellerMeetsPage({required this.onOpenChat, super.key});

  final VoidCallback onOpenChat;

  @override
  State<ApprovedSellerMeetsPage> createState() =>
      _ApprovedSellerMeetsPageState();
}

class _ApprovedSellerMeetsPageState extends State<ApprovedSellerMeetsPage> {
  final Set<String> _expandedAppointments = <String>{};

  void _toggleAppointment(_Appointment appointment) {
    setState(() {
      if (!_expandedAppointments.add(appointment.initials)) {
        _expandedAppointments.remove(appointment.initials);
      }
    });
  }

  Future<void> _openReschedule(_Appointment appointment) async {
    final submitted = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0xB30B1231),
      builder: (context) => ApprovedSellerRescheduleDialog(
        customerName: appointment.name,
        currentDate: appointment.date,
        currentTime: appointment.time,
      ),
    );
    if (!mounted || submitted != true) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          key: Key('sellerRescheduleSubmittedNotice'),
          content: Text('Reschedule request sent. You are still in Meets.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SellerResponsivePage(
      builder: (context, metrics) {
        return CustomScrollView(
          key: const Key('sellerMeetsScroll'),
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
                  const _MeetsHeader(),
                  SizedBox(height: metrics.spacing(12)),
                  const _MeetStatusTabs(),
                  SizedBox(height: metrics.spacing(14)),
                  for (final appointment in _appointments) ...[
                    _AppointmentCard(
                      appointment: appointment,
                      expanded: _expandedAppointments.contains(
                        appointment.initials,
                      ),
                      onToggle: () => _toggleAppointment(appointment),
                      onMessage: widget.onOpenChat,
                      onReschedule: () => _openReschedule(appointment),
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

class _MeetsHeader extends StatelessWidget {
  const _MeetsHeader();
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
                'Meets',
                style: sellerText(metrics, 25, weight: FontWeight.w800),
              ),
              SizedBox(height: metrics.geometry(3)),
              Text(
                'Customers you agreed to meet',
                textAlign: TextAlign.center,
                style: sellerText(metrics, 13, color: SellerUiColors.body),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Filter appointments',
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_outlined),
          color: SellerUiColors.primaryBright,
        ),
      ],
    );
  }
}

class _MeetStatusTabs extends StatelessWidget {
  const _MeetStatusTabs();
  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Container(
      padding: EdgeInsets.all(metrics.geometry(2)),
      decoration: BoxDecoration(
        border: Border.all(color: SellerUiColors.line),
        borderRadius: BorderRadius.circular(metrics.geometry(11)),
      ),
      child: Row(
        children: [
          _StatusTab(label: 'Upcoming', count: '5', selected: true),
          _StatusTab(label: 'Today', count: '2'),
          _StatusTab(label: 'Completed'),
          _StatusTab(label: 'Canceled'),
        ],
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({required this.label, this.count, this.selected = false});
  final String label;
  final String? count;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return Expanded(
      child: Container(
        constraints: BoxConstraints(minHeight: metrics.geometry(48)),
        padding: EdgeInsets.symmetric(horizontal: metrics.geometry(3)),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [
                    SellerUiColors.primary,
                    SellerUiColors.primaryBright,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(metrics.geometry(9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              Icon(
                Icons.calendar_month_outlined,
                size: metrics.artSize(16),
                color: Colors.white,
              ),
              SizedBox(width: metrics.geometry(4)),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sellerText(
                  metrics,
                  10,
                  weight: FontWeight.w700,
                  color: selected ? Colors.white : SellerUiColors.body,
                ),
              ),
            ),
            if (count != null) ...[
              SizedBox(width: metrics.geometry(4)),
              CircleAvatar(
                radius: metrics.geometry(10),
                backgroundColor: selected
                    ? Colors.white
                    : SellerUiColors.lavender,
                child: Text(
                  count!,
                  style: sellerText(
                    metrics,
                    9,
                    weight: FontWeight.w800,
                    color: SellerUiColors.primaryBright,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.appointment,
    required this.expanded,
    required this.onToggle,
    required this.onMessage,
    required this.onReschedule,
  });
  final _Appointment appointment;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onMessage;
  final VoidCallback onReschedule;
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: metrics.artSize(26),
                    backgroundColor: appointment.avatarColor,
                    child: Text(
                      appointment.initials,
                      style: sellerText(
                        metrics,
                        20,
                        weight: FontWeight.w800,
                        color: appointment.initialColor,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -1,
                    bottom: 0,
                    child: Container(
                      width: metrics.geometry(11),
                      height: metrics.geometry(11),
                      decoration: BoxDecoration(
                        color: SellerUiColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: metrics.spacing(9)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.name,
                      style: sellerText(metrics, 18, weight: FontWeight.w800),
                    ),
                    Text(
                      appointment.request,
                      style: sellerText(
                        metrics,
                        12,
                        color: SellerUiColors.body,
                      ),
                    ),
                    Text(
                      '${appointment.city}  •  ${appointment.distance}',
                      style: sellerText(
                        metrics,
                        11,
                        color: SellerUiColors.body,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: metrics.geometry(7),
                      vertical: metrics.geometry(5),
                    ),
                    decoration: BoxDecoration(
                      color: SellerUiColors.greenSurface,
                      borderRadius: BorderRadius.circular(metrics.geometry(7)),
                    ),
                    child: Text(
                      appointment.date,
                      style: sellerText(
                        metrics,
                        10,
                        weight: FontWeight.w800,
                        color: SellerUiColors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: metrics.geometry(3)),
                  Text(
                    appointment.time,
                    style: sellerText(
                      metrics,
                      11,
                      weight: FontWeight.w800,
                      color: SellerUiColors.primaryBright,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24, color: SellerUiColors.line),
          Semantics(
            container: true,
            button: true,
            onTap: onToggle,
            label: expanded
                ? '${appointment.product}. Hide meeting details'
                : '${appointment.product}. Show meeting details',
            excludeSemantics: true,
            child: InkWell(
              key: Key('sellerMeetProduct${appointment.initials}'),
              onTap: onToggle,
              excludeFromSemantics: true,
              borderRadius: BorderRadius.circular(metrics.geometry(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: metrics.geometry(3)),
                child: Row(
                  children: [
                    Container(
                      width: metrics.artSize(52),
                      height: metrics.artSize(52),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: SellerUiColors.lavender,
                        borderRadius: BorderRadius.circular(
                          metrics.geometry(8),
                        ),
                      ),
                      child: Icon(
                        Icons.tablet_mac_outlined,
                        size: metrics.artSize(28),
                        color: SellerUiColors.primaryBright,
                      ),
                    ),
                    SizedBox(width: metrics.spacing(9)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agreed Product',
                            style: sellerText(
                              metrics,
                              9,
                              color: SellerUiColors.body,
                            ),
                          ),
                          Text(
                            appointment.product,
                            style: sellerText(
                              metrics,
                              14,
                              weight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            appointment.details,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agreed Price',
                          style: sellerText(
                            metrics,
                            9,
                            color: SellerUiColors.body,
                          ),
                        ),
                        Text(
                          appointment.price,
                          style: sellerText(
                            metrics,
                            17,
                            weight: FontWeight.w800,
                            color: SellerUiColors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 24, color: SellerUiColors.line),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: SellerUiColors.primaryBright,
                ),
                SizedBox(width: metrics.geometry(7)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.location,
                        style: sellerText(metrics, 13, weight: FontWeight.w800),
                      ),
                      Text(
                        appointment.city,
                        style: sellerText(
                          metrics,
                          10,
                          color: SellerUiColors.body,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Open map',
                  onPressed: () {},
                  icon: const Icon(Icons.map_outlined),
                  color: SellerUiColors.primaryBright,
                ),
              ],
            ),
            SizedBox(height: metrics.spacing(8)),
            Row(
              children: [
                Expanded(
                  child: _MeetAction(
                    icon: Icons.lock_outline,
                    label: 'Enter PIN',
                    color: SellerUiColors.primaryBright,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: metrics.geometry(6)),
                Expanded(
                  child: _MeetAction(
                    icon: Icons.call_outlined,
                    label: 'Call',
                    color: SellerUiColors.green,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: metrics.geometry(6)),
                Expanded(
                  child: _MeetAction(
                    icon: Icons.chat_bubble_outline,
                    label: 'Message',
                    color: SellerUiColors.primaryBright,
                    onTap: onMessage,
                  ),
                ),
                SizedBox(width: metrics.geometry(6)),
                Expanded(
                  child: _MeetAction(
                    icon: Icons.history,
                    label: 'Reschedule',
                    color: SellerUiColors.amber,
                    onTap: onReschedule,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MeetAction extends StatelessWidget {
  const _MeetAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final metrics = ApprovedReplicaScope.of(context);
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, metrics.geometry(62)),
        padding: EdgeInsets.symmetric(horizontal: metrics.geometry(2)),
        side: const BorderSide(color: SellerUiColors.line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(metrics.geometry(8)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: metrics.artSize(20), color: color),
          SizedBox(height: metrics.geometry(3)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sellerText(
              metrics,
              9,
              weight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Appointment {
  const _Appointment({
    required this.name,
    required this.initials,
    required this.request,
    required this.city,
    required this.distance,
    required this.date,
    required this.time,
    required this.product,
    required this.details,
    required this.price,
    required this.location,
    required this.avatarColor,
    required this.initialColor,
  });
  final String name,
      initials,
      request,
      city,
      distance,
      date,
      time,
      product,
      details,
      price,
      location;
  final Color avatarColor, initialColor;
}

const _appointments = [
  _Appointment(
    name: 'James M.',
    initials: 'JM',
    request: 'Looking for iPad Air (5th gen)',
    city: 'Yonkers, NY',
    distance: '2.1 mi',
    date: 'May 19, 2025',
    time: '2:00 PM',
    product: 'iPad Air (5th gen)',
    details: '64GB  •  Space Gray  •  Good condition',
    price: r'$475',
    location: 'Cross County Mall',
    avatarColor: Color(0xFFF0EDFF),
    initialColor: SellerUiColors.primaryBright,
  ),
  _Appointment(
    name: 'Alicia C.',
    initials: 'AC',
    request: 'Need iPad Pro 11-inch',
    city: 'New Rochelle, NY',
    distance: '4.7 mi',
    date: 'May 19, 2025',
    time: '5:30 PM',
    product: 'iPad Pro 11-inch (M2)',
    details: '128GB  •  Silver  •  Like new',
    price: r'$650',
    location: 'New Rochelle Public Library',
    avatarColor: Color(0xFFFFF0DF),
    initialColor: SellerUiColors.amber,
  ),
  _Appointment(
    name: 'Robert W.',
    initials: 'RW',
    request: 'iPad 10th Gen',
    city: 'Mount Vernon, NY',
    distance: '3.3 mi',
    date: 'May 20, 2025',
    time: '11:00 AM',
    product: 'iPad 10th Gen',
    details: '64GB  •  Blue  •  Excellent condition',
    price: r'$375',
    location: 'Target - Mount Vernon',
    avatarColor: Color(0xFFE3F7E9),
    initialColor: SellerUiColors.green,
  ),
];
