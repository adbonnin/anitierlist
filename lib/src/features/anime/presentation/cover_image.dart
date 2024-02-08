import 'package:anitierlist/assets.dart';
import 'package:flutter/widgets.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.image,
    this.placeholder = Images.anilistCoverMediumDefault,
  });

  final String? image;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Image.asset(placeholder)
        : FadeInImage.assetNetwork(
            image: image!,
            fit: BoxFit.cover,
            placeholder: placeholder,
            imageErrorBuilder: (_, __, ___) => Image.asset(placeholder),
          );
  }
}
