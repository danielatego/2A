import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:two_a/database/cloud/cloud_storage_constants.dart';

class CloudWork {
  final String documentId;
  final String assignerId;
  final String assignerEmail;
  final String assignedId;
  final String assignedEmail;
  final bool isHomeWork;
  final String title;
  final int beginTime;
  final int finishTime;
  final String description;
  final String attachedFiles;
  final Map message;
  final String account;
  final String accountAttachedFiles;
  final bool open;
  final bool completed;
  final bool archived;
  final bool declined;
  final bool expired;
  final bool pending;

  CloudWork.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        assignerId = snapshot[assignerIdColumn] as String,
        assignerEmail = snapshot[assignerEmailColumn] as String,
        assignedId = snapshot[assignedIdColumn] as String,
        assignedEmail = snapshot[assignedEmailColumn] as String,
        isHomeWork = snapshot[isHomeWorkColumn] as bool,
        title = snapshot[titleColumn] as String,
        beginTime = snapshot[beginTimeColumn] as int,
        finishTime = snapshot[finishTimeColumn] as int,
        description = snapshot[descriptionColumn] as String,
        attachedFiles = snapshot[attachedFilesColumn] as String,
        accountAttachedFiles = snapshot[accountAttachedFilesColumn] as String,
        open = snapshot[openColumn] as bool,
        completed = snapshot[completedColumn] as bool,
        archived = snapshot[archivedColumn] as bool,
        declined = snapshot[declinedColumn] as bool,
        expired = snapshot[expiredColumn] as bool,
        message = snapshot[messageColumn] as Map,
        account = snapshot[accountColumn] as String,
        pending = snapshot[pendingColumn] as bool;

  const CloudWork({
    required this.documentId,
    required this.assignerId,
    required this.assignedId,
    required this.title,
    required this.isHomeWork,
    required this.beginTime,
    required this.finishTime,
    required this.description,
    required this.account,
    required this.attachedFiles,
    required this.accountAttachedFiles,
    required this.open,
    required this.completed,
    required this.archived,
    required this.declined,
    required this.expired,
    required this.message,
    required this.pending,
    required this.assignerEmail,
    required this.assignedEmail,
  });
}
