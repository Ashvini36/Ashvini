import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/responsive/responsive.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final String placeHolderUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final BoxFit? placeHolderFit;

  final double? borderRadius;
  final Color? color;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    this.placeHolderFit,
    required this.imageUrl,
    required this.placeHolderUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      height: height ?? Responsive.height(8, context),
      width: width ?? Responsive.width(8, context),
      color: color,
      progressIndicatorBuilder: (context, url, downloadProgress) => Constant.loader(context),
      errorWidget: (context, url, error) =>
      errorWidget ??
          CachedNetworkImage(
            fit: placeHolderFit ?? BoxFit.fitWidth,
            height: height ?? Responsive.height(8, context),
            width: width ?? Responsive.width(15, context),
            imageUrl: placeHolderUrl,
          ),
    );
  }
}
