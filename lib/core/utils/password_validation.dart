String? validatePassword(String? value){
  if(value == null || value.isEmpty){
    return 'Password cannot be empty';
  }
  return null;
}

String? validateConfirmPassword(String? value, String? compareValue){
  if(value == null || value.isEmpty){
    return 'Password cannot be empty';
  }

  if(value.toLowerCase() != compareValue?.toLowerCase()){
    return "Password must be the same";
  }

  return null;
}