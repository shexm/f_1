import 'package:flutter/cupertino.dart';

class HomeState {
  List<String> tabs;
  List<List<Banner>> banner;
  List<List<Goods>> goods;
  HomeState({required this.tabs, required this.banner, required this.goods});
}
class Banner {
  String url;
  String title;
  Banner({required this.url,required this.title});
}
class Goods {
  String url;
  String title;
  double price;
  Goods({required this.url,required this.title,required this.price});
}
