import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone_diary/Utils/assetmanager.dart';
import 'package:capstone_diary/Utils/datamanager.dart';

class ProfileWindow extends StatefulWidget {
  final Function(int) backButtonEvent;
  const ProfileWindow({super.key, required this.backButtonEvent});

  @override
  State<ProfileWindow> createState() => _ProfileWindowState();
}

class _ProfileWindowState extends State<ProfileWindow> {
  bool isEditMode = false;
  String nickname = "닉네임";
  late TextEditingController nickNameContentController;
  Widget defaultProfileImage = AssetManager.instance.getProfileImage(
    "defaultpro.png",
    130,
    130,
  );

  TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  TextStyle infoStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  void backToHomeWindow() {
    widget.backButtonEvent(0); //메인 화면으로 돌아가기
  }

  void editProfile() {
    setState(() {
      isEditMode = true;
    });
  }

  void showSaveProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("프로필 저장"),
          content: Text("프로필을 저장하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                saveProfile();
                Navigator.of(context).pop();
              },
              child: Text("저장"),
            ),
          ],
        );
      },
    );
  }

  void saveProfile() async {
    setState(() {
      nickname = nickNameContentController.text;
      isEditMode = false;
    });
    await Datamanager().removeData("user_Name");
    await Datamanager().saveData("user_Name", nickname, true);
  }

  void changeProfileImage() {
    //프로필 이미지 변경 기능 구현
  }

  //사진 권한 요청
  Future<bool> profilePermissionCheck(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await permission.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // 사용자가 영구적으로 거부한 경우, 설정으로 이동하도록 안내
      openAppSettings();
      return false;
    }
    return false;
  }

  //갤러리에서 이미지 선택
  /*
  Future<void> _pickImageFromGallery() async {
    Permission permission =
        Platform.isAndroid && await targetSdkVersion() >= 33
            ? Permission.photos
            : Permission.storage;

    if (await _requestPermission(permission)) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    } else {
      _showPermissionDeniedDialog('갤러리');
    }
  }*/

  void getNickname() async {
    nickname = await Datamanager().getData("user_Name");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    nickNameContentController = TextEditingController();
    getNickname();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            //제목 부분
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: backToHomeWindow,
                  icon: Icon(Icons.arrow_back_sharp, color: Color(0xffFC8650)),
                ),
                Text(
                  "프로필",
                  style: TextStyle(color: Color(0xffFC8650), fontSize: 45),
                ),
                SizedBox(width: 60),
              ],
            ),
            Divider(color: Color(0xffFC8650), thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: isEditMode ? showSaveProfileDialog : editProfile,
                  icon:
                      isEditMode
                          ? Icon(Icons.save, color: Colors.grey)
                          : Icon(Icons.border_color_sharp, color: Colors.grey),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(255, 246, 231, isEditMode ? 1 : 0),
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap:
                        isEditMode ? changeProfileImage : null, //프로필 이미지 변경 기능
                    child: AssetManager.instance.getProfileImage(
                      "defaultpro.png",
                      130,
                      130,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Color(0xff919572), thickness: 2),
                  //닉네임 설정
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                    child: Row(
                      children: [
                        Text("닉네임", style: titleStyle),
                        SizedBox(width: 20),
                        //닉네임 입력창
                        SizedBox(
                          height: 40,
                          width: 200,
                          child: TextField(
                            controller: nickNameContentController,
                            readOnly: !isEditMode,
                            decoration: InputDecoration(
                              hintText: nickname,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              filled: isEditMode,
                              fillColor: Color(0xffFFF6E7),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xff919572), thickness: 2),
                  //이메일
                  infomationSet("이메일", "abcd@gmail.com"),
                  Divider(color: Color(0xff919572), thickness: 2),
                  //비밀번호
                  /*
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                    child: Row(
                      children: [
                        Text("비밀번호", style: titleStyle),
                        SizedBox(width: 50),
                        FilledButton(
                          onPressed: chanagePassword,
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xffFFF6E7),
                          ),
                          child: Text(
                            "비밀번호 변경",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xff919572), thickness: 2), */
                  //뱃지
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("뱃지", style: titleStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(
                                  255,
                                  246,
                                  231,
                                  isEditMode ? 1 : 0,
                                ),
                              ),
                              child: defaultProfileImage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xff919572), thickness: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding infomationSet(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
      child: Row(
        children: [
          Text(title, style: titleStyle),
          SizedBox(width: 20),
          Text(value, style: infoStyle),
        ],
      ),
    );
  }
}
