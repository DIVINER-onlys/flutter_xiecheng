import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart'
  show Swiper, SwiperPagination;
import 'package:flutter_xiecheng/dao/home_dao.dart' show HomeDao;
import 'package:flutter_xiecheng/model/home_model.dart' show HomeModel;
const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUris = [
    'https://img1.qunarzz.com/travel/poi/1411/79/798d88609ffd421b213a9cdb.jpg_r_720x400x95_bdb8c28d.jpg',
    'http://www.noahgreece.com/uploads/180913/2-1P9131023042A.jpg',
    'http://210.76.68.128/zxwcms//gd_zxw/upload/file/201805/30121611jwtf.jpg'
  ];
  double appBarAlpha = 0;
  String resultString = '12';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    // HomeDao.fetch().then((result) {
    //   setState((){
    //     resultString = json.encode(result);
    //   });
    // }).catchError((onError) {
    //   setState(() {
    //     resultString = onError;
    //   });
    // });

    try {
      HomeModel model = await HomeDao.fetch();
      setState((){
        resultString = json.encode(model);
      });
    } catch(e) {
      setState(() {
        resultString = e.toString();
      });
    }
  }

  _onScroll(offset) {
    // print(offset);
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if (alpha<0) {
      alpha = 0;
    } else if (alpha>1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          mainListView(),
          mainAppBar()
        ],
      )
    );
  }

  Widget mainListView () {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
            // 滚动且是列表滚动的时候
            _onScroll(scrollNotification.metrics.pixels);
          }
        },
        child: ListView(
          children: <Widget>[
            Container(
              height: 160.0,
              child: Swiper(
                itemCount: _imageUris.length,
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    _imageUris[index],
                    fit: BoxFit.fill,
                  );
                },
                pagination: SwiperPagination(),
              ),
            ),
            Container(
              height: 800,
              child: ListTile(
                title: Text(resultString),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget mainAppBar () {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }
}
