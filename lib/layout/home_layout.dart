import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:control_your_money/shared/components/components/color_manager.dart';
import 'package:control_your_money/shared/components/components/default_button.dart';
import 'package:control_your_money/shared/components/components/default_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/constants.dart';
import '../shared/cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, HomeState state) {
        if (state is HomeInsertToDatabaseState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, HomeState state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_4_outlined),
                onPressed: () {
                  AppCubit.get(context).changeAppMode();
                },
              )
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! HomeGetDatabaseLoadingState,
            builder: (context) => HomeCubit.get(context)
                .screens[HomeCubit.get(context).currentIndex],
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: AlertDialog(
                        backgroundColor: AppCubit.get(context).isDark
                            ? ColorManager.gray
                            : ColorManager.white,
                        title: const Center(child: Text('Add Your Amount')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextField(
                                controller: cubit.amountController,
                                type: TextInputType.number,
                                label: "Amount",
                                prefix: Icons.attach_money),
                            const SizedBox(
                              height: 8,
                            ),
                            defaultTextField(
                                controller: cubit.noteController,
                                type: TextInputType.text,
                                label: "Note",
                                prefix: Icons.note),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                defaultButton(
                                    width: 115,
                                    function: () {
                                      cubit.insertToDatabase(
                                        amount: int.parse(
                                            cubit.amountController.text),
                                        note: cubit.noteController.text,
                                        status: 'balance',
                                        time: DateTime.now().toString(),
                                      );
                                      cubit.amountController.clear();
                                      cubit.noteController.clear();
                                    },
                                    text: 'balance',
                                    context: context),
                                const SizedBox(
                                  width: 8,
                                ),
                                defaultButton(
                                    width: 115,
                                    function: () {
                                      cubit.insertToDatabase(
                                        amount: int.parse(
                                            cubit.amountController.text),
                                        note: cubit.noteController.text,
                                        status: 'lost',
                                        time: DateTime.now().toString(),
                                      );
                                      cubit.amountController.clear();
                                      cubit.noteController.clear();
                                    },
                                    text: 'lost',
                                    context: context),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                size: 30,
              )),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              elevation: 0,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.balance),
                    label: 'Balance $totalBalance\$'),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.minimize),
                    label: 'Lost $totalLost\$'),
              ]),
        );
      },
    );
  }
}
