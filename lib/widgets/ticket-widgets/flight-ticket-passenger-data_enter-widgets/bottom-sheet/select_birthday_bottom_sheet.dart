import 'package:bamobile1/cubit/flight_ticket-cubit/flight_ticket_cubit.dart';
import 'package:bamobile1/utils/app_sizes.dart';
import 'package:bamobile1/widgets/bottom_sheet_widget.dart';
import 'package:bamobile1/widgets/save_and_clean_in_bottom_sheet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectBirthdayBottomSheet extends StatelessWidget {
  const SelectBirthdayBottomSheet({super.key, required this.index});

  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlightTicketCubit, FlightTicketState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        FlightTicketCubit flightTicketCubit =
            BlocProvider.of<FlightTicketCubit>(context);
        return BottomSheetWidget(
          paddingLeftRight: 0,
          paddingTop: 0,
          height: 0.4,
          title: SaveAndCleanInBottomSheetWidget(
            onTopForSave: () {
              // if (flightTicketCubit.cardDataList[index] != null) {
              //   flightTicketCubit.upDataTest(index: index);
              // } else {
              flightTicketCubit.upDataTestForBarthDay(index: index);
              // }

              flightTicketCubit.bottomSheetValue(type: 0);
            },
            onTopForClean: () {
              // if (flightTicketCubit.birthday != null) {
              //   flightTicketCubit.upDataTestForBarthDay(index: index);
              // }
              flightTicketCubit.bottomSheetValue(type: 0);
            },
          ),
          widgetBody: Container(
            height: context.height * 0.315,
            color: Colors.white,
            width: context.width * 1,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    maximumYear: DateTime.now().year,
                    minimumDate: DateTime(1900),
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime:
                        flightTicketCubit.passengerCardDataList[index] != null
                            ? flightTicketCubit
                                .passengerCardDataList[index]!.birthday
                            : DateTime.now(),
                    onDateTimeChanged: (DateTime value) {
                      flightTicketCubit.birthday = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
