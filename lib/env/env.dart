import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'googleApiKey', obfuscate: true)
  static final String googleApiKey = _Env.googleApiKey;
}
