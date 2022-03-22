import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading_widget.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  const CustomNetworkImage(
      {required this.image, this.height, this.width, this.fit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit ?? BoxFit.fill,
      // color: Theme.of(context).scaffoldBackgroundColor,
      height: height,
      width: width ?? double.infinity,
      placeholder: (_, __) => const Center(
        child: LoadingWidget(),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.error_outline),
      ),
    );
  }
}
