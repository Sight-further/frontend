import 'package:deepind/pages/MapPage.dart';
import 'package:deepind/widgets/BottomNavigatrionBar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late List<Widget> pages;
  String _selectedSchool = "";
  Function(String)? _moveToAddress;

  final Map<String, String> schoolAddresses = {
    "미림마이스터고등학교": "서울특별시 관악구 호암로 546",
    "대영고등학교": "서울특별시 영등포구 도림로86길 16"
  };


  @override
  void initState() {
    super.initState();
    pages = [
      MapPage(
        schoolAddresses: schoolAddresses,
        onSearchSchool: (moveToAddressFunc) {
          _moveToAddress = moveToAddressFunc;
        },
      ),
      const MapPage(schoolAddresses: {}),
    ];
  }

  void _searchSchools(String query) {
    if (schoolAddresses.containsKey(query) && _moveToAddress != null) {
      _moveToAddress!(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        title: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _schoolList.where((String option) {
                      return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _selectedSchool = selection;
                      _searchSchools(_selectedSchool);
                    });
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextField(
                      cursorColor: Colors.black,
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: const InputDecoration(
                        hintText: '학교명 검색',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        _selectedSchool = fieldTextEditingController.text;
                        _searchSchools(_selectedSchool);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

final List<String> _schoolList = [
  '미림마이스터고등학교',
  '대영고등학교'
];