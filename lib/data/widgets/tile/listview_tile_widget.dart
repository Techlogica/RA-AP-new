import 'package:flutter/material.dart';
import '../../model/projects_list_model/project_list_response.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({Key? key, required this.response, this.onTap})
      : super(key: key);

  final ProjectListResponse response;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(
            response.projectTitle,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text(
          //   response.projectUrl,
          //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
          //         fontSize: 13,
          //       ),
          // ),
        ),
      ),
    );
  }
}
