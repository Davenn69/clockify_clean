import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:clockify_miniproject/features/activity/domain/entities/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_paths.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/utils/responsive_functions.dart';
import '../../application/providers/history_providers.dart';
import '../../application/providers/timer_providers.dart';
import '../widgets/history_widgets.dart';

class ActivityScreen extends ConsumerWidget{
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);

  ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    // final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
    // final historyState = ref.watch(historyHiveStateNotifierProvider).history;
    // final token = ref.watch(tokenProvider);
    Orientation orientation = MediaQuery.of(context).orientation;
    final lat = ref.watch(timeLocationProvider).lat;
    final lng = ref.watch(timeLocationProvider).lng;

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
                      GestureDetector(
                        onTap: (){Navigator.of(context).push(NavigationService.createRouteForContent());},
                        child: Hero(
                          tag: 'Timer',
                          child: Text(
                            "Timer",
                            style: textTheme.navigationTextInactive,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:(){},
                            child: Hero(
                              tag: 'Activity',
                              child: Text(
                                "Activity",
                                style: textTheme.navigationTextActive,
                              ),
                            ),
                          ),
                          Gap(5.h),
                          Hero(
                            tag: "timer-activity",
                            child: AnimatedContainer(
                              width:  orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.20 : MediaQuery.of(context).size.height * 0.30,
                              height: 3,
                              color : colors.secondary,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(30.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _searchController,
                              onChanged: (value){
                                if(value.length >= 3){
                                  _debouncer.run((){
                                    ref.read(searchQueryProvider.notifier).state = value;
                                  });
                                }

                                ref.read(searchQueryProvider.notifier).state = "";
                              },
                              decoration: InputDecoration(
                                  hintText: "Search Activity...",
                                  hintStyle: textTheme.inputHintText,
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    size: 30,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              ),
                            )
                        ),
                        Gap(10.h),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            isExpanded : true,
                            value: ref.watch(selectedChoiceProvider)??"Oldest",
                            onChanged: (String? value){
                              ref.read(selectedChoiceProvider.notifier).state = value;
                              // ref.refresh(historyHiveStateNotifierProvider);
                            },
                            items: <String>['Latest Date', "Nearby", "Oldest"].map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: textTheme.dropDownText,
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.white, width: 50)
                                )
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(20.h),
                  (lat == null || lng == null) ? CircularProgressIndicator() : Consumer(builder: (context, ref, child){
                    final historyState = ref.watch(historyHiveStateNotifierProvider).history;
                    return Column(children: makeWidget(ref, historyState));
                  })
                ],
              ),
            ),
          )
      ),
    );
  }
}