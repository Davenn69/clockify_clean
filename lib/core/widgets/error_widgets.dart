import 'package:clockify_miniproject/core/constants/image_paths.dart';
import 'package:clockify_miniproject/core/constants/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../features/activity/application/notifiers/history_hive_notifier.dart';
import '../../features/activity/data/models/activity_hive_model.dart';
import '../constants/colors.dart';
import '../router/router_constants.dart';

class ShowDialog{

  static void showModalToConfirm(BuildContext context, ActivityHive activity, String token, String type, double lat, double lng, HistoryHiveStateNotifier historyNotifier){
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: SizedBox(
          width: 350,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height:20),
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: Image.asset(
                        "assets/images/alert.png"
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "You are about to delete a data",
                    style: textTheme.messageText1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Are you sure?",
                    style: textTheme.descriptionText1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.fontGrey.shade200,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: textTheme.buttonText2,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            historyNotifier.deleteContent(activity.uuid, token, type, lat, lng);
                            showModalForActivityDeletion();
                          });
                        },
                        child: Text(
                          "Delete",
                          style: textTheme.buttonText2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void showModalForActivityUpdate(){
    showDialog(
        context: ctx,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350.w,
              height: 400.h,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 100.w,
                          height: 100.h,
                          child: Image.asset(
                              "assets/images/success-medium.png"
                          ),
                        ),
                        Gap(50.h),
                        Text(
                          "Success",
                          style: textTheme.messageText1,
                        ),
                        Gap(20.h),
                        Text(
                          "Activity has been successfully updated.",
                          style: textTheme.descriptionText1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  static void showModalForActivityDeletion(){
    showDialog(
        context: ctx,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350.w,
              height: 400.h,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: Image.asset(
                          images.successLogo
                      ),
                    ),
                    Gap(50.h),
                    Text(
                      "Success",
                      style: textTheme.messageText1,
                    ),
                    Gap(20.h),
                    Text(
                      "Activity has been successfully deleted.",
                      style: textTheme.descriptionText1,
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

  static void showModalForForgotPassword(){
    showDialog(
        context: ctx,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350.w,
              height: 400.h,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: Image.asset(
                          images.successLogo
                      ),
                    ),
                    Gap(50.h),
                    Text(
                      "Successfully sent reset password link",
                      style: textTheme.messageText1,
                      textAlign: TextAlign.center,
                    ),
                    Gap(20.h),
                    Text(
                      "Please check your mail!",
                      style: textTheme.descriptionText1,
                      textAlign: TextAlign.center,
                    ),
                    // GestureDetector(
                    //   child: Text(data),
                    // )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  static void showSuccessModal(){
    showDialog(
        context: ctx,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350.w,
              height: 400.h,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: Image.asset(
                            images.successLogo
                        ),
                      ),
                      Gap(50.h),
                      Text(
                        "Success",
                        style: textTheme.messageText1,
                      ),
                      Gap(20.h),
                      Text(
                        "Your account has been successfully created.",
                        style: textTheme.descriptionText1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  static void showModalForLocationDenied(String data) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350.w,
              height: 400.h,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: Image.asset(
                          images.alert
                      ),
                    ),
                    Gap(50.h),
                    Text(
                      "Location Error",
                      style: textTheme.messageText1,
                    ),
                    Gap(20.h),
                    Text(
                      data,
                      style: textTheme.descriptionText1,
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

  static void showErrorDialog({
    required String message,
    String? description
  }){
    showDialog(
        context: ctx,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350.w,
              height: 300.h,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      images.cancel,
                      width: 100.w,
                      height: 100.h,
                    ),
                    Gap(20.h),
                    Text(
                      message,
                      style: textTheme.messageText1,
                      textAlign: TextAlign.center,
                    ),
                    Gap(10.h),
                    if(description !=null)
                      Text(
                        description,
                        style: textTheme.descriptionText1,
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
}
