import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DbManager{
  late Box box;
  late SharedPreferences preferences;

  DbManager(){
    openBox();
  }

  openBox(){
    box = Hive.box('money');
  }
  Future deleteData(int index) async{
    await box.deleteAt(index);
  }
  Future addData(int amount,DateTime date,String description, String type) async {
    var value = {'amount': amount , 'date' : date, 'description' : description,'type' : type};
    box.add(value);
  }

  Future<Map> fetch(){
    if(box.values.isEmpty){
      return Future.value({});
    }else{
      return Future.value(box.toMap());
    }
  }

  addName(String name) async{
    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
  }

  getName() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('name');
  }

}