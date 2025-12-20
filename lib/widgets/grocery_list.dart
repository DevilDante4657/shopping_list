import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/model/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  GroceryList({super.key});
  @override

  State<GroceryList> createState() => _GroceryListState();
}
  class _GroceryListState extends State<GroceryList>{
    List<GroceryItem> _groceryItems = [];
    var _isLoading = true;
    String ? _error = '';

    void initState(){
      super.initState();
      _loaditems();
    }

    void _loaditems() async{
      final url = Uri.https(
        'shopping-list-25850-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      final response = await http.get(url);
      //print(response.body);
      if(response.statusCode > 400){
        setState(() {
          _error = "Failed to fetch data. Try again later!";
        });
      }
      final Map<String,dynamic> listData = json.decode(response.body);
      final List<GroceryItem> _loadedItems = [];
      for (final item in listData.entries){
        final currentCat = categories.entries
        .firstWhere(
          (catItem) => catItem.value.title == item.value['category'],
        ).value;
        _loadedItems.add(
          GroceryItem(
            id: item.key, 
            name: item.value['name'], 
            quantity: item.value['quantity'], 
            category: currentCat
            ),
        );
      }
      setState(() {
        _groceryItems = _loadedItems;
        _isLoading = false;
      });
    }

    void _addItem() async{ 
      final newItem = await Navigator.of(
        context)
        .push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem())
      );
      if (newItem == null){
        return;
      }
      setState(() {
        _groceryItems.add(newItem);
      });
    }

    void _removeItem(GroceryItem item) async{
      final index = _groceryItems.indexOf(item);
      setState(() {
        _groceryItems.remove(item);
      });
      final url = Uri.https(
        'shopping-list-25850-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json',
      );
      var response = await http.delete(url);
      setState(() {
        _groceryItems.remove(item);
      });
    }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("Pease click the + button to add Item"),);
    if(_isLoading){
      content = const Center(child: CircularProgressIndicator(),);
    }
    if(_error != null){
      content = Center(child: Text(_error!),);
    }
    if(_groceryItems.isNotEmpty){
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction){
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            title: Text(_groceryItems[index].name),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Grocery"),
        actions: [
          IconButton(
            onPressed: _addItem, 
            icon: Icon(Icons.add_box))
        ],
      ),
      body: content,
    );
  }
  }