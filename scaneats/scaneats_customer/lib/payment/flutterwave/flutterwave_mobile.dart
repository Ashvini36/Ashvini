import 'dart:io';
import 'dart:math';

setRef() {
  Random numRef = Random();
  int year = DateTime.now().year;
  int refNumber = numRef.nextInt(20000);
  if (Platform.isAndroid) {
    return "AndroidRef$year$refNumber";
  } else if (Platform.isIOS) {
    return "IOSRef$year$refNumber";
  } else {
    return '';
  }
}

