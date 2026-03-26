import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/features/home_screen/providers/food_stall.dart';
import 'package:automatic_demonstration/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:automatic_demonstration/core/constants/constants.dart';
import 'package:automatic_demonstration/core/theme/theme.dart';

class AudioCategoryContainer extends ConsumerStatefulWidget {
  final int allCount;
  final int listenedCount;
  final Function(int) onCategoryChanged;

  const AudioCategoryContainer({
    super.key,
    required this.allCount,
    required this.listenedCount,
    required this.onCategoryChanged,
  });

  @override
  ConsumerState<AudioCategoryContainer> createState() => _AudioCategoryContainerState();
}

class _AudioCategoryContainerState extends ConsumerState<AudioCategoryContainer> {
  final LayerLink _layerLink = LayerLink();
  int selectedIndex = 0;
  double _selectedRadius = 500; // Default radius of 500m
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 2) {
      _showDistanceFilterDropdown();
    } else {
      widget.onCategoryChanged(index);
    }
  }

  void _showDistanceFilterDropdown() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside to close
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _removeOverlay();
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown positioned below the category container
          Positioned(
            width:
              MediaQuery.of(context).size.width -
              (AppConstants.spacingL.w * 2),
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(-7, 5),
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: RadiusFilterDropdown(
                  selectedRadius: _selectedRadius,
                  onConfirm: (double radius) {
                    setState(() {
                      _selectedRadius = radius;
                    });
                    ref.read(foodStallProvider.notifier).updateRadius(radius);
                    _removeOverlay();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final selectionColors = context.selectionColors;
    final l10n = AppLocalizations.of(context)!;

    List<String> audioCategoryItems = [l10n.all, l10n.listened, l10n.filter];
    int lastCategoryItemIndex = audioCategoryItems.length - 1;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          color: selectionColors.unselectedBg,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Row(
          mainAxisAlignment: .spaceAround,
          children: audioCategoryItems.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;

            bool isSelected = selectedIndex == index;
            bool isLastCategoryItem = index == lastCategoryItemIndex;

            Widget itemContent = Text(
              isLastCategoryItem ? item : item,
              style: TextStyle(
                fontSize: AppConstants.fontS.sp,
                color: isSelected ? selectionColors.selectedText : selectionColors.unselectedText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            );

            return Expanded(
              child: GestureDetector(
                onTap: () => _onTap(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppConstants.spacingXS.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectionColors.selectedBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                  ),
                  child: isLastCategoryItem
                    ? Row(
                        mainAxisAlignment: .center,
                        children: [
                          itemContent,
                          SizedBox(width: AppConstants.spacingXXS.w),
                          Icon(
                            FontAwesomeIcons.caretDown,
                            size: AppConstants.fontL.r,
                            color: isSelected
                              ? selectionColors.selectedText
                              : AppColors.unSelectedTextColor,
                          ),
                        ],
                    )
                    : itemContent,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RadiusFilterDropdown extends StatefulWidget {
  final double selectedRadius;
  final Function(double) onConfirm;

  const RadiusFilterDropdown({
    super.key,
    required this.selectedRadius,
    required this.onConfirm,
  });

  @override
  State<RadiusFilterDropdown> createState() => _RadiusFilterDropdownState();
}

class _RadiusFilterDropdownState extends State<RadiusFilterDropdown> {
  late TextEditingController _radiusController;
  late double _currentRadius;

  @override
  void initState() {
    super.initState();
    _currentRadius = widget.selectedRadius;
    _radiusController = TextEditingController(
      text: _currentRadius.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _onRadiusChanged(String value) {
    final double? newRadius = double.tryParse(value);
    if (newRadius != null && newRadius >= 0) {
      setState(() {
        _currentRadius = newRadius;
      });
    }
  }

  void _decrement() {
    setState(() {
      _currentRadius = (_currentRadius - 50).clamp(0, double.infinity);
      _radiusController.text = _currentRadius.toStringAsFixed(0);
    });
  }

  void _increment() {
    setState(() {
      _currentRadius += 50;
      _radiusController.text = _currentRadius.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColors = context.surfaceColors;

    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: surfaceColors.primarySurface,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.spacingL.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "${AppLocalizations.of(context)!.radius} (m)",
                style: TextStyle(
                  fontSize: AppConstants.fontL.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM.w,
                vertical: AppConstants.spacingL.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decrement,
                    icon: Icon(FontAwesomeIcons.minus, color: const Color(0xffF97015), size: 20.r),
                  ),
                  SizedBox(width: AppConstants.spacingS.w),
                  Expanded(
                    child: _RadiusTextFieldItem(
                      controller: _radiusController,
                      onChanged: _onRadiusChanged,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingS.w),
                  IconButton(
                    onPressed: _increment,
                    icon: Icon(FontAwesomeIcons.plus, color: const Color(0xffF97015), size: 20.r),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppConstants.spacingS.h),
            GestureDetector(
              onTap: () {
                widget.onConfirm(_currentRadius);
              },
              child: const _ConfirmButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadiusTextFieldItem extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const _RadiusTextFieldItem({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColors = context.surfaceColors;

    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Color(0xffF97015), width: 1.5),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: AppConstants.spacingS.h),
        filled: true,
        fillColor: surfaceColors.lighterPrimarySurface,
        enabledBorder: outlineBorder,
        focusedBorder: focusedBorder,
        hintText: "0",
        hintStyle: TextStyle(color: Colors.grey.shade600),
      ),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: AppConstants.fontM.sp,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffF97015),
          borderRadius: BorderRadius.circular(AppConstants.radiusCircular.sp),
        ),
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingS.h),
        child: Text(
          AppLocalizations.of(context)!.confirmButton,
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
            fontWeight: .w600,
            color: AppColors.textOnDark,
          ),
          textAlign: .center,
        ),
      ),
    );
  }
}
