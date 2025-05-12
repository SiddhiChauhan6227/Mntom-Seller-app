import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../Helper/ApiBaseHelper.dart';
import '../../Model/otoStore/otoStoreModel.dart';
import '../../Repository/otoRepository.dart';
import '../../Widget/snackbar.dart';
import 'otostore_event.dart';
import 'otostore_state.dart';

class OtoStoreBloc extends Bloc<OtoStoreEvent, OtoStoreState> {
  int _offset = 0; // Start with the initial offset
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasReachedMax = false;

  OtoStoreBloc() : super(OtoStoreInitial()) {
    on<OtoStoreLists>(_onListOfOtoStore);
    on<AddOtoStore>(_onAddOtoStore);
    on<SearchOtoStore>(_onSearchOtoStore);
    on<LoadMoreOtoStore>(_onLoadMoreOtoStore);
  }

  Future<void> _onListOfOtoStore(
      OtoStoreLists event, Emitter<OtoStoreState> emit) async {
    try {
      _offset = 0; // Reset offset for the initial load
      _hasReachedMax = false;
      emit(OtoStoreLoading());
      List<OtoStoreModel> oto = [];
      Map<String, dynamic> result = await OtoStoreRepo()
          .otoStoreList(limit: _limit, offset: _offset, search: '',sellerIds: event.sellerId);
      oto = List<OtoStoreModel>.from(result['data']
          .map((projectData) => OtoStoreModel.fromJson(projectData)));

      // _offset += _limit;
      // _hasReachedMax = oto.length >= (int.tryParse(result['total'].toString()) ?? 0);
      if (result['error'] == false) {
        emit(OtoStorePaginated(oto: oto, hasReachedMax: _hasReachedMax));
      }
      if (result['error'] == true) {
        emit((OtoStoreError(result['message'])));
      }
    } on ApiException catch (e) {
      emit(OtoStoreError("Error: $e"));
    }
  }

  Future<void> _onAddOtoStore(
      AddOtoStore event, Emitter<OtoStoreState> emit) async {
    emit(OtoStoreCreateSuccessLoading());
    var oto = event.oto;
    try {
      Map<String, dynamic> result = await OtoStoreRepo().createOtoStore(
          sellerId:int.tryParse(oto.sellerId?.toString() ?? '') ?? 0,
          storeName: oto.storeName ?? "",
          warehouseCity: oto.warehouseCity ?? "",
          warehouseCode: int.tryParse(oto.warehouseCode?.toString() ?? '') ?? 0
      );


      if (result['error'] == false) {
        emit(const OtoStoreCreateSuccess());

      }
      if (result['error'] == true) {
        emit((OtoStoreCreateError(result['message'])));

      }
    } catch (e) {
      print('Error while creating OTO store: $e');
    }
  }

  Future<void> _onSearchOtoStore(
      SearchOtoStore event, Emitter<OtoStoreState> emit) async {
    try {
      List<OtoStoreModel> meeting = [];
      _offset = 0;
      emit(OtoStoreLoading());

      Map<String, dynamic> result = await OtoStoreRepo().otoStoreList(
          limit: _limit, offset: _offset, search: event.searchQuery);

      if (result['error'] == false) {
        meeting = List<OtoStoreModel>.from(result['data']
            .map((projectData) =>OtoStoreModel.fromJson(projectData)));
        bool hasReachedMax = meeting.length >= result['total'];

        emit(OtoStorePaginated(oto: meeting, hasReachedMax: hasReachedMax));
      } else if (result['error'] == true) {
        emit(OtoStoreError(result['message']));
      }
    } on ApiException catch (e) {
      emit(OtoStoreError("Error: $e"));
    }
  }

  Future<void> _onLoadMoreOtoStore(
      LoadMoreOtoStore event, Emitter<OtoStoreState> emit) async {
    if (state is OtoStorePaginated && !_hasReachedMax && !_isLoading) {
      _isLoading = true; // Prevent concurrent API calls
      try {
        final currentState = state as OtoStorePaginated;
        final updatedMeeting = List<OtoStoreModel>.from(currentState.oto);

        // Fetch additional meetings
        Map<String, dynamic> result = await OtoStoreRepo().otoStoreList(
          limit: _limit,
          offset: _offset,
          search: event.searchQuery,
        );

        final additionalMeeting = List<OtoStoreModel>.from(result['data']
            .map((projectData) => OtoStoreModel.fromJson(projectData)));

        if (additionalMeeting.isEmpty) {
          _hasReachedMax = true;
        } else {
          _offset += _limit; // Increment the offset consistently
          updatedMeeting.addAll(additionalMeeting);
        }

        // Determine if all data is loaded
        // _hasReachedMax = updatedMeeting.length + additionalMeeting.length >= result['total'];

        // Add the new data to the existing list
        // updatedMeeting.addAll(additionalMeeting);

        if (result['error'] == false) {
          emit(OtoStorePaginated(
            oto: updatedMeeting,
            hasReachedMax: _hasReachedMax,
          ));
        } else {
          emit(OtoStoreError(result['message']));
        }
      } on ApiException catch (e) {
        emit(OtoStoreError("Error: $e"));
      } finally {
        _isLoading = false; // Reset the loading flag
      }
    }
  }
}
