import 'package:control_your_money/shared/components/components/color_manager.dart';
import 'package:flutter/material.dart';
import '../../../layout/cubit/cubit.dart';
import '../constants.dart';

Widget buildTaskItem(
  Map model,
  BuildContext context,
) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['amount']}',
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['note'].toString().isEmpty ? model['status'] : model['note']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['time'].toString().substring(0, 16)}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                HomeCubit.get(context).deleteData(
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.delete,
                color: ColorManager.primary,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     HomeCubit.get(context).updateData(
            //       status: 'archive',
            //       id: model['id'],
            //     );
            //   },
            //   icon: Icon(
            //     Icons.archive,
            //     color: Colors.black45,
            //   ),
            // ),
          ],
        ),
      ),
      onDismissed: (direction) {
        HomeCubit.get(context).deleteData(
          id: model['id'],
        );
      },
    );
