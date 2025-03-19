import 'package:clockify_miniproject/features/activity/application/providers/activity_repository_provider.dart';
import 'package:clockify_miniproject/features/detail/presentation/widgets/detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../activity/application/providers/history_providers.dart';
import '../../../activity/application/providers/timer_providers.dart';
import '../../../activity/data/models/activity_hive_model.dart';

void showModalForError(BuildContext context, String data){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 350,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/cancel.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    data,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
  );
}

Widget saveDeleteState(WidgetRef ref, TextEditingController controller, ActivityHive activity, BuildContext context){
  final historyNotifier = ref.watch(historyHiveStateNotifierProvider.notifier);
  final token = ref.read(tokenProvider.notifier).state;
  final type = ref.watch(selectedChoiceProvider);
  final lat = ref.watch(timeLocationProvider).lat;
  final lng = ref.watch(timeLocationProvider).lng;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF45CDDC),
                        Color(0xFF2EBED9),
                      ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){
                        if(controller.text == ""){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            showModalForError(context, "Please input a description");
                          });
                          return;
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          historyNotifier.updateExistingActivity(ActivityHive(uuid : activity.uuid, description: controller.text, startTime: activity.startTime, endTime: activity.endTime, locationLat: activity.locationLat, locationLng: activity.locationLng, createdAt: activity.createdAt, updatedAt: activity.updatedAt, userUuid: activity.userUuid), token, type!, lat!, lng!);
                          Navigator.pop(context);
                          showModal(context);
                        });
                      },
                      child: Text(
                        "SAVE",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white
                        ),
                      )
                  )
              )
          ),
          SizedBox(width: 20,),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          showModalToConfirm(context, activity, token, type!, lat!, lng!, historyNotifier);
                        });
                      },
                      child: Text(
                        "DELETE",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade500
                        ),
                      )
                  )
              )
          ),
        ]
    ),
  );
}