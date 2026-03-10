import 'package:crypto/crypto.dart';

class IdGenerator {
  static String deterministic(String namespace, List<String> parts) {
    final input = '$namespace::${parts.join('::')}';
    return sha1.convert(input.codeUnits).toString();
  }
}
