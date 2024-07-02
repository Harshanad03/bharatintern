import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizHomePage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _questionIndex = 0;
  int _totalScore = 0;
  int? _selectedAnswerIndex; // Track selected answer index
  bool _isAnswerCorrect = false; // Track if the selected answer is correct
  bool _isAnswerSelected = false; // Track if any answer has been selected

  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'Who developed the Flutter Framework ?',
      'answers': [
        {'text': ' Facebook', 'score': 0, 'isCorrect': false},
        {'text': 'Microsoft', 'score': 0, 'isCorrect': false},
        {'text': 'Google', 'score': 1, 'isCorrect': true},
        {'text': 'Oracle', 'score': 0, 'isCorrect': false},
      ],
    },
    {
      'questionText':
          'Which programming language is used to build Flutter applications?',
      'answers': [
        {'text': 'Dart', 'score': 1, 'isCorrect': true},
        {'text': 'Kotlin', 'score': 0, 'isCorrect': false},
        {'text': 'Java', 'score': 0, 'isCorrect': false},
        {'text': 'Python', 'score': 0, 'isCorrect': false},
      ],
    },
    {
      'questionText':
          'What widget would you use for repeating content in Flutter?',
      'answers': [
        {'text': 'ExpandedView', 'score': 0, 'isCorrect': false},
        {'text': 'Stack', 'score': 0, 'isCorrect': false},
        {'text': 'ArrayView', 'score': 0, 'isCorrect': false},
        {'text': 'ListView', 'score': 1, 'isCorrect': true},
      ],
    },
  ];

  void _answerQuestion(int score, bool isCorrect, int index) {
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswerCorrect = isCorrect;
      _isAnswerSelected = true;
      if (isCorrect) {
        _totalScore += score;
      }
    });

    // Move to the next question after a short delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_questionIndex < _questions.length - 1) {
          _questionIndex += 1;
          _selectedAnswerIndex = null;
          _isAnswerCorrect = false;
          _isAnswerSelected = false;
        }
      });
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_questionIndex > 0) {
        _questionIndex -= 1;
        _selectedAnswerIndex = null;
        _isAnswerCorrect = false;
        _isAnswerSelected = false;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_questionIndex < _questions.length - 1) {
        _questionIndex += 1;
        _selectedAnswerIndex = null;
        _isAnswerCorrect = false;
        _isAnswerSelected = false;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _selectedAnswerIndex = null;
      _isAnswerCorrect = false;
      _isAnswerSelected = false;
    });
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Text('Your final score is $_totalScore.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _resetQuiz(); // Reset the quiz after showing the score
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _questionIndex / _questions.length;
    final String questionText =
        _questions[_questionIndex]['questionText'] as String;
    final bool isLastQuestion = _questionIndex == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
        // Set the AppBar color to purple
        toolbarHeight: 200.0, // Set the height of the AppBar
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              height: 100, // Height of the container inside the AppBar
              width: 350, // Ensure it spans the width of the screen
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Q${_questionIndex + 1}/${_questions.length}', // Question number
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                        width:
                            16), // Space between the question number and progress bar
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      height: 200, // Height of the container in the body
                      width: 350,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            questionText,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Space between question and buttons
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...(_questions[_questionIndex]['answers']
                              as List<Map<String, Object>>)
                          .asMap()
                          .entries
                          .map((entry) {
                        final int idx = entry.key;
                        final Map<String, Object> answer = entry.value;
                        final bool isSelected = _selectedAnswerIndex == idx;
                        final bool isCorrect = answer['isCorrect'] as bool;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_isAnswerSelected) {
                                _answerQuestion(
                                  answer['score'] as int,
                                  isCorrect,
                                  idx,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(200, 60), // Adjust the button size here
                              backgroundColor: isSelected
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.grey[200], // Default color
                              textStyle: TextStyle(
                                  fontSize: 18), // Adjust text size if needed
                            ),
                            child: Text(answer['text'] as String),
                          ),
                        );
                      }).toList(),
                      if (_questionIndex >
                          0) // Show Previous button if not on the first question
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: _previousQuestion,
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(150, 60), // Adjust the button size here
                              textStyle: TextStyle(
                                  fontSize: 18), // Adjust text size if needed
                            ),
                            child: Text('Previous'),
                          ),
                        ),
                      if (_questionIndex <
                          _questions.length -
                              1) // Show Next button if not on the last question
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(150, 60), // Adjust the button size here
                              textStyle: TextStyle(
                                  fontSize: 18), // Adjust text size if needed
                            ),
                            child: Text('Next'),
                          ),
                        ),
                      if (isLastQuestion) // Show Submit button only on the last question
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed:
                                _showScoreDialog, // Update to show dialog
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(150, 60), // Adjust the button size here
                              textStyle: TextStyle(
                                  fontSize: 18), // Adjust text size if needed
                            ),
                            child: Text('Submit'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_questionIndex < _questions.length - 1 ||
              isLastQuestion) // Row for navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_questionIndex >
                      0) // Show Previous button if not on the first question
                    ElevatedButton(
                      onPressed: _previousQuestion,
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(150, 60), // Adjust the button size here
                        textStyle: TextStyle(
                            fontSize: 18), // Adjust text size if needed
                      ),
                      child: Text('Previous'),
                    ),
                  if (_questionIndex <
                      _questions.length -
                          1) // Show Next button if not on the last question
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.withOpacity(0.8),
                        minimumSize:
                            Size(150, 60), // Adjust the button size here
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18), // Adjust text size if needed
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  if (isLastQuestion) // Show Submit button only on the last question
                    ElevatedButton(
                      onPressed: _showScoreDialog, // Update to show dialog
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.withOpacity(0.8),
                        minimumSize:
                            Size(150, 60), // Adjust the button size here
                        textStyle: TextStyle(
                            fontSize: 18), // Adjust text size if needed
                      ),
                      child:
                          Text('Submit', style: TextStyle(color: Colors.black)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
