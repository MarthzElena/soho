import 'package:scoped_model/scoped_model.dart';

class OnboardingState extends Model {
  bool showBottom = false;
  String selectedMilk = "";
  String selectedSugar = "";
  String qrData = "";

  void updateShowBottom() {
    if (selectedSugar.isNotEmpty && selectedMilk.isNotEmpty) {
      showBottom = true;
    } else {
      showBottom = false;
    }
  }

  void updateSelectedMilk(String value) {
    selectedMilk = value;
    updateShowBottom();
    notifyListeners();
  }

  void updateSelectedSugar(String value) {
    selectedSugar = value;
    updateShowBottom();
    notifyListeners();
  }
}