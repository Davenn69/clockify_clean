String? validateEmail(String? value){
  if(value == null || value.isEmpty){
    return 'Email cannot be empty';
  }

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if(!emailRegex.hasMatch(value)){
    return "Enter a valid email address";
  }

  return null;
}