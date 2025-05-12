import 'package:equatable/equatable.dart';

import '../../Model/otoStore/otoStoreModel.dart';

abstract class OtoStoreState extends Equatable {
  const OtoStoreState();

  @override
  List<Object?> get props => [];
}

class OtoStoreInitial extends OtoStoreState {}

class OtoStoreLoading extends OtoStoreState {}

class OtoStoreSuccess extends OtoStoreState {
  const OtoStoreSuccess([this.meeting=const []]);

  final List<OtoStoreModel> meeting;

  @override
  List<Object> get props => [meeting];
}

class OtoStoreError extends OtoStoreState {
  final String errorMessage;
  const OtoStoreError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
class OtoStorePaginated extends OtoStoreState {
  final List<OtoStoreModel> oto;
  final bool hasReachedMax;

  const OtoStorePaginated({
    required this.oto,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [oto, hasReachedMax];
}
class OtoStoreCreateError extends OtoStoreState {
  final String errorMessage;

  const OtoStoreCreateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
class OtoStoreEditError extends OtoStoreState {
  final String errorMessage;

  const OtoStoreEditError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
class OtoStoreDeleteError extends OtoStoreState {
  final String errorMessage;

  const OtoStoreDeleteError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
class OtoStoreCreateSuccessLoading extends OtoStoreState {}

class OtoStoreCreateSuccess extends OtoStoreState {
  const OtoStoreCreateSuccess();
  @override
  List<Object> get props => [];
}
