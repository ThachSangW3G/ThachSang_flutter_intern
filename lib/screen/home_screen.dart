import 'package:bai5_bloc_dio/blocs/story_bloc/story_bloc.dart';
import 'package:bai5_bloc_dio/blocs/story_bloc/story_event.dart';
import 'package:bai5_bloc_dio/blocs/story_bloc/story_state.dart';
import 'package:bai5_bloc_dio/components/story_component.dart';
import 'package:bai5_bloc_dio/repositories/story_repository.dart';
import 'package:bai5_bloc_dio/services/internet_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else if (_scrollController.offset <= 200 && _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = false;
      });
    }
  }

  void showNoInternetSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Không có kết nối internet'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void someFunction(BuildContext context) async {
    if (await InternetConnect().isInternetConnected()) {
      // Logic khi có kết nối internet
    } else {
      // Hiển thị SnackBar khi không có kết nối internet
      showNoInternetSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: SizedBox(
            height: 30,
            width: 30,
            child: SvgPicture.asset(
              'assets/icons/menu.svg',
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'My News',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              fontSize: 25),
        ),
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromRGBO(29, 30, 99, 1),
                  Color.fromRGBO(24, 215, 183, 1)
                ]),
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Text(
            'News',
            style: TextStyle(
                fontFamily: 'Open Sans',
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 20),
          ),
        ),
        Expanded(
          child: RepositoryProvider(
            create: (context) => StoryRepository(),
            child: BlocProvider(
              create: (context) => StoryBloc(
                  storyRepository:
                      RepositoryProvider.of<StoryRepository>(context),
                  scrollController: _scrollController),
              child: BlocBuilder<StoryBloc, StoryState>(
                builder: (context, state) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification) {
                        if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                          context.read<StoryBloc>().add(GetStories());
                          if (state.isLoadedLocal == true) {
                            showNoInternetSnackBar(context);
                          }
                        }
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          return StoryComponent(
                            story: state.stories[index],
                          );
                        }, childCount: state.stories.length)),
                        _buildLoadMoreIndicator(context)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ]),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              shape: const CircleBorder(),
              backgroundColor: const Color.fromRGBO(95, 93, 143, 0.7),
              child: SvgPicture.asset('assets/icons/scroll_to_top.svg'),
            )
          : null,
    );
  }
}

Widget _buildLoadMoreIndicator(BuildContext context) {
  return SliverToBoxAdapter(
    child: BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        return state.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 25,
                      height: 25,
                      child: const CircularProgressIndicator()),
                ],
              )
            : const SizedBox.shrink();
      },
    ),
  );
}
