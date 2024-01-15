DEFINE NAMESPACE dev;
DEFINE DATABASE main;
DEFINE TABLE notes;
DEFINE ANALYZER notes_analyzer TOKENIZERS blank,class,camel,punct FILTERS snowball(english);
DEFINE INDEX note_content ON notes FIELDS note SEARCH ANALYZER notes_analyzer BM25(1.2,0.75) HIGHLIGHTS;