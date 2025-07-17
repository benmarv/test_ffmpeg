import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/movies.dart';
import 'package:link_on/screens/movies/movie_detail.dart';

class MoviesCategories extends StatelessWidget {
  final List<Movies> moviesdata;
  const MoviesCategories({super.key, required this.moviesdata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          translate(context, 'categories').toString(),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Set the number of items in each row/column
              crossAxisSpacing: 10.0, // Set spacing between columns
              mainAxisSpacing: 0.0, // Set spacing between rows
              mainAxisExtent: 130),
          scrollDirection: Axis.vertical,
          itemCount: moviesdata.length,
          itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetail(moviesdata: moviesdata[index]),
                    ),
                  ),
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      image: DecorationImage(
                          image: NetworkImage(moviesdata[index].coverPic!),
                          fit: BoxFit.cover),
                    ),
                    child: SizedBox(
                      width: 110,
                      child: Center(
                        child: Text(
                          translate(context, 'adventure').toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
