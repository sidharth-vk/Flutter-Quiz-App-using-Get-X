// lib/controllers/quiz_controller.dart
import 'package:get/get.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizController extends GetxController {
  final ApiService apiService = ApiService();
  RxList<Question> questions = <Question>[].obs;
  RxInt currentIndex = 0.obs;
  RxString selectedAnswer = ''.obs;
  RxBool isAnswered = false.obs;

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  Future<void> fetchQuestions() async {
    try {
      questions.value = await apiService.fetchQuestions();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load questions: $e');
    }
  }

  void selectAnswer(String answer) {
    if (!isAnswered.value) {
      selectedAnswer.value = answer;
      isAnswered.value = true;
      update();
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      resetAnswer();
      update();
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      resetAnswer();
      update();
    }
  }

  void resetAnswer() {
    selectedAnswer.value = '';
    isAnswered.value = false;
    update();
  }

  Question get currentQuestion => questions[currentIndex.value];
}
