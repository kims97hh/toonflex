import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/utils.dart';

final tabs = [
  "Top",
  "User",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late TabController _tabController;

  String _searchWord = "";

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _searchWord = _textEditingController.text;
      });
    });

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _onStopSearch();
        });
      }
    });
  }

  void _onSearchSubmitted() {
    if (_searchWord != "") {
      print(_searchWord); // 검색어 전달자 사전작업
    }
  }

  void _onClearTap() {
    _textEditingController.clear();
  }

  void _onStopSearch() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textEditingController.dispose();

    super.dispose();
  } // Controller 를 사용시는 반드시 dispose 를 하여야 한다 (resource 문제)

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              onEditingComplete: _onSearchSubmitted,
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: "Search for ...",
                hintStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.size8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode(context)
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                contentPadding: EdgeInsets.zero,
                icon: GestureDetector(
                  onTap: _onStopSearch,
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                  ),
                ),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: Sizes.size16),
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: isDarkMode(context)
                            ? Colors.grey.shade500
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_searchWord.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: Sizes.size10),
                        child: GestureDetector(
                          onTap: _onClearTap,
                          child: FaIcon(
                            FontAwesomeIcons.solidCircleXmark,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.sliders,
              ),
              tooltip: "Under Construction",
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
            splashFactory:
                NoSplash.splashFactory, // 메터리얼 디자인 효과 ("스플래쉬 효과" 라고 함),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontSize: Sizes.size16,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            indicatorWeight: 3,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(Sizes.size6),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      width > Breakpoints.md ? 5 : 2, // 화면크기에 따라 보여줄 갯수 선택
                  crossAxisSpacing: Sizes.size10,
                  mainAxisSpacing: Sizes.size10,
                  childAspectRatio: 9 / 20),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size4),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 15,
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholderFit: BoxFit.cover,
                            placeholder: "assets/images/placeholder.jpg",
                            image:
                                "https://images.unsplash.com/photo-1583824093698-e81dede1e8d8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      "${constraints.maxWidth}This is a very long caption for my tiktok that im upload just now currently.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Gaps.v8,
                    if (constraints.maxWidth < 200 ||
                        constraints.maxWidth > 250)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                "https://avatars.githubusercontent.com/u/42740714",
                              ),
                            ),
                            Gaps.h4,
                            const Expanded(
                              child: Text(
                                "My avatar is going to be very long",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.h4,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size16,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h5,
                            const Text(
                              "2.5M",
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(fontSize: Sizes.size36),
                ),
              )
          ],
        ),
      ),
    );
  }
}
