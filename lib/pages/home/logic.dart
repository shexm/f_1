import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'state.dart' as home;

class HomeLogic extends GetxController with GetSingleTickerProviderStateMixin{
    late TabController tabController;
    Rx<bool> canLoadMore = true.obs;
    late List<ScrollController> scrollControllerList;
    late String searchValue;
    late Future load;
    Rx<home.HomeState> state = home.HomeState(tabs:[],banner: [], goods: []).obs;
    home.HomeState get value => state.value;
    @override
    void onInit()  {
        load = loadAll();
        super.onInit();
    }
    @override
    void onClose() {
        tabController.dispose();
        for (var element in scrollControllerList) {element.dispose();}
    }
    Future loadAll() async{
        var res = await Future.wait([loadBanner(),loadGoods(),loadTabs()]);
        state.value.banner = res[0] as List<List<home.Banner>>;
        state.value.goods = res[1] as List<List<home.Goods>>;
        state.value.tabs = res[2] as List<String>;
        searchValue = '康师傅老痰酸菜牛肉面';
        tabController = TabController(length: res[2].length,vsync:this);
        scrollControllerList = List.generate(res[2].length, (index) {
            ScrollController scrollController = ScrollController();
            scrollController.addListener(() {
                if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
                    loadMore(index);
                }
            });
            return scrollController;
        });
    }
    Future<List<String>> loadTabs() async{
        await Future.delayed(const Duration(seconds: 1));
        return List.generate(6, (index) => 'tab$index');
    }
    Future<List<List<home.Banner>>> loadBanner() async{
        await Future.delayed(const Duration(seconds: 1));
        return List.generate(8, (_) => List.generate(10, (index) => home.Banner(url: 'assets/avatar.webp', title: 'Banner$index')));
    }
    void refreshData() {

    }
    Future<List<List<home.Goods>>> loadGoods() async{
        await Future.delayed(const Duration(seconds: 1));
        return List.generate(8, (_) => List.generate(8, (index) => home.Goods(price: 100, url: 'assets/avatar.webp', title: '我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是我是Goods$index')));
    }
    loadMore(index) async {
        canLoadMore.value = true;
        await Future.delayed(const Duration(seconds: 0));
        var goods = state.value.goods[index];
        if(goods.length>20){
            canLoadMore.value = false;
            // Get.showSnackbar(const GetSnackBar(duration: Duration(milliseconds: 3000), message: '没有更多了',));
            return;
        }
        var newGoods = List.generate(4, (_)=>home.Goods(price: 99, url: 'assets/avatar.webp', title: '我是新的'));
        state.value.goods[index] = [...goods,...newGoods];
        state.refresh();
    }
}
