import 'package:flutter/material.dart';

class ImageWithLoader extends StatelessWidget {
  final String imageUrl;
  final double h;
  final double w;
  const ImageWithLoader({
    super.key,
    required this.imageUrl,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: Image.network(
        imageUrl,
        height: h,
        width: w,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }
        },
      ),
    );
  }
}
