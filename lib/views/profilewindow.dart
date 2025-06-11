import 'dart:io';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone_diary/Utils/assetmanager.dart';
import 'package:capstone_diary/Utils/datamanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfileWindow extends StatefulWidget {
  final Function(int) backButtonEvent;
  const ProfileWindow({super.key, required this.backButtonEvent});

  @override
  State<ProfileWindow> createState() => _ProfileWindowState();
}

class _ProfileWindowState extends State<ProfileWindow> {
  bool isEditMode = false;
  String nickname = "닉네임";
  XFile? selectedImageFile;
  String selectedImagepath = "";
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
    //프로필 사진 저장
    if (selectedImageFile != null) {
      try {
        final Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();

        // 원본 파일의 이름을 가져와서 새 파일 이름을 만듦
        final String fileName = path.basename(selectedImageFile!.path);
        final String localPath = path.join(appDocumentsDir.path, fileName);

        // 선택된 파일을 앱 내부 저장소로 복사
        final File newImageFile = await File(
          selectedImageFile!.path,
        ).copy(localPath);

        await Datamanager().saveProfileImagePath(newImageFile.path);

        setState(() {
          selectedImagepath = newImageFile.path; // 저장된 최종 이미지 경로로 업데이트
          selectedImageFile = null; // 임시 XFile은 저장 후 초기화하여 메모리 관리
        });
        showToastMessage("프로필이 성공적으로 저장되었습니다.");
      } catch (e) {
        showToastMessage("이미지 저장 중 오류가 발생했습니다.");
        print("이미지 저장 오류: $e"); // 디버깅을 위해 콘솔에 오류 출력
      }
    } else {
      // 이미지가 새로 선택되지 않았을 경우 (닉네임만 변경했거나, 기존 이미지를 유지할 경우)
      showToastMessage("프로필이 저장되었습니다.");
    }
  }

  void changeProfileImage() async {
    if (!isEditMode) {
      return;
    }

    //갤러리 접근 권한 요청
    Permission permissionType = Permission.photos;
    bool hasPemission = await profilePermissionCheck(permissionType);

    if (hasPemission) {
      //갤러리에서 사진 가져오기
      getProfileImage();
    } else {
      showToastMessage("프로필 이미지 변경을 위한 갤러리 권한이 필요합니다.");
    }
  }

  void getProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImageFile = image; // 선택된 이미지를 화면에 표시하기 위해 상태 업데이트
      });
      showToastMessage("프로필 이미지가 선택되었습니다."); // 사용자에게 이미지 선택 성공 알림
    } else {
      showToastMessage("이미지 선택을 취소했습니다."); // 사용자가 이미지 선택을 취소했을 때
    }
  }

  void changeBadge() {
    if (!isEditMode) {
      return;
    }
    showToastMessage("준비 중입니다.");
  }

  //사진 권한 요청
  Future<bool> profilePermissionCheck(Permission permission) async {
    PermissionStatus status = await permission.status;
    //모두 허용 or 제한적 허용
    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isDenied) {
      status = await permission.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      //사용자가 영구적으로 거부한 경우, 설정으로 이동
      openAppSettings();
      return false;
    }
    return false;
  }

  void getNickname() async {
    nickname = await Datamanager().getData("user_Name");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    nickNameContentController = TextEditingController();
    checkCustomProgile();
    getNickname();
  }

  void checkCustomProgile() async {
    selectedImagepath = await Datamanager().getProfileImagePath();
    setState(() {});
  }

  Widget showProfileImage() {
    //프로필 편집 중 갤러리에서 '새로 선택된 이미지'가 있다면
    if (selectedImageFile != null) {
      return ClipOval(
        child: Image.file(
          File(selectedImageFile!.path),
          width: 130,
          height: 130,
          fit: BoxFit.cover,
        ),
      );
    }
    //'저장된 프로필 이미지 경로'가 있다면
    else if (selectedImagepath.isNotEmpty) {
      return ClipOval(
        child: Image.file(
          File(selectedImagepath),
          width: 130,
          height: 130,
          fit: BoxFit.cover,
        ),
      );
    }
    //나머지: '기본 프로필 이미지' 표시
    else {
      return AssetManager.instance.getProfileImage("defaultpro.png", 130, 130);
    }
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
                    child: showProfileImage(),
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
                  /*
                  //이메일
                  infomationSet("이메일", "abcd@gmail.com"),
                  Divider(color: Color(0xff919572), thickness: 2),
                  //비밀번호
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
                            GestureDetector(
                              onTap: changeBadge,
                              child: Container(
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
