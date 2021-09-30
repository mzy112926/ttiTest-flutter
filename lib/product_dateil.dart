import 'dart:ffi';

import 'package:flutter/material.dart';
import 'product_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'http_manager.dart';

class ProductDetailView extends StatefulWidget {
  final String sku;

  ProductDetailView(
      {required this.sku});

  @override
  _MainDetailView createState() => _MainDetailView();
}

class _MainDetailView extends State<ProductDetailView> {
  ProductItem? product;
  Icon? buttonIcon;

  @override
  void initState() {
    super.initState();
    buttonStatus();
    getDetail();
  }

  void getDetail() async {
    ProductItem p = await HttpManager().productDetail(widget.sku) as ProductItem;
    setState(() {
      product = p;
    });
  }

  saveBookmarkStatus() async {
    bool status = await getBookmarkStatus();
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('bookmarked' + widget.sku, !status);
  }

  Future<bool> getBookmarkStatus() async {
    bool status;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('bookmarked' + widget.sku) ?? false;
    return status;
  }

  void buttonStatus() async {
    bool status = await getBookmarkStatus();
    buttonIcon = status ? Icon(Icons.favorite) : Icon(Icons.favorite_border);
  }

  void buttonStatusChange() async {
    await saveBookmarkStatus();
    setState(() {
      buttonStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
           'product detail',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                  child: Text(
                      product?.name ?? '',
                      textAlign: TextAlign.left,
                      maxLines: 10,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      )
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Text(
                      'price: ${product?.price ?? 0}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16
                      )
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Text(
                      'create: ${product?.createdat ?? ''}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 16
                      )
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Text(
                      'update: ${product?.updatedat ?? ''}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 16
                      )
                  )
              ),
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: IconButton(
                  icon: buttonIcon ?? Icon(Icons.favorite_border),
                  onPressed: () { buttonStatusChange(); },
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }
}