import 'dart:convert';

import 'package:clockify_miniproject/features/activity/domain/entities/activity_entity.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ActivityRemoteDataSource{
  // final baseUrl = "https://light-master-eagle.ngrok-free.app/api/v1/";
  final baseUrl = "http://192.168.1.8:3000/api/v1/";

  const ActivityRemoteDataSource();

  Future<Response> getHistory(String token)async{
    Dio dio = Dio();

    try{

      if(token == null || token.isEmpty){
        print("token is empty");
        throw Exception("Token is empty");
      }else{

        final response = await dio.get(
          "${baseUrl}activity/",
          options: Options(
              headers: {
                "authorization": "Bearer $token",
                "Content-Type": "application/json",
              },
          ),
        );
        print("Response + ${response.data}");
        return response;
      }

    }on DioException catch(e){
      print("Dio Error: ${e.message}");
      print("Response Data: ${e.response?.data}");
      print("Response Status: ${e.response?.statusCode}");

      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}activity/"),
          statusCode: 500, // Internal server error
          data: {"error": "Unknown error occurred"},
        );
      }
    }catch(e){
      throw Exception("Error $e");
    }
  }

  Future<Response> getFilteredByLatestDateHistory(String token)async{
    Dio dio = Dio();

    try{

      if(token == null || token.isEmpty){
        print("token is empty");
        throw Exception("Token is empty");
      }else{

        final response = await dio.get(
          "${baseUrl}activity/filter?sortBy=latest",
          options: Options(
            headers: {
              "authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        print("Response + ${response.data}");
        return response;
      }

    }on DioException catch(e){
      print("Dio Error: ${e.message}");
      print("Response Data: ${e.response?.data}");
      print("Response Status: ${e.response?.statusCode}");

      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}activity/"),
          statusCode: 500, // Internal server error
          data: {"error": "Unknown error occurred"},
        );
      }
    }catch(e){
      throw Exception("Error $e");
    }
  }

  Future<Response> getFilteredByNearbyHistory(String token, double lat, double lng)async{
    Dio dio = Dio();

    try{

      if(token == null || token.isEmpty){
        print("token is empty");
        throw Exception("Token is empty");
      }else{

        final response = await dio.get(
          "${baseUrl}activity/filter?sortBy=distance&lat=$lat&lng=$lng",
          options: Options(
            headers: {
              "authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        print("Response + ${response.data}");
        return response;
      }

    }on DioException catch(e){
      print("Dio Error: ${e.message}");
      print("Response Data: ${e.response?.data}");
      print("Response Status: ${e.response?.statusCode}");

      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}activity/"),
          statusCode: 500, // Internal server error
          data: {"error": "Unknown error occurred"},
        );
      }
    }catch(e){
      throw Exception("Error $e");
    }
  }

  Future<Response> saveHistory(ActivityEntity entity, String token)async{
    Dio dio = Dio();
    print("${baseUrl}activity/");
    print("Token $token");
    try{

      var data = json.encode({
        "description": entity.description,
        "start_time": entity.startTime.toIso8601String(),
        "end_time": entity.endTime.toIso8601String(),
        "location_lat": entity.locationLat,
        "location_lng": entity.locationLng
      });

      final response = await dio.post(
        "${baseUrl}activity/",
        data: data,
        options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          },
        ),
      );
      print("response + ${response.data}");
      return response;
    }on DioException catch(e){
      print("❌ Dio Error: ${e.type}");
      print("📝 Error Message: ${e.message}");
      print("📡 Request URL: ${e.requestOptions.uri}");
      print("🔍 Request Headers: ${e.requestOptions.headers}");
      print("📦 Request Data: ${e.requestOptions.data}");
      print("🔄 Response Status: ${e.response?.statusCode}");
      print("🔎 Response Data: ${e.response?.data}");

      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}activity/"),
          statusCode: 500, // Internal server error
          data: {"error": "Unknown error occurred"},
        );
      }
    }catch(e){
      throw Exception("Error $e");
    }

    return Response(
      requestOptions: RequestOptions(path: "${baseUrl}activity/"),
      statusCode: 500, // Internal server error
      data: {"error": "Unknown error occurred"},
    );
  }
  Future<Response> updateActivity(String uuid,String description, String token)async{
  Dio dio = Dio();
  try{
    final response = await dio.patch(
        "${baseUrl}activity/$uuid",
        data: {
          "description" : description
        },
        options: Options(
          headers: {
            "Authorization" : "Bearer $token"
          }
        )
    );
    print("response + ${response.data}");

    return response;
  }on DioException catch(e){
    print("❌ Dio Error: ${e.type}");
    print("📝 Error Message: ${e.message}");
    print("📡 Request URL: ${e.requestOptions.uri}");
    print("🔍 Request Headers: ${e.requestOptions.headers}");
    print("📦 Request Data: ${e.requestOptions.data}");
    print("🔄 Response Status: ${e.response?.statusCode}");
    print("🔎 Response Data: ${e.response?.data}");

    if (e.response != null) {
      return e.response!;
    } else {
      return Response(
        requestOptions: RequestOptions(path: "${baseUrl}activity/"),
        statusCode: 500, // Internal server error
        data: {"error": "Unknown error occurred"},
      );
    }
  }catch(e){
    throw Exception("Error $e");
  }

  }

  Future<Response> deleteActivity(String uuid, String token)async{
    Dio dio = Dio();
    try{
      final response = await dio.delete(
        "${baseUrl}activity/$uuid",
        options: Options(
          headers: {
            "Authorization" : "Bearer $token",
          },
        ),
      );
      print("response + ${response.data}");
      return response;
    }on DioException catch(e){
      print("❌ Dio Error: ${e.type}");
      print("📝 Error Message: ${e.message}");
      print("📡 Request URL: ${e.requestOptions.uri}");
      print("🔍 Request Headers: ${e.requestOptions.headers}");
      print("📦 Request Data: ${e.requestOptions.data}");
      print("🔄 Response Status: ${e.response?.statusCode}");
      print("🔎 Response Data: ${e.response?.data}");

      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}activity/"),
          statusCode: 500, // Internal server error
          data: {"error": "Unknown error occurred"},
        );
      }
    }catch(e){
      throw Exception("Error $e");
    }

  }

}