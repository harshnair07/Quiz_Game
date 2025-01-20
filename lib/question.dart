import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quizgame/progressbar.dart';
import 'package:quizgame/resultscreen.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<dynamic> _questions = [];
  bool _isLoading = true;
  List<String> _userAnswers = [];

  Future<void> fetchQuiz() async {
    const String apiUrl = 'https://api.jsonserve.com/Uw5CrX';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _questions = (data['questions'] as List<dynamic>).map((question) {
            final options = (question['options'] as List<dynamic>)
                .map((option) => {
                      'description': option['description'],
                      'is_correct': option['is_correct'],
                    })
                .toList();
            return {
              'description': question['description'],
              'options': options,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error fetching quiz: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  void _answerQuestion(Map<String, dynamic> selectedOption) {
    setState(() {
      _userAnswers.add(selectedOption['description']);
      if (selectedOption['is_correct'] == true) {
        _score++;
      }
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _navigateToResultScreen();
      }
    });
  }

  void _navigateToResultScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Resultscreen(
          score: _score,
          questions: _questions,
          userAnswers: _userAnswers,
          // userAnswers: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : _questions.isEmpty
                  ? const Center(
                      child: Text(
                        'No questions available. Please try again later.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Progress Tracker
                          GradientProgressBar(
                            value:
                                (_currentQuestionIndex + 1) / _questions.length,
                            height: 12,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _questions[_currentQuestionIndex]['description']
                                as String,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ...(_questions[_currentQuestionIndex]['options']
                                  as List<Map<String, dynamic>>)
                              .map((option) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: NiceButtons(
                                startColor:
                                    const Color.fromARGB(157, 193, 198, 199),
                                endColor: const Color.fromARGB(255, 3, 6, 37),
                                borderColor: Colors.transparent,
                                width: double.infinity,
                                stretch: true,
                                onTap: (finish) => _answerQuestion(option),
                                child: Text(
                                  option['description'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),

                          const Spacer(),
                          Text(
                            "Score: $_score",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
