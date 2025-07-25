import 'dart:developer';

import 'package:ade_restapi/model/product_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService extends GetConnect {
  @override
  // Pastikan URL ini mengarah ke IP atau domain server Anda yang benar
  // PENTING: Gunakan IP lokal komputer Anda jika emulator/perangkat ada di jaringan yang sama
  // Untuk emulator Android, 10.0.2.2 adalah localhost komputer host
  // final baseUrl = "http://10.215.83.3:3000"; // Contoh: Ganti dengan IP Anda
  // final baseUrl = 'http://10.0.2.2:3000'; // for Android emulator
  final baseUrl = 'http://127.0.0.1:3000'; // for web or desktop

  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.addRequestModifier<Object?>((request) {
      final accessToken = box.read<String>("access_token");
      if (accessToken != null) {
        request.headers["Authorization"] = "Bearer $accessToken";
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      // DEBUGGING: Tambahkan log untuk melihat status code respons
      log("Response Modifier - Status Code: ${response.statusCode}");
      log("Response Modifier - Request URL: ${request.url}");

      if (response.statusCode == 401) {
        log("401 Unauthorized detected. Redirecting to login.");
        GetStorage().remove('access_token'); // Hapus token kadaluarsa
        // Delay sedikit untuk memastikan Get.snackbar ditampilkan
        Future.delayed(Duration.zero, () {
          Get.snackbar(
            'Sesi Habis',
            'Sesi Anda telah berakhir, silakan login kembali.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
          );
          Get.offAllNamed('/login'); // Redirect ke login
        });
      }
      return response;
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        "/login",
        body: {"email": email, "password": password},
      );

      // DEBUGGING: Log respons API login
      log("Login API Response Status: ${response.statusCode}");
      log("Login API Response Body: ${response.bodyString}");

      if (response.statusCode == 200) {
        final accessToken = response.body["access_token"];
        if (accessToken != null) {
          log("Access Token received: $accessToken");
          await box.write("access_token", accessToken);
          return true;
        } else {
          log("Access Token is null in response.");
          return false;
        }
      } else {
        // Jika status code bukan 200, berarti login gagal
        log("Login failed with status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Tangani error jaringan atau lainnya
      log("Error during login API call: $e");
      return false;
    }
  }

  void logout() {
    box.remove("access_token");
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await httpClient.get('/products');
      log("Fetch Products Response Status: ${response.statusCode}");
      log(
        "Fetch Products Response Body: ${response.bodyString}",
      ); // Pastikan ada 'data' key

      if (response.status.hasError ||
          response.body == null ||
          !response.body.containsKey('data')) {
        throw Exception(
          'Failed to load products: ${response.statusText ?? 'Unknown error'}',
        );
      }

      final List<dynamic> rawList = response.body['data'];
      return rawList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      log("Error fetching products: $e");
      rethrow; // Lempar ulang exception agar bisa ditangkap di controller
    }
  }
}
