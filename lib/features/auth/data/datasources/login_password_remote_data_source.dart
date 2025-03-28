import 'package:dio/dio.dart';

class LoginPasswordRemoteDataSource{

  final baseUrl = "https://clocklify-api.onrender.com/api/v1/";

  LoginPasswordRemoteDataSource();

  Future<Response> fetchUserLogin(String email,  String password) async{
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 2),
        receiveTimeout: Duration(seconds: 2),
        sendTimeout: Duration(seconds: 2),
      )
    );

    try{
      Response response = await dio.post(
          "${baseUrl}user/login",
          data : {
            'email' : email,
            'password' : password
          },
        options: Options(
          method: "POST",
        ),
      );


      return response;
    }on DioException catch(e){
      if(e.response == null){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if(e.response?.statusMessage!.contains("Not Found") ?? false){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if(e.response?.statusMessage!.contains("The endpoint") ?? false){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      return e.response!;
    }catch(e){
      throw Exception("Error $e");
    }
  }

  Future<Response> registerUserData(String email, String password, String confirmPassword) async {
    Dio dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 2),
          receiveTimeout: Duration(seconds: 2),
          sendTimeout: Duration(seconds: 2),
        )
    );
    try{
      Response response = await dio.post(
          "${baseUrl}user/register",
          data: {
            'email' : email,
            'password' : password,
            'confirmPassword' : confirmPassword
          },
        options: Options(
          method: "POST"
        )
      );
      if(response.statusCode == 201){
        return response;
      }else if (response.statusCode == 404 || response.statusCode == 401 || response.statusCode == 400){
        return response;
      }else{
        throw Exception("Register failed: ${response.statusMessage}");
      }
    }on DioException catch(e){
      if(e.response == null){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if(e.response?.statusMessage!.contains("Not Found") ?? false){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if(e.response?.statusMessage!.contains("The endpoint") ?? false){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      return e.response!;
    }catch(e){
      throw Exception("This is an Error ppppppppppppppppppppp $e");
    }
  }

  Future<Response?> sendForgotPasswordLink(String email)async{
    Dio dio = Dio();

    try{
      Response response = await dio.post(
        "${baseUrl}user/forgotpassword",
        data: {
          'email' : email
        }
      );
      if(response.statusCode == 200){
        return response;
      }else if (response.statusCode == 404){
        return response;
      }else{
        throw Exception("Register failed: ${response.statusMessage}");
      }
    }on DioException catch(e){
      if(e.response == null){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if(e.response?.statusMessage!.contains("Not Found") ?? false){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if(e.response?.statusMessage!.contains("The endpoint") ?? false){
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      return e.response!;
    }catch(e){
      throw Exception("Error $e");
    }
  }

  Future<Response?> verifyEmail(String emailToken)async {
    Dio dio = Dio();
    try {
      Response response = await dio.patch(
          "${baseUrl}user/verifyemail",
          data: {
            'emailToken': emailToken
          }
      );
      if (response.statusCode == 200) {
        return response;
      }else {
        throw Exception("Register failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Response response $e");
      print("Response response ${e.message}");
      print("Response response ${e.response}");
      if (e.response == null) {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if (e.response?.statusMessage!.contains("Not Found") ?? false) {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      if (e.response?.statusMessage!.contains("The endpoint") ?? false) {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500,
          data: {"error": "Unknown error occurred"},
        );
      }

      return e.response!;
    } catch (e) {
      throw Exception("Error $e");
    }
  }

}