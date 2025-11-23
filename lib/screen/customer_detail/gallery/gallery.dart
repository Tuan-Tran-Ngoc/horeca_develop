import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/screen/customer_detail/gallery/cubit/gallery_cubit.dart';
import 'package:open_filex/open_filex.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryCubit()..init(),
      child: const GalleryBody(),
    );
  }
}

class GalleryBody extends StatefulWidget {
  const GalleryBody({super.key});

  @override
  State<GalleryBody> createState() => _GalleryBodyState();
}

class _GalleryBodyState extends State<GalleryBody> {
  var _openResult = 'Unknown';

  Future<void> openFile(String pathFile) async {
    _openFile(pathFile);
  }

  // ignore: unused_element
  _openFile(String pathFile) async {
    final result = await OpenFilex.open(pathFile);
    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> lstFileName = [];

    Widget getFileIcon(String fileName) {
      String extension = fileName.split('.').last.toLowerCase();

      switch (extension) {
        case 'mp4':
          return Image.asset('assets/icons_app/mp4.png');
        case 'pdf':
          return Image.asset('assets/icons_app/pdf.png');
        case 'png':
          return Image.asset('assets/icons_app/png-icon.png');
        case 'jpg':
          return Image.asset('assets/icons_app/jpg-icon.png');
        default:
          return Image.asset('assets/icons_app/default.png');
      }
    }

    return BlocConsumer<GalleryCubit, GalleryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingInit) {
          lstFileName = state.lstFileName;
        }
        return Container(
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 6,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 30,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(lstFileName.length, (index) {
              return Center(
                child: InkWell(
                  onTap: () {
                    openFile(lstFileName[index]);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 60,
                        child: getFileIcon(lstFileName[index]),
                      ),
                      Text(
                        lstFileName[index].split('/').last,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
