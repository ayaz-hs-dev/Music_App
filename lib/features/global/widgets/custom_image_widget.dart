import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String imagePath; // Image path (asset or network)
  final double size; // Adjustable size
  final bool isCircular; // Profile (circle) or thumbnail (square)
  final bool isNetwork; // Profile (circle) or thumbnail (square)

  const CustomImageWidget({
    super.key,
    required this.imagePath,
    this.size = 80,
    this.isCircular = true,
    this.isNetwork = false,
  });

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(12),
        image: DecorationImage(
          image: _isNetworkImage
              ? NetworkImage(imagePath)
              : AssetImage(imagePath) as ImageProvider,
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
    );
  }
}
