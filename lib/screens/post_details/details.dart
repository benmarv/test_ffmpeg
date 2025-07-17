import 'package:flutter/material.dart';
import 'package:link_on/models/posts.dart' as postModel;

class DetailsList extends StatefulWidget {
  final List<postModel.Audio> photo;
  final int? index;
  const DetailsList({super.key, required this.photo, this.index});
  @override
  State<DetailsList> createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsList> {
  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 1.0, initialPage: widget.index!);

    _init();
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white : Colors.grey,
            shape: BoxShape.circle),
      );
    });
  }

  late int activePage;
  void _init() {
    activePage = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 30)),
        ),
        body: PhysicalModel(
          color: Colors.black.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.photo.length,
                    onPageChanged: (page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Image.network(
                              widget.photo[index].mediaPath!,
                              fit: BoxFit.contain,
                            )),
                      );
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicators(
                    widget.photo.length,
                    activePage,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
