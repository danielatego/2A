import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/cloud/cloud_storage_constants.dart';
import 'package:two_a/database/cloud/cloud_storage_exceptions.dart';
import 'package:two_a/database/cloud/cloud_work.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
  final cloudUsers = FirebaseFirestore.instance.collection('CloudUsers');
  final cloudWorks = FirebaseFirestore.instance.collection('CloudWorks');

  Future<void> deleteCloudUser({required String cloudUserid}) async {
    try {
      await cloudUsers.doc(cloudUserid).delete();
    } catch (e) {
      throw CouldNotDeleteCloudUserException();
    }
  }

  Future<void> updatedCloudUser({
    required String documentId,
    required String? workContacts,
    required String? homeContacts,
    required String? profilePicture,
  }) async {
    if (workContacts != null) {
      try {
        await cloudUsers.doc(documentId).update(
          {cloudUserWorkContactColumn: workContacts},
        );
      } catch (e) {
        throw CouldNotUpdateCloudUserException();
      }
    }
    if (homeContacts != null) {
      try {
        await cloudUsers.doc(documentId).update(
          {cloudUserHomeContactColumn: homeContacts},
        );
      } catch (e) {
        throw CouldNotUpdateCloudUserException();
      }
    }
    if (profilePicture != null) {
      try {
        await cloudUsers.doc(documentId).update(
          {cloudUserProfPicColumn: profilePicture},
        );
      } catch (e) {
        throw CouldNotUpdateCloudUserException();
      }
    }
  }

  Future<CloudUser> getOrCreateCloudUser({
    required String cloudUserid,
    required String cloudUserEmail,
  }) async {
    try {
      return await cloudUsers
          .where(cloudUserIdColumn, isEqualTo: cloudUserid)
          .limit(1)
          .get()
          .then((value) => CloudUser.fromSnapshot(value.docs[0]));
    } catch (e) {
      return createNewCloudUser(
          cloudUserid: cloudUserid, cloudUserEmail: cloudUserEmail);
    }
  }

  Future<bool> cloudUserExists({
    required String cloudUserId,
  }) async {
    try {
      return await cloudUsers
          .where(cloudUserIdColumn, isEqualTo: cloudUserId)
          .limit(1)
          .get()
          .then((value) => value.docs[0].exists);
    } catch (e) {
      return false;
    }
  }

  Future<CloudUser?> getcloudUser({
    required String cloudUserId,
  }) async {
    try {
      return await cloudUsers
          .where(cloudUserIdColumn, isEqualTo: cloudUserId)
          .limit(1)
          .get()
          .then((value) => CloudUser.fromSnapshot(value.docs[0]));
    } catch (e) {
      return null;
    }
  }

  Future<CloudUser?> getcloudUserwithEmail({
    required String cloudUserEmail,
  }) async {
    try {
      return await cloudUsers
          .where(cloudUserEmailColumn, isEqualTo: cloudUserEmail)
          .limit(1)
          .get()
          .then((value) => CloudUser.fromSnapshot(value.docs[0]));
    } catch (e) {
      return null;
    }
  }

  Future<CloudUser> createNewCloudUser({
    required String cloudUserid,
    required String cloudUserEmail,
  }) async {
    final document = await cloudUsers.add({
      cloudUserIdColumn: cloudUserid,
      cloudUserEmailColumn: cloudUserEmail,
      cloudUserWorkContactColumn: null,
      cloudUserHomeContactColumn: null,
      cloudUserProfPicColumn: null,
    });
    final fetchedNote = await document.get();
    return CloudUser(
      documentId: fetchedNote.id,
      cloudUserId: cloudUserEmail,
      accountEmail: cloudUserEmail,
      homeContacts: null,
      workContacts: null,
      profilePicture: null,
    );
  }

  Future<CloudWork> createNewCloudWork({
    required String assignerId,
    required String assignerEmail,
    required String assignedId,
    required String assignedEmail,
    required bool isHomeWork,
    required String title,
    required int beginTime,
    required int finishTime,
    required String description,
    required String attachedFiles,
  }) async {
    final document = await cloudWorks.add({
      assignerIdColumn: assignerId,
      assignerEmailColumn: assignerEmail,
      assignedIdColumn: assignedId,
      assignedEmailColumn: assignedEmail,
      isHomeWorkColumn: isHomeWork,
      titleColumn: title,
      beginTimeColumn: beginTime,
      finishTimeColumn: finishTime,
      descriptionColumn: description,
      attachedFilesColumn: attachedFiles,
      accountColumn: '',
      accountAttachedFilesColumn: '',
      openColumn: true,
      completedColumn: false,
      archivedColumn: false,
      declinedColumn: false,
      expiredColumn: false,
      pendingColumn: false,
      messageColumn: {},
    });
    final fetchedWork = await document.get();
    return CloudWork(
      documentId: fetchedWork.id,
      assignerId: assignerId,
      assignerEmail: assignerEmail,
      assignedId: assignedId,
      assignedEmail: assignedEmail,
      isHomeWork: isHomeWork,
      title: title,
      beginTime: beginTime,
      finishTime: finishTime,
      description: description,
      attachedFiles: attachedFiles,
      account: '',
      open: true,
      completed: false,
      archived: false,
      declined: false,
      expired: false,
      message: {},
      pending: false,
      accountAttachedFiles: '',
    );
  }

  Future<void> updateCloudWork({
    required String documentId,
    String? account,
    String? uploadedfiles,
    List? message,
    bool? open,
    bool? completed,
    bool? archived,
    bool? declined,
    bool? expired,
    bool? pending,
  }) async {
    if (account != null) {
      try {
        await cloudWorks.doc(documentId).update({accountColumn: account});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (open != null) {
      try {
        await cloudWorks.doc(documentId).update({openColumn: open});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (completed != null) {
      try {
        await cloudWorks.doc(documentId).update({completedColumn: completed});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (archived != null) {
      try {
        await cloudWorks.doc(documentId).update({archivedColumn: archived});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (declined != null) {
      try {
        await cloudWorks.doc(documentId).update({declinedColumn: declined});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (expired != null) {
      try {
        await cloudWorks.doc(documentId).update({expiredColumn: expired});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (pending != null) {
      try {
        await cloudWorks.doc(documentId).update({pendingColumn: pending});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (message != null) {
      try {
        await cloudWorks
            .doc(documentId)
            .update({'$messageColumn.${message[0]}': message[1]});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
    if (uploadedfiles != null) {
      try {
        await cloudWorks
            .doc(documentId)
            .update({accountAttachedFilesColumn: uploadedfiles});
      } catch (e) {
        throw CouldNotUpdateCloudWorkException();
      }
    }
  }

  Stream<List<CloudWork>> allAssignerCloudWorks(
      {required String assignerId, required DateTime date}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: false)
        .where(beginTimeColumn, isGreaterThan: timeLimit(date).lowerLimit)
        .where(beginTimeColumn, isLessThan: timeLimit(date).upperLimit)
        .where(assignerIdColumn, isEqualTo: assignerId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> allAssignerCloudWorks2(
      {required String assignerId, required DateTime date}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: false)
        .where(beginTimeColumn, isGreaterThan: timeLimit(date).lowerLimit)
        .where(beginTimeColumn, isLessThan: timeLimit(date).upperLimit)
        .where(assignerIdColumn, isEqualTo: assignerId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> allAssignedCloudWorks({required String assignedId}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: true)
        .where(assignedIdColumn, isEqualTo: assignedId)
        .limit(20)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> allAssignedCloudWorks2(
      {required String assignedId, required DateTime date}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: true)
        .where(beginTimeColumn, isGreaterThan: timeLimit(date).lowerLimit)
        .where(beginTimeColumn, isLessThan: timeLimit(date).upperLimit)
        .where(assignedIdColumn, isEqualTo: assignedId)
        .limit(20)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> assignedSingleStream(
      {required String assignedId, required int beginTime}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: true)
        .where(assignedIdColumn, isEqualTo: assignedId)
        .where(beginTimeColumn, isEqualTo: beginTime)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> secondAllAssignedCloudWorks(
      {required String assignedId,
      required DocumentSnapshot documentSnapshot,
      required int numbertoadd}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: true)
        .where(assignedIdColumn, isEqualTo: assignedId)
        .startAfterDocument(documentSnapshot)
        .limit(numbertoadd)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> secondAllAssignedCloudWorks2(
      {required String assignedId,
      required DocumentSnapshot documentSnapshot,
      required int numbertoadd,
      required DateTime date}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: true)
        .where(beginTimeColumn, isGreaterThan: timeLimit(date).lowerLimit)
        .where(beginTimeColumn, isLessThan: timeLimit(date).upperLimit)
        .where(assignedIdColumn, isEqualTo: assignedId)
        .startAfterDocument(documentSnapshot)
        .limit(numbertoadd)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }

  Stream<List<CloudWork>> thirdAllAssignedCloudWorks(
      {required String assignedId,
      required DocumentSnapshot documentSnapshot}) {
    final allcloudWorks = cloudWorks
        .orderBy(beginTimeColumn, descending: true)
        .where(assignedIdColumn, isEqualTo: assignedId)
        .startAfterDocument(documentSnapshot)
        .limit(20)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudWork.fromSnapshot(doc)).toList());
    return allcloudWorks.asBroadcastStream();
  }
}

({int upperLimit, int lowerLimit}) timeLimit(DateTime date) {
  return (
    upperLimit: DateTime(date.year, date.month, date.day, 23, 59)
        .microsecondsSinceEpoch,
    lowerLimit:
        DateTime(date.year, date.month, date.day).microsecondsSinceEpoch,
  );
}
