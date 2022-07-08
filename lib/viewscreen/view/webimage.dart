import 'package:flutter/material.dart';

class WebImage extends Image {
  WebImage({
    required String url,
    required BuildContext context,
    double height = 200.0,
    Key? key,
  }) : super.network(
          url,
          height: height,
          key: key,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Icon(
              Icons.error,
              size: height,
            );
          },
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
            }
          },
        );
}