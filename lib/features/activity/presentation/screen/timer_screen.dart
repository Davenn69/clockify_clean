import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:clockify_miniproject/core/utils/responsive_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_paths.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/utils/date_formatting.dart';
import '../../application/providers/button_provider.dart';
import '../../application/providers/timer_providers.dart';
import '../../domain/entities/activity_entity.dart';
import '../widgets/button_widget.dart';
import '../widgets/timer_widgets.dart';

class ContentScreen extends ConsumerStatefulWidget{
  const ContentScreen({super.key});

  @override
  ConsumerState<ContentScreen> createState() => ContentScreenState();
}
class ContentScreenState extends ConsumerState<ContentScreen>{
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context){
    Orientation orientation = MediaQuery.of(context).orientation;
    final condition = ref.watch(isStart);
    final stopWatchTime = ref.watch(stopWatchTimeProvider);
    final state = ref.watch(timeLocationProvider);
    final notifier = ref.read(timeLocationProvider.notifier);

    if(state.lat == null && state.lng == null){
      WidgetsBinding.instance.addPostFrameCallback((_){
        notifier.updateGeolocation();
      });
    }

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  settingSizeForScreenSpaces(context, 0.05, 0),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                        images.clockifyLogo,
                        width: settingSizeForScreen(context, 200, 150),
                        fit: BoxFit.cover
                    ),
                  ),
                  settingSizeForScreenSpaces(context, 0.05, 0.05),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){},
                            child: Hero(
                              tag: 'Timer',
                              child: Text(
                                "Timer",
                                style: textTheme.navigationTextActive,
                              ),
                            ),
                          ),
                          Gap(5.h),
                          Hero(
                            tag: "timer-activity",
                            child: AnimatedContainer(
                              width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.20 : MediaQuery.of(context).size.height * 0.30,
                              height: 3,
                              color : colors.secondary,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.of(context).push(NavigationService.createRouteForActivity());
                        },
                        child: Hero(
                          tag: 'Activity',
                          child: Text(
                            "Activity",
                            style: textTheme.navigationTextInactive,
                          ),
                        ),
                      ),
                    ],
                  ),
                  settingSizeForScreenSpaces(context, 0.1, 0.1),
                  Text(
                    stopWatchTime.when(data: (value)=> StopWatchTimer.getDisplayTime(value, milliSecond: false).replaceAll(":", " : "), loading: () => "00 : 00 : 00", error: (err, stack) => "Error"),
                    style: textTheme.timeDisplay,
                  ),
                  settingSizeForScreenSpaces(context, 0.1, 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Start Time",
                            style: textTheme.timeDateHeadlineText,
                          ),
                          Gap(5.h),
                          Text(
                            formatTime(state.startTime),
                            style: textTheme.timeText,
                          ),
                          Gap(5.h),
                          Text(
                            formatDate(state.startTime),
                            style: textTheme.dateText,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "End Time",
                            style: textTheme.timeDateHeadlineText,
                          ),
                          Gap(5.h),
                          Text(
                            formatTime(state.endTime),
                            style: textTheme.timeText,
                          ),
                          Gap(5.h),
                          Text(
                            formatDate(state.endTime),
                            style: textTheme.dateText,
                          ),
                        ],
                      )
                    ],
                  ),
                  Gap(20.h),
                  SizedBox(
                    width: 275.w,
                    height: 60.h,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (state.lat == null && state.lng == null) ? <Widget>[SpinKitCircle(
                          color: Colors.white,
                          size: 30,
                        )] : <Widget>[
                          Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color:  colors.secondary
                          ),
                          Text(
                            "${state.lat} ${state.lng}",
                            style: textTheme.locationText,
                          )
                        ],
                      ),
                    ),
                  ),
                  Gap(20.h),
                  SizedBox(
                    width: 400.w,
                    height: 100.h,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: _descriptionController,
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
                  condition ? StartButtonWidget(ref : ref, provider : isStart, startTimer : startTimer, notifier : notifier) : ActivityDisabledWidgets(ref : ref, isResetStop: isResetStop, isStart: isStart, stopTimer: stopTimer, resetTimer: resetTimer, notifier: notifier, controller: _descriptionController, activity: ActivityEntity(
                    description: _descriptionController.text,
                    startTime:  state.startTime ?? DateTime.now(),
                    endTime: state.endTime ?? DateTime.now(),
                    locationLat: state.lat ?? 0,
                    locationLng: state.lng ?? 0,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    userUuid: "",
                  )),
                  Gap(40.h)
                ],
              ),
            ),
          )
      ),
    );
  }
}