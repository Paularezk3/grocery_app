import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/common/strings.dart';
import 'package:grocery_app/features/checkout/domain/entity/checkout_data_entity.dart';
import 'package:grocery_app/features/checkout/presentation/bloc/checkout_page_state.dart';
import 'package:grocery_app/features/checkout/presentation/widgets/text_with_text_field.dart';

import '../../../../core/themes/app_colors.dart';
import '../bloc/checkout_page_bloc.dart';

class CheckoutSecondPageBody extends StatefulWidget {
  final GlobalKey formKey;
  final CheckoutDataEntity checkoutData;
  const CheckoutSecondPageBody(
      {required this.formKey, required this.checkoutData, super.key});

  @override
  State<CheckoutSecondPageBody> createState() => _CheckoutSecondPageBodyState();
}

class _CheckoutSecondPageBodyState extends State<CheckoutSecondPageBody> {
  late GlobalKey formKey;
  final cardHolderNameController = TextEditingController();
  final cardNumber = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void initState() {
    formKey = widget.formKey;
    cardHolderNameController.text =
        widget.checkoutData.fullName ?? "Md Rafatul islam";
    cardNumber.text = "333 4444 5555 6666";
    super.initState();
  }

  @override
  void dispose() {
    cardHolderNameController.dispose();
    cardNumber.dispose();
    phoneController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.read<CheckoutPageBloc>().state is CheckoutPageLoading;
    return Form(
      key: formKey,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  children: [
                    CreditCardWidget(
                      cardNumber: "1212 1212 2222 4444",
                      expiryDate: "27/01",
                      cardHolderName: widget.checkoutData.fullName ?? "",
                      cvvCode: "545",
                      showBackView: false,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      bankName: 'Bank Name',
                      cardBgColor: Colors.black87,
                      glassmorphismConfig: Glassmorphism.defaultConfig(),
                      enableFloatingCard: true,
                      floatingConfig: FloatingConfig(
                        isGlareEnabled: true,
                        isShadowEnabled: true,
                        shadowConfig: FloatingShadowConfig(),
                      ),
                      backgroundImage: Strings.cardBg2,
                      labelValidThru: 'VALID\nTHRU',
                      obscureCardNumber: true,
                      obscureInitialCardNumber: false,
                      obscureCardCvv: true,
                      labelCardHolder: 'CARD HOLDER',
                      cardType: CardType.mastercard,
                      isHolderNameVisible: true,
                      height: 190,
                      width: MediaQuery.of(context).size.width * 0.9,
                      isChipVisible: true,
                      isSwipeGestureEnabled: true,
                      animationDuration: Duration(milliseconds: 1000),
                      chipColor: Colors.yellow[800],
                      padding: 16,
                    ),
                    CreditCardWidget(
                      cardNumber: "4216 1212 2222 4846",
                      expiryDate: "27/01",
                      cardHolderName: widget.checkoutData.fullName ?? "",
                      cvvCode: "545",
                      showBackView: false,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      bankName: 'Bank Name',
                      cardBgColor: Colors.black87,
                      glassmorphismConfig: Glassmorphism.defaultConfig(),
                      enableFloatingCard: true,
                      floatingConfig: FloatingConfig(
                        isGlareEnabled: true,
                        isShadowEnabled: true,
                        shadowConfig: FloatingShadowConfig(),
                      ),
                      backgroundImage: Strings.cardBg,
                      labelValidThru: 'VALID\nTHRU',
                      obscureCardNumber: true,
                      obscureInitialCardNumber: false,
                      obscureCardCvv: true,
                      labelCardHolder: 'CARD HOLDER',
                      cardType: CardType.mastercard,
                      isHolderNameVisible: true,
                      height: 190,
                      width: MediaQuery.of(context).size.width * 0.9,
                      isChipVisible: true,
                      isSwipeGestureEnabled: true,
                      animationDuration: Duration(milliseconds: 1000),
                      chipColor: Colors.yellow[800],
                      padding: 16,
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWithTextField(
                title: "Card Holder Name",
                controller: cardHolderNameController,
                hintText: "Enter the name on the card",
                isLoading: true,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your Full Name";
                  }
                  return null;
                },
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWithTextField(
                title: "Card Number",
                controller: cardNumber,
                hintText: "Enter your card number",
                isLoading: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email address";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextWithTextField(
                      title: "Month/Year",
                      controller: zipCodeController,
                      hintText: "Enter your zip code",
                      isLoading: isLoading,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your zip code";
                        }
                        return null;
                      },
                    ),
                  ),
                  8.horizontalSpace,
                  Flexible(
                    child: TextWithTextField(
                      title: "CVV",
                      controller: cityController,
                      hintText: "Enter your city",
                      isLoading: isLoading,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your city";
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {},
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.gPercent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: true
                                ? AppColors.gPercent
                                : AppColors.white, // Green box inside
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ), // No content when unchecked
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
