import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioCategoryContainer extends StatefulWidget {
  final int foodStallListLength;
  const AudioCategoryContainer({super.key, required this.foodStallListLength});

  @override
  State<AudioCategoryContainer> createState() => _AudioCategoryContainerState();
}

class _AudioCategoryContainerState extends State<AudioCategoryContainer> {
  final LayerLink _layerLink = LayerLink();
  int selectedIndex = 0;
  final double _minDistance = 0;
  final double _maxDistance = 50;
  late double _selectedMinDistance;
  late double _selectedMaxDistance;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedMinDistance = _minDistance;
    _selectedMaxDistance = _maxDistance;
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
                setState(() {
                  selectedIndex = 0;
                });
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
                child: DistanceFilterDropdown(
                  minDistance: _minDistance,
                  maxDistance: _maxDistance,
                  selectedMinDistance: _selectedMinDistance,
                  selectedMaxDistance: _selectedMaxDistance,
                  onConfirm: (double minDistance, double maxDistance) {
                    setState(() {
                      _selectedMinDistance = minDistance;
                      _selectedMaxDistance = maxDistance;
                    });
                    _removeOverlay();
                    setState(() {
                      selectedIndex = 0;
                    });
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
    List<String> audioCategoryItems = ['Tất cả', 'Đã nghe', 'Lọc'];
    int lastCategoryItemIndex = audioCategoryItems.length - 1;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Row(
          mainAxisAlignment: .spaceAround,
          children: audioCategoryItems.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;

            bool isSelected = selectedIndex == index;
            bool isLastCategoryItem = index == lastCategoryItemIndex;
            bool isDefaultCategoryItem = index == 0;

            int listNumber = isDefaultCategoryItem
              ? widget.foodStallListLength
              : 0;

            Widget itemContent = Text(
              isLastCategoryItem ? item : "$item ($listNumber)",
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: isSelected ? Colors.white : const Color(0xff000000),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
              textAlign: .center,
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
                        ? AppColors.selectedBackgroundColor
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
                                ? AppColors.selectedTextColor
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

class DistanceFilterDropdown extends StatefulWidget {
  final double minDistance;
  final double maxDistance;
  final double selectedMinDistance;
  final double selectedMaxDistance;
  final Function(double, double) onConfirm;

  const DistanceFilterDropdown({
    super.key,
    required this.minDistance,
    required this.maxDistance,
    required this.selectedMinDistance,
    required this.selectedMaxDistance,
    required this.onConfirm,
  });

  @override
  State<DistanceFilterDropdown> createState() => _DistanceFilterDropdownState();
}

class _DistanceFilterDropdownState extends State<DistanceFilterDropdown> {
  late RangeValues _selectedRange;

  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _selectedRange = RangeValues(
      widget.selectedMinDistance,
      widget.selectedMaxDistance,
    );

    _minController = TextEditingController(
      text: widget.selectedMinDistance.toStringAsFixed(1),
    );
    _maxController = TextEditingController(
      text: widget.selectedMaxDistance.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _onSliderChanged(RangeValues newRange) {
    setState(() {
      _selectedRange = newRange;
      _minController.text = newRange.start.toStringAsFixed(1);
      _maxController.text = newRange.end.toStringAsFixed(1);
    });
  }

  void _onMinTextChanged(String value) {
    final double? newMin = double.tryParse(value);
    if (newMin != null) {
      // Validation: Must be within global bounds and less than current Max
      if (newMin >= widget.minDistance && newMin <= _selectedRange.end) {
        setState(() {
          _selectedRange = RangeValues(newMin, _selectedRange.end);
        });
      }
    }
  }

  void _onMaxTextChanged(String value) {
    final double? newMax = double.tryParse(value);
    if (newMax != null) {
      // Validation: Must be within global bounds and greater than current Min
      if (newMax <= widget.maxDistance && newMax >= _selectedRange.start) {
        setState(() {
          _selectedRange = RangeValues(_selectedRange.start, newMax);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: Color(0xff1F2933),
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
          crossAxisAlignment: .center,
          children: [
            // Start Date and End Date
            SizedBox(
              width: double.infinity,
              child: Text(
                "Khoảng cách (m)",
                style: TextStyle(
                  fontSize: AppConstants.fontL.sp,
                  fontWeight: .w600,
                  color: Colors.white,
                ),
                textAlign: .start,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM.w,
                vertical: AppConstants.spacingXS.h,
              ),
              child: Column(
                children: [
                  RangeSlider(
                    values: _selectedRange,
                    min: widget.minDistance,
                    max: widget.maxDistance,
                    activeColor: Color(0xffF97015),
                    inactiveColor: Colors.white,
                    // divisions: ((widget.maxDistance - widget.minDistance) / 1).toInt(),
                    padding: EdgeInsets.zero,
                    labels: RangeLabels(
                      _selectedRange.start.toStringAsFixed(1),
                      _selectedRange.end.toStringAsFixed(1),
                    ),
                    onChanged: (RangeValues newRange) =>
                        _onSliderChanged(newRange),
                  ),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        widget.minDistance.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: AppConstants.fontS.sp,
                          fontWeight: .w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.maxDistance.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: AppConstants.fontS.sp,
                          fontWeight: .w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.spacingXXS.h),
                  _MinMaxTextField(
                    minController: _minController,
                    maxController: _maxController,
                    onMinChanged: _onMinTextChanged,
                    onMaxChanged: _onMaxTextChanged,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppConstants.spacingS.h),
            GestureDetector(
              onTap: () {
                widget.onConfirm(_selectedRange.start, _selectedRange.end);
              },
              child: const _ConfirmButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinMaxTextField extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController maxController;
  final Function(String) onMinChanged;
  final Function(String) onMaxChanged;

  const _MinMaxTextField({
    required this.minController,
    required this.maxController,
    required this.onMinChanged,
    required this.onMaxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .center,
        children: [
          Expanded(
            child: _TextFieldItem(
              label: "Min",
              controller: minController,
              onChanged: onMinChanged,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppConstants.spacingM.w,
              right: AppConstants.spacingM.w,
              top: AppConstants.spacingL.h,
            ),
            child: Container(height: 2.h, width: 10.w, color: Colors.grey.shade600),
          ),
          Expanded(
            child: _TextFieldItem(
              label: "Max",
              controller: maxController,
              onChanged: onMaxChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextFieldItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;

  const _TextFieldItem({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Color(0xffF97015), width: 1.5),
    );

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: AppConstants.fontS.sp,
              fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(height: AppConstants.spacingXXS.h),

        Container(
          decoration: BoxDecoration(),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: .number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: const Color(0xff2E3A44), // Slightly lighter than background
              enabledBorder: outlineBorder,
              focusedBorder: focusedBorder,
              hintText: "0.0",
              hintStyle: TextStyle(color: Colors.grey.shade600),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppConstants.fontS.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: .center,
          ),
        ),
      ],
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
          AppStrings.confirmButton,
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
            fontWeight: .w600,
            color: Colors.white,
          ),
          textAlign: .center,
        ),
      ),
    );
  }
}
