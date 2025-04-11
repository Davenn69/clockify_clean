import 'package:clockify_miniproject/core/utils/responsive_functions.dart';
import 'package:clockify_miniproject/core/widgets/error_widgets.dart';
import 'package:clockify_miniproject/features/detail/application/providers/detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_theme.dart';
import '../../../../core/utils/date_formatting.dart';
import '../../../activity/data/models/activity_hive_model.dart';
import '../widgets/button_widget.dart';

class DetailScreen extends ConsumerStatefulWidget{
  final ActivityHive activity;
  const DetailScreen({super.key, required this.activity});
  @override
  ConsumerState<DetailScreen> createState() => DetailScreenState();
}
class DetailScreenState extends ConsumerState<DetailScreen>{
  final TextEditingController descriptionController = TextEditingController();
  late DateTime changedTime;

  @override
  void initState() {
    super.initState();

    Future.microtask((){
      descriptionController.text = widget.activity.description;
      ref.read(detailProvider.notifier).changeBothTime(widget.activity.startTime, widget.activity.endTime);
    });
  }

  @override
  void dispose(){
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    var changedStartTime = ref.watch(detailProvider).changedStartTime;
    var changedEndTime = ref.watch(detailProvider).changedEndTime;

    Future<void> selectDateStartTime(BuildContext context, DateTime startTime, DateTime endTime) async {
      DatePicker.showDatePicker(
          context,
          locale: LocaleType.en,
          onConfirm: (date) {
            DatePicker.showTimePicker(
              context,
              showSecondsColumn: true,
              currentTime: DateTime.now(),
              locale: LocaleType.en,
              onConfirm: (time) {
                DateTime selectedDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                  time.second,
                );

                if(selectedDateTime.isAfter(endTime)){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    ShowDialog.showErrorDialog(message: "Start time should not be greater than end time");
                  });
                  return;
                }

                ref.read(detailProvider.notifier).changeStartTime(selectedDateTime);
              },
            );
          });
    }

    Future<void> selectDateEndTime(BuildContext context, DateTime startTime, DateTime endTime) async {
      DatePicker.showDatePicker(
          context,
          locale: LocaleType.en,
          onConfirm: (date) {
            DatePicker.showTimePicker(
              context,
              showSecondsColumn: true,
              currentTime: DateTime.now(),
              locale: LocaleType.en,
              onConfirm: (time) {
                DateTime selectedDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                  time.second,
                );

                if(selectedDateTime.isBefore(startTime)){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    ShowDialog.showErrorDialog(message: "End time should not be greater than start time");
                  });
                  return;
                }

                ref.read(detailProvider.notifier).changeEndTime(selectedDateTime);
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail",
          style: textTheme.headline1,
        ),
      ),
      backgroundColor: colors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                settingSizeForScreenSpaces(context, 0.05, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      formatDate(DateTime.now()),
                      style: textTheme.dateDisplayText,
                    ),
                  ],
                ),
                settingSizeForScreenSpaces(context, 0.1, 0.05),
                Text(
                  formatDuration(changedEndTime.difference(changedStartTime)),
                  style: textTheme.durationDetailText,
                ),
                settingSizeForScreenSpaces(context, 0.08, 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()async{
                        await selectDateStartTime(context, changedStartTime, changedEndTime);
                      },
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Start Time",
                            style: textTheme.timeDateHeadlineText,
                          ),
                          Gap(5.h),
                          Text(
                            formatTime(changedStartTime),
                            style: textTheme.timeText,
                          ),
                          Gap(5.h),
                          Text(
                            formatDate(changedStartTime),
                            style: textTheme.dateText,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        await selectDateEndTime(context, changedStartTime, changedEndTime);
                      },
                      child: Column(
                        children: <Widget>[
                          Text(
                            "End Time",
                            style: textTheme.timeDateHeadlineText,
                          ),
                          Gap(5.h),
                          Text(
                            formatTime(changedEndTime),
                            style: textTheme.timeText,
                          ),
                          Gap(5.h),
                          Text(
                            formatDate(changedEndTime),
                            style: textTheme.dateText,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Gap(20.h),
                SizedBox(
                  width: settingSizeForScreen(context, 275, 200),
                  height: settingSizeForScreen(context, 60, 40),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color: colors.secondary,
                            ),
                            Text(
                              "${widget.activity.locationLat} ${widget.activity.locationLng}",
                              style: textTheme.locationText,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                SizedBox(
                  width: settingSizeForScreen(context, 400, 300),
                  height: settingSizeForScreen(context, 150, 100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      style: textTheme.activityDescriptionText,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                      ],
                      decoration: InputDecoration(
                        hintText: "Write your activity here...",
                        filled: true,
                        fillColor: Colors.white,
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                SavingButtonWidgetDetails(ref : ref, controller:  descriptionController, activity: widget.activity),
                Gap(40.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}