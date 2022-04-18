class DetailState {
  String title;
  double price;
  List<String> imgList;
  GoodsInfo info;
  DetailState({required this.title, required this.price,required this.imgList,required this.info});
}
class GoodsInfo {
  List<String> imgList;
  String text;
  GoodsInfo({required this.imgList,required this.text});
}
class ShoppingCart {
  String title;
  double price;
  String url;
  int count;
  ShoppingCart({required this.title, required this.url,  required this.price, required this.count});
}