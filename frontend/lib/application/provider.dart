import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/application/poker.dart';
import 'package:porker2fe/application/port/port.dart';
import 'package:porker2fe/application/user.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/domain/room.dart';

/// core layer -----------------------------------------------------------------

final envProvider = Provider<Env>((ref) => Env());

/// port (application → infrastructure) ---------------------------------------
///
/// 実装は infrastructure 層が [ProviderScope.overrides] で差し込む
/// (`infrastructureOverrides`)。application 層は実装の型を知らない。
/// テストでは任意のフェイクに差し替える。

Never _notOverridden(String name) =>
    throw StateError('$name is not overridden. Did you pass infrastructureOverrides to ProviderScope?');

final porker2ServiceProvider =
    Provider<Porker2Service>((ref) => _notOverridden('porker2ServiceProvider'));

final localStorageProvider =
    Provider<LocalStorage>((ref) => _notOverridden('localStorageProvider'));

/// application layer ----------------------------------------------------------

final userProvider =
    NotifierProvider<User, UserState>(User.new);

final pokerProvider =
    NotifierProvider<Poker, Room>(Poker.new);
