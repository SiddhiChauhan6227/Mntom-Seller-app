import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/parameterString.dart';

class OtoStoreRepo {
  Future<Map<String, dynamic>> otoStoreList(
      {int? limit, int? offset, String? search = "", int? sellerIds}) async {
    try {
      print("dfgvhbjkm,l");
      Map<String, dynamic> body = {SellerId: sellerIds.toString()};

      // if (limit != null) {
      //   body["limit"] = limit;
      // }
      // if (offset != null) {
      //   body["offset"] = offset;
      // }
      final response = await ApiBaseHelper().postAPICall(getOtoStoreApi, body);
      print("Printing response field types:");
      if (response.containsKey('data') && response['data'] is List) {
        for (var i = 0; i < response['data'].length; i++) {
          print("Item $i:");
          final item = response['data'][i];
        }
      } else {
        print("Response doesn't contain 'data' as a List.");
      }

      return response;
    } catch (error) {
      print("=======Error ${error.toString()}");
      throw Exception('Error occurred');
    }
  }

  Future<Map<String, dynamic>> createOtoStore({
    required int sellerId,
    required String storeName,
    required int warehouseCode,
    required String warehouseCity,
  }) async {
    try {
        print("jkbsgljkdl ${sellerId.runtimeType} ${warehouseCity.runtimeType} ${warehouseCode.runtimeType} ${storeName.runtimeType}");
      Map<String, dynamic> body = {
        "seller_id": sellerId.toString(),
        "warehouse_code": warehouseCode.toString(),
        "store_name": storeName,
        "warehouse_city": warehouseCity,
      };

      print("Creating Oto Store with body: $body");

      final response = await ApiBaseHelper().postAPICall(addOtoStoreApi, body);
      return response;
    } catch (error) {
      print("======= Error ${error.toString()}");
      throw Exception('Error occurred while creating oto store');
    }
  }
}
