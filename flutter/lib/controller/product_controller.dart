import 'package:ade_restapi/model/product_model.dart';
import 'package:ade_restapi/services/api_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductController extends GetxController {
  final ApiService _service = ApiService();

  var isLoggedIn = false.obs;
  var products = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    _service.onInit();
    // Inisialisasi status isLoggedIn berdasarkan token yang ada di GetStorage
    // Ini penting agar aplikasi tahu apakah user sudah login saat dibuka pertama kali
    isLoggedIn.value = GetStorage().hasData('access_token');
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    isLoading(true); // Tampilkan loading saat mencoba login
    try {
      final success = await _service.login(email, password);
      isLoggedIn.value = success; // >>> STATUS isLoggedIn DISET DI SINI

      if (!success) {
        Get.snackbar(
          'Login Gagal',
          'Email atau kata sandi salah. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        "Gagal terhubung ke server. Periksa koneksi internet Anda atau coba lagi nanti.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
      isLoggedIn.value = false; // Pastikan status login false jika ada error
    } finally {
      isLoading(false); // Sembunyikan loading setelah percobaan login selesai
    }
  }

  void logout() {
    _service.logout();
    isLoggedIn.value = false;
    Get.offAllNamed('/login'); // Redirect ke halaman login setelah logout
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      final result = await _service.fetchProducts();
      products.value = result;
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        "Gagal memuat produk. Coba lagi nanti.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
      // Jika fetchProducts gagal (misal karena 401 Unauthorized), middleware akan redirect ke login
    } finally {
      isLoading(false);
    }
  }
}