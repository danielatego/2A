const createUserTable = '''
CREATE TABLE IF NOT EXISTS "users" (
	"user_id"	TEXT NOT NULL UNIQUE,
	"email_address"	TEXT NOT NULL UNIQUE,
	"hints_enabled"	TEXT DEFAULT 'true',
	PRIMARY KEY("user_id")
) ''';
const droptable = '''
DROP TABLE IF EXISTS user;
 ''';
const usertableName = 'users';
const idColumn = 'user_id';
const emailColumn = 'email_address';
const hintsEnabledColumn = 'hints_enabled';

class DatabaseUser {
  final String id;
  final String email;
  final bool hintsEnabled;

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as String,
        email = map[emailColumn] as String,
        hintsEnabled = map[hintsEnabledColumn] == "true";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  DatabaseUser({
    required this.hintsEnabled,
    required this.id,
    required this.email,
  });
}
