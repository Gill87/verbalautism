import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalautism/components/animations/correct_animation.dart';
import 'package:verbalautism/components/animations/incorrect_animation.dart';
import 'package:verbalautism/components/audio%20services/tts_service.dart';

class DragDropMultipleObjectsComponent extends StatefulWidget {
  final VoidCallback onCompleted;
  final String correctAssetLinks;
  final List<String> wrongAssetLinks; // Can be 1 or 2 wrong objects
  final String mainData;
  final VoidCallback onCorrectAction;
  final VoidCallback onIncorrectAction;
  final String directory;
  final String objectVariation;


  const DragDropMultipleObjectsComponent({
    super.key,
    required this.onCompleted,
    required this.correctAssetLinks,
    required this.wrongAssetLinks,
    required this.mainData,
    required this.onCorrectAction,
    required this.onIncorrectAction,
    required this.directory,
    required this.objectVariation,
  });

  @override
  State<DragDropMultipleObjectsComponent> createState() => _DragDropMultipleObjectsComponentState();
}


class _DragDropMultipleObjectsComponentState extends State<DragDropMultipleObjectsComponent> with SingleTickerProviderStateMixin{
  bool imageDropped = false;
  bool isProcessing = false;
  late List<String> allObjectLinks;
  late AnimationController _controller;
  late Animation<double> _animation;

  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();

    _ttsService.speak("Drag and Drop the ${widget.objectVariation} ${widget.mainData}");

    allObjectLinks = [widget.correctAssetLinks, ...widget.wrongAssetLinks];
    allObjectLinks.shuffle(); // Randomize order
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // makes it float up and down

    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }


  void _showCorrectAnimation() {
    // NEW: Prevent multiple calls
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    widget.onCorrectAction();

    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false, // NEW: Prevent dismissing dialog by tapping
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: CorrectAnimation(),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && isProcessing) { // NEW: Additional safety check
        Navigator.of(context).pop();
        setState(() {
          isProcessing = false; // NEW: Reset processing flag
        });
        widget.onCompleted();
      }
    });
  }

  void _showIncorrectAnimation() {
    // NEW: Prevent multiple calls
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    widget.onIncorrectAction();
    
    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false, // NEW: Prevent dismissing dialog by tapping
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: IncorrectAnimation(),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && isProcessing) { // NEW: Additional safety check
        Navigator.of(context).pop();
        setState(() {
          isProcessing = false; // NEW: Reset processing flag
        });
        widget.onCompleted();
      }
    });
  }

  void _handleDrop(DragTargetDetails<String> details) {
    // NEW: Prevent handling drops when processing
    if (isProcessing) return;
    
    if (details.data == widget.correctAssetLinks) {
      setState(() {
        imageDropped = true;
      });
      _showCorrectAnimation();
    } else {
      _showIncorrectAnimation();
    }
  }

  double horizontalPadding(){
    final screenWidth = MediaQuery.of(context).size.width;

    if(allObjectLinks.length == 3 && screenWidth <= 1050){
      return 1;
    } else if(allObjectLinks.length == 2 && screenWidth <= 800){
      return 1;
    } else {
      return screenWidth * 0.01;
    }
  }

  double widthSize(){
    final screenWidth = MediaQuery.of(context).size.width;

    if(screenWidth <= 680 && allObjectLinks.length == 3){
      return screenWidth * 0.005;
    } else if(screenWidth <= 700 && allObjectLinks.length == 2){
      return screenWidth * 0.02;
    } else {
      return screenWidth * 0.04;
    }
  }

  double imageWidth(){
    final screenWidth = MediaQuery.of(context).size.width;

    if(screenWidth <= 1000 && allObjectLinks.length == 3){
      return screenWidth * 0.1;
    } else if(screenWidth <= 700 && allObjectLinks.length == 2){
      return screenWidth * 0.15;
    } else {
      return screenWidth * 0.2;
    }
  }

  double imageHeight(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(screenWidth <= 1000 && allObjectLinks.length == 3){
      return screenHeight * 0.2;
    } else if(screenWidth <= 700 && allObjectLinks.length == 2){
      return screenHeight * 0.25;
    } else {
      return screenHeight * 0.3;
    }
  }

  bool isColor() {
    if (widget.objectVariation == "Color") {
      return true;
    } else {
      return false;
    }
  }

  bool isTooLarge(){
    if(widget.objectVariation == "Sight Word"){
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animation.removeListener(() {});
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.97,
      child: Column(
        children: [
          Text(
            "Drag and Drop the ${widget.objectVariation} ${widget.mainData}",
            style: GoogleFonts.ubuntu(fontSize: 40, color: Colors.white),
          ),

          const SizedBox(height: 50),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageDropped ? [
              _buildDragTarget(),
            ] : [
              ...allObjectLinks.map((object) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding(),
                    ),
                    child: _buildDraggable(object),
                  )),
              SizedBox(width: widthSize(),),
              _buildDragTarget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggable(String assetLink) {
    // Define color map for color variations for color drag and drop
    Map<String, Color> colorMap = {};

    if(widget.objectVariation == "Color"){
      colorMap = {
        'blue': Colors.blue,
        'red': Colors.red,
        'green': Colors.green,
        'black': Colors.black,
        'white': Colors.white,
        'yellow': Colors.yellow,
        'purple': Colors.purple,
        'orange': Colors.orange,
        'pink': Colors.pink,
        'brown': Colors.brown,
      };
    }

    // Define object image
    final svg = !isColor() 
      ? SvgPicture.asset(
          '${widget.directory}$assetLink.svg',
          width: imageWidth(),
          height: imageHeight(),
          fit: BoxFit.contain,
        )
      : Padding(      // Only for Colors Drag and Drop
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: colorMap[assetLink.toLowerCase()],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

    final animatedSvg = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: svg,
    );

    return Draggable<String>(
      data: assetLink,

      // The widget being dragged
      feedback: Material(
        color: Colors.transparent,  // no background
        child: Transform.scale(
          scale: isTooLarge() ? 1.25 : 1.5,
          child: animatedSvg
        ), // same as child -> no offset
      ),

      // What is shown in the original spot when dragging is occuring (in this case invisible lettter)
      childWhenDragging: Opacity(
        opacity: 0.0,
        child: animatedSvg,
      ),

      // 👇 Stop floating when drag starts
      onDragStarted: () {
        _controller.stop();
      },

      // If correct image dropped in
      child: imageDropped
          ? const SizedBox.shrink()
          : animatedSvg,

      // If image not dropped in, resume floating animation
      onDragEnd: (details) {
        if (mounted && !imageDropped) {
          _controller.repeat(reverse: true);
        }
      },

    );
  }


  Widget _buildDragTarget() {
    
    // Define color map for color variations for color drag and drop
    Map<String, Color> colorMap = {};

    if(widget.objectVariation == "Color"){
      colorMap = {
        'blue': Colors.blue,
        'red': Colors.red,
        'green': Colors.green,
        'black': Colors.black,
        'white': Colors.white,
        'yellow': Colors.yellow,
        'purple': Colors.purple,
        'orange': Colors.orange,
        'pink': Colors.pink,
        'brown': Colors.brown,
      };
    }
    return AnimatedAlign(
      alignment: imageDropped ? Alignment.center : Alignment.centerRight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: DragTarget<String>(
        onAcceptWithDetails: _handleDrop,
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(40),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, -1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: imageDropped
                  ? !isColor() 
                      ? SvgPicture.asset(
                          '${widget.directory}${widget.correctAssetLinks}.svg',
                          key: const ValueKey('droppedImage'),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.contain,
                        )
                      : Padding(      // Only for Colors Drag and Drop
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              color: colorMap[widget.correctAssetLinks.toLowerCase()],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                  : Center(
                      key: const ValueKey('dropText'),
                      child: Text(
                        "Drop Here",
                        style: GoogleFonts.ubuntu(fontSize: 30),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
