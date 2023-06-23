import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Person {
  final String name;
  late final List<Person> children;

  Person({required this.name, this.children = const []});
}

class FamilyTreeView extends StatelessWidget {
  final Person rootPerson;

  const FamilyTreeView({super.key, required this.rootPerson});

  Widget _buildNode(Person person) {
    return Column(
      children: [
        Text(person.name),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: person.children.length,
          itemBuilder: (context, index) {
            return _buildNode(person.children[index]);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Family Tree'),
      ),
      body: SingleChildScrollView(
        child:Center(
          child: Column(
            children: [
              const SizedBox(height: 100,width: 100,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50)),
                      height: 100,
                      width: 100,
                      child: Icon(Icons.person,color: Colors.white,),
                    ),
                    Container(width: 40,color: Colors.black,height: 5,),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                            borderRadius: BorderRadius.circular(50)
                          ),width: 10,height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                            borderRadius: BorderRadius.circular(50)
                          ),width: 10,height: 60,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          height: 100,
                          width: 100,
                          child: Icon(Icons.person,color: Colors.white,),
                        ),

                      ],
                    ),
                    Container(width: 40,color: Colors.black,height: 5,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50)),
                      height: 100,
                      width: 100,
                      child: Icon(Icons.woman,color: Colors.white,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

void main() {
  Person john = Person(name: 'John');
  Person mary = Person(name: 'Mary');
  Person alice = Person(name: 'Alice');
  Person bob = Person(name: 'Bob');

  john.children = [mary];
  mary.children = [alice, bob];

  runApp(
    MaterialApp(
      home: FamilyTreeView(rootPerson: john),
    ),
  );
}
