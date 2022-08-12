import 'package:flutter/material.dart';
import 'package:roadmap/app/shared/models/scheduler_model.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';

class UserRoadmapsPage extends StatefulWidget {
  List<Roadmap> roadmaps;

  UserRoadmapsPage(this.roadmaps);

  @override
  _UserRoadmapsPageState createState() => _UserRoadmapsPageState();
}

class _UserRoadmapsPageState extends State<UserRoadmapsPage> {
  Roadmap? selectedRoadmap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Select optional nodes to add to your exam',
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.roadmaps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: nodeTile(widget.roadmaps[index], context),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedRoadmap);
                },
                child: Text('Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.white)))
          ],
        ),
      ),
    );
  }

  Widget nodeTile(Roadmap roadmap, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ListTile(
        selectedTileColor: AppColors.primary.withOpacity(0.2),
        title: Text(roadmap.name, style: Theme.of(context).textTheme.titleMedium),
        selected: selectedRoadmap == roadmap,
        onTap: () {
          setState(() {
            selectedRoadmap = roadmap;
          });
        },
      ),
    );
  }
}
