import 'package:flutter/material.dart';

/// Shimmer/skeleton loading effect widget.
///
/// Shows a subtle animated gradient to indicate loading state.
class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ?? 
        (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ?? 
        (isDark ? Colors.grey[600]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer placeholder for a POI list item.
class POIListItemShimmer extends StatelessWidget {
  const POIListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            const ShimmerWidget(
              width: 80,
              height: 80,
              borderRadius: 8,
            ),
            const SizedBox(width: 12),
            
            // Content placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const ShimmerWidget(
                    width: double.infinity,
                    height: 18,
                  ),
                  const SizedBox(height: 8),
                  
                  // Address line 1
                  ShimmerWidget(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 14,
                  ),
                  const SizedBox(height: 4),
                  
                  // Address line 2
                  ShimmerWidget(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 14,
                  ),
                  const SizedBox(height: 12),
                  
                  // Distance/time row
                  Row(
                    children: [
                      const ShimmerWidget(
                        width: 70,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(width: 12),
                      const ShimmerWidget(
                        width: 60,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const Spacer(),
                      const ShimmerWidget(
                        width: 50,
                        height: 16,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
