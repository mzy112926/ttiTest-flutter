import 'package:flutter/material.dart';
import 'package:ttitest/http_manager.dart';
import 'package:ttitest/product_dateil.dart';
import 'product_item.dart';

void main() {
  runApp(const MyApp());
}

class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  _MainListView createState() => _MainListView();
}

class _MainListView extends State<ProductListView> {
  late List<ProductItem> products = [];

  @override
  void initState() {
    super.initState();
    login();
  }

  void login() async {
    await HttpManager().login('appDevTest', 'tti2020');
    getList();
  }

  void getList() async {
    List<ProductItem> lists = await HttpManager().productLists(20) as List<ProductItem>;
    setState(() {
      products = lists;
    });
  }

  void sortList() {
    setState(() {
      products.sort((left, right) => left.name.compareTo(right.name));
    });
  }

  Widget buildCell(ProductItem product, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailView(
              sku: product.sku,
            )));
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 79,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 5, bottom: 5),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    product.name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                    width: 100,
                    child: Text(
                      '${product.price}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    )
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.black12
          )
        ],
      ),
    );
  }

  List<Widget> indexList() => List.generate(products.length, (index) {
    ProductItem item = products[index];
    return buildCell(item, context);
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'product list',
            style: TextStyle(fontSize: 18)
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                getList();
              },
              child: Container(
                padding: EdgeInsets.only(top: 18),
                child:const Text(
                  'reload',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 16),
              child: GestureDetector(
                onTap: () async {
                  sortList();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 18),
                    child:const Text(
                      'sort',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                )
              ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            ListView(scrollDirection: Axis.vertical, children: indexList())
          ),
        ),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'product list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductListView(),
    );
  }
}
