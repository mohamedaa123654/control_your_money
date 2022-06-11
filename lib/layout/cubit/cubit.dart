import 'package:bloc/bloc.dart';
import 'package:control_your_money/layout/cubit/states.dart';
import 'package:control_your_money/modules/lost_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/balance_screen.dart';
import '../../shared/components/constants.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const BalanceScreen(),
    const LostScreen(),
  ];
  List<String> titles = [
    'Balance',
    'Lost',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavigationBarState());
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  late Database database;
  List<Map> balance = [];
  List<Map> lost = [];

  void createDatabase() async {
    openDatabase('moeny.db', version: 1, onCreate: (database, version) async {
      print('database Created');

      await database
          .execute(
              'CREATE TABLE Money (id INTEGER PRIMARY KEY, amount INTEGER, time TEXT,note TEXT,  status TEXT)')
          .then((value) {
        print('table Created');
      }).catchError((error) {
        print(error);
      });
    }, onOpen: (database) {
      print('database file is opened');
      getDatabase(database);
    }).then((value) {
      database = value;
      emit(HomeCreateDatabaseState());
    }).catchError((error) {
      print('errro when opening the file');
    });
  }

  // insert to database
  void insertToDatabase(
      {required int amount,
      required String time,
      required String note,
      required String status}) {
    database.transaction((txn) async {
      // insert into tableName
      txn
          .rawInsert(
              'INSERT INTO Money( amount,time,note,status) VALUES($amount, "$time","$note", "$status")')
          .then((value) {
        print('$value is inserted successfully');
        print('XXXXXXXXXXXXXXXXXXXXX');
        emit(HomeInsertToDatabaseState());

        getDatabase(database);
      }).catchError((error) {
        print('an error when inserting into database');
      });
    });
  }

  void getDatabase(database) {
    balance = [];
    lost = [];
    totalBalance = 0;
    totalLost = 0;
    print('get Database XXXXXXXXXXXXXXX');
    emit(HomeGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM Money').then((value) {
      value.forEach((element) {
        if (element['status'] == 'balance') {
          balance.add(element);

          totalBalance += element['amount'] as int;
          print(totalBalance);
        } else {
          lost.add(element);
          totalLost = totalLost + element['amount'] as int;
        }
      });
      totalBalance = totalBalance - totalLost;
      emit(HomeGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE Money SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDatabase(database);
      emit(HomeUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    await database
        .rawDelete('DELETE FROM Money WHERE id = ?', [id]).then((value) {
      getDatabase(database);
      emit(HomeDeleteDatabaseState());
    });
  }
}
