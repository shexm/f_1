import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class HomePage extends GetView<HomeLogic> {
  @override
  Widget build(BuildContext context) {
    Widget child = FutureBuilder(
      future: controller.load,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(),
            body: _buildTabBarView());
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            )
          );
        }
        return Container();
      }
    );
    return WillPopScope(
      child: child,
      onWillPop: () async{
        return await showDialog(
          context: context,
          builder: (context)=> AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: const Text('提示'),
            content: const Text('你确定要离开'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: const Text('确定')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                child: const Text('取消')
              )
            ],
          ));
      }
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Center(
        child: Container(
          width: 360,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.searchValue,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      bottom: TabBar(
        labelColor: Colors.red,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontSize: 18),
        indicatorColor: Colors.red,
        controller: controller.tabController,
        tabs: controller.value.tabs.map((e) => Tab(text: e)).toList(),
        isScrollable: true,
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: controller.tabController,
      children: List.generate(
        controller.value.tabs.length,
        (index) => Container(
          color: Colors.grey[300],
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 2));
              controller.refreshData();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              key: PageStorageKey<int>(index),
              controller: controller.scrollControllerList[index],
              slivers: [
                _buildTabBanner(index),
                Obx(() => _buildGoods(index)),
                Obx(() => _buildLoadMore()),
              ],
            )
          ),
        )
      )
    );
  }

  Widget _buildTabBanner(int index) {
    var banner = controller.value.banner[index];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  runSpacing: 20,
                  children: banner.map((e) => FractionallySizedBox(
                    widthFactor: 0.2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(e.url)
                              ),
                            ),
                            child: const SizedBox(
                              width: 70,
                              height: 70,
                            ),
                          )
                        ),
                        Text(
                          e.title,
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    )
                  )).toList(),
                )
              )
          )
      )
    );
  }
  Widget _buildLoadMore(){
    return SliverToBoxAdapter(
      child:Visibility(
        visible: controller.canLoadMore.value,
        child: LayoutBuilder(
          builder: (ctx,ctr)=>
            SizedBox(
              width: ctr.maxWidth,
              height: 100,
              child: const Center(child: Text('加载中...'))
            )
        )
      )
    );
  }

  Widget _buildGoods(int index) {
    var goods = controller.value.goods[index];
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, index) => GestureDetector(
              onTap: (){
                Get.toNamed('/detail?id=$index');
              },
              child: Card(
                elevation: 4,
                child: LayoutBuilder(
                  builder: (ctx, ctr) => Column(
                    children: [
                      SizedBox(
                        height: ctr.maxHeight * 0.8,
                        child: Image.asset(
                          goods[index].url,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: ctr.maxWidth * 0.9,
                        height: ctr.maxHeight * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goods[index].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '¥${goods[index].price}',
                              style: const TextStyle(
                                color: Colors.red, fontSize: 20
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                )
              )
            ),
            childCount: goods.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
            mainAxisSpacing: 8,
          ),
        ));
  }
}
