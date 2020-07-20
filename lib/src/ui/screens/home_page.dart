import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/src/bloc/base_states/result_state/result_api_builder.dart';
import 'package:fluttercommerce/src/bloc/base_states/result_state/result_state.dart';
import 'package:fluttercommerce/src/bloc/home_page/home_page_cubit.dart';
import 'package:fluttercommerce/src/di/app_injector.dart';
import 'package:fluttercommerce/src/models/product_model.dart';
import 'package:fluttercommerce/src/res/string_constants.dart';
import 'package:fluttercommerce/src/res/text_styles.dart';
import 'package:fluttercommerce/src/routes/router.gr.dart';
import 'package:fluttercommerce/src/ui/common/action_text.dart';
import 'package:fluttercommerce/src/ui/common/product_card.dart';
import 'package:shimmer/shimmer.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  ProductDataCubit dealsDayCubit =
      AppInjector.get<ProductDataCubit>(instanceName: AppInjector.dealOfTheDay);
  ProductDataCubit topProductsCubit =
      AppInjector.get<ProductDataCubit>(instanceName: AppInjector.topProducts);
  ProductDataCubit onSaleCubit =
      AppInjector.get<ProductDataCubit>(instanceName: AppInjector.onSale);

  @override
  void initState() {
    fetchProductData();
    super.initState();
  }

  fetchProductData() async {
    dealsDayCubit.fetchProductData(ProductData.DealOfTheDay);
    topProductsCubit.fetchProductData(ProductData.OnSale);
    onSaleCubit.fetchProductData(ProductData.TopProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          StringsConstants.products,
          style: AppTextStyles.medium20Black,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed(Router.allProductListScreen);
          },
          label: Text(
            StringsConstants.viewAllProducts,
            style: AppTextStyles.medium14White,
          )),
      body: RefreshIndicator(
        onRefresh: () => fetchProductData(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              productDataBuilder(dealsDayCubit, StringsConstants.dealOfTheDay),
              productDataBuilder(onSaleCubit, StringsConstants.onSale),
              productDataBuilder(
                  topProductsCubit, StringsConstants.topProducts),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget productDataBuilder(Cubit cubit, String title) {
    return BlocBuilder<ProductDataCubit, ResultState<List<ProductModel>>>(
      cubit: cubit,
      builder: (BuildContext context, ResultState<List<ProductModel>> state) {
        return ResultStateBuilder(
          state: state,
          errorWidget: (String error) => Column(
            children: <Widget>[
              Center(child: Text(error)),
            ],
          ),
          dataWidget: (List<ProductModel> value) {
            return productsGrids(title, value);
          },
          loadingWidget: (bool isReloading) => productLoader(),
        );
      },
    );
  }

  productLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 10),
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          children: List.generate(
            6,
            (index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Container(
                          height: 100,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 20,
                            width: 50,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 20,
                            width: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 20,
                            width: 50,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget productsGrids(String title, List<ProductModel> products) {
    if (products == null) return Container();
    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: AppTextStyles.medium20Color20203E,
              ),
              Container(
                  margin: EdgeInsets.only(right: 16),
                  child: ActionText(
                    StringsConstants.viewAllCaps,
                    onTap: () {
                      String condition;
                      if (title == StringsConstants.dealOfTheDay) {
                        condition = "deal_of_the_day";
                      } else if (title == StringsConstants.topProducts) {
                        condition = "top_products";
                      } else if (title == StringsConstants.onSale) {
                        condition = "on_sale";
                      }
                      Navigator.of(context).pushNamed(
                          Router.allProductListScreen,
                          arguments: condition);
                    },
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10, right: 10),
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              children: List.generate(
                products.length > 6 ? 6 : products.length,
                (index) => ProductCard(products[index]),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
