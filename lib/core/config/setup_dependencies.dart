import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_app/core/config/database_helper.dart';
import 'package:grocery_app/features/cart/domain/usecases/decrement_from_cart_usecase.dart';
import 'package:hive/hive.dart';

import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repository/cart_repository.dart';
import '../../features/cart/domain/usecases/add_item_to_cart.dart';
import '../../features/cart/domain/usecases/get_cart_item.dart';
import '../../features/cart/domain/usecases/remove_item_from_cart.dart';
import '../../features/cart/presentation/bloc/cart_page_bloc.dart';
import '../../features/product_details_page/data/datasources/local_product_details_datasource.dart';
import '../../features/product_details_page/data/datasources/remote_product_details_datasource.dart';
import '../../features/product_details_page/data/repositories/product_details_repository_impl.dart';
import '../../features/product_details_page/domain/repositories/product_details_repository.dart';
import '../../features/product_details_page/domain/usecases/get_product_details.dart';
import '../../features/product_details_page/presentation/blocs/product_details_page_bloc.dart';
import 'package:grocery_app/features/cart/domain/entity/cart_item_entity_hive.dart'
    as hive;

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  Hive.registerAdapter(hive.CartItemDataAdapter());
  final cartBox = await Hive.openBox<hive.CartItemData>('cartBox');

  // Repositories
  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(
        firestore: FirebaseFirestore.instance,
        cartBox: cartBox,
      ));
  getIt.registerLazySingleton<ProductDetailsRepository>(
      () => ProductDetailsRepositoryImpl(
            localDataSource:
                LocalProductDetailsDataSource(DatabaseHelper.instance.database),
            remoteDataSource:
                RemoteProductDetailsDataSource(FirebaseFirestore.instance),
          ));

  // Use Cases
  getIt.registerLazySingleton(() => GetCartItems(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => AddItemToCart(getIt<CartRepository>()));
  getIt
      .registerLazySingleton(() => RemoveItemFromCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(
      () => DecrementFromCartUsease(getIt<CartRepository>()));

  getIt.registerLazySingleton(
      () => GetProductDetails(getIt<ProductDetailsRepository>()));

  // Blocs
  getIt.registerFactory(() => CartPageBloc(
      getCartItems: getIt<GetCartItems>(),
      addItemToCart: getIt<AddItemToCart>(),
      decrementFromCart: getIt<DecrementFromCartUsease>(),
      removeItemFromCart: getIt<RemoveItemFromCart>()));
  getIt.registerFactory(() =>
      ProductDetailsPageBloc(getProductDetails: getIt<GetProductDetails>()));
}
