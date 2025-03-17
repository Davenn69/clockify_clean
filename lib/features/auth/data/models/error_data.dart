class ErrorData{
  final String message;

  ErrorData(this.message);

  Map<String, dynamic> toMap(){
    return {
      'message' : message,
    };
  }
}