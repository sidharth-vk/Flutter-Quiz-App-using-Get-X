// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import '../controllers/quiz_controller.dart';

class QuizScreen extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cracku'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(),
      body: Stack(
        children: [
          Obx(() {
            if (controller.questions.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionContainer(),
                  if (controller.isAnswered.value) ...[
                    SizedBox(height: 16),
                    _buildExplanationContainer(),
                  ],
                ],
              ),
            );
          }),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildQuestionContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${controller.currentIndex.value + 1}/${controller.questions.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _parseHtmlString(controller.currentQuestion.question),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          _buildOption('A', '1', controller.currentQuestion.option1),
          SizedBox(
            height: 5,
          ),
          _buildOption('B', '2', controller.currentQuestion.option2),
          SizedBox(
            height: 5,
          ),
          _buildOption('C', '3', controller.currentQuestion.option3),
          SizedBox(
            height: 5,
          ),
          _buildOption('D', '4', controller.currentQuestion.option4),
        ],
      ),
    );
  }

  Widget _buildOption(String letter, String number, String option) {
    return Obx(() {
      bool isSelected = controller.selectedAnswer.value == number;
      bool isCorrect = controller.currentQuestion.answer == number;
      Color color = Colors.grey;

      if (controller.isAnswered.value) {
        if (isSelected) {
          color = isCorrect ? Colors.green : Colors.red;
        }
      }

      return Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(border: Border.all(width: 1)),
        child: InkWell(
          onTap: () {
            controller.selectAnswer(number);
            controller.update();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color.withOpacity(0.2),
                  child: controller.isAnswered.value && isSelected && isCorrect
                      ? Icon(Icons.check, size: 16, color: Colors.green)
                      : Text(
                          letter,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _parseHtmlString(option),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildExplanationContainer() {
    bool isCorrect =
        controller.selectedAnswer.value == controller.currentQuestion.answer;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Solution :",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _parseHtmlString(controller.currentQuestion.explanation),
            style: TextStyle(
              fontSize: 20,
              color: isCorrect ? Colors.green[900] : Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.currentIndex.value > 0
                        ? controller.previousQuestion
                        : null,
                    child: Text('<< Previous'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (controller.currentIndex.value <
                                controller.questions.length - 1 &&
                            controller.isAnswered.value)
                        ? controller.nextQuestion
                        : null,
                    child: Text('Next >>'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? htmlString;
  }
}
