const createCloudWorkStatusTable = '''
CREATE TABLE IF NOT EXISTS "cloud_work_status" (
  "document_id" TEXT NOT NULL UNIQUE,
  "number_of_messages" INTEGER DEFAULT 0,
  "account_message" TEXT,
  "file_to_upload" TEXT,
  PRIMARY KEY("document_id")
)
''';

const cloudWorkStatusTableName = 'cloud_work_status';
const documentIdColumn = 'document_id';
const numberOfMessagesColumn = 'number_of_messages';
const cloudWorkaccountMessageColumn = 'account_message';
const fileToUploadColumn = 'file_to_upload';

class CloudWorkStatus {
  final String documentId;
  final int? numberOfMessages;
  final String? accountMessage;
  final String? fileToUpload;

  CloudWorkStatus.fromRow(Map<String, Object?> map)
      : documentId = map[documentIdColumn] as String,
        numberOfMessages = map[numberOfMessagesColumn] as int?,
        accountMessage = map[cloudWorkaccountMessageColumn] as String?,
        fileToUpload = map[fileToUploadColumn] as String?;

  @override
  bool operator ==(covariant CloudWorkStatus other) =>
      documentId == other.documentId;

  CloudWorkStatus(
      {required this.documentId,
      this.numberOfMessages,
      this.accountMessage,
      this.fileToUpload});

  @override
  int get hashCode => documentId.hashCode;
}
