// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserinfoAdapter extends TypeAdapter<Userinfo> {
  @override
  final int typeId=0;
  @override
  Userinfo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Userinfo(
      userid: fields[0] as String,
      usertype: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Userinfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userid)
      ..writeByte(1)
      ..write(obj.usertype);
  }
}
