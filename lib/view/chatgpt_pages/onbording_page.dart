import 'package:chatgptuz/models/onBoarding_model.dart';
import 'package:chatgptuz/view/chatgpt_pages/chatgpt_home_page.dart';
import 'package:flutter/material.dart';

class OnbordingPage extends StatefulWidget {
  const OnbordingPage({super.key});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  String button = 'Next';
  final List<OnBoardingModel> _dataList = [
    OnBoardingModel(
        Icons.sunny,
        "Misollar",
        "\"Kvant hisoblashni oddiy so'zlar bilan tushuntiring\"",
        "\"10 yoshli bolaning tug'ilgan kuni uchun ijodiy g'oyalaringiz bormi?\"",
        "\"Javascriptda HTTP so'rovini qanday qilishim mumkin?\""),
    OnBoardingModel(
        Icons.reduce_capacity,
        "Imkoniyatlar",
        "Foydalanuvchi suhbatda avval aytganlarini eslab qoladi",
        "Foydalanuvchiga keyingi tuzatishlar kiritish imkonini beradi",
        "Nomaqbul so'rovlarni rad etishga\n o'rgatilgan"),
    OnBoardingModel(
        Icons.restart_alt_rounded,
        "Cheklovlar",
        "Vaqti-vaqti bilan noto'g'ri ma'lumotlar paydo bo'lishi mumkin",
        "Vaqti-vaqti bilan zararli ko'rsatmalar yoki noto'g'ri kontent yaratishi mumkin",
        "2021 yildan keyingi dunyo va voqealar haqida cheklangan bilim")
  ];

  void _onNextPressed() {
    if (_currentIndex == _dataList.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatgptHomePage()),
      );
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 36,
            ),
            Image.asset('assets/images/chatgpt_black.png'),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Welcome to',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              'ChatGPT',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Istalgan narsangizni so\'rang, tezda javob oling'),
            Expanded(
                child: PageView.builder(
                    controller: _controller,
                    itemCount: _dataList.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                        _currentIndex == _dataList.length - 1
                            ? button = 'Done'
                            : button = 'Next';
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_dataList[_currentIndex].icon),
                          Text(_dataList[_currentIndex].data),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 16.0),
                            child: Card(
                              color: Colors.white24,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  _dataList[_currentIndex].data1,
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 16.0),
                            child: Card(
                              color: Colors.white24,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  _dataList[_currentIndex].data2,
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 16.0),
                            child: Card(
                              color: Colors.white24,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  _dataList[_currentIndex].data3,
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_dataList.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                    onPressed: _onNextPressed,
                    child: Padding(
                        padding: EdgeInsets.all(16.0), child: Text(button))))
          ],
        ),
      ),
    );
  }
}
