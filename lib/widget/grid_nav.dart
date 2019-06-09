import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/grid_nav_model.dart' show GridNavModel, GridNavItem;
import 'package:flutter_xiecheng/model/common_model.dart' show CommonModel;
import 'package:flutter_xiecheng/widget/webview.dart' show WebView;

// 网格布局
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;
  final String name;
  const GridNav({Key key, @required this.gridNavModel, this.name='sammy'}):super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用Container包裹Column，然后设置Container圆角后，Column覆盖在Container上面导致看不到效果
    // PhysicalModel 解决圆角问题
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  // 三个大模块
  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) {
      return items;
    }
    // 酒店模块
    if(gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    // 机票模块
    if(gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    // 旅行模块
    if(gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }
  
  // 单独一个模块
  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first){
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(
        Expanded(child: item, flex: 1,)
      );
    });
    Color startColor=Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor=Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      margin: first?null:EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        // 线性渐变
        gradient: LinearGradient(
          colors: [startColor, endColor]
        )
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  // 左侧部分
  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
      context,
      Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.network(
            model.icon,
            fit: BoxFit.contain,
            height: 88,
            width: 121,
            alignment: AlignmentDirectional.bottomEnd, //图片位置居下
          ),
          Container(
            margin: EdgeInsets.only(top: 11),
            child: Text(
              model.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14
              ),
            ),
          )
        ],
      ),
      model
    );
  }

  // 双层部分
  _doubleItem(BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        // 撑开父布局高度
        Expanded(
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, bottomItem, false),
        )
      ],
    );
  }

  // 当层部分
  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSize = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      // 撑满父布局宽度
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: borderSize,
            bottom: first?borderSize:BorderSide.none
          )
        ),
        child: _wrapGesture(
          context,
          Center(
            child: Text(
              item.title,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          item
        ),
      ),
    );
  }

  // 可点击组件
  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => 
            WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
              title: model.title,
            )
          )
        );
      },
      child: widget,
    );
  }
}