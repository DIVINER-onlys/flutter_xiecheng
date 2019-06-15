import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart'
  show Swiper, SwiperPagination;
import 'package:flutter_xiecheng/dao/home_dao.dart' show HomeDao;
import 'package:flutter_xiecheng/model/home_model.dart' show HomeModel;
import 'package:flutter_xiecheng/model/common_model.dart' show CommonModel;
import 'package:flutter_xiecheng/model/grid_nav_model.dart' show GridNavModel;
import 'package:flutter_xiecheng/model/sales_box_model.dart' show SalesBoxModel;
import 'package:flutter_xiecheng/widget/webview.dart' show WebView;
import 'package:flutter_xiecheng/widget/grid_nav.dart' show GridNav;
import 'package:flutter_xiecheng/widget/local_nav.dart' show LocalNav;
import 'package:flutter_xiecheng/widget/sub_nav.dart' show SubNav;
import 'package:flutter_xiecheng/widget/sales_box.dart' show SalesBox;
import 'package:flutter_xiecheng/widget/loading_container.dart' show LoadingContainer;
import 'package:flutter_xiecheng/widget/search_bar.dart' show SearchBar, SearchBarType;

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红大卡地 景点 酒店 美食';

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
  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBox;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefesh();
  }

  Future<Null> _handleRefesh() async {
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
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNavModel = model.griNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        _loading = false;
      });
    } catch(e) {
      setState(() {
        _loading = false;
      });
      print(e);
    }
    return null;
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
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            mainListView(),
            mainAppBar()
          ],
        ),
      )
    );
  }

  Widget mainListView () {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: RefreshIndicator( // 上拉刷新组件
        onRefresh: _handleRefesh,
        child: NotificationListener(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
              // 滚动且是列表滚动的时候
              _onScroll(scrollNotification.metrics.pixels);
            }
          },
          child: _listView
        ),
      )
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel)
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBox),
        )
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 160.0,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return WebView(
                      url: bannerList[index].url,
                      title: bannerList[index].title,
                      hideAppBar: bannerList[index].hideAppBar,
                    );
                  }
                )
              );
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  Widget mainAppBar () {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          )
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]
          ),
        )
      ],
    );
    // Opacity(
    //   opacity: appBarAlpha,
    //   child: Container(
    //     height: 80,
    //     decoration: BoxDecoration(color: Colors.white),
    //     child: Center(
    //       child: Padding(
    //         padding: EdgeInsets.only(top: 20),
    //         child: Text('首页'),
    //       ),
    //     ),
    //   ),
    // );
  }

  _jumpToSearch() {}

  _jumpToSpeak() {}
}
