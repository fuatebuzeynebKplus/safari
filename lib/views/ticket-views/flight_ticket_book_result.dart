import 'package:bamobile1/bottom_nav_bar.dart';
import 'package:bamobile1/generated/l10n.dart';
import 'package:bamobile1/utils/app_colors.dart';
import 'package:bamobile1/utils/app_images.dart';
import 'package:bamobile1/utils/app_sizes.dart';
import 'package:bamobile1/views/main_views/home_view.dart';
import 'package:bamobile1/widgets/app_bar_widget.dart';
import 'package:bamobile1/widgets/transaction_result_widget.dart';
import 'package:flutter/material.dart';

class FlightTicketBookResult extends StatelessWidget {
  const FlightTicketBookResult({super.key});
  static String id = 'FlightTicketBookResult';
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        Navigator.pushNamed(context, BottomNavBar.id);
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          toolbarHeight: context.height * 0.06,
          automaticallyImplyLeading: false,
          title: const AppBarWidget(),
          backgroundColor: AppColors.kAppBarColor,
        ),
        body: TransactionResultWidget(
          image: AppImages.doneIcon,
          title: S.of(context).YourTransactionHasBeenSuccessfullyCompleted,
          subTitle: S.of(context).ReservationNumber,
          code: '',
          buttonText: S.of(context).ReservationDetails,
        ),
      ),
    );
  }
}
