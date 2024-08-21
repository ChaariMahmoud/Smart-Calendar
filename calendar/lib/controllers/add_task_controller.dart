import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskController extends GetxController {
  // Reactive variables
  var selectedDate = DateTime.now().obs;
  var endTime = "11:59 PM".obs;
  var startTime = DateFormat("hh:mm a").format(DateTime.now()).obs;
  var selectedDifficulty = 1.obs;
  var selectedColor = 0.obs;
  var selectedPriority = 1.obs;
  var autoSelectTime = false.obs;

  // Function to toggle auto-select time
  void toggleAutoSelectTime() {
    autoSelectTime.value = !autoSelectTime.value;
  }

  // Function to update time
  void updateTime({required bool isStartTime, required String time}) {
    if (isStartTime) {
      startTime.value = time;
    } else {
      endTime.value = time;
    }
  }

  // Function to update difficulty
  void updateDifficulty(int value) {
    selectedDifficulty.value = value;
  }

  // Function to update priority
  void updatePriority(int index) {
    selectedPriority.value = index + 1;
  }

  // Function to update color
  void updateColor(int color) {
    selectedColor.value = color;
  }

  // Function to update date
  void updateDate(DateTime date) {
    selectedDate.value = date;
  }
}
