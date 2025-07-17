// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:link_on/models/product_model/product_model.dart';
import 'package:link_on/screens/products/products.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'dart:developer' as dev;

class GetProductProvider extends ChangeNotifier {
  // A boolean variable to track whether data is being loaded or not.
  bool laoding = false;

// A string variable to store the name of the current screen.
  String _currentScreen = '';

// Lists to store product data for different screens.
  final List<ProductsModel> productList = [];
  final List<ProductsModel> myProductList = [];

// Getter function to retrieve the product data based on the current screen.
  List<ProductsModel> get getproductData {
    switch (_currentScreen) {
      case "my_product":
        {
          // If the current screen is "my_product," return the list of my products.
          return myProductList;
        }
      default:
        {
          // For other screens, return the list of all products.
          return productList;
        }
    }
  }

// Setter function to set the current screen name.
  set setScreenName(String name) {
    _currentScreen = name;
    notifyListeners();
  }

// A function to fetch and load product data.
  Future getProducts({afterPostId, screenName}) async {
    // Indicate that data loading has started.
    loadingData(true);
    // Define the API URL for fetching products.
    String url = "get-products";
    // Create a map to store API parameters.
    Map<String, dynamic> mapData = {
      "limit": 6,
    };
    // If the current screen is "my_product," add the user ID to the API parameters.
    if (screenName == "my_product") {
      mapData["user_id"] = getStringAsync("user_id");
    }
    // If afterPostId is provided, add it to the API parameters.
    if (afterPostId != null) {
      mapData["offset"] = afterPostId;
    }
    // Call the API to fetch product data.
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    log('Response is ${res}');

    if (res["code"] == '200') {
      // If the API call is successful, parse the response data into a list of ProductsModel.
      List<ProductsModel> tempModel = List.from(res["data"]).map((item) {
        ProductsModel productsModle = ProductsModel.fromJson(item);
        return productsModle;
      }).toList();

      // Add the fetched products to the appropriate list based on the current screen.
      if (tempModel.isEmpty) {
        toast('No more data to show');
      } else {
        for (int i = 0; i < tempModel.length; i++) {
          switch (screenName) {
            case "my_product":
              {
                myProductList.add(tempModel[i]);
                notifyListeners();
                break;
              }
            default:
              {
                productList.add(tempModel[i]);
                notifyListeners();
                break;
              }
          }
        }
      }

      // Indicate that data loading has completed.
      loadingData(false);
    } else {
      // If the API call is not successful, display an error message.
      loadingData(false);
    }
  }

// Function to create a new product.
  Future createProduct({mapData, context, isFromTimeline}) async {
    // Show a custom loading dialog.
    customDialogueLoader(context: context);

    // Define the API URL for creating a product.
    String url = "add-product";

    // Call the API to create the product with the provided data.
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    // Log the response data for debugging purposes.
    dev.log('create product data ====>$res');

    if (res["code"] == '200') {
      // If the API call is successful, display a success message and navigate back.
      toast("Product published successfully");
      Navigator.pop(context);
      Navigator.pop(context);

      if (isFromTimeline == false) {
        Navigator.pop(context);
      }
    } else {
      // If the API call is not successful, close the loading dialog and display an error message.
      Navigator.pop(context);
    }
  }

// Function to delete a product via API.
  Future<void>? deleteProduct({
    String? screenName,
    required int? index,
    required BuildContext context,
    required ProductsModel productsModel,
  }) async {
    // Show a custom loading dialog.
    customDialogueLoader(context: context);

    // Prepare the data for the API call.
    Map<String, dynamic> dataArray = {
      "product_id": productsModel.id,
    };

    // Make the API call to delete the product.
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'delete-product', apiData: dataArray);

    if (res["code"] == '200') {
      if (screenName?.isNotEmpty != null) {
        switch (screenName) {
          case "home":
            {
              // If the deletion is from the home screen, remove the product from the list.
              context.read<PostProvider>().removePostAtIndex(index);
              break;
            }
          case "profile":
            {
              // If the deletion is from the profile screen, remove the product from the profile posts list.
              context.read<ProfilePostsProvider>().removeAtIndex(index!);
            }
        }
      }
      if (index != null) {
        // If the screenName is not provided, simply remove the product at the specified index.
        removeAtIndex(index: index);
      }
      // Display a success message and navigate back.
      toast("Delete Product Successful");

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      // If the API call is not successful, close the loading dialog and display an error message.
      Navigator.pop(context);
      // toast('Error: ${res['errors']['error_text']}');
    }
  }

// Function to edit product data.
  Future editProduct({mapData, context}) async {
    // Show a custom loading dialog.
    customDialogueLoader(context: context);

    // Define the API URL for editing a product.
    String url = "update-product";

    // Call the API to update the product data with the provided data.
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    if (res["code"] == '200') {
      // If the API call is successful, display a success message and navigate back.
      toast("Product data updated successfully");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Products(),
        ),
      );
    } else {
      // If the API call is not successful, close the loading dialog and display an error message.
      Navigator.pop(context);
    }
  }

// Function to update the loading status.
  void loadingData(bool value) {
    laoding = value;
    notifyListeners();
  }

// This function clears the list of products based on the current screen.
  void makeListEmpty() {
    switch (_currentScreen) {
      case "my_product":
        {
          myProductList.clear(); // Clear the 'my_product' list
          break;
        }
      default:
        {
          productList.clear(); // Clear the default product list
        }
    }
  }

// This function removes an item at the specified index from the list of products.
// It also notifies listeners after removing the item.
  void removeAtIndex({required int index}) {
    switch (_currentScreen) {
      case "my_product":
        {
          myProductList
              .removeAt(index); // Remove an item from 'my_product' list
          break;
        }
      default:
        {
          productList
              .removeAt(index); // Remove an item from the default product list
        }
    }
    notifyListeners(); // Notify listeners after removing the item
  }
}
