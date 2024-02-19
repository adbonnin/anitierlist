import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/widgets/cover_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TierListCard extends StatelessWidget {
  const TierListCard({
    super.key,
    required this.tierList,
    this.onTap,
  });

  static const double width = 80;
  static const double height = 120;

  final TierList tierList;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: CoverImage(image: tierList.cover),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                color: const Color(0xE6292929),
                padding: const EdgeInsets.fromLTRB(4, 3, 4, 2),
                child: AutoSizeText(
                  tierList.title,
                  style: GoogleFonts.overpass(
                    color: Colors.white,
                    height: 0,
                  ),
                  minFontSize: 0,
                  maxFontSize: 9,
                  maxLines: 6,
                  stepGranularity: 0.1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
