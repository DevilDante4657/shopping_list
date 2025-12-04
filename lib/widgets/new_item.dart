import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/model/category.dart';
import 'package:shopping_list/model/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }}

class _NewItemState extends State<NewItem>{
  final _formkey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem(){
    _formkey.currentState!.validate();
    _formkey.currentState!.save();
    // print(_enteredName);
    // print(_enteredQuantity);
    // print(_selectedCategory);
    Navigator.of(context).pop(
      GroceryItem(id: DateTime.now().toString(), name: _enteredName, quantity: _enteredQuantity, category: _selectedCategory)
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new item..."),
      ),
      body: Padding(padding: EdgeInsets.all(12),
      child: Form(
        key: _formkey,
        child:Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                label: Text("Name"),
              ),
              validator: (value){
                if(value == null || value.isEmpty || value.length <= 1 || value.length > 50)
                {
                  return "Must have a name between 2 and 50 characters long";
                }
                return null;
              },
              onSaved: (value){
                _enteredName = value!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Quantity")
                  ),
                  initialValue: _enteredQuantity.toString(),
                  validator: (value){
                     if(value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0)
                {
                  return "Must Enter a quantity greater than 0";
                }
                    return null;
                  },
                   onSaved: (value){
                    _enteredQuantity = int.parse(value!);
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: DropdownButtonFormField(
                  items: [
                    for(final category in categories.entries)
                    DropdownMenuItem(
                      value: _selectedCategory,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: category.value.color,
                          ),
                          const SizedBox(width: 6),
                          Text(category.value.title)
                        ],
                      ),),  
                  ], 
                  onChanged: (value){
                    setState(() {
                      _selectedCategory = value!;
                    });
                  }
                  ),
              )
            ],),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(
                onPressed:(){_formkey.currentState!.reset();},
                child: Text("Reset")
                ),
              ElevatedButton(
                onPressed: _saveItem, 
                child: Text("Add Item"),
                ),
            ],)
          ],
        ) 
        ),
      ),
    );
  }
}