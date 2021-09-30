
import 'package:dio/dio.dart';
import 'package:ttitest/product_item.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class HttpManager {
  String baseUrl = 'https://milwaukee.dtndev.com/rest/default/V1/';
  final Dio _dio = Dio();

  Future<bool> login (
      String username, String password) async {
    await _dio.post(baseUrl + "integration/admin/token", data: Map<String, dynamic>.from({
      'username': username,
      'password': password,
    })).then((value) => {
      saveUserToken(value.toString()),
      true
    });
    return false;
  }

  saveUserToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("userToken", token);
  }

  Future<String> getToken() async {
    String token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("userToken") ?? '';
    return token;
  }

  Future<List> productLists (int pageSize) async {
    String token = await getToken() as String;
    Options options = Options(headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    Map<String, dynamic> map = {};
    map["searchCriteria[pageSize]"] = pageSize;
    Response response = await _dio.get(baseUrl + "products", queryParameters: map,
      options: options);
    Map <String, dynamic> data = response.data;
    List items = data["items"];
    List<ProductItem> datas = [];
    for (var element in items) {datas.add(ProductItem.fromJson(element)); }
    return datas;
  }

  Future<ProductItem> productDetail (String sku) async {
    String token = await getToken() as String;
    Options options = Options(headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    Response response = await _dio.get(baseUrl + "products/" + sku, options: options);
    Map <String, dynamic> data = response.data;
    return ProductItem.fromJson(data);
  }
}
