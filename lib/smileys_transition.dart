
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class SmileysTransition extends StatefulWidget {
  const SmileysTransition({Key? key}) : super(key: key);

  @override
  _SmileysTransitionState createState() => _SmileysTransitionState();
}

class _SmileysTransitionState extends State<SmileysTransition>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<String> feedbackImages = [
    "assets/smiley_very_sad.png",
    "assets/smiley_very_sad.png",
    "assets/smiley_very_sad.png",
    "assets/smiley_very_sad.png",
    "assets/smiley_very_sad.png",
  ];

  late AnimationController controller;
  late AnimationController newController;
  late AnimationController fadeController;
  late Tween<Offset> offset;
  late Tween<Offset> newOffset;
  late Animation<Offset> textAnimation;
  late Animation<Offset> newAnimation;
  late Animation<double> fadeAnimation;
  List<Widget> feedbacks = [];
  int selected = 2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
    newOffset = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0));
    textAnimation = offset
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    controller.forward();

    newController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    newAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -0.5))
        .animate(
            CurvedAnimation(parent: newController, curve: Interval(0.0, 0.5),));
    fadeController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: newController,
      curve: Interval(0.5, 1.0,curve: Curves.easeIn),
    ));

    // fires after the build method has run
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      addFeedbacks();
    });
      // addFeedbacks();
  }

  void addFeedbacks() {
    Future ft = Future(() {});
    for (int i = 0; i<feedbackImages.length; i++) {
      ft = ft.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          feedbacks.add(_buildSingleFeedback(feedbackImages[i]));
          listKey.currentState!.insertItem(i);
        });
      });
    }
  }

   void removeFeedbacks(){
    Future ft = Future((){});
    for (int i = feedbackImages.length; i>=0; i--) {
      ft = ft.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          final deletedItem = feedbackImages.removeAt(i);
          listKey.currentState!.removeItem(i,
                  (BuildContext context, Animation<double> animation) {
                return SlideTransition(
                  position: CurvedAnimation(
                    curve: Curves.easeOut,
                    parent: animation,
                  ).drive(newOffset),
                  child: _buildSingleFeedback(deletedItem),
                );
              });
        });
      });
    }
  }

  Widget _buildSingleFeedback(String feedback) {
    return FxContainer.rounded(
      onTap: (){
        removeFeedbacks();

       /* newController.forward();
        fadeController.forward();*/
      },
      color: Colors.grey.shade200,
      margin: FxSpacing.right(20),
      paddingAll: 8,
      child: Image(height: 32, width: 32, image: AssetImage(feedback),
      ),
    );
  }

  @override
  void dispose() {
    fadeController.dispose();
    newController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: newAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                  position: textAnimation,
                  child: FxText.b1(
                    "How would you rate the \natmosphere in the studio?",
                    fontWeight: 700,
                  )),
              FxSpacing.height(20),
              Container(
                height: 50,
                padding: FxSpacing.x(20),
                child: AnimatedList(
                    scrollDirection: Axis.horizontal,
                    key: listKey,
                    initialItemCount: feedbacks.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                          position: animation.drive(offset),
                          child: feedbacks[index]);
                    }),
              ),
              FxSpacing.height(40),
              TweenAnimationBuilder(
                duration: Duration(seconds: 2),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (BuildContext context,double val,Widget? child){
                  return Opacity(
                    opacity:val,
                    child: child,
                  );
                },
                child: Divider(
                  thickness: 2,
                ),
              ),
            ],
          ),
        ),
        FadeTransition(
            opacity: fadeAnimation,
            child: FxText.b1(
              "Add comment",
              fontWeight: 600,
              xMuted: true,
            )),
        FadeTransition(
            opacity: fadeAnimation,
            child: Divider(
              thickness: 2,
            )),
      ],
    ));
  }
}
