import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';
import 'package:qrscanner/widgets/circular_checkin_button.dart';
import 'package:qrscanner/widgets/user_header_widget.dart';
import 'package:qrscanner/widgets/today_summary_widget.dart';

import '../../widgets/abstract_background_wrapper.dart';


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
              if (controller.isLoading.value)
              {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                      color: Colors.white, size: 30),
                );
              }
              if ( controller.error.value.isNotEmpty)
                {
                  return _buildErrorState(controller);
                }
              return _buildMainContent(controller);
            }),
          ),
        )
      )
    );
  }

  Widget _buildMainContent(HomeController controller) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: Colors.blue[600],
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildUserHeader(controller),
            const SizedBox(height: 45),

            _buildActionButton(controller),
            const SizedBox(height: 35),

            _buildTodaySummary(controller),

            // _buildQuickStats(controller),
            // const SizedBox(height: 30,),
            //
            // _buildHistorySection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(HomeController controller) {
    return UserHeader(
      uid: controller.uid.value,
      onLogout: controller.logout,
    );
  }


  Widget _buildActionButton(HomeController controller) {
    return Center(
      child: CircularCheckInButton(
        canSwipe: controller.canSwipe,
        label: controller.swipeLabel,
        onTap: controller.openScanner,
        currentLocation: controller.currentLocationName.value,
      ),
    );
  }

  Widget _buildTodaySummary(HomeController controller) {
    return TodaySummaryWidget(
      todayData: controller.todayData.value,
    );
  }
  Widget _buildErrorState(HomeController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 26,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white.withOpacity(0.8),
                fontFamily: GoogleFonts.poppins().fontFamily,
                height: 1.6,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: controller.loadAttendanceData,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
