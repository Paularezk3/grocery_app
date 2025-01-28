import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/config/routes/route_names.dart';
import 'package:grocery_app/core/utils/cached_image_handler.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_bloc.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_event.dart';
import 'package:grocery_app/features/cart/presentation/bloc/cart_page_state.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../common/components/quantity_counter.dart';
import '../../domain/entity/cart_item_entity_hive.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Details",
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.blackText)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: TextButton(
                onPressed: () {
                  (context.read<CartPageBloc>().state as CartLoadedState)
                          .items
                          .cartItemData
                          .isEmpty
                      ? null
                      : Navigator.pushNamed(context, RouteNames.checkoutPage);
                },
                child: Text("Place Order",
                    style: GoogleFonts.poppins(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    )),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.whiteBackground,
      body: BlocBuilder<CartPageBloc, CartPageState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            context.read<CartPageBloc>().add(LoadCartItems());
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoadedState) {
            return ListView.builder(
              itemCount: state.items.cartItemData.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                final item = state.items.cartItemData[index];
                return _buildCartItem(context, item, index);
              },
            );
          } else {
            return const Center(
              child: Text("Error loading cart items."),
            );
          }
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemData item, int index) {
    return Dismissible(
      key: ValueKey(index),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.black,
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        // Remove the item from the underlying list first
        final cartBloc = context.read<CartPageBloc>();
        cartBloc.add(RemoveFromCart(item));
        // Remove the dismissed item from the UI
        (cartBloc.state as CartLoadedState)
            .items
            .cartItemData
            .remove(item); // Adjust based on your state structure
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Image with Price Overlay
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: CachedImageHandler.asBoxDecoration(
                        imageUrl: item.imagePath,
                        borderRadius: 12,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        "\$${item.price}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.blackText,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackText.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${(item.price * item.quantity).toStringAsFixed(1)}",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        QuantityCounter(
                          counterValue: item.quantity, // Example quantity
                          onIncrement: () {
                            // Increment logic
                            context.read<CartPageBloc>().add(AddToCart(
                                item.copyWith(quantity: item.quantity + 1)));
                          },
                          onDecrement: () {
                            // Decrement logic
                            context.read<CartPageBloc>().add(
                                DecrementFromCartEvent(item.copyWith(
                                    quantity: item.quantity - 1)));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
