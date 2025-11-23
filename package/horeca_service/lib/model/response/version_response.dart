import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_response.g.dart';

@JsonSerializable()
class VersionResponse extends Equatable {
  @JsonKey(name: 'masterUrlFile')
  final String? masterUrlFile;
  @JsonKey(name: 'baUrlFile')
  final String? baUrlFile;
  @JsonKey(name: 'dateCreateFile')
  final String? dateCreateFile;
  @JsonKey(name: 'version')
  final String? version;

  const VersionResponse(
      this.masterUrlFile, this.baUrlFile, this.dateCreateFile, this.version);

  factory VersionResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VersionResponseToJson(this);

  @override
  List<Object?> get props =>
      [masterUrlFile, baUrlFile, dateCreateFile, version];
}
