import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryInitial());
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(Session.username.toString()) ?? '';
    var databasesPath = await getDatabasesPath();
    String pathFolder = '$databasesPath/$username/lib/';

    final directory = Directory(pathFolder);
    final files = directory.listSync();

    List<String> lstFileName = [];
    for (var file in files) {
      if (file is File) {
        print('filePath: ${file.path}');
        lstFileName.add(file.path);
      }
    }
    emit(LoadingInit(lstFileName));
  }
}
