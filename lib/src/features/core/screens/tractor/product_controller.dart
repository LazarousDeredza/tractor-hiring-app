import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor_hiring_app/src/features/core/screens/tractor/product_repo.dart';
import 'package:tractor_hiring_app/src/features/core/screens/tractor/products_list.dart';
import 'package:tractor_hiring_app/src/features/core/screens/tractor/model_product.dart';

class TractorController extends GetxController {
  static TractorController get instance => Get.find();

  final _tractorRepo = Get.put(ProductRespository());
  //get user email and pass to userRepository to fetch user details

//get all cases
  Future<List<Tractor>> getAllTractors() async {
    return _tractorRepo.getAllTractors();
  }

  //save case

  Future<void> saveProduct(Tractor productModel) async {
    //snackbar
    Get.snackbar(
      "Please wait",
      "Saving Tractor",
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(
        Icons.sync_rounded,
        color: Colors.green,
      ),
    );
    await _tractorRepo.saveTractor(productModel.toJson()).whenComplete(() {
      print("Tractor saved successfully ");

      Get.snackbar(
        "Success",
        "Tractor saved successfully ",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
      );
      Get.to(() => const ProductListScreen());
    }).catchError((onError) {
      Get.snackbar(
        "Error",
        "Tractor not saved",
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return onError;
    });
  }

  // updateRecord(UserModel user) async {
  //   Get.snackbar(
  //     "Please wait",
  //     "Updating user details",
  //     snackPosition: SnackPosition.BOTTOM,
  //     icon: Icon(
  //       Icons.sync_rounded,
  //       color: Colors.green,
  //     ),
  //   );
  //   await _caseRepo.updateUserRecord(user);
  // }
}
