import 'package:room_repository/device_repository.dart';

class DeviceConverter{

  String convertList2Dispositivos(List<String> list){
    var str = StringBuffer();
    list.forEach((device) {
      str.write(device);
      str.write(":");
    });

    return str.toString();
  }

  List<String> convertDispositivos2List(String devices){
    return devices.split(":");
  }
}