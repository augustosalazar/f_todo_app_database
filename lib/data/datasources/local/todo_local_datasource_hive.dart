import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';

class UserLocalDataSourceHive {
  addUser(RandomUser user) {
    Hive.box('users').add(UserDB(
        gender: user.gender,
        name: user.name,
        country: user.city,
        email: user.email,
        picture: user.picture));
  }

  Future<List<RandomUser>> getAllUsers() async {
    return Hive.box('users').values.map((e) {
      return RandomUser(
          id: e.key,
          name: e.name,
          city: e.country,
          email: e.email,
          picture: e.picture,
          gender: e.gender);
    }).toList();
  }

  deleteAll() async {
    logInfo("Deleting all from database");
    await Hive.box('users').clear();
  }

  deleteUser(index) async {
    await Hive.box('users').deleteAt(index);
  }

  updateUser(RandomUser user) async {
    logInfo("Updating entry $user");
    await Hive.box('users').putAt(
        user.id!,
        UserDB(
            gender: user.gender,
            name: user.name,
            country: user.city,
            email: user.email,
            picture: user.picture));
  }
}
