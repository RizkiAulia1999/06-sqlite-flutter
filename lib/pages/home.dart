import 'package:flutter/material.dart';
import '../helpers/dbhelper.dart';
import '../pages/entryForm.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import '../models/item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 0;
  List<Item> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Item'),
        ),
        body: Column(
          children: [
            Expanded(
              child: createListView(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Tambah Item'),
                  onPressed: () async {
                    var item = await navigateToEntryForm(context, null);
                    if (item != null) {
                      //TODO 2 Panggil Fungsi untuk Insert ke DB
                      int result = await SQLHelper.createItem(item);
                      if (result > 0) {
                        updateListView();
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  ListView createListView() {
    TextStyle? textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) => Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.ad_units),
                ),
                title: Text(
                  itemList[index].name,
                  style: textStyle,
                ),
                subtitle: Text(itemList[index].price.toString()),
                trailing: GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () async {
                    //delete by id
                    deleteItem(itemList[index]);
                  },
                ),
                onTap: () async {
                  var item =
                      await navigateToEntryForm(context, itemList[index]);
                  // 4 TODO: edit by id memanggil fungsi edit data
                  editItem(itemList[index]);
                },
              ),
            ));
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item? item) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EntryForm()),
    );
    return result;
  }

  void updateListView() {
    final Future<Database> dbFuture = SQLHelper.db();
    dbFuture.then((database) {
      //TODO 1 : get all item from DB
      Future<List<Item>> itemListFuture = SQLHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          count = itemList.length;
        });
      });
    });
  }

  //delete contact
  void deleteItem(Item item) async {
    int result = await SQLHelper.deleteItem(item.id);
    if (result > 0) {
      updateListView();
    }
  }

  //Edit contact
  void editItem(Item item) async {
    int result = await SQLHelper.updateItem(item);
    if (result > 0) {
      updateListView();
    }
  }
}
