import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }}

class _NewItemState extends State<NewItem>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new item..."),
      ),
      body: Padding(padding: EdgeInsets.all(12),
      child: Form(
        child:Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                label: Text("Name"),
              ),
              validator: (value){
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Text("Quantity")
                  ),
                  initialValue: '1',
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: DropdownButtonFormField(
                  items: [
                    for(final category in categories.entries)
                    DropdownMenuItem(
                      value: category.value,
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
                      ))  
                  ], 
                  onChanged: (value){}
                  ),
              )
            ],),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(
                onPressed:(){},
                child: Text("Reset")
                ),
              ElevatedButton(
                onPressed: (){}, 
                child: Text("Submit"),
                ),
            ],)
          ],
        ) 
        ),
      ),
    );
  }
}