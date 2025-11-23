part of 'gallery_cubit.dart';

@immutable
sealed class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

final class GalleryInitial extends GalleryState {}

final class LoadingInit extends GalleryState {
  List<String> lstFileName;
  LoadingInit(this.lstFileName);
}
