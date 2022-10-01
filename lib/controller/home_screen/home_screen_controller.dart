import 'package:get/get.dart';
import '../splash_screen/screen_splash.dart';

class HomeScreenController extends GetxController {
  final RxBool floatingBtnVisibility = false.obs;
  final RxBool notification = true.obs;
  int tabIndex = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  final RxBool miniPlayerVisibility = false.obs;

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
