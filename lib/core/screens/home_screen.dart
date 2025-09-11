import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';
import 'package:qrscanner/widgets/abstract_background_wrapper.dart';
import '../../widgets/home_error_state.dart';
import '../../widgets/home_main_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: AbstractBackgroundWrapper(
          child: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: Colors.white,
                    size: 30,
                  ),
                );
              }
              if (controller.error.value.isNotEmpty) {
                return HomeErrorState(controller: controller);
              }
              return HomeMainContent(controller: controller);
            }),
          ),
        ),
      ),
    );
  }
}
