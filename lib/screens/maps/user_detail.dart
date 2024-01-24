import 'package:flutter/material.dart';
import 'package:madcamp_week4/widgets/global_button.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_data.dart';

class UserDetailView extends StatelessWidget {
  UserDetailView({Key? key, required this.authToken, required this.user,})
      : super(key: key);
  final String authToken;
  late final UserRankingData user;

  // image widgets
  final double coverHeight = 200;
  final double profileHeight = 50;

  Widget buildCoverImage() => Container(
    color: GlobalColors.textColor,
    child: Image.asset(
      'assets/dummy_wall.jpeg',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),
  );

  Widget buildProfileImage () => CircleAvatar(
    backgroundColor: GlobalColors.textColor.withOpacity(0.1),
    radius: profileHeight,
    backgroundImage: const AssetImage(
        'assets/avatar.jpeg',
    ),
  );

  Widget buildTop() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // cover image
        Container(
          margin: EdgeInsets.only(bottom: ((coverHeight - profileHeight)/2)),
            child: buildCoverImage(),
        ),
        // profile image
        Positioned(
          top: (coverHeight - profileHeight),
          child: buildProfileImage(),
        ),
      ],
    );
  }

  // content widgets
  Widget buildContent() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'User Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5,),
        const Divider(),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Score',
              style: TextStyle(
                color: GlobalColors.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${user.score}',
              style: TextStyle(
                color: GlobalColors.textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        foregroundColor: Colors.white.withOpacity(0.4),
      ),
      body: Column(
          children: <Widget>[
            buildTop(),
            Text(
                user.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              color: GlobalColors.textColor.withOpacity(0.1),
              width: double.infinity,
              height: 10,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  buildContent(),
                ],
              ),
            ),
          ],
        ),
    );


  }
}