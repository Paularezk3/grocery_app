import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/features/checkout/domain/entity/checkout_data_entity.dart';
import 'package:grocery_app/features/checkout/presentation/bloc/checkout_page_state.dart';
import 'package:grocery_app/features/checkout/presentation/widgets/text_with_text_field.dart';

import '../bloc/checkout_page_bloc.dart';

class CheckoutFirstForm extends StatefulWidget {
  // final GlobalKey formKey;
  final CheckoutDataEntity checkoutData;
  const CheckoutFirstForm(
      {
      // required this.formKey,
      required this.checkoutData,
      super.key});

  @override
  State<CheckoutFirstForm> createState() => _CheckoutFirstFormState();
}

class _CheckoutFirstFormState extends State<CheckoutFirstForm> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void initState() {
    fullNameController.text = widget.checkoutData.fullName ?? "";
    emailController.text = widget.checkoutData.emailAddress ?? "";
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
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
      // key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWithTextField(
            title: "Full Name",
            controller: fullNameController,
            hintText: "Enter your full name",
            isLoading: isLoading,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your Full Name";
              }
              return null;
            },
          ),
          16.verticalSpace,
          TextWithTextField(
            title: "Email Address",
            controller: emailController,
            hintText: "Enter your email address",
            isLoading: isLoading,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your email address";
              }
              if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(value)) {
                return "Please enter a valid email address";
              }
              return null;
            },
          ),
          16.verticalSpace,
          TextWithTextField(
            title: "Phone",
            controller: phoneController,
            hintText: "Enter your phone number",
            isLoading: isLoading,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your phone number";
              }
              if (!RegExp(r"^\+?[0-9]{7,15}$").hasMatch(value)) {
                return "Please enter a valid phone number";
              }
              return null;
            },
          ),
          16.verticalSpace,
          TextWithTextField(
            title: "Address",
            controller: addressController,
            hintText: "Enter your address",
            isLoading: isLoading,
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your address";
              }
              return null;
            },
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextWithTextField(
                  title: "Zip Code",
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
                  title: "City",
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
            ],
          ),
          16.verticalSpace,
          TextWithTextField(
            title: "Country",
            controller: countryController,
            hintText: "Enter your country",
            isLoading: isLoading,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your country";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
