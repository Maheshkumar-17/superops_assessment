import 'package:flutter/material.dart';

///We can reuse this widget  whenever needs.

class FavouriteIconWidget extends StatelessWidget {
  final VoidCallback onTap;
  final ValueNotifier<bool> isFavourite;
  final double iconSize;
  const FavouriteIconWidget({
    super.key,
    required this.isFavourite,
    required this.onTap,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isFavourite,
      builder: (context, isFav, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: GestureDetector(
            onTap: () {
              onTap();
              isFavourite.value = !isFavourite.value;
            },
            child: Icon(
              Icons.favorite,
              color: isFav ? Colors.red : Colors.blueGrey,
              size: iconSize,
            ),
          ),
        );
      },
    );
  }
}
