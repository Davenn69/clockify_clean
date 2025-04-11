formatHistory(String data){
  if(data.length>20){
    return "${data.substring(0, 17)}...";
  }

  return data;
}