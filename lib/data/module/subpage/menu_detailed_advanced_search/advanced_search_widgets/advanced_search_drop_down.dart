import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart' as typeahead;
import '../../../../model/metadata_columns_model/metadata_columns_response.dart';

class AdvancedSearchDropDown extends StatefulWidget {
  const AdvancedSearchDropDown(
      {Key? key,
      required this.title,
      required this.list,
      required this.onChanged,
      required this.controller})
      : super(key: key);

  final String title;
  final List<MetadataColumnsResponse> list;
  final ValueChanged<MetadataColumnsResponse?> onChanged;
  final TextEditingController controller;

  @override
  State<AdvancedSearchDropDown> createState() => _AdvancedSearchDropDownState();
}

class _AdvancedSearchDropDownState extends State<AdvancedSearchDropDown> {
  MetadataColumnsResponse? selectedTitle;

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
              child: typeahead.TypeAheadField<MetadataColumnsResponse>(
                suggestionsCallback: getDataList,
                itemBuilder: (context, MetadataColumnsResponse suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.mdcMetatitle.toString(),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color!),
                    ),
                  );
                },
                onSuggestionSelected: (MetadataColumnsResponse? suggestion) =>
                    _onChanged(suggestion),
                noItemsFoundBuilder: (context) => ListTile(
                  title: Text('No data found',
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.headline1!.color!)),
                ),
                textFieldConfiguration: typeahead.TextFieldConfiguration(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color!),
                  controller: widget.controller,
                  maxLines: null,
                  cursorColor: Theme.of(context).backgroundColor,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      counterText: '',
                      labelText: widget.title,
                      enabledBorder:
                          Theme.of(context).inputDecorationTheme.enabledBorder,
                      focusedBorder:
                          Theme.of(context).inputDecorationTheme.focusedBorder,
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color!,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                      )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onChanged(MetadataColumnsResponse? value) {
    widget.onChanged(value);
    setState(() {
      widget.controller.value = TextEditingValue(text: value!.mdcMetatitle);
      selectedTitle = value;
    });
  }

  Future<List<MetadataColumnsResponse>> getDataList(String searchQuery) async {
    List<MetadataColumnsResponse> responseList = widget.list
        .where((element) => element.mdcMetatitle
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
    return responseList;
  }
}
