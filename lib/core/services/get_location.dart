import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation()async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    return Future.error("Location service is disabled");
  }

  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied){
      return Future.error("Location service is denied");
    }
  }

  if (permission == LocationPermission.deniedForever){
    return Future.error("Location permissions are permanently denied, enable them in settings");
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}