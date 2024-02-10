import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../models/global_data.dart';
import '../../util/global_colors.dart';
import '../../service/network.dart';

class MapDetailView extends StatefulWidget{
  MapDetailView({Key? key, required this.authToken, required this.map, required this.user}) : super(key: key);
  final String authToken;
  late final MapRankingData map;
  late final User user;

  @override
  State<MapDetailView> createState() => _MapDetailViewState();
}

class _MapDetailViewState extends State<MapDetailView> {
  // for auth
  Map<String, String> headers = {};

  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.map.likedUserId.contains(widget.user.userId);
    Network network = Network(authToken: widget.authToken);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
        actions: [
          IconButton(
              icon: isLiked
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
              onPressed: () async {
                setState(() {
                  isLiked = !isLiked;
                  network.updateLikedStatus(widget.map.mapId);
                });

              },
          ),
        ],
        leading: GestureDetector(
          onTap: (){
            Get.back(result: isLiked);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 700,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: GlobalColors.textColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 5,
                            width: 100,
                          ),
                          const SizedBox(height: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Map Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Divider(),
                              const SizedBox(height: 5,),
                              Text('Level: ${widget.map.level}'),
                              Text('Number of Likes: ${widget.map.liked}'),
                              Text('Designer: ${widget.map.designer}'),
                            ],
                          ),
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