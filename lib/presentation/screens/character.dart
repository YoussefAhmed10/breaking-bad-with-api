import '../../data/models/characters_model.dart';
import '../../logic/cubit/characters_cubit.dart';
import '../../logic/cubit/characters_state.dart';
import '../shared/local/constance.dart';
import '../widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_offline/flutter_offline.dart';

class AllCharacters extends StatefulWidget {
  const AllCharacters({Key? key}) : super(key: key);

  @override
  State<AllCharacters> createState() => _AllCharactersState();
}

class _AllCharactersState extends State<AllCharacters> {
  List<Character>? allCharacter;
  List<Character>? searchForCharacters;
  final _searchTextController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacter();
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
        backgroundColor: MyColors.myYellow,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: buildappBarAction(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return BlocConsumer<CharactersCubit, CharactersState>(
              listener: (context, state) {
                if (state is CharactersLoaded) {
                  allCharacter = state.chracters;
                } else if (state is CharactersError) {
                  Center(
                    child: Text(
                      'ERROR HAPPEND',
                      style: TextStyle(
                          color: MyColors.myGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Conditional.single(
                  context: context,
                  conditionBuilder: (context) {
                    return state is! CharactersLoading;
                  },
                  widgetBuilder: (context) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        color: MyColors.myGrey,
                        child: Column(
                          children: [
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2 / 3,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                              ),
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: _searchTextController.text.isEmpty
                                  ? allCharacter?.length
                                  : searchForCharacters?.length,
                              itemBuilder: (contex, index) {
                                return CharacterItem(
                                  characterItem:
                                      _searchTextController.text.isEmpty
                                          ? allCharacter![index]
                                          : searchForCharacters![index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  fallbackBuilder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.myYellow,
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return buildNoInterntWidget();
          }
        },
        child: Center(
          child: CircularProgressIndicator(color: MyColors.myYellow),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Find a character...',
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 20),
        border: InputBorder.none,
      ),
      style: TextStyle(color: MyColors.myGrey, fontSize: 20),
      onChanged: (searchedCharacter) {
        addSearchedItemToSearchList(searchedCharacter);
      },
    );
  }

  void addSearchedItemToSearchList(String searchedCharacter) {
    searchForCharacters = allCharacter?.where((character) {
      return character.name.toLowerCase().startsWith(searchedCharacter);
    }).toList();
    setState(() {});
  }

  List<Widget> buildappBarAction() {
    if (_isSearching) {
      return [
        IconButton(
          //todo: lesa badry
          onPressed: () {
            clearSearching();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: strtSearch,
          icon: Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void strtSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void stopSearching() {
    clearSearching();
    setState(() {
      _isSearching = false;
    });
  }

  void clearSearching() {
    setState(() {
      _searchTextController.clear();
    });
  }

  Widget buildNoInterntWidget() {
    return Center(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              'You Are Offline Please Reconnet again ',
              style: TextStyle(
                fontSize: 20,
                color: MyColors.myGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/nointernet.png',
              ),
            )
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}
