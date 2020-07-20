import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/src/bloc/base_states/result_state/result_api_builder.dart';
import 'package:fluttercommerce/src/bloc/base_states/result_state/result_state.dart';
import 'package:fluttercommerce/src/bloc/my_orders/my_orders_cubit.dart';
import 'package:fluttercommerce/src/core/utils/date_time_util.dart';
import 'package:fluttercommerce/src/di/app_injector.dart';
import 'package:fluttercommerce/src/models/order_model.dart';
import 'package:fluttercommerce/src/res/app_colors.dart';
import 'package:fluttercommerce/src/res/string_constants.dart';
import 'package:fluttercommerce/src/res/text_styles.dart';
import 'package:fluttercommerce/src/ui/common/common_app_loader.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  MyOrdersCubit ordersCubit = AppInjector.get<MyOrdersCubit>();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ordersCubit.fetchOrders();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      ordersCubit.fetchNextList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConstants.myOrders),
      ),
      body: BlocBuilder<MyOrdersCubit, ResultState<List<OrderModel>>>(
        cubit: ordersCubit,
        builder: (BuildContext context, ResultState<List<OrderModel>> state) {
          return ResultStateBuilder(
            state: state,
            loadingWidget: (bool isReloading) {
              return Center(
                child: CommonAppLoader(),
              );
            },
            dataWidget: (List<OrderModel> value) {
              return orderView(value);
            },
            errorWidget: (String error) {
              return Container();
            },
          );
        },
      ),
    );
  }

  Widget orderView(List<OrderModel> orderList) {
    return ListView.builder(
      controller: controller,
      itemCount: orderList.length,
      itemBuilder: (BuildContext context, int orderListIndex) {
        return Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringsConstants.orderedOnCaps,
                                style: AppTextStyles.normal12Color81819A,
                              ),
                              Text(
                                getOrderedTime(
                                    orderList[orderListIndex].orderedAt),
                                style: AppTextStyles.medium14Black,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    ...List<Widget>.generate(
                        orderList[orderListIndex].orderItems.length,
                        (index) => orderCard(
                            orderList[orderListIndex].orderItems[index])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringsConstants.totalCaps,
                              style: AppTextStyles.normal12Color81819A,
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              "${orderList[orderListIndex].currency} ${orderList[orderListIndex].price}",
                              style: AppTextStyles.normal14Black,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${orderList[orderListIndex].orderStatus}",
                              style: AppTextStyles.normal14Color81819A,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            getOrderStatusIcon(
                                orderList[orderListIndex].orderStatus)
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )),
            (orderListIndex < orderList.length) ? Divider() : Container()
          ],
        );
      },
    );
  }

  Widget orderCard(OrderItem orderItem) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 20),
      child: Card(
          child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: orderItem.image,
                  height: 46,
                  width: 46,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderItem.name,
                      style: AppTextStyles.normal14Black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${orderItem.currency} ${orderItem.price} / ${orderItem.unit}",
                      style: AppTextStyles.normal14Color81819A,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${orderItem.noOfItems} item${orderItem.noOfItems > 1 ? "s" : ""}",
              style: AppTextStyles.normal14Color81819A,
            ),
          ],
        ),
      )),
    );
  }

  Widget getOrderStatusIcon(String orderStatus) {
    if (orderStatus == "Delivered") {
      return Icon(
        Icons.check_circle,
        color: AppColors.color5EB15A,
      );
    } else {
      return Icon(
        Icons.info,
        color: AppColors.colorFFE57F,
      );
    }
  }
}
