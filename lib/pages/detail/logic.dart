import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'state.dart';

class DetailLogic extends GetxController with GetSingleTickerProviderStateMixin{
  String? id;
  late String userId;
  Rx<bool> isExpand = false.obs;
  GlobalKey key = GlobalKey();
  late Offset end;
  late Offset start;
  Rx<int> buyCount = 0.obs;
  late ScrollController scrollController;
  // late Future load;
  late AnimationController bottomSheetController;
  Rx<bool> showColoredAppBar = false.obs;
  List<ShoppingCart> shoppingCart = [];
  Rx<DetailState> state = DetailState(title:'',price: 0, imgList: [], info: GoodsInfo(imgList: [],text: '')).obs;
  DetailState get value => state.value;
  DetailLogic(this.id);
  @override
  void onInit() {
    userId = SpUtil.getString('userId')!;
    bottomSheetController = BottomSheet.createAnimationController(this);
    scrollController = ScrollController()..addListener(() {
      if(scrollController.position.pixels > 60){
        showColoredAppBar.value = true;
      } else {
        showColoredAppBar.value = false;
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      end = (key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    });

    // load = loadData();
    loadData();
    loadShoppingCart();
    super.onInit();
  }
  void loadShoppingCart() async{
    if(userId != ''){
      await Future.delayed(const Duration(microseconds: 300));
      shoppingCart = [ShoppingCart(title: '一件商品',url:'assets/avatar.webp',price:10.00,count:1)];
    }
  }
  void pay() async{
    if(userId==''){
      var data = await Get.toNamed('/login');
      if(data!=null){
        userId = data;
        loadShoppingCart();
      }
    }
  }
  void toggleExpand(){
    isExpand.value = !isExpand.value;
  }
  void setBuyCount(int value)async {
    if(userId==''){
      var data = await Get.toNamed('/login');
      if(data!=null){
        userId = data;
        loadShoppingCart();
      }
      return;
    }
    buyCount.value = value;
  }
  void reduceBuyCount() {
    buyCount.value --;
  }
  Future increaseBuyCount() async{
    await Future.delayed(const Duration(milliseconds: 400));
    buyCount.value ++;
  }
  Future loadData()async {
    await Future.delayed(const Duration(milliseconds: 300));
    value.title = '我是我是我是我是我是我是我是我是我是我是我是我是title';
    value.price = 10.00;
    value.imgList = ['assets/avatar.webp','assets/avatar.webp',];
    value.info = GoodsInfo(imgList: ['assets/avatar.webp','assets/avatar.webp'],text: '我是商品信息12345');
    state.refresh();
  }
}
