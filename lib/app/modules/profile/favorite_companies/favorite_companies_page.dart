import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/profile/favorite_companies/favorite_companies_store.dart';
import 'package:roadmap/app/modules/profile/followed_companies/followed_companies_store.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../../shared/models/company.dart';
import '../../../shared/theme/app_colors.dart';

class FavoriteCompaniesPage extends StatefulWidget {
  const FavoriteCompaniesPage({Key? key}) : super(key: key);

  @override
  _FavoriteCompaniesPageState createState() => _FavoriteCompaniesPageState();
}

class _FavoriteCompaniesPageState extends State<FavoriteCompaniesPage> {
  final store = Modular.get<FavoriteCompaniesStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Companies')),
      body: Observer(builder: (context) {
        return ComponentTemplate(
          state: store.pageState,
          screen: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: store.favoriteCompanies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: companyItem(context, store.favoriteCompanies[index]),
                        );
                      }))
            ]),
          ),
        );
      }),
    );
  }

  Widget companyItem(BuildContext context, CompanyModel company) {
    final theme = Theme.of(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(company.coverImage ?? ""))),
              ),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 1,
                left: 1,
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Image.network(company.logo ?? ""))),
                ),
              ),
              Positioned(
                bottom: 40,
                right: 1,
                left: 1,
                child: Text(
                  company.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headline5!.copyWith(color: AppColors.white),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 1,
                left: 1,
                child: Text(
                  'Software Company',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2!.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Modular.dispose<FavoriteCompaniesStore>();
    super.dispose();
  }
}
