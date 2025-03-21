import 'package:clockify_miniproject/core/utils/responsive_functions.dart';
import 'package:clockify_miniproject/features/detail/application/providers/detail_providers.dart';
import 'package:clockify_miniproject/features/detail/presentation/widgets/detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      ref.read(changedStartTimeProvider.notifier).state = widget.activity.startTime;
      ref.read(changedEndTimeProvider.notifier).state = widget.activity.endTime;
    });
  }

  @override
  Widget build(BuildContext context){
    var changedStartTime = ref.watch(changedStartTimeProvider);
    var changedEndTime = ref.watch(changedEndTimeProvider);

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
                    showModalForDetailError(context, "Start time should not be greater than end time");
                  });
                  return;
                }

                ref.read(changedStartTimeProvider.notifier).state = selectedDateTime;
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
                    showModalForDetailError(context, "End time should not be greater than start time");
                  });
                  return;
                }

                ref.read(changedEndTimeProvider.notifier).state = selectedDateTime;
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF233971),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Detail",
          style: GoogleFonts.nunitoSans(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Color(0xFF233971),
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
                      style: GoogleFonts.nunitoSans(
                          color: Color(0xFFF8D068),
                          fontWeight: FontWeight.bold,
                          fontSize: settingSizeForText(context, 18, 14)
                      ),
                    ),
                  ],
                ),
                settingSizeForScreenSpaces(context, 0.1, 0.05),
                Text(
                  formatDuration(changedEndTime.difference(changedStartTime)),
                  style: GoogleFonts.nunitoSans(
                      fontSize: settingSizeForText(context, 38, 28),
                      fontWeight: FontWeight.bold,
                      color : Colors.white
                  ),
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
                            style: GoogleFonts.nunitoSans(
                                fontSize: settingSizeForText(context, 12, 10),
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatTime(changedStartTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: settingSizeForText(context, 16, 12),
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatDate(changedStartTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: settingSizeForText(context, 12, 10),
                                color: Colors.white
                            ),
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
                            style: GoogleFonts.nunitoSans(
                                fontSize: settingSizeForText(context, 12, 10),
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatTime(changedEndTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: settingSizeForText(context, 14, 12),
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatDate(changedEndTime),
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: settingSizeForText(context, 12, 10),
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
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
                              color: Color(0xFFF8D068),
                            ),
                            Text(
                              "${widget.activity.locationLat} ${widget.activity.locationLng}",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: settingSizeForScreen(context, 400, 300),
                  height: settingSizeForScreen(context, 150, 100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      style: GoogleFonts.nunitoSans(
                          fontSize: settingSizeForText(context, 16, 12),
                          color: Colors.black
                      ),
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
                SizedBox(height: 20),
                saveDeleteState(ref, descriptionController, widget.activity, context),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }
}