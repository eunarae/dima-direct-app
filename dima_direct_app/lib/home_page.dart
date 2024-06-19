import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            color: Colors.white,
          ),
          Container(
            width: 390,
            height: 120,
            color: Colors.white,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/dimalogo.svg',
                height: 80,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 306,
                    height: 80.07,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 86.22,
                          top: 0,
                          child: Container(
                            width: 219.78,
                            height: 80.07,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFE8E8E8)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    '앱콘텐츠개발 수업듣기',
                                    style: TextStyle(
                                      color: Color(0xFF454545),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    '08:10 am - 08:50 am',
                                    style: TextStyle(
                                      color: Color(0xFF454545),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      letterSpacing: 0.30,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text(
                                      '40 mins',
                                      style: TextStyle(
                                        color: Color(0xFF454545),
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        height: 1.2,
                                        letterSpacing: 0.30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 80.66,
                            height: 80.07,
                            decoration: ShapeDecoration(
                              color: Color(0xFFF59E0B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '다음 일정',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.51,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w900,
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    '2024-04-24',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 500,
              height: 645,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(color: Colors.white),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/schedule.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/department.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/electronic attendance.svg'),
                  _buildFeatureButton(
                      'https://everytime.kr', 'assets/icons/everytime.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/bustable.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/intranet.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/contacts.svg'),
                  _buildFeatureButton(
                      'https://www.dima.ac.kr/?p=78', 'assets/icons/LMS.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/notice.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/library.svg'),
                  _buildFeatureButton(
                      'https://www.dima.ac.kr/?p=78', 'assets/icons/print.svg'),
                  _buildFeatureButton('https://www.dima.ac.kr/?p=78',
                      'assets/icons/rental.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(String url, String iconPath) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {},
      onExit: (_) {},
      child: GestureDetector(
        onTap: () {
          _launchURL(url);
        },
        child: SvgPicture.asset(
          iconPath,
          width: 90,
          height: 110,
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
