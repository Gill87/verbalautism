import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/animated_card.dart';

class ImageActivityCard extends StatefulWidget {
  
  final String label;
  final String image;
  final VoidCallback onTap;
  
  const ImageActivityCard({
    required this.label,
    required this.image,
    required this.onTap,
    super.key
  });

  @override
  State<ImageActivityCard> createState() => _ImageActivityCardState();
}

class _ImageActivityCardState extends State<ImageActivityCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: widget.onTap,
      child: Card(
        elevation: 10,
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 200,
          height: 230,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                Transform.scale(
                  scale: 1.5,
                  child: SvgPicture.asset(
                    widget.image,
                    width: 100,
                    height: 100,
                  ),
                ),
                
                const SizedBox(height: 10),
      
                Text(
                  widget.label,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );  
  }
}