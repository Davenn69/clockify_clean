import 'package:clockify_miniproject/core/widgets/error_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';


Future<LocationPermission> checkLocationPermission()async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if(!serviceEnabled){
    return Future.error("Location service is disabled");
  }

  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
  }

  return permission;
}

// Future<Position> getCurrentLocation()async{
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//   if(!serviceEnabled){
//     return Future.error("Location service is disabled");
//   }
//
//   permission = await Geolocator.checkPermission();
//   if(permission == LocationPermission.denied){
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied){
//       // if (ModalRoute.of(context)?.settings.name != "/login") {
//       //   WidgetsBinding.instance.addPostFrameCallback((_) {
//       //     showModalForLocationDenied(context, "Location service is denied");
//       //     Navigator.pushReplacementNamed(context, "/login");
//       //   });
//       // }
//       return Future.error("Location service is denied");
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever){
//     // WidgetsBinding.instance.addPostFrameCallback((_){
//     //   Navigator.pushReplacementNamed(context, "/login");
//     //   showModalForLocationDenied(context, "Location permissions are permanently denied, enable them in settings");
//     // });
//     return Future.error("Location permissions are permanently denied, enable them in settings");
//   }
//
//   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
// }