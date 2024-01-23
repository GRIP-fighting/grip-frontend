import 'package:flutter/material.dart';
import 'package:madcamp_week4/utils/global_data.dart';

import '../../utils/global_colors.dart';

class MapDetailView extends StatelessWidget{
  MapDetailView({Key? key, required this.authToken, required this.map,}) : super(key: key);
  final String authToken;
  late final MapRankingData map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
        centerTitle: true,
        title: Text(
          map.mapName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Map Information',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10,),
                            child: const Divider(),
                          ),
                          const SizedBox(height: 5,),
                          Text('Map Path: ${map.mapPath}'),
                          Text('Level: ${map.level}'),
                          Text('Number of Likes: ${map.liked}'),
                          Text('Designer: ${map.designer}'),
                        ],
                      ),
                    )
                ),
              );
            },
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset('assets/dummy_wall.jpeg', fit: BoxFit.contain),
        ),
      ),
    );
  }

}