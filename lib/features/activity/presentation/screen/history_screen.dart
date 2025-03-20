import 'package:clockify_miniproject/features/activity/domain/entities/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/navigation_service.dart';
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
    final lat = ref.watch(timeLocationProvider).lat;
    final lng = ref.watch(timeLocationProvider).lng;

    return Scaffold(
      backgroundColor: Color(0xFF233971),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                        "assets/images/clockify-medium.png",
                        width: 200,
                        fit: BoxFit.cover
                    ),
                  ),
                  SizedBox(height: 40),
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
                            style: GoogleFonts.nunitoSans(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
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
                                style: GoogleFonts.nunitoSans(
                                    color: Color(0xFFF8D068),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Hero(
                            tag: "timer-activity",
                            child: AnimatedContainer(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: 3,
                              color : Color(0xFFF8D068),
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _searchController,
                              onChanged: (value){
                                _debouncer.run((){
                                  ref.read(searchQueryProvider.notifier).state = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Search Activity...",
                                  hintStyle: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    color: Colors.grey
                                  ),
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
                        SizedBox(width: 10),
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
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black87
                                  ),
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
                  SizedBox(height: 20),
                  (lat == null || lng == null) ? CircularProgressIndicator() : Consumer(builder: (context, ref, child){
                    final historyState = ref.watch(historyHiveStateNotifierProvider).history;
                    return Column(children: makeWidget(context, ref, historyState));
                  })
                ],
              ),
            ),
          )
      ),
    );
  }
}