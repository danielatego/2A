const createPersonalDiaryTable = '''
  CREATE TABLE IF NOT EXISTS "personal_diary"(
    "diary_id" INTEGER NOT NULL UNIQUE,
    "creator_of_diary" TEXT NOT NULL,
    "date" TEXT NOT NULL UNIQUE,
    "date_of_creation" TEXT NOT NULL,
    "diary_attached" TEXT,
    "diary_entry" TEXT,
    PRIMARY KEY("diary_id" AUTOINCREMENT),
    FOREIGN KEY("creator_of_diary") REFERENCES "users"("user_id")
  )
 ''';

const personDiaryTableName = 'personal_diary';
const diaryIdColumn = 'diary_id';
const creatorOfDiaryColumn = 'creator_of_diary';
const dateColumn = 'date';
const dateofCreationDiaryColumn = 'date_of_creation';
const diaryEntryColumn = 'diary_entry';
const diaryAttachedColumn = 'diary_attached';

class PersonalDiary {
  final int diaryId;
  final String creatorOfDiary;
  final String date;
  final String dateOfCreation;
  final String? diaryAttached;
  final String? diaryEntry;

  PersonalDiary.fromRow(Map<String, Object?> map)
      : diaryId = map[diaryIdColumn] as int,
        creatorOfDiary = map[creatorOfDiaryColumn] as String,
        date = map[dateColumn] as String,
        dateOfCreation = map[dateofCreationDiaryColumn] as String,
        diaryAttached = map[diaryAttachedColumn] as String?,
        diaryEntry = map[diaryEntryColumn] as String?;

  @override
  bool operator ==(covariant PersonalDiary other) => diaryId == other.diaryId;

  @override
  int get hashCode => diaryId.hashCode;

  PersonalDiary(
      {required this.diaryId,
      required this.creatorOfDiary,
      required this.date,
      required this.dateOfCreation,
      required this.diaryAttached,
      required this.diaryEntry});
}
