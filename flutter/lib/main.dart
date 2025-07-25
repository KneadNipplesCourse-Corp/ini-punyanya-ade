import 'package:flutter/material.dart';
import 'package:ade_restapi/controller/product_controller.dart';
import 'package:ade_restapi/login.dart';
import 'package:ade_restapi/middleware/auth_middleware.dart';
import 'package:ade_restapi/products.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YAHYA SHOES',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple, // Default AppBar color
          foregroundColor: Colors.white, // Default AppBar text/icon color
          elevation: 4,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: "/products", // Middleware akan mengecek ini
      getPages: [
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(
          name: "/products",
          page: () => ProductPage(),
          middlewares: [AuthMiddleware()],
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(ProductController());
      }),
    );
  }
}
