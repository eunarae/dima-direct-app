import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart'; // HomePage를 import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonActive = false;

  void _updateButtonState() {
    setState(() {
      _isButtonActive =
          _idController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _idController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 180, decoration: BoxDecoration(color: Colors.white)),
          Container(
            width: 390,
            height: 180,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/dimalogo.svg',
                height: 80,
              ),
            ),
          ),
          // 로그인 폼
          Expanded(
            child: Container(
              width: 390,
              height: 645,
              padding: const EdgeInsets.symmetric(horizontal: 52),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0x3870737C), width: 0.82),
                    ),
                    child: TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '학번/사번을 입력해주세요',
                        hintStyle: TextStyle(
                          color: Color(0xFFA9A9A9),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 비밀번호 입력 필드
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0x3870737C), width: 0.82),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '비밀번호를 입력해주세요.',
                        hintStyle: TextStyle(
                          color: Color(0xFFA9A9A9),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 로그인 버튼
                  ElevatedButton(
                    onPressed: _isButtonActive
                        ? () {
                            // HomePage로 네비게이션
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (_isButtonActive) {
                            return const Color(0xFFFF57B8); // 활성화 시의 색상
                          }
                          return const Color(0xFFF4F4F5); // 비활성화 시의 색상
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (_isButtonActive) {
                            return Colors.white; // 활성화 시의 텍스트 색상
                          }
                          return const Color(0xFFBFBFC1); // 비활성화 시의 텍스트 색상
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 48),
                      ),
                    ),
                    child: const Text(
                      '로그인하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '처음사용자 | 학번/사번 찾기 | 비밀번호 찾기',
                    style: TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
