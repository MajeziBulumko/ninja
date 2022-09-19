import 'package:flutter/material.dart';
import 'package:think_ninja/screens/add_product.dart';
import 'package:think_ninja/screens/view_products_by_category.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  //this will help us know when an action can be pressed
  bool greyed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() async {
          await Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const addProduct())));
        }),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Category>?>(
        future: DatabaseHelper.getAllCategory(),
        builder: (context, AsyncSnapshot<List<Category>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                padding: const EdgeInsets.all(13),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const CategoryView();
                      }));
                    });
                  },
                  onLongPress: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                const Text('Do you wanna delete this category'),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () async {
                                  await DatabaseHelper.deleteCategory(
                                      snapshot.data![index]);
                                  setState(() {});
                                },
                                child: const Text('Yes'),
                              ),
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'))
                            ],
                          );
                        });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    color: Colors.amber[index * 100],
                    child: Center(child: Text(snapshot.data![index].category)),
                  ),
                ),
              );
            }
            return const Center(
              child: Text('No Categories Yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
