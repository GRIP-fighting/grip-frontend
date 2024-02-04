import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../models/global_data.dart';
import '../../util/global_colors.dart';

class UserDetailView extends StatefulWidget {
  UserDetailView({Key? key, required this.authToken, required this.user,})
      : super(key: key);
  final String authToken;
  late final UserRankingData user;

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  // for auth
  Map<String, String> headers = {};

  Uint8List? _imageData;

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
    radius: profileHeight,
    child: _imageData == null
        ? CircularProgressIndicator()
        : ClipOval(
            child: Image.memory(
              Uint8List.fromList(_imageData as List<int>),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
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
              '${widget.user.score}',
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
    if(_imageData == null){
      fetchImageData();
    }

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
                widget.user.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.user.email,
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

  Future<void> fetchImageData() async {
    // set cookie
    headers['cookie'] = "x_auth=${widget.authToken}";

    try {
      final response = await http.get(Uri.parse('http://143.248.225.53:8000/api/users/profileImage/${widget.user.userId}'), headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          _imageData = response.bodyBytes;
        });
      } else {
        print('Failed to load image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}