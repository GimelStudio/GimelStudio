import 'package:uuid/uuid.dart';

class IdService {
  String newId() {
    Uuid uuid = const Uuid();
    return uuid.v4obj().toString();
  }
}
