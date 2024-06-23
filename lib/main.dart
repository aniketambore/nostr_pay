import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_credentials_manager.dart';
import 'package:nwc_app_final/services/keychain.dart';
import 'package:path/path.dart' as p;

import 'package:nwc_app_final/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'nwc_app.dart';
// TODO: Import nwc package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that the app only supports portrait mode
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // TODO: Initialize Nostr Wallet Connect class
  const nwc = dynamic;

  // Get the application documents directory for storing hydrated bloc state
  final appDir = await getApplicationDocumentsDirectory();

  // Initialize HydratedBloc storage with the application documents directory
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: Directory(p.join(appDir.path, "bloc_storage")),
  );

  runApp(
    BlocProvider<NWCAccountCubit>(
      create: (_) => NWCAccountCubit(
        nwc,
        NWCCredentialsManager(
          keyChain: KeyChain(),
        ),
      ),
      child: NWCApp(),
    ),
  );
}
