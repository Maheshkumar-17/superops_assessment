import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superops_assessment/data/network/endpoints.dart';
import 'package:superops_assessment/presentation/strings/app_strings.dart';

class CachedImageWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String photoUrl;
  const CachedImageWidget({
    super.key,
    this.height,
    this.width,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: '${APIEndPoints.baseURL}$photoUrl',
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Image.asset(AssetImagePaths.placeholderImagePath);
          },
          errorWidget: (context, url, error) {
            return Image.asset(AssetImagePaths.placeholderImagePath);
          },
        ),
      ),
    );
  }
}
