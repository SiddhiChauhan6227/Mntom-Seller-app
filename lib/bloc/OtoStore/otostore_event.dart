import "package:equatable/equatable.dart";

import "../../Model/otoStore/otoStoreModel.dart";


abstract class OtoStoreEvent extends Equatable {
  const OtoStoreEvent();
  @override
  List<Object?> get props => [];
}

class CreateOtoStore extends OtoStoreEvent {
  final OtoStoreModel oto;

  const CreateOtoStore(this.oto);

  @override
  List<Object?> get props => [oto];
}

class OtoStoreLists extends OtoStoreEvent {
  final int sellerId;
  const OtoStoreLists(this.sellerId);

  @override
  List<Object?> get props => [sellerId];
}

class AddOtoStore extends OtoStoreEvent {
  final OtoStoreModel oto;

  const AddOtoStore(this.oto);

  @override
  List<Object?> get props => [oto];
}

class OtoStoreUpdateds extends OtoStoreEvent {
  final OtoStoreModel oto;

  const OtoStoreUpdateds(this.oto);

  @override
  List<Object> get props => [oto];

}

class DeleteOtoStore extends OtoStoreEvent {
  final int oto;

  const DeleteOtoStore(this.oto);

  @override
  List<Object?> get props => [oto];
}

class SearchOtoStore extends OtoStoreEvent {
  final String searchQuery;

  const SearchOtoStore(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

class LoadMoreOtoStore extends OtoStoreEvent {
  final String searchQuery;
  const LoadMoreOtoStore(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}
