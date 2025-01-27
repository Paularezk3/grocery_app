import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_colors.dart';

class TheTwoCircularIndicators extends StatefulWidget {
  final bool isFirstPage;

  const TheTwoCircularIndicators({
    required this.isFirstPage,
    super.key,
  });

  @override
  State<TheTwoCircularIndicators> createState() =>
      _TheTwoCircularIndicatorsState();
}

class _TheTwoCircularIndicatorsState extends State<TheTwoCircularIndicators>
    with TickerProviderStateMixin {
  late AnimationController _onPageEntryController;
  late Animation<Color?> _containerColor;
  late Animation<double> _leftCircleFill;
  late Animation<double> _rightCircleFill;
  late Animation<Color?> _rightCircleColor;
  late Animation<double> _lineWidth;

  @override
  void initState() {
    super.initState();

    // _onPageEntryController = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );
    _onPageEntryController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _containerColor = ColorTween(
      begin: AppColors.lightGrey,
      end: AppColors.white,
    ).animate(_onPageEntryController);

    _leftCircleFill = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _onPageEntryController, curve: Curves.easeInOutCubic));
    _rightCircleFill = Tween<double>(begin: 0, end: 1.0).animate(
        CurvedAnimation(
            parent: _onPageEntryController, curve: Curves.easeInOutCubic));
    _rightCircleColor = ColorTween(begin: AppColors.grey, end: AppColors.orange)
        .animate(CurvedAnimation(
            parent: _onPageEntryController, curve: Curves.easeInOutCubic));

    _lineWidth = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
        parent: _onPageEntryController, curve: Curves.easeInOutCubic));

    if (!widget.isFirstPage) {
      _onPageEntryController.forward();
    }
  }

  @override
  void didUpdateWidget(TheTwoCircularIndicators oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFirstPage) {
      _onPageEntryController.reverse();
    } else {
      _onPageEntryController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _onPageEntryController,
      builder: (context, child) {
        return Container(
          height: 100,
          width: double.infinity,
          color: _containerColor.value,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  24.horizontalSpace,
                  // Left Circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.orange,
                      ),
                      CircleAvatar(
                        radius: _leftCircleFill.value * 16,
                        backgroundColor: AppColors.white,
                      ),
                    ],
                  ),
                  // Connecting Line
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            height: 4,
                            color: AppColors.grey,
                          ),
                          Container(
                            height: 4,
                            width: constraints.maxWidth * _lineWidth.value,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  // Right Circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _rightCircleColor.value,
                      ),
                      CircleAvatar(
                        radius: 16 * _rightCircleFill.value,
                        backgroundColor: AppColors.white,
                      ),
                    ],
                  ),

                  24.horizontalSpace,
                ],
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shipping Address",
                    style: TextStyle(
                      color: AppColors.blackText.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Payment Method",
                    style: TextStyle(
                      color: AppColors.blackText.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _onPageEntryController.dispose();
    super.dispose();
  }
}
