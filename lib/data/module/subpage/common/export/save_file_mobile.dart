///Dart import
import 'dart:io';

///Package imports
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

///To save the Excel file in the device
Future<void>saveAndLaunchFile(List<int> bytes, String fileName)async{
  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');
}