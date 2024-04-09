import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart' as typeahead;
import 'package:get/get.dart';

class AdvancedDropDownWidget extends StatefulWidget {
  const AdvancedDropDownWidget({
    Key? key,
    required this.list,
    required this.title,
    this.hint,
    required this.onChanged,
    required this.controller,
    this.enabled,
  }) : super(key: key);

  final List<String> list;
  final String title;
  final String? hint;
  final ValueChanged<String?> onChanged;
  final TextEditingController controller;
  final bool? enabled;

  @override
  State<AdvancedDropDownWidget> createState() => _AdvancedDropDownWidgetState();
}

class _AdvancedDropDownWidgetState extends State<AdvancedDropDownWidget> {
  String? selectedResponse;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              widget.title,
              style: Theme.of(Get.context!).textTheme.headline1!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto'),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            child: Align(
              alignment: Alignment.centerRight,
              child: typeahead.TypeAheadField<String>(
                suggestionsCallback: getDataList,
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color!),
                    ),
                  );
                },
                onSuggestionSelected: (String? suggestion) =>
                    _onChanged(suggestion),
                noItemsFoundBuilder: (context) => ListTile(
                  title: Text(
                    'No data found',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color!),
                  ),
                ),
                textFieldConfiguration: typeahead.TextFieldConfiguration(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color!),
                  controller: widget.controller,
                  maxLines: null,
                  enabled: widget.enabled ?? true,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Theme.of(context).backgroundColor,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: widget.title,
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.headline1!.color!,
                    ),
                    enabledBorder:
                        Theme.of(context).inputDecorationTheme.enabledBorder,
                    focusedBorder:
                        Theme.of(context).inputDecorationTheme.focusedBorder,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onChanged(String? value) {
    widget.onChanged(value);
    setState(() {
      widget.controller.value = TextEditingValue(text: value!);
      selectedResponse = value;
    });
  }

  Future<List<String>> getDataList(String searchQuery) async {
    List<String> responseList = widget.list
        .where((element) => element
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
    return responseList;
  }
}
