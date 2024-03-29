import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui';

class imageviewer extends StatefulWidget {
  final String url;
  imageviewer({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<imageviewer> createState() => _imageviewerState();
}

class _imageviewerState extends State<imageviewer> {
  late String imageurl;

  // Future<bool> fileExists(url) async{
  //   await FirebaseStorage.instance.ref().child(url).getDownloadURL().then((url) => {true}).catchError((){return false;});
  // }
  @override
  Widget build(BuildContext context) {
    String url = widget.url;
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
        ),
        title: const Text(
          '상세 이미지',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white.withAlpha(100),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseStorage.instance
            .ref()
            .child(url)
            .getDownloadURL()
            .then((url) {
          imageurl = url;
          return true;
        }).catchError(() {
          return false;
        }),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('로딩중...'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return PhotoView(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white10,
                ),
                imageProvider: NetworkImage(imageurl),
                loadingBuilder: (context, event) {
                  if (event != null) {
                    return Center(child: Lottie.asset("assets/68374-animation-image.json"),);
                  }
                  return const Text('');
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      child: Lottie.asset(
                          "assets/73061-search-not-found.json",reverse: false,),
                    ),
                    const Text('해당 수행평가의 이미지가 없습니다.'),
                    const SizedBox(height: 100,)
                  ],
                ),
              );
            }
          }
          return const Center(
            child: Text('error'),
          );
        },
      ),
    );
  }
}
