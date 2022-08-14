import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/profile/followed_depts/followed_depts_store.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

class FollowedDeptsPage extends StatefulWidget {
  const FollowedDeptsPage({Key? key}) : super(key: key);

  @override
  _FollowedDeptsPageState createState() => _FollowedDeptsPageState();
}

class _FollowedDeptsPageState extends State<FollowedDeptsPage> {
  final store = Modular.get<FollowedDeptsStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Followed Departments')),
      body: Center(
        child: Observer(builder: (context) {
          return ComponentTemplate(
            state: store.pageState,
            screen: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                    child: store.followedDepts.isEmpty
                        ? Center(
                            child: Text('No Followed Departments'),
                          )
                        : ListView.builder(
                            itemCount: store.followedDepts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: deptItem(context, store.followedDepts[index]),
                              );
                            }))
              ]),
            ),
          );
        }),
      ),
    );
  }

  Widget deptItem(BuildContext context, Department department) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title:
              Text(department.name, style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
        ));
  }

  @override
  void dispose() {
    Modular.dispose<FollowedDeptsStore>();
    super.dispose();
  }
}
