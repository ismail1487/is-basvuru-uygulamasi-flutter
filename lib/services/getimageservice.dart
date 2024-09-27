import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GetImageService {
  Future<XFile?> checkPermissionAndOpenGallery() async {
    // Galeri izni kontrol edilir
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return null;
    }
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }
}
