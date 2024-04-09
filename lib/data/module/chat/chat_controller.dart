import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/projects_list_model/project_list_response.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';

import '../../../res/utils/generate_random_string.dart';
import '../../../res/utils/rapid_controller.dart';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

import '../../../res/values/strings.dart';
import '../../api/http_method.dart';
import '../../model/base/base_response.dart';

class ChatController extends RapidController {
  RxList<types.Message> messages = RxList([]);
  final user = types.User(
    id: RapidPref().getLoginUserId().toString(),
  );
  final aiResponder = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void onInit() {
    super.onInit();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

  void handleAttachmentPressed(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          messages[index] = updatedMessage;

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          messages[index] = updatedMessage;
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    messages[index] = updatedMessage;
  }

  void handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    apiClient.updateBaseUrl('https://cloud.clikonworld.com/saleschat/api/');
    await sendQueryToApi(textMessage.text);
  }

  sendQueryToApi(String message) async {
    dynamic body = {'prompt': message};

    BaseResponse result = await apiClient.executeRequest(
        endpoint: 'Sales/generateSqlQuery',
        method: HttpMethod.POST,
        body: body);
    fetchProjectsFromDb();
    handleReceivedMessage(result.data['query']);
  }

  Future<String> fetchProjectsFromDb() async {
    final userBox =
        await Hive.openBox<ProjectListResponse>(Strings.kRapidMainDatabase);
    // read metadata table values
    List<ProjectListResponse> dbSavedProjects =
        userBox.values.toList().cast<ProjectListResponse>();

    return dbSavedProjects.first.projectUrl;
  }

  handleReceivedMessage(String msg) async {
    apiClient.updateBaseUrl(await fetchProjectsFromDb());
    final response = await apiClient.rapidRepo.getBaseData(msg);

    List<dynamic> data = response.data;

    List<Map<String, dynamic>> parsedData = data.map((item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        throw Exception('Invalid data format: $item');
      }
    }).toList();

    List<String> result = parsedData
        .map((item) => "${item['ITEM_CODE']} : ${item['ITEM_NAME']}")
        .toList();

    final textMessage = types.TextMessage(
      author: aiResponder,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: result.join('\n'),
    );
    print('Message is :::: ${textMessage.text}');
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    this.messages.value = messages;
  }
}
