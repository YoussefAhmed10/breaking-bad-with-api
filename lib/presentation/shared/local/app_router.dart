import '../../../data/models/characters_model.dart';
import '../../../data/webservcies/characters_web_services.dart';
import 'package:flutter/material.dart';

import '../../../logic/cubit/characters_cubit.dart';
import '../../screens/character.dart';
import '../../screens/characters_details.dart';
import 'constance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersCubit = CharactersCubit(CharactersWebServices());
  }

  // ignore: body_might_complete_normally_nullable
  Route? genrateRouter(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case characterScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: const AllCharacters(),
          ),
        );
      case characterDetailsScreen:
        final character = routeSettings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => charactersCubit,
            child: CharactersDetails(character: character),
          ),
        );
    }
  }
}
