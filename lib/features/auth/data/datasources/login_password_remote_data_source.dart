import 'package:dio/dio.dart';

class LoginPasswordRemoteDataSource{
  // final baseUrl = "https://light-master-eagle.ngrok-free.app/api/v1/";
  final baseUrl = "http://192.168.1.8:3000/api/v1/";

  LoginPasswordRemoteDataSource();

  Future<Response> fetchUserLogin(String email,  String password) async{
    Dio dio = Dio();

    print('email + $email');
    print('password + $password');
    print("${baseUrl}user/login");

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

      print("Data + ${response.data}");

      return response;
    }on DioException catch(e){
      print("Dio Error: ${e.message}");
      print("Response Data: ${e.response?.data}");
      print("Response Status: ${e.response?.statusCode}");

      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: "${baseUrl}user/login"),
          statusCode: 500, // Internal server error
          data: {"error": "Unknown error occurred"},
        );
      }
    }catch(e){
      throw Exception("Error $e");
    }
  }

  Future<Response> registerUserData(String email, String password) async {
    Dio dio = Dio();
    print("${baseUrl}user/register");
    print('password + $password');
    print("${baseUrl}user/login");
    try{
      print("hello");
      Response response = await dio.post(
          "${baseUrl}user/register",
          data: {
            'email' : email,
            'password' : password,
          },
        options: Options(
          method: "POST"
        )
      );
      print(response.statusCode);
      print("register + ${response.data}");
      if(response.statusCode == 201){
        return response;
      }else if (response.statusCode == 404 || response.statusCode == 401){
        return response;
      }else{
        throw Exception("Register failed: ${response.statusMessage}");
      }
    }on DioError catch(dioError){
      print("DioError caught!");
      print("Type: ${dioError.type}");
      print("Message: ${dioError.message}");

      throw Exception("DioError: ${dioError.message}");
    }catch(e){
      print("sampai sini");
      throw Exception("This is an Error ppppppppppppppppppppp $e");
    }
  }

}