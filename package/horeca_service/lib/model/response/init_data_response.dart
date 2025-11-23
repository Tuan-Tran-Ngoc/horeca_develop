import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'init_data_response.g.dart';

@JsonSerializable()
class InitDataResponse extends Equatable {
  @JsonKey(name: 'masterUrlFile')
  final String? masterUrlFile;
  @JsonKey(name: 'baUrlFile')
  final String? baUrlFile;
  @JsonKey(name: 'dateCreateFile')
  final String? dateCreateFile;
  const InitDataResponse(
      this.masterUrlFile, this.baUrlFile, this.dateCreateFile);

  factory InitDataResponse.fromJson(Map<String, dynamic> json) =>
      _$InitDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InitDataResponseToJson(this);

  @override
  List<Object?> get props => [masterUrlFile, baUrlFile, dateCreateFile];
}
