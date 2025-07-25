import 'package:flutter/material.dart';
import 'package:ade_restapi/controller/product_controller.dart';
import 'package:ade_restapi/products.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Pastikan ini ada di pubspec.yaml

class LoginPage extends StatelessWidget {
  final ProductController controller = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Logo/Brand Area ---
              Icon(
                Icons.shopping_bag_outlined, // A shopping bag icon for a store
                size: 100,
                color: Colors.blueGrey[700],
              ),
              const SizedBox(height: 20),
              Text(
                "Masuk ke Toko Sepatu",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- Email Input ---
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email Anda',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Password Input ---
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  hintText: 'Masukkan kata sandi Anda',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Login Button ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null // Tombol akan dinonaktifkan jika isLoading true
                            : () async {
                              final email = emailController.text;
                              final password = passwordController.text;

                              // Panggil metode login dari controller
                              await controller.login(email, password);

                              // Penting: Cek status isLoggedIn.value HANYA SETELAH await controller.login() selesai
                              // Ini akan otomatis di-trigger oleh Obx di ProductPage.
                              // Namun, jika Anda ingin redirect secara eksplisit di sini, pastikan
                              // isLoading sudah false (artinya login() sudah selesai).
                              if (controller.isLoggedIn.value) {
                                // Tunggu sebentar untuk memastikan UI sudah diupdate dari isLoading(false)
                                // Walaupun biasanya GetX akan menangani ini dengan cepat.
                                Get.offAllNamed('/products');
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Modern button color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            ) // Tampilkan indikator loading
                            : const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Fitur Belum Tersedia',
                    'Fitur lupa kata sandi akan segera hadir!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orangeAccent,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(10),
                    borderRadius: 8,
                  );
                },
                child: Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(color: Colors.deepPurple[400]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
