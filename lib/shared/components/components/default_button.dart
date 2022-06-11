import 'package:control_your_money/shared/components/components/color_manager.dart';
import 'package:flutter/material.dart';

import '../../cubit/cubit.dart';

Widget defaultButton(
        {double width = double.infinity,
        Color background = Colors.blue,
        bool isUpperCase = true,
        double radius = 3.0,
        required VoidCallback function,
        required String text,
        context}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: AppCubit.get(context).isDark == false
            ? ColorManager.primary
            : ColorManager.darkPrimary,
      ),
    );
