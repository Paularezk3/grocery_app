import 'package:flutter/material.dart';
import 'package:grocery_app/common/components/quantity_counter.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item Details",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Place Order",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.whiteBackground,
      body: ListView.builder(
        itemCount: 5, // Example: Replace with actual item count
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(index),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              // Handle delete action
            },
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Image with Price Overlay
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/banana.jpg'), // Replace with actual image
                              fit: BoxFit.cover,
                            ),
                          ),
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
                              "\$28.8",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
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
                            "Fruits",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.blackText
                                          .withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Banana",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$28.8",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              QuantityCounter(
                                counterValue: 1, // Example quantity
                                onIncrement: () {
                                  // Increment logic
                                },
                                onDecrement: () {
                                  // Decrement logic
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
        },
      ),
    );
  }
}
