import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 2)
class AppSettings extends HiveObject {
  /// The saved user auth credential. Will be null or empty if there are none
  /// saved.
  @HiveField(0)
  String credentials;

  AppSettings({this.credentials});

}