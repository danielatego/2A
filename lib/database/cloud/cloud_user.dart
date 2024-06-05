import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:two_a/database/cloud/cloud_storage_constants.dart';

@immutable
class CloudUser {
  final String documentId;
  final String cloudUserId;
  final String accountEmail;
  final String? workContacts;
  final String? homeContacts;
  final String? profilePicture;

  const CloudUser(
      {required this.documentId,
      required this.cloudUserId,
      required this.accountEmail,
      required this.workContacts,
      required this.homeContacts,
      required this.profilePicture});

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        cloudUserId = snapshot[cloudUserIdColumn] as String,
        accountEmail = snapshot[cloudUserEmailColumn] as String,
        workContacts = snapshot[cloudUserWorkContactColumn] as String?,
        homeContacts = snapshot[cloudUserHomeContactColumn] as String?,
        profilePicture = snapshot[cloudUserProfPicColumn] as String?;
}
