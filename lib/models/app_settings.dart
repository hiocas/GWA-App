import 'package:flutter/cupertino.dart';
import 'package:gwa_app/models/audio_launch_options.dart';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 2)
class AppSettings extends HiveObject {
  /// The saved user auth credential. Will be null or empty if there are none
  /// saved.
  @HiveField(0)
  String credentials;

  /// The saved user's audio launch options.
  @HiveField(1)
  AudioLaunchOptions audioLaunchOptions;

  @HiveField(2)
  bool firstTime;

  @HiveField(3)
  bool miniButtons;

  AppSettings({
    this.credentials,
    this.audioLaunchOptions,
    this.firstTime,
    @required this.miniButtons,
  });
}
