import 'dart:io';

import 'package:cloudinary/cloudinary.dart';

Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    final cloudinary = Cloudinary.signedConfig(
        apiKey: '473473228572349',
        apiSecret: 'EZTgpcXxJmGICxnkySQMoaT522M',
        cloudName: 'ddpesayzy');

    final result = await cloudinary.upload(
      file: imageFile.path,
      folder: 'WedwheelImages',
      resourceType: CloudinaryResourceType.image,
    );

    final profileImage = result.secureUrl;
    print(
        '------------------------------------------------------------------------------------------------');
    print(profileImage);
    return result.secureUrl;
  } catch (e) {
    print("Error uploading image: $e");

    return null;
  }
}
