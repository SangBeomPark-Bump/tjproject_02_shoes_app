import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:shoes_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'detail.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late DatabaseHandler handler;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late int selectIndex;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    selectIndex = 0;
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "brand",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: handler.queryShoes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        selectIndex = index;
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => Detail(), arguments: [
                              snapshot.data![index].seq,
                              snapshot.data![index].shoesname,
                              snapshot.data![index].price,
                              snapshot.data![index].image,
                              snapshot.data![index].size,
                              snapshot.data![index].brand,
                            ]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(16.0), // 모서리를 둥글게 설정
                              child: Image.memory(
                                snapshot.data![index].image,
                                fit: BoxFit.contain, // 이미지가 잘리지 않도록 조정
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
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
                MaterialPageRoute(
                    builder: (context) => const SignInPage()), // SignInPage로 이동
              );
            },
          ),
        ],
      );
    },
  );
}

/*
  Widget _buildBrandSection(String brand, Uint8List images) {
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
        FutureBuilder(
          future: handler.queryShoes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  selectIndex = index;
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => Detail(), arguments: [
                        snapshot.data![index].seq,
                        snapshot.data![index].shoesname,
                        snapshot.data![index].price,
                        snapshot.data![index].size,
                        snapshot.data![index].image,
                        snapshot.data![index].brand,
                      ]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(16.0), // 모서리를 둥글게 설정
                        child: Image.memory(
                          images,
                          fit: BoxFit.contain, // 이미지가 잘리지 않도록 조정
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
*/
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
