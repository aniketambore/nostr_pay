import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nwc/nwc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_credentials_manager.dart';
import 'package:nostr_pay/services/keychain.dart';
import 'package:path/path.dart' as p;

import 'package:nostr_pay/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'nwc_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  final nwc = NWC();

  final appDir = await getApplicationDocumentsDirectory();

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
