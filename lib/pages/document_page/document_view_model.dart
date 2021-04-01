import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneypros/app/app_helper.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/model/user_doc_data.dart';
import 'package:moneypros/services/api_service.dart';
import 'package:moneypros/utils/Constants.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DocumentViewModel extends BaseViewModel with AppHelper {
  bool _isAddOpen = false;
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  UserRepo _userRepo;

  bool _loading = true;
  bool _hasError = false;
  List<UserDocData> _docList = [];

  bool get addOpen => _isAddOpen;
  List<UserDocData> get docList => _docList;
  bool get loading => _loading;
  bool get hasError => _hasError;

  void addButtonClicked() {
    _isAddOpen = !_isAddOpen;
    notifyListeners();
  }

  getImage(var tag, String type, BuildContext context) async {
    myPrint("type before is $type");
    PickedFile pickedFile;
    type = Utility.getDocTypeForServer(type);
    if (tag == 1) {
      pickedFile = await ImagePicker()
          .getImage(source: ImageSource.camera, imageQuality: 25);
    } else {
      pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 25);
    }
    if (pickedFile != null) {
      myPrint(pickedFile.path);
      File imageFile = File(pickedFile.path);
      File compressFile = await Utility.compressFile(imageFile);
      print(compressFile.lengthSync());
      myPrint("type is $type");
      // _image =
      uploadDocument(compressFile, type);
    } else {
      print('No image selected.');
    }
  }

  void initData(UserRepo userRepo) {
    _userRepo = userRepo;
    fetchUserDocuments();
  }

  void uploadDocument(File file, String type) async {
    try {
      showProgressDialogService("Uploading...");
      final response = await _apiService.fileUpload(file, type);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        final index =
            _docList.indexWhere((element) => element.documentType == type);
        if (index == -1) {
          _docList.add(response.data);
        } else {
          _docList[index] = response.data;
        }
        notifyListeners();
      } else {
        final value = await _dialogService.showCustomDialog(
            variant: DialogType.error,
            title: "Error",
            description: response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      final value = await _dialogService.showCustomDialog(
          variant: DialogType.error, title: "Error", description: e.toString());
    }
  }

  void deleteDocument(index) async {
    try {
      showProgressDialogService("Please wait...");
      final response = await _apiService.deleteDocument(_docList[index].id);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _docList.removeAt(index);
        notifyListeners();
      } else {
        final value = await _dialogService.showCustomDialog(
            variant: DialogType.error,
            title: "Error",
            description: response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      final value = await _dialogService.showCustomDialog(
          variant: DialogType.error, title: "Error", description: e.toString());
    }
  }

  void fetchUserDocuments() async {
    _loading = true;
    _hasError = false;
    notifyListeners();
    try {
      final resposne = await _apiService.docList();
      _loading = false;
      if (resposne.status == Constants.SUCCESS) {
        _docList = resposne.data??[];
        notifyListeners();
      } else {
        _hasError = true;
        notifyListeners();
      }
    } catch (e) {
      myPrint(e.toString());
      _loading = false;
      _hasError = true;
      notifyListeners();
    }
  }
}
