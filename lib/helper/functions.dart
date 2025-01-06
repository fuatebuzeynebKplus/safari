import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bamobile1/generated/l10n.dart';
import 'package:bamobile1/utils/app_colors.dart';
import 'package:bamobile1/utils/app_images.dart';
import 'package:bamobile1/utils/app_sizes.dart';
import 'package:bamobile1/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message,
      [int seconds = 1]) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.kSecondColor,
      duration: Duration(seconds: seconds),
      action: SnackBarAction(
        label: S.of(context).Ok,
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showAwesomeSnackbarFromTop({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType type,
    int seconds = 2,
  }) {
    final overlay = Overlay.of(context);

    double initialTopOffset = -100;
    double finalTopOffset = MediaQuery.of(context).padding.top + 10;

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(const Duration(milliseconds: 10), () {
              setState(() {
                initialTopOffset = finalTopOffset;
              });
            });

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: initialTopOffset,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: AwesomeSnackbarContent(
                  title: title,
                  message: message,
                  contentType: type,
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: seconds), () {
      overlayEntry.remove();
    });
  }
}
