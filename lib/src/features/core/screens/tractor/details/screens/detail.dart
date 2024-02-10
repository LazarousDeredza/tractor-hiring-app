import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tractor_hiring_app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:tractor_hiring_app/src/features/core/screens/tractor/details/constant.dart';
import 'package:tractor_hiring_app/src/features/core/screens/tractor/model_product.dart';
import 'package:tractor_hiring_app/src/features/core/screens/tractor/view_image.dart';
import 'package:tractor_hiring_app/src/features/core/services/widgets/widgets.dart';
import 'package:tractor_hiring_app/src/repository/authentication_repository/authentication_repository.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _productFuture;

  late String? userId;
  int quantity = 1;
  String payingphone = "";
  bool _isLoading = false;

  String selectedOption = 'hour';
  String firstName = "";
  String lastName = "";

  @override
  void initState() {
    super.initState();
    _productFuture =
        FirebaseFirestore.instance.collection('tractors').doc(widget.id).get();

    //initiate the user id from firebase
    userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("users")
        .doc(AuthenticationRepository.instance.firebaseUser.value!.uid)
        .get()
        .then((value) {
      setState(() {
        firstName = value.data()!["firstName"];
        lastName = value.data()!["lastName"];

        print(value.data()!['firstName']);
        print(value.data()!['lastName']);

        print("$firstName $lastName");

        // if (value.data()!["level"] == "admin") {
        //   isAdmin = true;
        // }
      });
    });
  }

  final _commentController = TextEditingController();
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 19, 19),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data!.data();
          final productImages = data!['productImages'];

          List<String>? castedProductImageUrls;
          if (productImages is List<dynamic>) {
            castedProductImageUrls = productImages.cast<String>().toList();
          }

//20% discount on monthly price
          double weeklyPrice =
              ((int.parse(data['productPrice']) * 24) * 7) * 0.8;

          //10% discount on weekly price
          double dailyPrice = (int.parse(data['productPrice']) * 24) * 0.9;

          return SafeArea(
            child: Stack(
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(26, 16, 231, 8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child:
                                    Icon(Icons.arrow_back, color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: kShadeColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.save),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/home.png"),
                          const SizedBox(width: 5),
                          Text(data['productName'], style: kCarTitle),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: castedProductImageUrls!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyImageWidget(
                                            imageUrl:
                                                castedProductImageUrls![index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      castedProductImageUrls![index],
                                      width: 350,
                                      height: 310,
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 49, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description', style: kSectionTitle),
                          const SizedBox(height: 10),
                          Text(
                            data['productDetails'],
                            style: kBrand.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fuel Type', style: kSectionTitle),
                          const SizedBox(height: 10),
                          Text(
                            data['fuelType'],
                            style: kBrand.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Specs', style: kSectionTitle),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/speed.png'),
                                    const SizedBox(height: 3),
                                    Text(data['topSpeed'] + " Km/Hr",
                                        style: kBrand),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Max. Speed',
                                      style: kBrand.copyWith(
                                        color: kTextColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/seat.png'),
                                    const SizedBox(height: 3),
                                    Text(data['power'] + " HH", style: kBrand),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Horse Power',
                                      style: kBrand.copyWith(
                                        color: kTextColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/engine.png'),
                                    const SizedBox(height: 3),
                                    Text(data['engineCapacity'] + " CC",
                                        style: kBrand),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Engine Capacity',
                                      style: kBrand.copyWith(
                                        color: kTextColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/engine.png'),
                                    const SizedBox(height: 3),
                                    Text(data['fuelConsumption'] + " L/Km",
                                        style: kBrand),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Fuel Consumption',
                                      style: kBrand.copyWith(
                                        color: kTextColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Prices', style: kSectionTitle),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption = 'week';
                                    });
                                  },
                                  child: Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.28,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedOption == 'week'
                                          ? kSecondaryColor.withOpacity(0.8)
                                          : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "\$" +
                                                weeklyPrice.toStringAsFixed(2),
                                            style: kPrice),
                                        const SizedBox(height: 2),
                                        Text(
                                          '/week',
                                          style: kRate.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: kTextColor.withOpacity(0.6),
                                          ),
                                        ),
                                        Text(
                                          '20% off',
                                          style: kRate.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: kTextColor.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption = 'day';
                                    });
                                  },
                                  child: Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.28,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedOption == 'day'
                                          ? kSecondaryColor.withOpacity(0.8)
                                          : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "\$" +
                                                dailyPrice.toStringAsFixed(2),
                                            style: kPrice),
                                        const SizedBox(height: 2),
                                        Text(
                                          '/day',
                                          style: kRate.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: kTextColor.withOpacity(0.6),
                                          ),
                                        ),
                                        Text(
                                          '10% off',
                                          style: kRate.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: kTextColor.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption = 'hour';
                                    });
                                  },
                                  child: Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.28,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedOption == 'hour'
                                          ? kSecondaryColor.withOpacity(0.8)
                                          : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(r'$' + data['productPrice'],
                                            style: kPrice),
                                        const SizedBox(height: 2),
                                        Text(
                                          '/hour',
                                          style: kRate.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: kTextColor.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                      child: Center(
                        child: Text(
                          "Comments",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: TextField(
                              controller: _commentController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Add a Comment',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: isSaving
                              ? () {
                                  print("is saving");
                                }
                              : submitComment,
                          //submit comment to firebase

                          child: const Text('Submit'),
                        ),
                      ],
                    ),

                    //show a list of comments from firebase where case id is equal to the case id of the case being viewed and approved is equal to yes
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .where('productID', isEqualTo: widget.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('No Comments available'));
                        }

                        final comments = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Column(children: [
                                ListTile(
                                  leading:
                                      //user profile icon
                                      const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child:
                                              Text(comments[index]['comment']),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          children: [
                                            //like icon
                                            GestureDetector(
                                              onTap: () async {
                                                //update the likes field in firebase

                                                LikeAndDislike likeAndDilike =
                                                    LikeAndDislike(
                                                        productID: widget.id,
                                                        userID: userId,
                                                        date: DateTime.now()
                                                            .toString());

                                                //check if the user has already liked the comment
                                                await FirebaseFirestore.instance
                                                    .collection('comments')
                                                    .doc(comments[index].id)
                                                    .collection('likes')
                                                    .where('userID',
                                                        isEqualTo: userId)
                                                    .get()
                                                    .then((value) async => {
                                                          if (value
                                                              .docs.isEmpty)
                                                            {
                                                              //check if i had disliked the comment before and remove it ,and deduct the number of dislikes by 1
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'comments')
                                                                  .doc(comments[
                                                                          index]
                                                                      .id)
                                                                  .collection(
                                                                      'dislikes')
                                                                  .where(
                                                                      'userID',
                                                                      isEqualTo:
                                                                          userId)
                                                                  .get()
                                                                  .then(
                                                                      (value) async =>
                                                                          {
                                                                            if (value.docs.isNotEmpty)
                                                                              {
                                                                                //remove the user from the dislikes collection
                                                                                await FirebaseFirestore.instance.collection('comments').doc(comments[index].id).collection('dislikes').doc(value.docs.first.id).delete().then((value) => {
                                                                                      //update the dislikes field in the comments collection
                                                                                      FirebaseFirestore.instance.collection('comments').doc(comments[index].id).update({
                                                                                        'numberOfDislikes': comments[index]['numberOfDislikes'] - 1
                                                                                      })
                                                                                    })
                                                                              }
                                                                          }),

                                                              //add the user to the likes collection
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'comments')
                                                                  .doc(comments[
                                                                          index]
                                                                      .id)
                                                                  .collection(
                                                                      'likes')
                                                                  .add(likeAndDilike
                                                                      .toJson())
                                                                  .then(
                                                                      (value) async =>
                                                                          {
                                                                            //update the likes field in the comments collection
                                                                            await FirebaseFirestore.instance.collection('comments').doc(comments[index].id).update({
                                                                              'numberOfLikes': comments[index]['numberOfLikes'] + 1
                                                                            }).then((value) =>
                                                                                {
                                                                                  //toast message
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(
                                                                                      content: Text('Comment liked successfully'),
                                                                                    ),
                                                                                  ),
                                                                                })
                                                                          })
                                                            }
                                                          else
                                                            {
                                                              //toast message
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'You have already liked this comment'),
                                                                ),
                                                              ),
                                                            }
                                                        });
                                              },
                                              child: const Icon(
                                                Icons.thumb_up,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(
                                                    '${comments[index]['numberOfLikes']}')),
                                            const SizedBox(width: 40.0),
                                            //dislike icon
                                            GestureDetector(
                                              onTap: () async {
                                                //update the likes field in firebase

                                                LikeAndDislike likeAndDilike =
                                                    LikeAndDislike(
                                                        productID: widget.id,
                                                        userID: userId,
                                                        date: DateTime.now()
                                                            .toString());

                                                //check if the user has already disliked the comment
                                                await FirebaseFirestore.instance
                                                    .collection('comments')
                                                    .doc(comments[index].id)
                                                    .collection('dislikes')
                                                    .where('userID',
                                                        isEqualTo: userId)
                                                    .get()
                                                    .then((value) async => {
                                                          if (value
                                                              .docs.isEmpty)
                                                            {
                                                              //check if i had liked the comment before and remove it ,and deduct the number of likes by 1
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'comments')
                                                                  .doc(comments[
                                                                          index]
                                                                      .id)
                                                                  .collection(
                                                                      'likes')
                                                                  .where(
                                                                      'userID',
                                                                      isEqualTo:
                                                                          userId)
                                                                  .get()
                                                                  .then(
                                                                      (value) async =>
                                                                          {
                                                                            if (value.docs.isNotEmpty)
                                                                              {
                                                                                //remove the user from the likes collection
                                                                                await FirebaseFirestore.instance.collection('comments').doc(comments[index].id).collection('likes').doc(value.docs.first.id).delete().then((value) async => {
                                                                                      //update the likes field in the comments collection
                                                                                      await FirebaseFirestore.instance.collection('comments').doc(comments[index].id).update({
                                                                                        'numberOfLikes': comments[index]['numberOfLikes'] - 1
                                                                                      })
                                                                                    })
                                                                              }
                                                                          }),

                                                              //add the user to the dislikes collection
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'comments')
                                                                  .doc(comments[
                                                                          index]
                                                                      .id)
                                                                  .collection(
                                                                      'dislikes')
                                                                  .add(likeAndDilike
                                                                      .toJson())
                                                                  .then(
                                                                      (value) async =>
                                                                          {
                                                                            //update the dislikes field in the comments collection
                                                                            await FirebaseFirestore.instance.collection('comments').doc(comments[index].id).update({
                                                                              'numberOfDislikes': comments[index]['numberOfDislikes'] + 1
                                                                            }).then((value) =>
                                                                                {
                                                                                  //toast message
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(
                                                                                      content: Text('Comment disliked successfully'),
                                                                                    ),
                                                                                  ),
                                                                                })
                                                                          })
                                                            }
                                                          else
                                                            {
                                                              //toast message
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'You have already disliked this comment'),
                                                                ),
                                                              ),
                                                            }
                                                        });
                                              },
                                              child: const Icon(
                                                Icons.thumb_down,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Text(
                                                '${comments[index]['numberOfDislikes']}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Divider(
                                    thickness: 2.0,
                                  ),
                                ),
                              ]),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 53,
                    width: MediaQuery.of(context).size.width - 32,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: TextButton(
                      onPressed: () {
                        //Navigator.of(context).pop();

                        MyHiring hiring = MyHiring(
                            dateAdded: DateTime.now().toString(),
                            productCategory: data['productCategory'],
                            productDetails: data['productDetails'],
                            productName: data['productName'],
                            productImages: castedProductImageUrls,
                            productPrice: data['productPrice'],
                            id: AuthenticationRepository
                                .instance.firebaseUser.value!.uid,
                            engineCapacity: data['engineCapacity'],
                            fuelConsumption: data['fuelConsumption'],
                            fuelType: data['fuelType'],
                            power: data['power'],
                            hired: false,
                            totalAmount: data['productPrice'],
                            topSpeed: data['topSpeed'],
                            quantity: 1);

                        popUpDialog(context, hiring, selectedOption,
                            weeklyPrice, dailyPrice);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kTextColor,
                        backgroundColor: kPrimaryColor,
                        textStyle: kPrice,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text('Rent This Tractor'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  popUpDialog(BuildContext context, MyHiring hiring, String selectedOption,
      double weeklyPrice, double dailyPrice) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              scrollable: true,
              actionsAlignment: MainAxisAlignment.center,
              alignment: Alignment.center,
              icon: GestureDetector(
                onTap: () {
                  setState(() {
                    quantity = 1;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
              title: Text(
                "You Selected " +
                    selectedOption +
                    " Package\n Amount: \$" +
                    (selectedOption == 'hour'
                        ? hiring.productPrice
                        : selectedOption == 'day'
                            ? dailyPrice.toString()
                            : weeklyPrice.toString()) +
                    "/" +
                    selectedOption +
                    "\nHow many do you want to rent?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading == true
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  "Processing payment...",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor),
                              ],
                            ),
                          )
                        : TextField(
                            onChanged: (val) {
                              setState(() {
                                if (val.isNotEmpty) {
                                  quantity = int.parse(val);
                                } else {
                                  quantity = 1;
                                }
                              });
                            },
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Quantity',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                    const SizedBox(height: 10),
                    //paying phone number
                    _isLoading == true
                        ? Container()
                        : TextField(
                            onChanged: (val) {
                              setState(() {
                                payingphone = val;
                              });
                            },
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Ecocash Phone Number',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                    const SizedBox(height: 10),
                    //total amount
                    Text(
                      "Total Amount: \$" +
                          (selectedOption == 'hour'
                              ? (int.parse(hiring.productPrice) * quantity)
                                  .toString()
                              : selectedOption == 'day'
                                  ? (dailyPrice * quantity).toString()
                                  : (weeklyPrice * quantity).toString()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text("Proceed To Payment"),
                    ),
                  ],
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    if (payingphone.length < 10 || payingphone.length > 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Invalid Phone Number \nuse format 077xxxxxxxx'),
                        ),
                      );
                      return;
                    }

                    if (payingphone != "0771111111" &&
                        payingphone != "0772222222" &&
                        payingphone != "0773333333" &&
                        payingphone != "0774444444") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'This application is using paynow in test mode . Please use paynow test numbers'),
                        ),
                      );

                      return;
                    }

                    if (payingphone == "0774444444") {
                      setState(() {
                        _isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 20 ~/ 2));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'There are insufficient funds in your account'),
                        ),
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.of(context).pop();

                      return;
                    }

                    if (payingphone == "0773333333") {
                      setState(() {
                        _isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 20 ~/ 2));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment Failed . User canceled'),
                        ),
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.of(context).pop();

                      return;
                    }

                    if (payingphone != "0771111111" ||
                        payingphone != "0772222222") {
                      setState(() {
                        _isLoading = true;
                      });

                      double amount = double.parse(selectedOption == 'hour'
                          ? (int.parse(hiring.productPrice) * quantity)
                              .toString()
                          : selectedOption == 'day'
                              ? (dailyPrice * quantity).toString()
                              : (weeklyPrice * quantity).toString());

                      await Future.delayed(const Duration(seconds: 20 ~/ 2));

                      int hrs = selectedOption == "hour"
                          ? quantity
                          : selectedOption == 'day'
                              ? quantity * 24
                              : quantity * 7 * 24;

                      DateTime endDte =
                          DateTime.now().add(Duration(hours: hrs));

                      MyHiring myHiring = MyHiring(
                          id: widget.id,
                          dateAdded: hiring.dateAdded,
                          endDate: endDte,
                          firstName: firstName,
                          lastName: lastName,
                          productName: hiring.productName,
                          productCategory: hiring.productCategory,
                          productDetails: hiring.productDetails,
                          productImages: hiring.productImages,
                          quantity: quantity,
                          totalAmount: amount.toString(),
                          productPrice: hiring.productPrice,
                          hired: true,
                          userId: userId,
                          topSpeed: hiring.topSpeed,
                          fuelType: hiring.fuelType,
                          engineCapacity: hiring.engineCapacity,
                          fuelConsumption: hiring.fuelConsumption,
                          power: hiring.power);

                      try {
                        final CollectionReference hiringCollection =
                            FirebaseFirestore.instance.collection("Hirings");

                        await hiringCollection.add(myHiring.toJson());

                        final db = FirebaseFirestore.instance;

                        await db
                            .collection("tractors")
                            .doc(widget.id)
                            .update({"hired": true});
                      } catch (e) {
                        // Error message
                        print(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hiring Failed')),
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment Successful'),
                        ),
                      );

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Dashboard()));

                      setState(() {
                        _isLoading = false;
                      });

                      return;
                    }

                    // setState(() {
                    //   _isLoading = true;
                    // });

                    // Paynow paynow = Paynow(
                    //     integrationKey: "ffa05013-9376-496f-aa51-524d6ae11351",
                    //     integrationId: "17003",
                    //     returnUrl: "https://google.com",
                    //     resultUrl: "https://google.com");
                    // Payment payment = paynow.createPayment(
                    //     "user", "lazarousderedza99@gmail.com");

                    // final cartItem = PaynowCartItem(
                    //     title: "Tractor Rental Payment", amount: amount);

                    // // add to cart
                    // payment.addToCart(cartItem);

                    // // add to cart with specific quantity
                    // // payment.addToCart(cartItem, quantity: 5);

                    // // Initiate Mobile Payment
                    // await paynow
                    //     .sendMobile(
                    //         payment, payingphone, MobilePaymentMethod.ecocash)
                    //     .then((InitResponse response) async {
                    //   // display results
                    //   log("Response.....");
                    //   log(response().toString());
                    //   await Future.delayed(const Duration(seconds: 20 ~/ 2));
                    // Check Transaction status from pollUrl
                    // paynow
                    //     .checkTransactionStatus(response.pollUrl)
                    //     .then((StatusResponse status) {
                    //   print(status.paid);
                    // // });
                    // if (response.instructions ==
                    //     "This+is+a+test+transaction.+Test+Case%3a+Success") {
                    //   print("Testing payment successful");

                    // String? message =
                    //     response.instructions!.replaceAll("+", " ");

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(message.replaceAll("%3", " ")),
                    //   ),
                    // );

                    // setState(() {
                    //   _isLoading = false;
                    // });
                    // Navigator.of(context).pop();
                    // });
                  },
                  child: Image.asset(
                    'assets/images/pay_with_ecocash.png',
                    width: 150,
                  ),
                ),
              ],
            );
          }));
        });
  }

  void submitComment() async {
    //only save if the comment is not empty
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment cannot be empty'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    Comment comment = Comment(
        comment: _commentController.text,
        productID: widget.id,
        userID: userId,
        date: DateTime.now().toString(),
        numberOfDislikes: 0,
        numberOfLikes: 0,
        approved: "No");

    await FirebaseFirestore.instance
        .collection('comments')
        .add(comment.toJson())
        .then((value) => {
              //clear the text field
              _commentController.clear(),
              //toast message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comment Added Successfully'),
                ),
              ),

              setState(() {
                isSaving = false;
              }),

              //show a list of comments

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    id: widget.id,
                  ),
                ),
              )
            });
  }
}
