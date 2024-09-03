import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_app/view/sign/sign_in.dart';
import 'package:shoes_app/vm/database_handler.dart';
import 'package:shoes_app/vm/database_handler_order.dart';
import 'detail.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late DatabaseHandlerOrder handler;
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandlerOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '검색어를 입력하세요',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    setState(() {});
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
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  !_isSearching
                      ? "Nike"
                      : (_searchController.text.isEmpty ? "" : "Result"),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1.5,
              ),
              FutureBuilder(
                future: _isSearching
                    ? handler.queryShoesByQuery(_searchController.text)
                    : handler.queryNike(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text('검색하신 결과와 일치하는 제품이 없습니다.'),
                          ],
                        ),
                      );
                    } else {
                      return _buildGridView(snapshot.data!);
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Visibility(
                visible: !_isSearching,
                child: const Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
              ),
              Visibility(
                visible: !_isSearching,
                child: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "NewBalance",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !_isSearching,
                child: FutureBuilder(
                  future: handler.queryNewB(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildGridView(snapshot.data!);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible: !_isSearching,
                child: const Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
              ),
              Visibility(
                visible: !_isSearching,
                child: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Prospecs",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !_isSearching,
                child: FutureBuilder(
                  future: handler.queryPro(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildGridView(snapshot.data!);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
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

Widget _buildGridView(List shoes) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.75,
    ),
    itemCount: shoes.length,
    itemBuilder: (context, index) {
      final shoe = shoes[index];
      return GestureDetector(
        onTap: () {
          Get.to(() => Detail(), arguments: [
            shoe.seq,
            shoe.shoesname,
            shoe.price,
            shoe.image,
            shoe.size,
            shoe.brand,
          ]);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    child: SizedBox(
                      width: 170,
                      height: 130,
                      child: Image.memory(
                        shoe.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shoe.brand,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        shoe.shoesname,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("${shoe.price}원",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      Text("SIZE ${shoe.size}", style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
