import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/src/models/product_model.dart';
import 'package:fluttercommerce/src/res/text_styles.dart';
import 'package:fluttercommerce/src/routes/router.gr.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  ProductCard(this.productModel);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context)
            .pushNamed(Router.productDetailPage, arguments: productModel);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: CachedNetworkImage(
                  imageUrl: productModel.image,
                  fit: BoxFit.fitWidth,
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
                  Text(
                    productModel.name,
                    style: AppTextStyles.medium14Black,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "${productModel.currency}${productModel.currentPrice}",
                        style: AppTextStyles.normal12Black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${productModel.currency}${productModel.actualPrice}",
                        style: AppTextStyles.normal12Color81819AStroke,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${productModel.quantityPerUnit}${productModel.unit}",
                    style: AppTextStyles.normal12Color81819A,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
