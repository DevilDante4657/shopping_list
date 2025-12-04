import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/model/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  GroceryList({super.key});
  @override

  State<GroceryList> createState() => _GroceryListState();
}
  class _GroceryListState extends State<GroceryList>{
    final List<GroceryItem> _groceryItem = [];
    void _addItem() async{
      final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem())
      );
      if(newItem == null)
      {
        return;
      }
      else{
        setState(() {
          _groceryItem.add(newItem);
        });
      }
    }

    void _removeItem(GroceryItem item){
      setState(() {
        _groceryItem.remove(item);
      });
    }

  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("Click the + button to add a grocery item"),
      );
      if(_groceryItem.isNotEmpty){
        content  = ListView.builder(
          itemCount: _groceryItem.length,
          itemBuilder: (ctx, index) => Dismissible(
            onDismissed: (direction){
              _removeItem(_groceryItem[index]);
            },
            key: ValueKey(_groceryItem[index].id),
            child: ListTile(
            leading: Container(
            width: 24,
            height: 24,
            color: _groceryItem[index].category.color,
          ),
          title: Text(_groceryItem[index].name),
          trailing: Text(_groceryItem[index].quantity.toString()
          ),
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
      body: ListView.builder(
        itemCount: _groceryItem.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItem[index].category.color,
          ),
          title: Text(_groceryItem[index].name),
          trailing: Text(_groceryItem[index].quantity.toString()),
        ),
      )
    );
  }
  }