import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../data/models/characters_model.dart';
import '../../logic/cubit/characters_cubit.dart';
import '../../logic/cubit/characters_state.dart';
import '../shared/local/constance.dart';
import '../widgets/character_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersDetails extends StatelessWidget {
  const CharactersDetails({Key? key, required this.character})
      : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            buildSliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CharacterInfo(
                            title: 'Job : ', value: character.jobs.join(' / ')),
                        buildDivider(315),
                        CharacterInfo(
                            title: 'Appeared in : ',
                            value: character.categoryForTwoSeries),
                        buildDivider(250),
                        CharacterInfo(
                            title: 'Seasons : ',
                            value: character.appearanceOfSeasons.join(' / ')),
                        buildDivider(280),
                        CharacterInfo(
                            title: 'Status : ',
                            value: character.statusIfDeadOrAlive),
                        buildDivider(300),
                        character.betterCallSaulAppearance.isEmpty
                            ? Container()
                            : CharacterInfo(
                                title: 'Better Call Saul Seasons : ',
                                value: character.betterCallSaulAppearance
                                    .join(' / ')),
                        character.betterCallSaulAppearance.isEmpty
                            ? Container()
                            : buildDivider(150),
                        CharacterInfo(
                            title: 'Actor/Actress : ',
                            value: character.acotrName),
                        buildDivider(300),
                        const SizedBox(height: 20),
                        BlocBuilder<CharactersCubit, CharactersState>(
                            builder: (context, state) {
                          return checkIfQuotesAreLoaded(state);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSliverAppBar() => SliverAppBar(
        backgroundColor: MyColors.myGrey,
        expandedHeight: 600.0,
        pinned: true,
        stretch: true,
        flexibleSpace: FlexibleSpaceBar(
          // centerTitle: true,
          title: Text(
            character.nickName,
            style: TextStyle(
              color: MyColors.myWhite,
            ),
          ),
          background: Hero(
            tag: character.charId,
            child: Image(
              image: NetworkImage(character.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  Widget buildDivider(double value) => Divider(
        color: MyColors.myYellow,
        height: 30.0,
        endIndent: value,
        thickness: 2,
      );
  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is CharacterQuotesLoaded) {
      var quotes = (state).quote;
      if (quotes.isNotEmpty) {
        int randomQuoteIndex = Random().nextInt(quotes.length - 1);
        return Center(
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                shadows: [
                  Shadow(
                    blurRadius: 7,
                    color: MyColors.myYellow,
                    offset: const Offset(0, 0),
                  ),
                ],
                color: MyColors.myWhite),
            child: AnimatedTextKit(
              animatedTexts: [
                FlickerAnimatedText(quotes[randomQuoteIndex].quote),
              ],
              repeatForever: true,
            ),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Center(child: CircularProgressIndicator(color: MyColors.myYellow));
    }
  }
}
