import 'package:flutter/material.dart';

// ─── Base animated shimmer box ────────────────────────────────────────────────

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    Key? key,
    required this.width,
    required this.height,
    this.radius = 8,
  }) : super(key: key);

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
    _anim = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [
              Color(0xFFEAEAEA),
              Color(0xFFF6F6F6),
              Color(0xFFEAEAEA),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Device card skeleton ─────────────────────────────────────────────────────

class DeviceCardSkeleton extends StatelessWidget {
  const DeviceCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 160, height: 16, radius: 4),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 120, height: 12, radius: 4),
                ],
              ),
              ShimmerBox(width: 20, height: 20, radius: 4),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          // Pump row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 140, height: 14, radius: 4),
                  const SizedBox(height: 6),
                  ShimmerBox(width: 190, height: 12, radius: 4),
                ],
              ),
              ShimmerBox(width: 48, height: 28, radius: 14),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          // Water quality + tank
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 100, height: 13, radius: 4),
                    const SizedBox(height: 8),
                    ShimmerBox(width: double.infinity, height: 12, radius: 4),
                    const SizedBox(height: 6),
                    ShimmerBox(width: double.infinity, height: 12, radius: 4),
                    const SizedBox(height: 12),
                    ShimmerBox(width: 100, height: 13, radius: 4),
                    const SizedBox(height: 8),
                    ShimmerBox(width: double.infinity, height: 12, radius: 4),
                    const SizedBox(height: 6),
                    ShimmerBox(width: double.infinity, height: 12, radius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  ShimmerBox(width: 60, height: 16, radius: 4),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 60, height: 100, radius: 8),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Notification item skeleton ───────────────────────────────────────────────

class NotificationItemSkeleton extends StatelessWidget {
  const NotificationItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 44, height: 44, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 13, radius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: 160, height: 11, radius: 4),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ShimmerBox(width: 35, height: 11, radius: 4),
        ],
      ),
    );
  }
}

// ─── Report stats skeleton ────────────────────────────────────────────────────

class ReportStatsSkeleton extends StatelessWidget {
  const ReportStatsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _row(),
          const SizedBox(height: 16),
          _row(),
          const SizedBox(height: 16),
          _row(),
        ],
      ),
    );
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerBox(width: 130, height: 12, radius: 4),
        ShimmerBox(width: 70, height: 14, radius: 4),
      ],
    );
  }
}
