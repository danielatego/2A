import 'dart:async';
import 'package:two_a/components/DateOnPress/todo_list_view.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/authentication/service.dart';
import 'package:two_a/views/homepage_view.dart';

class Contact {
  final String email = '';
  List<({String id, String email, String name, String ppicAvailable})>
      homeContactList = [];
  List<({String id, String email, String name, String ppicAvailable})>
      workContactList = [];
  late final StreamController<
          List<({String id, String email, String name, String ppicAvailable})>>
      _homeContactsController;
  late final StreamController<
          List<({String id, String email, String name, String ppicAvailable})>>
      _workContactsController;

  //final String userId = Service(FireAuth()).currentUser!.id;
  final LocalDatabaseService localService = LocalDatabaseService();
  final FirebaseCloudStorage cloudService = FirebaseCloudStorage();

  static final Contact _shared = Contact._sharedInstance();
  Contact._sharedInstance() {
    _homeContactsController = StreamController.broadcast(
      onListen: () {
        _homeContactsController.sink.add(homeContactList);
      },
    );
    _workContactsController = StreamController.broadcast(onListen: () {
      _workContactsController.sink.add(workContactList);
    });
  }

  factory Contact() => _shared;
  void resetContactList() {
    homeContactList.clear();
    _homeContactsController.add(homeContactList);
    workContactList.clear();
    _workContactsController.add(workContactList);
  }

  int contactListLength() {
    return homeContactList.length + workContactList.length;
  }

  Future<void> closeController() async {
    _homeContactsController.close();
    _workContactsController.close();
  }

  Future<void> cacheContacts() async {
    final list = await litercontactList(homecontacts: true);
    final list2 = await litercontactList(homecontacts: false);

    if (list != null) {
      for (var element in list) {
        homeContactList.removeWhere((eleme) => eleme.id == element.id);
        homeContactList.add((
          email: element.email,
          id: element.id,
          name: element.name,
          ppicAvailable: element.ppicAvailable
        ));
      }
      _homeContactsController.add(homeContactList);
    }
    if (list2 != null) {
      for (var element in list2) {
        workContactList.removeWhere((eleme) => eleme.id == element.id);
        workContactList.add((
          email: element.email,
          id: element.id,
          name: element.name,
          ppicAvailable: element.ppicAvailable
        ));
      }
      _workContactsController.add(workContactList);
    }
  }

  Future<OnlineUser> get currentUser async {
    FireAuth().initialize();
    final String userId = Service(FireAuth()).currentUser!.id;
    return await localService.getOnlineUser(id: userId);
  }

  Future<CloudUser> get cloudUser async {
    OnlineUser user = await currentUser;
    return cloudService.getOrCreateCloudUser(
        cloudUserid: user.onlineUserId, cloudUserEmail: user.accountEmail);
  }

  Future<Map<String, (String, String, String, String, String)>?>
      get litehomeContacts async {
    OnlineUser user = await currentUser;
    String? homeContactsString;
    if (user.homeContacts?.isEmpty == true ||
        user.homeContacts == null && user.workContacts?.isEmpty == false) {
      homeContactsString = user.workContacts;
    }
    if (user.homeContacts?.isEmpty == false &&
            user.workContacts?.isEmpty == true ||
        user.workContacts == null) {
      homeContactsString = user.homeContacts;
    }
    if (user.homeContacts?.isEmpty == false &&
        user.workContacts?.isEmpty == false) {
      homeContactsString = '${user.homeContacts},${user.workContacts}';
    }

    if (homeContactsString == null || homeContactsString.length < 3) {
      return null;
    } else {
      Map<String, (String, String, String, String, String)> homeContactMap = {};

      int positionOflastbracket = homeContactsString.lastIndexOf(RegExp(r'\)'));

      String stringWOlastbracket =
          homeContactsString.substring(0, positionOflastbracket);

      String removeCurlyBracesandfirstBrackets =
          stringWOlastbracket.replaceAll(RegExp(r'}|{|\('), '');
      String removeSpaces =
          removeCurlyBracesandfirstBrackets.replaceAll(RegExp(r'' ''), '');
      List<String> listString = removeSpaces.split(RegExp(r'\),'));
      final path = await pathtoProfilePicture(null);
      final clouduploadPath = '${await pathtoCloudUploadedPicture()}/';
      for (String user in listString) {
        List userElements = user.split(RegExp(r':'));
        List valueElements = userElements[1].split(RegExp(r','));

        //returns the current profile picture
        // var updateppic = isImageAvailable(
        //     '${await pathtoProfilePicture(null)}/${userElements[0].toString().trim()}.jpg');

        homeContactMap.addAll({
          userElements[0].toString().trim(): (
            valueElements[0].toString().trim(),
            valueElements[1].toString().trim(),
            valueElements[1].toString().trim(),
            //updateppic.toString(),//adjudted to check speed increase
            path, //profilepic path
            clouduploadPath //clouduploaded docs path
          )
        });
      }
      return homeContactMap;
    }
  }

  Future<Map<String, (String, String, String)>?> get literhomeContacts async {
    OnlineUser user = await currentUser;
    String? homeContactsString = user.homeContacts;
    if (homeContactsString == null || homeContactsString.length < 3) {
      return null;
    } else {
      Map<String, (String, String, String)> homeContactMap = {};

      int positionOflastbracket = homeContactsString.lastIndexOf(RegExp(r'\)'));

      String stringWOlastbracket =
          homeContactsString.substring(0, positionOflastbracket);

      String removeCurlyBracesandfirstBrackets =
          stringWOlastbracket.replaceAll(RegExp(r'}|{|\('), '');
      String removeSpaces =
          removeCurlyBracesandfirstBrackets.replaceAll(RegExp(r'' ''), '');
      List<String> listString = removeSpaces.split(RegExp(r'\),'));
      for (String user in listString) {
        List userElements = user.split(RegExp(r':'));
        List valueElements = userElements[1].split(RegExp(r','));

        //returns the current profile picture
        // var updateppic = isImageAvailable(
        //     '${await pathtoProfilePicture(null)}/${userElements[0].toString().trim()}.jpg');

        homeContactMap.addAll({
          userElements[0].toString().trim(): (
            valueElements[0].toString().trim(),
            valueElements[1].toString().trim(),
            valueElements[2]
                .toString()
                .trim(), //adjusted to check speed increase

            //updateppic.toString(),
          )
        });
      }
      return homeContactMap;
    }
  }

  Future<Map<String, (String, String, String)>?> get literworkContacts async {
    OnlineUser user = await currentUser;
    String? workContactsString = user.workContacts;
    if (workContactsString == null || workContactsString.length < 3) {
      return null;
    } else {
      Map<String, (String, String, String)> workContactMap = {};

      int positionOflastbracket = workContactsString.lastIndexOf(RegExp(r'\)'));

      String stringWOlastbracket =
          workContactsString.substring(0, positionOflastbracket);

      String removeCurlyBracesandfirstBrackets =
          stringWOlastbracket.replaceAll(RegExp(r'}|{|\('), '');
      String removeSpaces =
          removeCurlyBracesandfirstBrackets.replaceAll(RegExp(r'' ''), '');
      List<String> listString = removeSpaces.split(RegExp(r'\),'));
      for (String user in listString) {
        List userElements = user.split(RegExp(r':'));
        List valueElements = userElements[1].split(RegExp(r','));

        //returns the current profile picture
        // var updateppic = isImageAvailable(
        //     '${await pathtoProfilePicture(null)}/${userElements[0].toString().trim()}.jpg');

        workContactMap.addAll({
          userElements[0].toString().trim(): (
            valueElements[0].toString().trim(),
            valueElements[1].toString().trim(),
            valueElements[2].toString().trim(), //adjusted for speed increase
            //updateppic.toString(),
          )
        });
      }
      return workContactMap;
    }
  }

  Future<List<({String id, String email, String name, String ppicAvailable})>?>
      litercontactList({required bool homecontacts}) async {
    final Map<String, (String, String, String)>? map;
    List<({String id, String email, String name, String ppicAvailable})>
        contactList = [];
    if (homecontacts) {
      map = await literhomeContacts;
    } else {
      map = await literworkContacts;
    }
    if (map != null) {
      map.forEach((key, value) {
        contactList.add((
          id: key,
          email: value.$1,
          name: value.$2,
          ppicAvailable: value.$3
        ));
      });
    }

    return contactList;
  }

  void get heavyhomeContacts async {
    OnlineUser user = await currentUser;
    String? homeContactsString = user.homeContacts;
    if (homeContactsString == null || homeContactsString.length < 3) {
      return null;
    } else {
      Map<String, (String, String, String)> homeContactMap = {};

      int positionOflastbracket = homeContactsString.lastIndexOf(RegExp(r'\)'));

      String stringWOlastbracket =
          homeContactsString.substring(0, positionOflastbracket);

      String removeCurlyBracesandfirstBrackets =
          stringWOlastbracket.replaceAll(RegExp(r'}|{|\('), '');
      String removeSpaces =
          removeCurlyBracesandfirstBrackets.replaceAll(RegExp(r'' ''), '');
      List<String> listString = removeSpaces.split(RegExp(r'\),'));

      for (String user in listString) {
        List userElements = user.split(RegExp(r':'));
        List valueElements = userElements[1].split(RegExp(r','));

        //returns the current profile picture
        var updateppic =
            await pathtoContactProfilePic(userElements[0].toString().trim());

        homeContactMap.addAll({
          userElements[0].toString().trim(): (
            valueElements[0].toString().trim(),
            valueElements[1].toString().trim(),
            updateppic.toString()
          )
        });
      }
      await localService.updateOnlineUser(
        onlineUser: user,
        workContacts: null,
        homeContacts: homeContactMap.toString(),
        profilePicture: null,
      );
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        workContacts: null,
        homeContacts: homeContactMap.toString(),
        profilePicture: null,
      );
    }
  }

  Future<List<({String id, String email, String name, String ppicAvailable})>?>
      contactList({required bool homecontacts}) async {
    final Map<String, (String, String, String)>? map;
    List<({String id, String email, String name, String ppicAvailable})>
        contactList = [];
    if (homecontacts) {
      map = await literhomeContacts;
    } else {
      map = await literworkContacts;
    }
    if (map != null) {
      map.forEach((key, value) {
        contactList.add((
          id: key,
          email: value.$1,
          name: value.$2,
          ppicAvailable: value.$3
        ));
      });
    }

    return contactList;
  }

  Stream<List<({String id, String email, String name, String ppicAvailable})>>
      contactListStream(bool ishomeContact) {
    if (ishomeContact) {
      return _homeContactsController.stream;
    }
    return _workContactsController.stream;
  }

  void get heavyworkContacts async {
    OnlineUser user = await currentUser;
    String? workContactsString = user.workContacts;
    if (workContactsString == null || workContactsString.length < 3) {
      return null;
    } else {
      Map<String, (String, String, String)> workContactMap = {};

      int positionOflastbracket = workContactsString.lastIndexOf(RegExp(r'\)'));

      String stringWOlastbracket =
          workContactsString.substring(0, positionOflastbracket);

      String removeCurlyBracesandfirstBrackets =
          stringWOlastbracket.replaceAll(RegExp(r'}|{|\('), '');
      String removeSpaces =
          removeCurlyBracesandfirstBrackets.replaceAll(RegExp(r'' ''), '');

      List<String> listString = removeSpaces.split(RegExp(r'\),'));

      for (String user in listString) {
        List userElements = user.split(RegExp(r':'));
        List valueElements = userElements[1].split(RegExp(r','));
        //returns the current profile picture

        var updateppic =
            await pathtoContactProfilePic(userElements[0].toString().trim());

        workContactMap.addAll({
          userElements[0].toString().trim(): (
            valueElements[0].toString().trim(),
            valueElements[1].toString().trim(),
            updateppic.toString()
          )
        });
      }
      await localService.updateOnlineUser(
          onlineUser: user,
          homeContacts: null,
          workContacts: workContactMap.toString(),
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: null,
        workContacts: workContactMap.toString(),
        profilePicture: null,
      );
      //print(workContactMap);
    }
  }

  Future<bool> get ishomeContactEmpty async {
    return await literhomeContacts == null;
  }

  Future<bool> get isworkContactEmpty async {
    return await literworkContacts == null;
  }

  Future<bool> existsInHomeContacts(String userId) async {
    if (await ishomeContactEmpty) {
      return false;
    } else {
      Map? homeCon = await literhomeContacts;
      if (homeCon != null) {
        return homeCon.containsKey(userId.trim());
      } else {
        return false;
      }
    }
  }

  Future<bool> existsInWorkContacts(String userId) async {
    if (await isworkContactEmpty) {
      return false;
    } else {
      Map? workCon = await literworkContacts;
      if (workCon != null) {
        return workCon.containsKey(userId.trim());
      } else {
        return false;
      }
    }
  }

  Future<bool> addHomeContact({
    required String userId,
    required userEmail,
    required name,
  }) async {
    OnlineUser user = await currentUser;
    bool iscontactppic = await pathtoContactProfilePic(userId);
    if (await ishomeContactEmpty) {
      homeContactList.add((
        email: userEmail,
        id: userId,
        name: name,
        ppicAvailable: iscontactppic.toString()
      ));
      _homeContactsController.add(homeContactList);
      await localService.updateOnlineUser(
        onlineUser: user,
        workContacts: null,
        homeContacts:
            '{$userId:($userEmail,$name,${iscontactppic.toString()})}',
        profilePicture: null,
      );
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        workContacts: null,
        homeContacts:
            '{$userId:($userEmail,$name,${iscontactppic.toString()})}',
        profilePicture: null,
      );
      return true;
    } else {
      bool exists = await existsInHomeContacts(userId);
      if (exists) {
        return true;
      } else {
        Map<String, (String, String, String)>? homeCon =
            await literhomeContacts;

        homeCon!.addAll({
          userId: (
            userEmail,
            name,
            iscontactppic.toString(),
          )
        });
        homeContactList.add((
          email: userEmail,
          id: userId,
          name: name,
          ppicAvailable: iscontactppic.toString()
        ));
        _homeContactsController.add(homeContactList);
        await localService.updateOnlineUser(
          onlineUser: user,
          workContacts: null,
          homeContacts: homeCon.toString(),
          profilePicture: null,
        );
        await cloudService.updatedCloudUser(
          documentId: user.documentId,
          workContacts: null,
          homeContacts: homeCon.toString(),
          profilePicture: null,
        );
        return true;
      }
    }
  }

  Future<bool> addWorkContact({
    required String userId,
    required userEmail,
    required name,
  }) async {
    OnlineUser user = await currentUser;
    {
      bool iscontactppic = await pathtoContactProfilePic(userId);
      if (await isworkContactEmpty) {
        workContactList.add((
          email: userEmail,
          id: userId,
          name: name,
          ppicAvailable: iscontactppic.toString()
        ));
        _workContactsController.add(workContactList);
        await localService.updateOnlineUser(
            onlineUser: user,
            homeContacts: null,
            workContacts:
                '{$userId:($userEmail,$name,${iscontactppic.toString()})}',
            profilePicture: null);
        await cloudService.updatedCloudUser(
          documentId: user.documentId,
          homeContacts: null,
          workContacts:
              '{$userId:($userEmail,$name,${iscontactppic.toString()})}',
          profilePicture: null,
        );
        return true;
      } else {
        if (await existsInWorkContacts(userId)) {
          return true;
        } else {
          Map<String, (String, String, String)>? workCon =
              await literworkContacts;
          workCon!.addAll({
            userId: (
              userEmail,
              name,
              iscontactppic.toString(),
            )
          });
          workContactList.add((
            email: userEmail,
            id: userId,
            name: name,
            ppicAvailable: iscontactppic.toString()
          ));
          _workContactsController.add(workContactList);
          await localService.updateOnlineUser(
              onlineUser: user,
              homeContacts: null,
              workContacts: workCon.toString(),
              profilePicture: null);
          await cloudService.updatedCloudUser(
            documentId: user.documentId,
            homeContacts: null,
            workContacts: workCon.toString(),
            profilePicture: null,
          );
          return true;
        }
      }
    }
  }

  Future<bool?> deleteHomeContact({required String userId}) async {
    Map<String, (String, String, String)>? homecontactsMap =
        await literhomeContacts;
    String stringtoUpdateDataBase;
    OnlineUser user = await currentUser;
    if (homecontactsMap != null) {
      homecontactsMap.removeWhere((key, value) => key == userId.trim());
      if (homecontactsMap.isEmpty) {
        stringtoUpdateDataBase = '';
      } else {
        stringtoUpdateDataBase = homecontactsMap.toString();
      }
      homeContactList.removeWhere((element) => element.id == userId);
      _homeContactsController.add(homeContactList);
      await localService.updateOnlineUser(
          onlineUser: await currentUser,
          workContacts: null,
          homeContacts: stringtoUpdateDataBase,
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: stringtoUpdateDataBase,
        workContacts: null,
        profilePicture: null,
      );
      return true;
    }
    return false;
  }

  Future<bool> deleteWorkContact({required String userId}) async {
    Map<String, (String, String, String)>? workcontactsMap =
        await literworkContacts;
    OnlineUser user = await currentUser;
    String stringtoUpdateDataBase;
    if (workcontactsMap != null) {
      workcontactsMap.removeWhere((key, value) => key == userId.trim());
      if (workcontactsMap.isEmpty) {
        stringtoUpdateDataBase = '';
      } else {
        stringtoUpdateDataBase = workcontactsMap.toString();
      }
      workContactList.removeWhere((element) => element.id == userId);
      _workContactsController.add(workContactList);
      await localService.updateOnlineUser(
          onlineUser: user,
          workContacts: stringtoUpdateDataBase,
          homeContacts: null,
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: null,
        workContacts: stringtoUpdateDataBase,
        profilePicture: null,
      );
      return true;
    }
    return false;
  }

  Future<bool> exchangehometowork(
      {required String userId,
      required String userEmail,
      required String name,
      required String isppicAvailable}) async {
    OnlineUser user = await currentUser;
    await deleteHomeContact(userId: userId);
    //bool iscontactppic = await pathtoContactProfilePic(userId);
    if (await isworkContactEmpty) {
      workContactList.add((
        email: userEmail,
        id: userId,
        name: name,
        ppicAvailable: isppicAvailable
      ));
      _workContactsController.add(workContactList);
      await localService.updateOnlineUser(
          onlineUser: user,
          homeContacts: null,
          workContacts: '{$userId:($userEmail,$name,$isppicAvailable)}',
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: null,
        workContacts: '{$userId:($userEmail,$name,$isppicAvailable)}',
        profilePicture: null,
      );
      return true;
    } else {
      Map<String, (String, String, String)>? workCon = await literworkContacts;
      workCon!.addAll({
        userId: (
          userEmail,
          name,
          isppicAvailable,
        )
      });
      workContactList.add((
        email: userEmail,
        id: userId,
        name: name,
        ppicAvailable: isppicAvailable
      ));
      _workContactsController.add(workContactList);
      await localService.updateOnlineUser(
          onlineUser: user,
          homeContacts: null,
          workContacts: workCon.toString(),
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: null,
        workContacts: workCon.toString(),
        profilePicture: null,
      );
      return true;
    }
  }

  Future<bool> exchangeworktohome(
      {required String userId,
      required String userEmail,
      required String name,
      required String isppicAvailable}) async {
    OnlineUser user = await currentUser;
    await deleteWorkContact(userId: userId);
    //bool iscontactppic = await pathtoContactProfilePic(userId);
    if (await ishomeContactEmpty) {
      homeContactList.add((
        email: userEmail,
        id: userId,
        name: name,
        ppicAvailable: isppicAvailable
      ));
      _homeContactsController.add(homeContactList);
      await localService.updateOnlineUser(
          onlineUser: user,
          homeContacts: '{$userId:($userEmail,$name,$isppicAvailable)}',
          workContacts: null,
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: '{$userId:($userEmail,$name,$isppicAvailable)}',
        workContacts: null,
        profilePicture: null,
      );
      return true;
    } else {
      Map<String, (String, String, String)>? homCon = await literhomeContacts;
      homCon!.addAll({
        userId: (
          userEmail,
          name,
          isppicAvailable,
        )
      });
      homeContactList.add((
        email: userEmail,
        id: userId,
        name: name,
        ppicAvailable: isppicAvailable
      ));
      _homeContactsController.add(homeContactList);
      await localService.updateOnlineUser(
          onlineUser: user,
          homeContacts: homCon.toString(),
          workContacts: null,
          profilePicture: null);
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        homeContacts: homCon.toString(),
        workContacts: null,
        profilePicture: null,
      );
      return true;
    }
  }

  Future<bool> updateContact({
    required String userId,
    required String name,
    required bool isHomeContact,
  }) async {
    final user = await currentUser;
    Map<String, (String, String, String)>? homeContactsMap = {};
    Map<String, (String, String, String)>? workContactsMap = {};
    if (isHomeContact) {
      homeContactsMap = await literhomeContacts;
      homeContactsMap?.update(userId, (value) => (value.$1, name, value.$3));
      final updateString = homeContactsMap.toString();
      await localService.updateOnlineUser(
        onlineUser: user,
        workContacts: null,
        homeContacts: updateString,
        profilePicture: null,
      );
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        workContacts: null,
        homeContacts: updateString,
        profilePicture: null,
      );
      return true;
    } else {
      workContactsMap = await literworkContacts;
      workContactsMap?.update(userId, (value) => (value.$1, name, value.$3));
      final updateString = workContactsMap.toString();
      await localService.updateOnlineUser(
        onlineUser: user,
        workContacts: updateString,
        homeContacts: null,
        profilePicture: null,
      );
      await cloudService.updatedCloudUser(
        documentId: user.documentId,
        workContacts: updateString,
        homeContacts: null,
        profilePicture: null,
      );
      return true;
    }
  }
}
