import 'package:flutter/material.dart';

class Searchingwindow extends StatefulWidget {
  final Function(String, String)? onSearch;
  const Searchingwindow({super.key, this.onSearch});

  @override
  State<Searchingwindow> createState() => _SearchingwindowState();
}

class _SearchingwindowState extends State<Searchingwindow> {
  List<bool> isSelected = [true, false, false, false];
  late TextEditingController contentController;
  String serchValue = "";

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
  }

  //뒤로가기 버튼
  void onClickedBackButton() {
    Navigator.pop(context);
  }

  //검색 버튼
  void onClickedSearchButton() {
    serchValue = contentController.text.trim();
    widget.onSearch?.call(
      isSelected[0]
          ? "title"
          : isSelected[1]
          ? "content"
          : isSelected[2]
          ? "emotion"
          : "summary",
      serchValue,
    );
    Navigator.pop(context);
  }

  //검색 옵션 버튼
  Widget createOptionButton(String text, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.175,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color:
            isSelected[index]
                ? Color(0xFFffbc41)
                : Color.fromARGB(255, 255, 246, 231),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected[index]
                  ? Color(0xFFffbc41)
                  : Color.fromARGB(255, 255, 246, 231),
        ),
        onPressed: () {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              if (i == index) {
                isSelected[i] = true;
              } else {
                isSelected[i] = false;
              }
            }
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFE4B5),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            //검색창
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 246, 231),
                borderRadius: BorderRadius.circular(45),
              ),
              child: TextField(
                controller: contentController,
                maxLines: 1,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "옵션 선택 후 검색어를 입력하세요",
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFFFC8650),
                      size: 30,
                    ),
                    onPressed: onClickedBackButton,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFFFC8650),
                      size: 40,
                    ),
                    onPressed: onClickedSearchButton,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            //검색 옵션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createOptionButton("제목", 0),
                  createOptionButton("내용", 1),
                  createOptionButton("감정", 2),
                  createOptionButton("요약", 3),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Icon(
              Icons.search_sharp,
              size: 200,
              color: Color.fromARGB(255, 120, 120, 120),
            ),
            Text(
              "전체 일기의 내용을 검색해보세요!",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
