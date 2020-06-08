import 'package:hive/hive.dart';

part 'userdata.g.dart';

@HiveType(typeId: 0)
class Userinfo{
  @HiveField(0)
  String userid;
  @HiveField(1)
  String usertype;
  

  Userinfo({this.userid,this.usertype});
}