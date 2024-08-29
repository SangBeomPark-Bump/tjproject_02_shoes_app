import 'package:flutter/material.dart';
import 'package:shoes_app/view/sign/sign_in.dart';
import 'detail.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  // 여기에 검색 기능을 구현하세요
                },
              )
            : const Text(''),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBrandSection('Nike', [
              'images/nike1.jpeg',
              'images/nike2.jpeg',
            ]),
            _buildBrandSection('ProsPecs', [
              'images/prospecs1.jpeg',
              'images/prospecs2.jpeg',
            ]),
            _buildBrandSection('NewBalance', [
              'images/newbalance1.jpeg',
              'images/newbalance2.jpeg',
            ]),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()), // SignInPage로 이동
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBrandSection(String brand, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            brand,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      imageUrl: images[index],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // 모서리를 둥글게 설정
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.contain, // 이미지가 잘리지 않도록 조정
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class DetailPage extends StatelessWidget {
  final String imageUrl;

  const DetailPage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0), // 모서리를 둥글게 설정
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain, // 이미지가 잘리지 않도록 조정
            ),
          ),
        ),
      ),
    );
  }
}
