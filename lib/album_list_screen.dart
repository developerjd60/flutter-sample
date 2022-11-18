import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter_code/ui/albumList/controllers/album_list_controller.dart';
import 'package:spotify_flutter_code/utils/color.dart';
import 'package:spotify_flutter_code/utils/constant.dart';
import 'package:spotify_flutter_code/utils/sizer_utils.dart';

import '../../../custom/dialog/progressdialog.dart';
class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.bgColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder<AlbumListController>(
            assignId: true,
            builder: (logic) {
              return SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.width_2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: Sizes.width_2),
                        child: Text(
                          "txtChooseMoreArtist".tr,
                          style: TextStyle(
                              color: CColor.white,
                              fontSize: FontSize.size_22,
                              fontFamily: Constant.strSpotifyFamily,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      _searchTextField(logic),
                      _listOfArtist(logic,context),
                      _doneBtn(logic)
                    ],
                  ),
                ),
              );
            },
          ),
          GetBuilder<AlbumListController>(
              id: Constant.isShowProgressUpload,
              builder: (logic) {
                return ProgressDialog(
                  inAsyncCall: logic.isShowProgress,
                  child: Container(),
                );
              }),
        ],
      ),
    );
  }

  _searchTextField(AlbumListController logic) {
    return Container(
      margin: EdgeInsets.only(top: Sizes.height_4),
      child: TextFormField(
        controller: logic.searchController,
        textAlign: TextAlign.start,
        onChanged: (value)=>{
          logic.onChangeAlbumList(value),
        } ,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: CColor.black,
          fontWeight: FontWeight.w400,
          fontFamily: Constant.strRobotoFamily,
        ),
        cursorColor: CColor.black,
        decoration: InputDecoration(
          filled: true,
          hintStyle: const TextStyle(
            color: CColor.txtGray,
            fontWeight: FontWeight.w400,
            fontFamily: Constant.strRobotoFamily,
          ),
          labelStyle: const TextStyle(color: Colors.black),
          hintText: 'searchHere'.tr,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: CColor.borderColor, width: 0.7),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CColor.borderColor, width: 0.7),
            borderRadius: BorderRadius.circular(8.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CColor.borderColor, width: 0.7),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CColor.borderColor, width: 0.7),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  _listOfArtist(AlbumListController logic,BuildContext context) {
    return Expanded(
      child: GetBuilder<AlbumListController>(
        assignId: true,
        id: Constant.idSelectAlbumImage,
        builder: (logic) {
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: Sizes.width_1),
            child: GridView.builder(
              itemCount: logic.albumListArray.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: Sizes.height_5,top: Sizes.height_1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0.1,
                mainAxisExtent: 190,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _itemArtist(index, logic,context);
              },
            ),
          );
        },
      ),
    );
  }

  _itemArtist(int index, AlbumListController logic,BuildContext context) {
    return InkWell(
      onTap: () {
        logic.changeSelectedValue(
            index, !logic.albumListArray[index].isSelected!,context);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  NetworkImage("${Constant.mediaUrl}${logic.albumListArray[index].albumLogo!}",),
                  backgroundColor: Colors.transparent,
                ),
                Container(
                    margin: EdgeInsets.only(top: Sizes.height_1),
                    child: Text(
                      logic.albumListArray[index].albumTitle!,
                      style: const TextStyle(color: CColor.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
          ),
          (logic.albumListArray[index].isSelected!)
              ? Container(
                  decoration: const BoxDecoration(
                      color: CColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.done_rounded,
                      color: CColor.black,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _doneBtn(AlbumListController logic) {
    return GetBuilder<AlbumListController>(
        assignId: true,
        id: Constant.idSelectAlbumImage,
        builder: (logic) {
          return (logic.isShowDoneBtn())
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.width_15,vertical: Sizes.height_2),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      logic.sendSelectedAlbumId(Get.context!);

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CColor.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: CColor.borderColor, width: 0.7),
                        ),
                      ),

                    ),
                    child: Text(
                      "txtDone".tr.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CColor.black,
                          fontSize: FontSize.size_16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              : Container();
        });
  }
}
