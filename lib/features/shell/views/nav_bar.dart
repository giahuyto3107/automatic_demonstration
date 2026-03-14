import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/router/app_routes.dart';
import 'package:automatic_demonstration/core/theme/app_colors.dart';
import 'package:automatic_demonstration/features/shell/data/models/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap; 
  
  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double barHeight  = 30.0.h;
    final double fabRadius  = 15.0.r;
    final double fabOverlap = 10.0.h;

    final double totalHeight = barHeight + fabRadius + fabOverlap;

    final List<NavItem> items = [
      const NavItem(icon: Icons.home),
      const NavItem(icon: FontAwesomeIcons.gear),
    ];

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 64.h),
              painter: BottomNavPainter(),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: .max,
                crossAxisAlignment: .center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: .center,
                      children: List.generate(items.length ~/ 2, (i) => _NavBarItem(
                        icon: items[i].icon,
                        isSelected: currentIndex == i,
                        index: i,
                        onTap: onTap,
                      )),
                    ),
                  ),

                  // FAB gap
                  SizedBox(width: ((fabRadius + 8) * 2 ).w),

                  // Right half
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(items.length ~/ 2, (i) {
                        final index = (items.length ~/ 2) + i;
                        return _NavBarItem(
                          icon: items[index].icon,
                          isSelected: currentIndex == index,
                          index: index,
                          onTap: onTap,
                        );
                      }),
                    ),
                  ),
                ]
              ),
          ),

          Positioned(
            top: 0.h,
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.qrScannerPath),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width:  (fabRadius + 8) * 2,
                height: (fabRadius + 8) * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6A8FFF), Color(0xFF3A50E0)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A50E0).withOpacity(0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: AppConstants.fontTitleM.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xffD9D9D9)
      ..style = PaintingStyle.fill;

    // Shadow paint
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    final double w = size.width;
    final double h = size.height;

    // Curve parameters
    final double notchRadius = 38.0;    // radius of the circular FAB
    final double notchMargin = 8.0;     // gap between FAB and bar edge
    final double cornerRadius = 24.0;   // bar corner radius
    final double curveWidth = 28.0;     // horizontal spread of the curve
    final double centerX = w / 2;

    final path = Path();

    // Start from top-left corner (after rounded corner)
    path.moveTo(cornerRadius, 0);

    // Top edge left → approaching the notch
    path.lineTo(centerX - notchRadius - notchMargin - curveWidth, 0);

    // Left curve going down into the notch
    path.cubicTo(
      centerX - notchRadius - notchMargin, 0,    // control point 1
      centerX - notchRadius - notchMargin, 0,    // control point 2
      centerX - notchRadius - notchMargin + 4, 6,    // end point
    );

    // Arc around the notch (bottom of the circle cutout)
    path.arcToPoint(
      Offset(centerX + notchRadius + notchMargin - 4, 6),
      radius: Radius.circular(notchRadius + notchMargin),
      clockwise: false,
    );

    // Right curve coming back up
    path.cubicTo(
      centerX + notchRadius + notchMargin,          0,    // control point 1
      centerX + notchRadius + notchMargin,          0,    // control point 2
      centerX + notchRadius + notchMargin + curveWidth, 0, // end point
    );

    // Top edge right → top-right corner
    path.lineTo(w - cornerRadius, 0);

    // Top-right rounded corner
    path.quadraticBezierTo(w, 0, w, cornerRadius);

    // Right edge
    path.lineTo(w, h);

    // Bottom edge
    path.lineTo(0, h);

    // Left edge
    path.lineTo(0, cornerRadius);

    // Top-left rounded corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();

    // Draw shadow first
    canvas.drawPath(path, shadowPaint);

    // Draw white bar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const _NavBarItem({
    required this.icon,
    required this.index,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: AppConstants.fontXL.sp,
        color: isSelected ? AppColors.textOnLight : AppColors.disable,
      ),
    );
  }
}