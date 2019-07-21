import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_xiecheng/model/travel_model.dart' show TravelModel;

// https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5
// 旅拍页接口

var Params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {},
  "contentType": "json"
};

class TravelDao {
  static Future<TravelModel> fetch(String url, String groupChannelCode, int pageIndex, int pageSize) async {
    Map paramsMap = Params["pagePara"];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;
    final response = await http.post(url, body: json.encode(Params));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();  // 修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      print('旅拍页数据$result');
      // return TravelModel.fromJson(result);
      // return '';
    } else {
      throw Exception('Failed to load travel.json');
    }
  }
}