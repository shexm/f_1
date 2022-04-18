import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'logic.dart';
import 'package:f_1/widgets/RedDot/view.dart';

class DetailPage extends GetView<DetailLogic> {
  Widget _buildSwiper(width) {
    return SizedBox(
      width: width,
      height: 300,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          if(controller.value.imgList.isEmpty){ // 动态生成swiper布局过程中swiper会闪动，先用Container占位
            return Container();
          }
          return Image.asset(controller.value.imgList[index],fit: BoxFit.fill,);
        },
        itemCount: controller.value.imgList.isEmpty?1:controller.value.imgList.length,
        pagination: controller.value.imgList.isEmpty? null :const SwiperPagination(),
        // control: const SwiperControl(),
      ),
    );
  }
  Widget _buildDetail(width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '¥${controller.value.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 25,
                    ),
                  ),
                  IndexedStack(
                      index: controller.buyCount.value == 0? 0 : 1,
                      children:[
                        SizedBox(
                            width: 180,
                            height: 60,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 4),
                                child: Builder(
                                  builder: (context){
                                    return TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        controller.setBuyCount(1);
                                        if(controller.userId==''){
                                          return;
                                        }
                                        OverlayEntry? _overlay = OverlayEntry(builder: (_){
                                          RenderBox box = context.findRenderObject() as RenderBox;
                                          var offset = box.localToGlobal(Offset.zero);
                                          return RedDotPage(startPosition: offset, endPosition: controller.end);
                                        });
                                        Overlay.of(context)?.insert(_overlay);
                                        Future.delayed(const Duration(milliseconds: 400),(){
                                          _overlay?.remove();
                                          _overlay = null;
                                        });

                                      },
                                      child: const Text('加入购物车', style: TextStyle(color: Colors.white),),
                                    );
                                  },
                                )
                            )
                        ),
                        SizedBox(
                          width: 180,
                          height: 60,
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.end,
                            direction: Axis.horizontal,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.red,width: 2),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    )
                                ),
                                onPressed: (){
                                  controller.reduceBuyCount();
                                },
                                child: const Text('-',style: TextStyle(color: Colors.red,fontSize: 20)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('${controller.buyCount.value}'),
                              ),
                              Builder(builder: (context){
                                return TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.red
                                  ),
                                  onPressed: (){
                                    OverlayEntry? _overlay = OverlayEntry(builder: (_){
                                      RenderBox box = context.findRenderObject() as RenderBox;
                                      var offset = box.localToGlobal(Offset.zero);
                                      return RedDotPage(startPosition: offset, endPosition: controller.end);
                                    });
                                    Overlay.of(context)?.insert(_overlay);
                                    Future.delayed(const Duration(milliseconds: 400),(){
                                      _overlay?.remove();
                                      _overlay = null;
                                    });
                                    controller.increaseBuyCount();
                                  },
                                  child: const Text('+',style: TextStyle(color: Colors.white,fontSize: 20),),
                                );
                              })
                            ],
                          ),
                        )
                      ]
                  )
                ],
              ),
            )
          ),
          SizedBox(
            width: width,
            child: Text(controller.value.title,style: const TextStyle(
                fontSize: 20
            ),),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 10,
          ),
          SizedBox(
              width: width,
              child: const Padding(
                padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                child: Text(
                    '商品信息',
                    style: TextStyle(
                        fontSize: 16
                    )
                ),
              )
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          controller.isExpand.value? Wrap(
              children: controller.value.imgList.map(
                      (e) => Image.asset(e,fit: BoxFit.cover,width: width)
              ).toList()
          ):
          SizedBox(
            width: width,
            height: 400,
            child: Wrap(
              clipBehavior: Clip.antiAlias,
              children: controller.value.imgList.map(
                (e) => Image.asset(e,fit: BoxFit.cover,width: width)
              ).toList()
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAppBar(width){
    return Positioned(
        top: 0,
        child: SizedBox(
          width: width,
          height: 80,
          child: AnimatedCrossFade(
              firstChild: AppBar( // 透明的AppBar
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: const BackButton(),
                title: const Center(child:Text('商品详情')),
                actions: const [
                  Icon(Icons.share)
                ],
              ),
              secondChild: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: const BackButton(),
                title: const Center(child:Text('商品详情')),
                actions: const [
                  Icon(Icons.share)
                ],
              ),
              duration: const Duration(milliseconds: 400),
              crossFadeState: controller.showColoredAppBar.value?CrossFadeState.showSecond:CrossFadeState.showFirst
          ),
        )
    );
  }
  Widget _buildBottom(width){
    return Positioned(
        bottom: 0,
        child: SizedBox(
          width: width,
          height: 60,
          child: Flex(
            direction: Axis.horizontal,
            children:  [
              Builder(
                builder: (context)=>GestureDetector(
                  onTap: (){

                  },
                  child:SizedBox(
                    width: width*0.3,
                    height: 60,
                    child: ColoredBox(
                      color: Colors.white,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Icon(Icons.shopping_cart,key:controller.key),
                          if(controller.buyCount > 0) Positioned(
                            top: 10,
                            right: 40,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text('${controller.buyCount}',style: const TextStyle(color: Colors.white),),
                              )
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  // if(controller.userId==''){
                  //   Get.toNamed('/login');
                  //   return;
                  // }
                  controller.pay();
                },
                child: SizedBox(
                  width: width*0.7,
                  height: 60,
                  child: const ColoredBox(
                      color: Colors.red,
                      child: Center(
                        child: Text('去支付',style: TextStyle(color: Colors.white,fontSize: 20),),
                      )

                  ),
                ),
              )
            ],
          )
        )
    );
  }
  Widget _buildExpand(width){
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: SizedBox(
        width: width,
        height: 60,
        child: GestureDetector(
          onTap: (){
            controller.toggleExpand();
          },
          child: Center(
            child: Text(controller.isExpand.value?'收起':'展开'),
          ),
        )
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
              width: width,
              height: height,
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                        children: [
                          _buildSwiper(width),
                          _buildDetail(width),
                          _buildExpand(width)
                        ],
                    ),
                  )
                ],
              )
            ),
          ),
          _buildAppBar(width),
          _buildBottom(width)

        ],
      )),
    );
  }
}
