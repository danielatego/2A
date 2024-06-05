import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:two_a/database/local/database_exceptions.dart';
import 'package:two_a/database/local/database_tables/cloud_work_status.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/database/local/database_tables/personal_diary.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/database/local/database_tables/user_table.dart';
import 'package:two_a/extensions/list/filter.dart';

const String dbName = '2aDatabase';

class LocalDatabaseService {
  bool? cachetodos;
  Database? _db;
  DatabaseUser? _user;
  OnlineUser? _onlineUser;
  List<PersonalTodo> _todos = [];
  List<PersonalDiary> _diaries = [];
  final Map<String, ({int messageCount, String message, String upload})>
      _cloudworkMap = {};

  static final LocalDatabaseService _shared =
      LocalDatabaseService._sharedInstance();
  LocalDatabaseService._sharedInstance() {
    _todosStreamController =
        StreamController<List<PersonalTodo>>.broadcast(onListen: () {
      _todosStreamController.sink.add(_todos);
    });
    _todosStreamController2 =
        StreamController<List<PersonalTodo>>.broadcast(onListen: () {
      _todosStreamController2.sink.add(_todos);
    });
    _diariesStreamController =
        StreamController<List<PersonalDiary>>.broadcast(onListen: () {
      _diariesStreamController.sink.add(_diaries);
    });
    _cloudWorkStatusStreamController = StreamController<
            Map<String,
                ({int messageCount, String message, String upload})>>.broadcast(
        onListen: () {
      _cloudWorkStatusStreamController.add(_cloudworkMap);
    });
  }
  factory LocalDatabaseService() => _shared;

  late final StreamController<List<PersonalTodo>> _todosStreamController;
  late final StreamController<List<PersonalTodo>> _todosStreamController2;

  late final StreamController<List<PersonalDiary>> _diariesStreamController;

  late final StreamController<
          Map<String, ({int messageCount, String message, String upload})>>
      _cloudWorkStatusStreamController;

  Stream<List<PersonalTodo>> get alltodos {
    return (_todosStreamController.stream.map(
      (event) =>
          event.where((element) => element.creatorOfTask == _user!.id).toList(),
    ));
  }

  Stream<Map<String, ({int messageCount, String message, String upload})>>
      get allCloudWorkStatuses {
    return (_cloudWorkStatusStreamController.stream);
  }

  Stream<List<PersonalTodo>> get allTodos =>
      _todosStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.creatorOfTask == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllTodos();
        }
      });
  Stream<List<PersonalDiary>> get allDiaries =>
      _diariesStreamController.stream.filter((diary) {
        final currentUser = _user;
        if (currentUser != null) {
          return diary.creatorOfDiary == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllTodos();
        }
      });
  Stream<List<PersonalTodo>> theDaysTodos(
      DatabaseUser user, DateTime date, bool? isweek, List<DateTime>? week) {
    return _todosStreamController.stream.filter((daysTodo) {
      final todoDateOfCreation = DateTime.parse(daysTodo.dateOfCreation);
      bool testpassed;
      if (isweek ?? false) {
        if (week != null) {
          testpassed = dateadjust(week[0]).isBefore(todoDateOfCreation) &&
              todoDateOfCreation.isBefore(dateadjust2(week[1]));
        } else {
          testpassed = false;
        }
      } else {
        testpassed = todoDateOfCreation.year == date.year &&
            todoDateOfCreation.month == date.month &&
            todoDateOfCreation.day == date.day;
      }
      return daysTodo.creatorOfTask == user.id && testpassed;
    });
  }

  Stream<List<PersonalTodo>> theDaysTodos2(
      DatabaseUser user, DateTime date, bool? isweek, List<DateTime>? week) {
    return _todosStreamController2.stream.filter((daysTodo) {
      final todoDateOfCreation = DateTime.parse(daysTodo.dateOfCreation);
      bool testpassed;
      if (isweek ?? false) {
        if (week != null) {
          testpassed = dateadjust(week[0]).isBefore(todoDateOfCreation) &&
              todoDateOfCreation.isBefore(dateadjust2(week[1]));
        } else {
          testpassed = false;
        }
      } else {
        testpassed = todoDateOfCreation.year == date.year &&
            todoDateOfCreation.month == date.month &&
            todoDateOfCreation.day == date.day;
      }
      return daysTodo.creatorOfTask == user.id && testpassed;
    });
  }

  Stream<List<PersonalDiary>> diarycollection(
      DatabaseUser user, List<DateTime> period) {
    return _diariesStreamController.stream.filter((diary) {
      final diaryDateOfCreation = DateTime.parse(diary.dateOfCreation);
      bool testpassed = dateadjust(period[0]).isBefore(diaryDateOfCreation) &&
          diaryDateOfCreation.isBefore(dateadjust2(period[1]));
      return diary.creatorOfDiary == user.id && testpassed;
    });
  }

  Future<Iterable<PersonalTodo>> getAllTodos() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final todos = await db.query(personalTaskTableName);
    return todos.map((todos) => PersonalTodo.fromRow(todos));
  }

  Future<Iterable<PersonalDiary>> getAllDiaries() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final diaries = await db.query(personDiaryTableName);
    return diaries.map((diary) => PersonalDiary.fromRow(diary));
  }

  Future<List<CloudWorkStatus>> getAllCloudWorkStatus() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final cloudWorkStatuses = await db.query(cloudWorkStatusTableName);
    return cloudWorkStatuses
        .map((statuses) => CloudWorkStatus.fromRow(statuses))
        .toList();
  }

  Future<void> _cacheTodos() async {
    final allTodos = await getAllTodos();
    _todos = allTodos.toList();
    _todosStreamController.add(_todos);
  }

  Future<void> _cacheDiaries() async {
    final allDiaries = await getAllDiaries();
    _diaries = allDiaries.toList();
    _diariesStreamController.add(_diaries);
  }

  Future<void> _cacheCloudWorkStatus() async {
    final cloudWorkStatuslist = await getAllCloudWorkStatus();
    for (CloudWorkStatus element in cloudWorkStatuslist) {
      Map<String, ({int messageCount, String message, String upload})> newmap =
          {
        element.documentId: ((
          messageCount: element.numberOfMessages ?? 0,
          message: element.accountMessage ?? '',
          upload: element.fileToUpload ?? '',
        ))
      };
      _cloudworkMap.addAll(newmap);
    }
    _cloudWorkStatusStreamController.add(_cloudworkMap);
  }

  Future<PersonalTodo> createTodo({required DateTime date}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //final currentDate = DateTime.now().toString();
    if (_user != null) {
      final todoId = await db.insert(
        personalTaskTableName,
        {
          creatorOfTaskColumn: _user!.id,
          titleColumn: '',
          startTimeColumn: '',
          endTimeColumn: '',
          dateofCreationColumn: date.toString(),
          alertTimeColumn: '',
          alertFrequencyColumn: '',
          descriptionColumn: '',
          fileAttachmentColumn: 'IMG-20230929-WA0001.jpg',
          accountAttachmentColumn: '',
          accountMessageColumn: ''
        },
      );
      final todo = PersonalTodo(
        taskId: todoId,
        creatorOfTask: _user!.id,
        title: '',
        done: false,
        startTime: null,
        endTime: null,
        dateOfCreation: date.toString(),
        alertTime: null,
        alertFrequency: null,
        fileAttachment: null,
        description: null,
        isAllDay: false,
        archived: false,
        accountAttachment: null,
        accountMessage: null,
      );
      _todos.add(todo);
      _todosStreamController.add(_todos);
      return todo;
    } else {
      throw CouldNotFindUser();
    }
  }

  Future<CloudWorkStatus> createCloudWork({required String documentId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(
        cloudWorkStatusTableName,
        {
          documentIdColumn: documentId,
          numberOfMessagesColumn: 0,
          cloudWorkaccountMessageColumn: '',
          fileToUploadColumn: ''
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    final Map<String, ({int messageCount, String message, String upload})>
        newcloudworkMap = {
      documentId: ((messageCount: 0, message: '', upload: ''))
    };

    _cloudworkMap.addAll(newcloudworkMap);
    _cloudWorkStatusStreamController.add(_cloudworkMap);

    return CloudWorkStatus(
        documentId: documentId,
        numberOfMessages: 0,
        accountMessage: '',
        fileToUpload: '');
  }

  Future<PersonalDiary> createDiary(
    String date,
    String email,
    String id,
  ) async {
    await getorCreateUser(email: email, id: id);
    if (_user != null) {
      await _ensureDbIsOpen();
      final db = _getDatabaseOrThrow();

      var record2 = await db.query(
        personDiaryTableName,
        where: '$dateColumn=?',
        whereArgs: [date],
      );

      var record = await db.query(
        personDiaryTableName,
        where: '$dateColumn=?',
        whereArgs: [date + _user!.id],
      );

      if (record.isEmpty) {
        record = record2;
      }

      PersonalDiary? diaryFound;
      try {
        final diaryFind = PersonalDiary.fromRow(record.first);

        if (diaryFind.creatorOfDiary == _user!.id) {
          diaryFound = diaryFind;
          return diaryFound;
        } else {
          final diaryId = await db.insert(personDiaryTableName, {
            creatorOfDiaryColumn: _user!.id,
            dateColumn: date + _user!.id,
            dateofCreationDiaryColumn: date,
            diaryAttachedColumn: null,
            diaryEntryColumn: null
          });
          final newdiary = PersonalDiary(
              diaryId: diaryId,
              creatorOfDiary: _user!.id,
              date: date + _user!.id,
              dateOfCreation: date,
              diaryAttached: null,
              diaryEntry: null);
          _diaries.add(newdiary);
          _diariesStreamController.add(_diaries);
          return newdiary;
        }
      } catch (e) {
        final diaryId = await db.insert(personDiaryTableName, {
          creatorOfDiaryColumn: _user!.id,
          dateColumn: date,
          dateofCreationDiaryColumn: date,
          diaryAttachedColumn: null,
          diaryEntryColumn: null
        });
        final newdiary = PersonalDiary(
            diaryId: diaryId,
            creatorOfDiary: _user!.id,
            date: date,
            dateOfCreation: date,
            diaryAttached: null,
            diaryEntry: null);
        _diaries.add(newdiary);
        _diariesStreamController.add(_diaries);
        return newdiary;
      }
    } else {
      throw CouldNotFindUser();
    }
  }

  Future<void> deleteTodo({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db
        .delete(personalTaskTableName, where: 'task_id = ?', whereArgs: [id]);
    if (deletedCount == 0) {
      throw CouldnotDeleteTodo();
    } else {
      _todos.removeWhere((element) => element.taskId == id);
      _todosStreamController.add(_todos);
    }
  }

  Future<void> deleteDiary({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(personDiaryTableName,
        where: '$diaryIdColumn=?', whereArgs: [id]);
    if (deleteCount == 0) {
      throw CouldnotDeleteDiary();
    }
    _diaries.removeWhere((element) => element.diaryId == id);
    _diariesStreamController.add(_diaries);
  }

  Future<PersonalTodo> getTodo({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final todos = await db.query(
      personalTaskTableName,
      where: '$taskIdColumn=?',
      whereArgs: [id],
    );
    if (todos.isEmpty) {
      throw CouldNotFindTodo();
    } else {
      final todo = PersonalTodo.fromRow(todos.first);
      _todos.removeWhere((element) => element.taskId == id);
      _todos.add(todo);
      _todosStreamController.add(_todos);
      return todo;
    }
  }

  Future<CloudWorkStatus> getorCreateCloudWorkStatus(
      {required String documentId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final cloudWorkStatus = await db.query(cloudWorkStatusTableName,
        where: '$documentIdColumn=?', whereArgs: [documentId]);
    if (cloudWorkStatus.isEmpty) {
      return await createCloudWork(documentId: documentId);
    }
    return CloudWorkStatus.fromRow(cloudWorkStatus.first);
  }

  Future<PersonalDiary> getDiary({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final record = await db.query(
      personDiaryTableName,
      where: '$diaryIdColumn=?',
      whereArgs: [id],
    );
    if (record.isEmpty) {
      throw CouldNotFindDiary();
    } else {
      final diary = PersonalDiary.fromRow(record.first);
      _diaries.removeWhere((element) => element.diaryId == id);
      _diaries.add(diary);
      _diariesStreamController.add(_diaries);
      return diary;
    }
  }

  Future<PersonalTodo> updateTodo({
    required PersonalTodo todo,
    String? title,
    bool? done,
    bool? isAllDay,
    bool? archived,
    String? startTime,
    String? endTime,
    String? dateOfCreation,
    String? alertTime,
    String? alertFrequency,
    String? fileAttachment,
    String? description,
    String? accountAttachment,
    String? accountMessage,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await getTodo(id: todo.taskId);
    if (title != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            titleColumn: title,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (done != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            doneColumn: done ? 1 : 0,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (archived != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            archivedColumn: archived ? 1 : 0,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (startTime != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            startTimeColumn: startTime,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (endTime != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            endTimeColumn: endTime,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (dateOfCreation != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            dateofCreationColumn: dateOfCreation,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (alertTime != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            alertTimeColumn: alertTime,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (alertFrequency != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            alertFrequencyColumn: alertFrequency,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (fileAttachment != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            fileAttachmentColumn: fileAttachment,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (accountAttachment != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            accountAttachmentColumn: accountAttachment,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (isAllDay != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            isAlldayColumn: isAllDay ? 1 : 0,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (description != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            descriptionColumn: description,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }
    if (accountMessage != null) {
      final updatedone = await db.update(
          personalTaskTableName,
          {
            accountMessageColumn: accountMessage,
          },
          where: 'task_id = ?',
          whereArgs: [todo.taskId]);
      if (updatedone == 0) throw CouldNotUpdateTodo();
    }

    final updatedTodo = await getTodo(id: todo.taskId);
    _todos.removeWhere((element) => element.taskId == updatedTodo.taskId);
    _todos.add(updatedTodo);
    _todosStreamController.add(_todos);
    return updatedTodo;
  }

  Future<CloudWorkStatus> updateCloudWorkStatus(
      {required CloudWorkStatus cloudWorkStatus,
      int? messageCount,
      String? accountMessage,
      String? fileToUpload}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    if (messageCount != null) {
      final updatedone = await db.update(
          cloudWorkStatusTableName, {numberOfMessagesColumn: messageCount},
          where: '$documentIdColumn=?',
          whereArgs: [cloudWorkStatus.documentId]);
      if (updatedone == 0) throw CouldNotUpdateCloudWorkStatus();
    }
    if (accountMessage != null) {
      final updatedone = await db.update(cloudWorkStatusTableName,
          {cloudWorkaccountMessageColumn: accountMessage},
          where: '$documentIdColumn=?',
          whereArgs: [cloudWorkStatus.documentId]);
      if (updatedone == 0) throw CouldNotUpdateCloudWorkStatus();
    }
    if (fileToUpload != null) {
      final updatedone = await db.update(
          cloudWorkStatusTableName, {fileToUploadColumn: fileToUpload},
          where: '$documentIdColumn=?',
          whereArgs: [cloudWorkStatus.documentId]);
      if (updatedone == 0) throw CouldNotUpdateCloudWorkStatus();
    }
    final updatedCloudworkStatus = await getorCreateCloudWorkStatus(
        documentId: cloudWorkStatus.documentId);
    final Map<String, ({int messageCount, String message, String upload})>
        newcloudworkMap = {
      updatedCloudworkStatus.documentId: ((
        messageCount: updatedCloudworkStatus.numberOfMessages ?? 0,
        message: updatedCloudworkStatus.accountMessage ?? '',
        upload: updatedCloudworkStatus.fileToUpload ?? ''
      ))
    };

    _cloudworkMap.addAll(newcloudworkMap);
    _cloudWorkStatusStreamController.add(_cloudworkMap);
    return updatedCloudworkStatus;
  }

  Future<PersonalDiary> updateDiary({
    required PersonalDiary diary,
    required String? diaryAttached,
    required String? diaryEntry,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getDiary(id: diary.diaryId);
    if (diaryAttached != null) {
      final diaryupdatedone = await db.update(
          personDiaryTableName, {diaryAttachedColumn: diaryAttached},
          where: '$diaryIdColumn=?', whereArgs: [diary.diaryId]);
      if (diaryupdatedone == 0) throw CouldNotUpdateDiary();
    }
    if (diaryEntry != null) {
      final diaryupdatedone = await db.update(
        personDiaryTableName,
        {diaryEntryColumn: diaryEntry},
        where: '$diaryIdColumn=?',
        whereArgs: [diary.diaryId],
      );
      if (diaryupdatedone == 0) throw CouldNotUpdateDiary();
    }
    final updatedDiary = await getDiary(id: diary.diaryId);
    _diaries.removeWhere((element) => element.diaryId == diary.diaryId);
    _diaries.add(updatedDiary);
    _diariesStreamController.add(_diaries);
    return updatedDiary;
  }

  Future<DatabaseUser> createUser({
    required String email,
    required String id,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usertableName,
      limit: 1,
      where: '$idColumn=?',
      whereArgs: [id.trim()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    await db.insert(usertableName, {
      emailColumn: email.toLowerCase(),
      idColumn: id,
      hintsEnabledColumn: 'true'
    });
    return DatabaseUser(
      id: id,
      email: email,
      hintsEnabled: true,
    );
  }

  Future<OnlineUser> createOnlineUser({
    required String email,
    required String id,
    required String documentId,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      onlineUserTableName,
      limit: 1,
      where: '$onlineUserEmailColumn=?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw OnlineUserAlreadyExists();
    }
    await db.insert(onlineUserTableName, {
      onlineUserIdColumn: id,
      onlineUserEmailColumn: email.toLowerCase(),
      cloudDocumentIdColumn: documentId,
      onlineUserWorkContactColumn: null,
      onlineUserHomeContactColumn: null,
      onlineUserProfPicColumn: null
    });
    return OnlineUser(
      accountEmail: email,
      homeContacts: null,
      onlineUserId: id,
      profilePicture: null,
      workContacts: null,
      documentId: documentId,
    );
  }

  Future<DatabaseUser> getUser({
    required String email,
    required String id,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usertableName,
      limit: 1,
      where: '$idColumn =?',
      whereArgs: [id.trim()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<OnlineUser> getOnlineUser({
    required String id,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      onlineUserTableName,
      limit: 1,
      where: '$onlineUserIdColumn =?',
      whereArgs: [id.trim()],
    );
    if (results.isEmpty) {
      throw CouldNotFindOnlineUser();
    } else {
      return OnlineUser.fromRow(results.first);
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(usertableName, where: '$emailColumn = ?', whereArgs: [
      email.toLowerCase(),
    ]);
    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Future<void> deleteOnlineUser({required email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(onlineUserTableName,
        where: '$onlineUserEmailColumn=?',
        whereArgs: [
          email.toLowerCase(),
        ]);
    if (deletedCount != 1) throw CouldNotDeleteOnlineUser();
  }

  Future<DatabaseUser> getorCreateUser({
    required String email,
    required String id,
  }) async {
    try {
      final user = await getUser(email: email, id: id);
      _user = user;
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email, id: id);
      _user = createdUser;
      return createdUser;
    }
  }

  Future<OnlineUser> getorCreateOnlineUser(
      {required String email,
      required String id,
      required String documentId}) async {
    try {
      final onlineUser = await getOnlineUser(id: id);
      _onlineUser = onlineUser;
      return onlineUser;
    } on CouldNotFindOnlineUser {
      final createdOnlineUser = await (createOnlineUser(
          email: email, id: id, documentId: documentId));
      _onlineUser = createdOnlineUser;
      return createdOnlineUser;
    }
  }

  Future<DatabaseUser> updateUser(
      {required DatabaseUser databaseUser, required bool hintsEnabled}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getUser(email: databaseUser.email, id: databaseUser.id);

    final updatedone = await db.update(
        usertableName, {hintsEnabledColumn: hintsEnabled.toString()},
        where: '$emailColumn =?', whereArgs: [databaseUser.email]);
    if (updatedone == 0) throw CouldNotUpdateOnlineUser();

    return await getUser(email: databaseUser.email, id: databaseUser.id);
  }

  Future<OnlineUser> updateOnlineUser({
    required OnlineUser onlineUser,
    required String? workContacts,
    required String? homeContacts,
    required String? profilePicture,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getOnlineUser(id: onlineUser.onlineUserId);
    if (workContacts != null) {
      final updatedone = await db.update(
          onlineUserTableName, {onlineUserWorkContactColumn: workContacts},
          where: '$onlineUserEmailColumn =?',
          whereArgs: [onlineUser.accountEmail]);
      if (updatedone == 0) throw CouldNotUpdateOnlineUser();
    }
    if (homeContacts != null) {
      final updatedone = await db.update(
          onlineUserTableName, {onlineUserHomeContactColumn: homeContacts},
          where: '$onlineUserEmailColumn =?',
          whereArgs: [onlineUser.accountEmail]);
      if (updatedone == 0) throw CouldNotUpdateOnlineUser();
    }
    if (profilePicture != null) {
      final updatedone = await db.update(
          onlineUserTableName, {onlineUserProfPicColumn: profilePicture},
          where: '$onlineUserEmailColumn =?',
          whereArgs: [onlineUser.accountEmail]);
      if (updatedone == 0) throw CouldNotUpdateOnlineUser();
    }
    return await getOnlineUser(id: onlineUser.onlineUserId);
  }

  Future<void> open(bool? cachetodos) async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(
        dbPath,
        version: 1,
      );
      _db = db;

      ///await db.execute('DROP TABLE IF EXISTS personal_task');
      await db.execute(createUserTable);
      await db.execute(createPersonalTaskTable);
      await db.execute(createPersonalDiaryTable);
      await db.execute(createOnlineUserTable);
      await db.execute(createCloudWorkStatusTable);
      await _cacheTodos();
      await _cacheCloudWorkStatus();
      await _cacheDiaries();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open(cachetodos);
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }
}

DateTime dateadjust(DateTime date) {
  return DateTime(date.year, date.month, date.day - 1, 23, 59);
}

DateTime dateadjust2(DateTime date) {
  return DateTime(date.year, date.month, date.day, 0, 1);
}
