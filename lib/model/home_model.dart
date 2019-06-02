import 'package:flutter_xiecheng/model/config_model.dart' show ConfigModel;
import 'package:flutter_xiecheng/model/common_model.dart' show CommonModel;
import 'package:flutter_xiecheng/model/grid_nav_model.dart' show GridNavModel;
import 'package:flutter_xiecheng/model/sales_box_model.dart' show SalesBoxModel;

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel griNav;
  final SalesBoxModel salesBox;

  HomeModel({
    this.config,
    this.bannerList,
    this.localNavList,
    this.subNavList,
    this.griNav,
    this.salesBox
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList = localNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList = bannerListJson.map((i) => CommonModel.fromJson(i)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList = subNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    return HomeModel(
      config: ConfigModel.fromJson(json['config']),
      bannerList: bannerList,
      localNavList: localNavList,
      subNavList: subNavList,
      griNav: GridNavModel.fromJson(json['griNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config' :config,
      'bannerList' :bannerList,
      'localNavList' :localNavList,
      'subNavList' :subNavList,
      'griNav' :griNav,
      'salesBox' :salesBox
    };
  }
}