import 'package:flutter/material.dart';

void main() {
  runApp(WordWiseApp());
}

class WordWiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordWise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Georgia',
      ),
      home: ReadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ReadingScreen extends StatefulWidget {
  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final String sampleText = """The old lighthouse stood majestically on the rocky promontory, its beacon illuminating the turbulent waters below. The keeper, a solitary figure, had maintained this vigil for decades, watching countless vessels navigate the treacherous coastline.

Each evening, as twilight descended upon the harbor, he would ascend the spiral staircase to ignite the luminous beacon. The rhythmic rotation of the light created an ethereal dance across the waves, guiding mariners safely to shore.

Despite the isolation, he found solace in this meaningful work. The lighthouse was more than a structure; it was a guardian, a steadfast sentinel protecting lives through the darkest storms.""";

  String? selectedWord;
  String? wordDefinition;
  final List<Map<String, String>> savedWords = [];
  double fontSize = 18.0;

  // Simple offline dictionary
  final Map<String, String> dictionary = {
    'majestically': 'In an impressive and dignified manner; with grandeur and beauty',
    'promontory': 'A high point of land that extends into water; a rocky headland',
    'beacon': 'A guiding light or signal, especially one used for navigation',
    'turbulent': 'Very disturbed and chaotic; characterized by conflict or confusion',
    'solitary': 'Existing alone; single and isolated',
    'vigil': 'A period of staying awake to keep watch or pray',
    'treacherous': 'Dangerous and unpredictable; likely to cause harm',
    'twilight': 'The soft glowing light from the sky when the sun is below the horizon',
    'ascend': 'To go up; to climb or rise',
    'luminous': 'Giving off light; bright and radiant',
    'ethereal': 'Extremely delicate and light; heavenly or spiritual',
    'mariners': 'Sailors; people who navigate ships',
    'solace': 'Comfort in times of distress or sadness',
    'steadfast': 'Firmly committed and unwavering; loyal',
    'sentinel': 'A guard or watchman; someone who keeps watch',
    'illuminate': 'To light up or brighten; to clarify or explain',
    'navigate': 'To plan and direct a route; to find one\'s way',
    'vessels': 'Ships or boats; containers for liquids',
    'coastline': 'The outline of a coast, especially along the sea',
    'isolation': 'The state of being alone or separated from others',
    'spiral': 'A curve that winds around a center point',
    'rhythmic': 'Having a regular repeated pattern of movement or sound',
    'rotation': 'The action of rotating around an axis or center',
    'guardian': 'A protector or defender; someone who watches over others'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.book, color: Colors.white),
            SizedBox(width: 8),
            Text('WordWise'),
          ],
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.text_decrease),
            onPressed: () => setState(() => fontSize = (fontSize - 2).clamp(12.0, 24.0)),
          ),
          IconButton(
            icon: Icon(Icons.text_increase),
            onPressed: () => setState(() => fontSize = (fontSize + 2).clamp(12.0, 24.0)),
          ),
          IconButton(
            icon: Icon(Icons.library_books),
            onPressed: () => _showVocabulary(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tap any blue word to see its definition',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildClickableText(),
                  ),
                ),
              ],
            ),
          ),
          if (selectedWord != null) _buildDefinitionModal(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, color: Colors.blue[600], size: 20),
            SizedBox(width: 8),
            Text(
              '${savedWords.length} words saved',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableText() {
    List<InlineSpan> spans = [];
    List<String> parts = sampleText.split(' ');
    
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      String cleanWord = part.replaceAll(RegExp(r'[^\w]'), '').toLowerCase();
      bool isClickableWord = dictionary.containsKey(cleanWord) && cleanWord.length > 2;
      
      if (isClickableWord) {
        spans.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _showWordDefinition(cleanWord),
              child: Text(
                part + (i < parts.length - 1 ? ' ' : ''),
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.blue[700],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue[300],
                  decorationStyle: TextDecorationStyle.dotted,
                  height: 1.6,
                ),
              ),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: part + (i < parts.length - 1 ? ' ' : ''),
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  void _showWordDefinition(String word) {
    setState(() {
      selectedWord = word;
      wordDefinition = dictionary[word] ?? 'Definition not found';
    });
  }

  Widget _buildDefinitionModal() {
    return GestureDetector(
      onTap: () => setState(() => selectedWord = null),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(30),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedWord!,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 28),
                      onPressed: () => setState(() => selectedWord = null),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  wordDefinition!,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.bookmark_add, size: 20),
                      label: Text('Save Word'),
                      onPressed: _saveWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: Icon(Icons.close, size: 20),
                      label: Text('Close'),
                      onPressed: () => setState(() => selectedWord = null),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveWord() {
    if (selectedWord != null && wordDefinition != null) {
      bool alreadySaved = savedWords.any((word) => word['word'] == selectedWord);
      
      if (!alreadySaved) {
        savedWords.add({
          'word': selectedWord!,
          'definition': wordDefinition!,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Word saved to vocabulary'),
            backgroundColor: Colors.green[600],
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Word already in vocabulary'),
            backgroundColor: Colors.orange[600],
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    setState(() => selectedWord = null);
  }

  void _showVocabulary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.library_books, color: Colors.blue[700]),
                  SizedBox(width: 10),
                  Text(
                    'My Vocabulary (${savedWords.length} words)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: savedWords.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'No words saved yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap blue words in the text to save them',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(15),
                      itemCount: savedWords.length,
                      itemBuilder: (context, index) {
                        final word = savedWords[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      word['word']!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                      onPressed: () {
                                        setState(() => savedWords.removeAt(index));
                                        Navigator.pop(context);
                                        _showVocabulary();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  word['definition']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}