import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart' as typeahead;
import 'package:get/get.dart';
import 'package:rapid_app/data/model/combo_box_model/lookup_response.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    Key? key,
    required this.list,
    required this.title,
    required this.hint,
    required this.onChanged,
    required this.controller,
    required this.editMode,
    required this.readOnly,
    this.enabled,
  }) : super(key: key);

  final List<LookupResponse> list;
  final String title, hint, editMode;
  final ValueChanged<LookupResponse?> onChanged;
  final TextEditingController controller;
  final bool? enabled;
  final String readOnly;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  LookupResponse? selectedResponse;

  @override
  void initState() {
    if (widget.editMode == 'Edit') {
      onEditData();
    }
  }

  void onEditData() {
    List<LookupResponse> responseList = widget.list
        .where((element) => element.valueField == widget.hint)
        .toList();
    if (responseList.isNotEmpty) {
      _onChanged(responseList[0]);
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: <Widget>[
  //       Expanded(
  //         flex: 1,
  //         child: Align(
  //           alignment: Alignment.centerRight,
  //           child: typeahead.TypeAheadField<LookupResponse>(
  //             suggestionsCallback: getDataList,
  //             itemBuilder: (context, LookupResponse suggestion) {
  //               return ListTile(
  //                 title: Text(
  //                   suggestion.textField,
  //                   style: TextStyle(
  //                       color: Theme.of(context).textTheme.headline1!.color!),
  //                 ),
  //               );
  //             },
  //             onSuggestionSelected: (LookupResponse? suggestion) =>
  //                 _onChanged(suggestion),
  //             noItemsFoundBuilder: (context) => ListTile(
  //               title: Text(
  //                 'No data found',
  //                 style: TextStyle(
  //                     color: Theme.of(context).textTheme.headline1!.color!),
  //               ),
  //             ),
  //             textFieldConfiguration: typeahead.TextFieldConfiguration(
  //                 style: TextStyle(
  //                     color: Theme.of(context).textTheme.headline1!.color!),
  //                 controller: widget.controller,
  //                 maxLines: null,
  //                 cursorColor: Theme.of(context).backgroundColor,
  //                 enabled: widget.enabled ?? true,
  //                 keyboardType: TextInputType.multiline,
  //                 decoration: InputDecoration(
  //                     counterText: '',
  //                     labelText: widget.title,
  //                     labelStyle: TextStyle(
  //                         fontSize: 12,
  //                         fontFamily: 'Roboto',
  //                         fontWeight: FontWeight.normal,
  //                         color: Theme.of(context).textTheme.headline1!.color!),
  //                     enabledBorder:
  //                         Theme.of(context).inputDecorationTheme.enabledBorder,
  //                     focusedBorder: Theme.of(context)
  //                         .inputDecorationTheme
  //                         .focusedBorder)),
  //           ),
  //         ),
  //       ),
  //       widget.readOnly == 'Y'
  //           ? const SizedBox()
  //           : IconButton(
  //             onPressed: () => _onChanged(null),
  //             icon: Icon(
  //               Icons.clear,
  //               size: 18,
  //               color: Theme.of(Get.context!).disabledColor,
  //             ),
  //           ),
  //     ],
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: typeahead.TypeAheadField<LookupResponse>(
              suggestionsCallback: getDataList,
              itemBuilder: (context, LookupResponse suggestion) {
                return ListTile(
                  title: Text(
                    suggestion.textField,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color!,
                     fontSize: 12),
                    maxLines: 1,
                  ),
                );
              },
              onSuggestionSelected: (LookupResponse? suggestion) =>
                  _onChanged(suggestion),
              noItemsFoundBuilder: (context) => ListTile(
                title: Text(
                  'No data found',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color!,
                  fontSize: 12),
                ),
              ),
              textFieldConfiguration: typeahead.TextFieldConfiguration(
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1!.color!),
                controller: widget.controller,
                maxLines: null,
                cursorColor: Theme.of(context).backgroundColor,
                enabled: widget.enabled ?? true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: widget.title,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.headline1!.color!,
                  ),
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  suffixIcon: widget.readOnly == 'Y'
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () => _onChanged(null),
                          icon: Icon(
                            Icons.clear,
                            size: 15,
                            color: Theme.of(Get.context!).disabledColor,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChanged(LookupResponse? value) {
    widget.onChanged(value);
    setState(() {
      if (value == null) {
        widget.controller.value = const TextEditingValue(text: '');
      } else {
        widget.controller.value = TextEditingValue(text: value.textField);
        selectedResponse = value;
      }
    });
  }

  Future<List<LookupResponse>> getDataList(String searchQuery) async {
    List<LookupResponse> responseList = widget.list
        .where((element) => element.textField
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
    return responseList;

  }

}
