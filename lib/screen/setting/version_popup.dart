import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/contants/contants.dart';
import 'package:horeca/screen/setting/cubit/version_popup_cubit.dart';
import 'package:horeca/themes/app_color.dart';
import 'package:horeca/widgets/button.dart';
import 'package:horeca/widgets/datatable.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horeca_service/sqflite_database/dto/version_dto.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VersionPopup extends StatelessWidget {
  final double width;
  final double height;

  const VersionPopup({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VersionPopupCubit()..init(),
      child: VersionPopupBody(width: width, height: height),
    );
  }
}

class VersionPopupBody extends StatefulWidget {
  final double width;
  final double height;
  const VersionPopupBody({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<VersionPopupBody> createState() =>
      _VersionPopupBodyState(width: 350, height: 200);
}

class _VersionPopupBodyState extends State<VersionPopupBody> {
  final ValueNotifier<int> _selectIndex = ValueNotifier(0);
  final DatatableController _datatableController = DatatableController(-1);
  final double width;
  final double height;

  _VersionPopupBodyState({
    required this.width,
    required this.height,
  });

  VersionDto versionInfo = VersionDto();

  bool isLoadingScreen = false;
  bool isLoadingItems = false;
  bool _isDownloading = false;
  double _progressValue = 0.0;

  List<Shift> lstShift = [];
  String filePath = '';

  @override
  void initState() {
    super.initState();
  }

  _localInstallApk(String pathFile) async {
    await InstallPlugin.installApk(pathFile);
  }

  _networkInstallApk() async {
    var status = await Permission.requestInstallPackages.status;
    if (status.isDenied) {
      status = await Permission.requestInstallPackages.request();
    }

    if (status.isDenied) {
      return;
    }

    if (_progressValue != 0 && _progressValue < 1) {
      return;
    }

    setState(() {
      _isDownloading = true;
      _progressValue = 0.0;
    });

    var appDocDir = await getTemporaryDirectory();
    String savePath = "${appDocDir.path}/app_release.apk";
    String fileUrl = versionInfo.urlDownload ?? '';

    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      setState(() {
        _progressValue = count / total;
      });
    });

    await _localInstallApk(savePath);

    setState(() {
      _isDownloading = false;
    });
  }

  Widget dialogContent(BuildContext context) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    return Container(
      color: Colors.white,
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppColor.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: const Color.fromRGBO(232, 40, 37, 1),
                  height: Contants.heightHeader,
                  child: Center(
                    child: Text(
                      multiLang.upgradeAppInfo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        multiLang.currentVersion,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        versionInfo.versionCurrent ?? '',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        multiLang.newVersion,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        versionInfo.versionApp ?? '',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isDownloading) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: LinearProgressIndicator(value: _progressValue),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Download Progress: ${(_progressValue * 100).toStringAsFixed(0)}%',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                      if (!_isDownloading)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
                          child: AppButton(
                            backgroundColor: AppColor.mainAppColor,
                            height: Contants.heightButton,
                            title: multiLang.update,
                            enabled: !(versionInfo.versionCurrent ==
                                versionInfo.versionApp),
                            onPress: () async {
                              await _networkInstallApk();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VersionPopupCubit, VersionPopupState>(
      listener: (context, state) {
        if (state is LoadingInitVersionSuccess) {
          versionInfo = state.versionInfo;
        }

        if (state is UpgradeVersionAppSuccess) {
          String filePath = state.filePath;
        }
      },
      builder: (context, state) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        );
      },
    );
  }
}
