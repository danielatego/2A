const createPersonalTaskTable = ''' 
CREATE TABLE IF NOT EXISTS "personal_task" (
	"task_id"	INTEGER NOT NULL UNIQUE,
	"creator_of_task"	TEXT NOT NULL,
	"title"	TEXT NOT NULL,
  "done" INTEGER NOT NULL DEFAULT 0,
  "archived" INTEGER NOT NULL DEFAULT 0, 
	"start_time"	TEXT,
	"end_time"	TEXT,
  "is_allday"  INTEGER NOT NULL DEFAULT 0,
	"date_of_creation"	TEXT NOT NULL,
	"alert_time"	TEXT,
	"alert_frequency"	TEXT,
	"file_attachment"	TEXT,
  "account_attachment" TEXT,
	"description"	TEXT,
  "account_message" TEXT,
	PRIMARY KEY("task_id" AUTOINCREMENT),
	FOREIGN KEY("creator_of_task") REFERENCES "users"("user_id")
)
''';

const taskIdColumn = 'task_id';
const creatorOfTaskColumn = 'creator_of_task';
const titleColumn = 'title';
const doneColumn = 'done';
const startTimeColumn = 'start_time';
const endTimeColumn = 'end_time';
const isAlldayColumn = 'is_allday';
const dateofCreationColumn = 'date_of_creation';
const alertTimeColumn = 'alert_time';
const alertFrequencyColumn = 'alert_frequency';
const fileAttachmentColumn = 'file_attachment';
const accountAttachmentColumn = 'account_attachment';
const descriptionColumn = 'description';
const accountMessageColumn = 'account_message';
const personalTaskTableName = 'personal_task';
const archivedColumn = 'archived';

class PersonalTodo {
  final int taskId;
  final String creatorOfTask;
  final String title;
  final bool done;
  final bool archived;
  final String? startTime;
  final bool isAllDay;
  final String? endTime;
  final String dateOfCreation;
  final String? alertTime;
  final String? alertFrequency;
  final String? fileAttachment;
  final String? accountAttachment;
  final String? description;
  final String? accountMessage;

  PersonalTodo.fromRow(Map<String, Object?> map)
      : taskId = map[taskIdColumn] as int,
        creatorOfTask = map[creatorOfTaskColumn] as String,
        title = map[titleColumn] as String,
        done = (map[doneColumn] == 1),
        isAllDay = (map[isAlldayColumn] == 1),
        archived = (map[archivedColumn] == 1),
        startTime = map[startTimeColumn] as String,
        endTime = map[endTimeColumn] as String,
        dateOfCreation = map[dateofCreationColumn] as String,
        alertTime = map[alertTimeColumn] as String,
        alertFrequency = map[alertFrequencyColumn] as String,
        fileAttachment = map[fileAttachmentColumn] as String,
        accountAttachment = map[accountAttachmentColumn] as String,
        description = map[descriptionColumn] as String,
        accountMessage = map[accountMessageColumn] as String;

  @override
  bool operator ==(covariant PersonalTodo other) => taskId == other.taskId;

  @override
  int get hashCode => taskId.hashCode;

  PersonalTodo({
    required this.taskId,
    required this.creatorOfTask,
    required this.title,
    required this.done,
    required this.isAllDay,
    required this.startTime,
    required this.endTime,
    required this.dateOfCreation,
    required this.alertTime,
    required this.alertFrequency,
    required this.fileAttachment,
    required this.description,
    required this.archived,
    required this.accountAttachment,
    required this.accountMessage,
  });
}
