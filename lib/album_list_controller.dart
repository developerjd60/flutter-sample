import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter_code/main.dart';
import 'package:spotify_flutter_code/ui/albumList/datamodel/albumlistdata.dart';
import 'package:spotify_flutter_code/ui/albumList/datamodel/albumlistdatamodel.dart';
import 'package:spotify_flutter_code/ui/albumList/datamodel/sendalbumIddata.dart';
import 'package:spotify_flutter_code/ui/albumList/datamodel/sendalbumiddatamodel.dart';
import 'package:spotify_flutter_code/utils/constant.dart';
import 'package:spotify_flutter_code/utils/utils.dart';

import '../../../connectivitymanager/connectivitymanager.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/debug.dart';
import '../../../utils/preference.dart';

class AlbumListController extends GetxController {
  TextEditingController searchController = TextEditingController();
  List<Datum> albumListArray = [];
  List<Datum> mainAlbumListArray = [];
  var albumListDataModel = AlbumListDataModel();
  var sendAlbumIdDataModel = SendAlbumIdDataModel();
  bool isShowProgress = false;

  @override
  void onInit() {
    super.onInit();
    callGetAllAlbumList(Get.context!);
  }

  callGetAllAlbumList(BuildContext context){
    InternetConnectivity.isInternetAvailable(
      context,
      success: () {
        isShowProgress = true;
       update([Constant.isShowProgressUpload]);
        getAllAlbumList(context);
      },
      cancel: () {
        isShowProgress = false;
       update([Constant.isShowProgressUpload]);
      },
      retry: () {
        isShowProgress = true;
        update([Constant.isShowProgressUpload]);
        getAllAlbumList(context);
      },
    );
  }

  getAllAlbumList(BuildContext context) async {
    await albumListDataModel.getAllAlbumList(context).then((value) {
      isShowProgress = false;
      update([Constant.isShowProgressUpload]);
      handleGetAllAlbumListResponse(value, context);
    });

  }

  handleGetAllAlbumListResponse(AlbumListData albumListData, BuildContext context) async {
    if (albumListData.responseCode == Constant.responseSuccessCode) {
      Debug.printLog(
          "LikeUnlike Res Success ===>> ${albumListData.toJson().toString()}  ${albumListData.data!.length} ");

      for (var element in albumListData.data!) {
        albumListArray.add(Datum(id:element.id,albumTitle: element.albumTitle, albumLogo: element.albumLogo,createdAt: element.createdAt,isSelected:false));
        mainAlbumListArray = albumListArray;
      }
      update([Constant.idSelectAlbumImage]);
    } else {
      if (albumListData.message != null &&
          albumListData.message!.isNotEmpty) {
        Utils.showToast(albumListData.message!);
      }
    }
  }

  changeSelectedValue(int index,bool val,BuildContext context){
    albumListArray[index].isSelected = val;
    update([Constant.idSelectAlbumImage]);
  }

  onChangeAlbumList(String strVal){
    albumListArray = mainAlbumListArray.where((element) => element.albumTitle!.toLowerCase().contains(strVal.toLowerCase())).toList();
    update([Constant.idSelectAlbumImage]);
  }

  bool isShowDoneBtn(){
    return albumListArray.where((element) => element.isSelected!).toList().isNotEmpty;
  }

  sendSelectedAlbumId(BuildContext context){
    InternetConnectivity.isInternetAvailable(
      context,
      success: () {
        isShowProgress = true;
        update([Constant.isShowProgressUpload]);
        callSendSelectedAlbum(context);
      },
      cancel: () {
        isShowProgress = false;
        update([Constant.isShowProgressUpload]);
      },
      retry: () {
        isShowProgress = true;
        update([Constant.isShowProgressUpload]);
        callSendSelectedAlbum(context);
      },
    );
  }

  callSendSelectedAlbum(BuildContext context) async {
    var selectedIds = StringBuffer();
    var arraySelectedData = albumListArray.where((element) => element.isSelected!).toList();
    for(int i=0;i < arraySelectedData.length;i++){
      if(selectedIds.isEmpty) {
        selectedIds.write(arraySelectedData[i].id.toString());
      }else{
        selectedIds.write(",${arraySelectedData[i].id}");
      }
    }
    sendAlbumIdDataModel.albumId = selectedIds.toString();
    sendAlbumIdDataModel.isFavourite = false;
    await sendAlbumIdDataModel.sendSelectedAlbumIds(context).then((value) {
      isShowProgress = false;
      update([Constant.isShowProgressUpload]);
      handleSendSelectedAlbumListResponse(value, context);
    });
  }

  handleSendSelectedAlbumListResponse(SendAlbumIdData sendAlbumIdData, BuildContext context) async {
    if (sendAlbumIdData.responseCode == Constant.responseSuccessCode) {
      Preference.shared.setBool(Preference.isAlbumSelect,true);
      Get.offAllNamed(AppRoutes.main);
    } else {
      if (sendAlbumIdData.message != null &&
          sendAlbumIdData.message!.isNotEmpty) {
        Utils.showToast(sendAlbumIdData.message!);
      }
    }
  }

}

class AlbumList{
  String? imageUrl;
  String? imageName;
  bool isSelected = false;

  AlbumList(this.imageUrl,this.imageName,this.isSelected);
}