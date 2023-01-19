const String tableNotes = 'folders';

class NoteFields {
  static final List<String> values = [id, folder];
  static const String id = '_id';
  static const String folder = 'folder';
}

class Note {
  final int? id;
  final String folder;

  Note({
    this.id,
    required this.folder,
  });

  Note copy({
    int? id,
    String? folder,
  }) =>
      Note(
        id: id ?? this.id,
        folder: folder ?? this.folder,
      );
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        folder: json[NoteFields.folder] as String,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.folder: folder,
      };
}
