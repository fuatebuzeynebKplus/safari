import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bamobile1/helper/functions.dart';
import 'package:bamobile1/utils/app_colors.dart';
import 'package:bamobile1/utils/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestTestView extends StatelessWidget {
  const TestTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kAppBarColor,
        title: const Text('TestTestView'),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              child: const Text('TestTestView'),
              onTap: () {
                SnackbarUtils.showAwesomeSnackbarFromTop(
                    context: context,
                    title: 'Title',
                    message: 'message',
                    type: ContentType.success);
              },
            ),
            const SizedBox(height: 205),
            Container(
              height: 170,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // تغيير موضع الظل
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3, // تخصيص 60% من المساحة للصورة
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/icon_logo.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2, // تخصيص 40% من المساحة للنصوص
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AED 50,000',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1 Bed • 2 Baths',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'New York, NY...',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
