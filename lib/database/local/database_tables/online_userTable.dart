const createOnlineUserTable = ''' 
CREATE TABLE IF NOT EXISTS "online_user"(
  "online_user_id" TEXT NOT NULL UNIQUE,
  "account_email" TEXT NOT NULL UNIQUE,
  "document_id" TEXT NOT NULL UNIQUE,
  "work_contacts" TEXT,
  "home_contacts" TEXT,
  "user_profile_picture" TEXT,
  PRIMARY KEY("online_user_id"),
  FOREIGN KEY("account_email") REFERENCES "users"("email_address")
)
''';

const onlineUserTableName = 'online_user';
const onlineUserIdColumn = 'online_user_id';
const onlineUserEmailColumn = 'account_email';
const onlineUserWorkContactColumn = 'work_contacts';
const onlineUserHomeContactColumn = 'home_contacts';
const onlineUserProfPicColumn = 'user_profile_picture';
const cloudDocumentIdColumn = 'document_id';

class OnlineUser {
  final String onlineUserId;
  final String accountEmail;
  final String? workContacts;
  final String? homeContacts;
  final String? profilePicture;
  final String documentId;

  OnlineUser.fromRow(Map<String, Object?> map)
      : onlineUserId = map[onlineUserIdColumn] as String,
        accountEmail = map[onlineUserEmailColumn] as String,
        documentId = map[cloudDocumentIdColumn] as String,
        workContacts = map[onlineUserWorkContactColumn] as String?,
        homeContacts = map[onlineUserHomeContactColumn] as String?,
        profilePicture = map[onlineUserProfPicColumn] as String?;

  @override
  bool operator ==(covariant OnlineUser other) {
    return onlineUserId == other.onlineUserId;
  }

  @override
  int get hashCode => onlineUserId.hashCode;
  OnlineUser(
      {required this.onlineUserId,
      required this.accountEmail,
      required this.documentId,
      required this.workContacts,
      required this.homeContacts,
      required this.profilePicture});
}
