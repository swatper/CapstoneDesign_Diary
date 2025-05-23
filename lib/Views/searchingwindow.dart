import 'package:flutter/material.dart';

class Searchingwindow extends StatefulWidget {
  const Searchingwindow({super.key});

  @override
  State<Searchingwindow> createState() => _SearchingwindowState();
}

class _SearchingwindowState extends State<Searchingwindow> {
  List<bool> isSelected = [true, false, false, false];

  //뒤로가기 버튼
  void onClickedBackButton() {}
  //검색 버튼
  void onClickedSearchButton() {}

  //검색 옵션 버튼
  Widget createOptionButton(String text, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.21,
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
            if (index != 0 && isSelected[0]) {
              isSelected[0] = false;
            }
            isSelected[index] = !isSelected[index];
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //검색창
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 246, 231),
                borderRadius: BorderRadius.circular(45),
              ),
              child: TextField(
                maxLines: 1,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "글 제목, 내용, 태그",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                createOptionButton("전체", 0),
                createOptionButton("제목", 1),
                createOptionButton("내용", 2),
                createOptionButton("태그", 3),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
