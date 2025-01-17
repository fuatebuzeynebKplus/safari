import 'dart:io';

import 'package:bamobile1/generated/l10n.dart';
import 'package:bamobile1/utils/app_colors.dart';
import 'package:bamobile1/utils/app_images.dart';
import 'package:bamobile1/utils/app_sizes.dart';
import 'package:bamobile1/widgets/button_widget.dart';
import 'package:bamobile1/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePopup extends StatelessWidget {
  const UpdatePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppImages.logo,
            width: context.width * 0.5, height: context.width * 0.5),
        const SizedBox(height: 20),
        Dialog(
          shadowColor: Colors.black,
          elevation: 52,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: 60,
                  color: AppColors.kSecondColor,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).UpdateAvailable,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kSecondColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).UpdateMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(Platform.isAndroid
                        ? 'https://play.google.com/store/apps/dev?id=7282599253291951508'
                        : 'https://apps.apple.com/tr/developer/kplus-bilişim/id1555929233');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          S.of(context).UnableToOpenTheAppStore,
                        )),
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.kSecondColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextWidget(
                          text: S.of(context).ClickToUpdateTheApp,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
