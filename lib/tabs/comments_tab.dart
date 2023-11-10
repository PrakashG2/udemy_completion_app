import 'dart:async';

import 'package:api_prov_try/provider/comments_data_class.dart';
import 'package:api_prov_try/screens/commentsInputs_screen.dart';
import 'package:api_prov_try/widgets/comment_input_widget.dart';
import 'package:api_prov_try/widgets/snackbar_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class CommentsTab extends StatefulWidget {
  const CommentsTab({super.key});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  
  //-------------------------------------------------------------------------> BUTTONS
  Icon commentSocioButtons() {
    return Icon(Icons.thumbs_up_down);
  }
  //-------------------------------------------------------------------------> INIT

  @override
  void initState() {
    super.initState();
    final postModel = Provider.of<CommentsProvider>(context, listen: false);
    postModel.getPostData();

   
  }

  

  //-----------------------------------------------------------------------> UI PART

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
//-----------------------------------------------------------> LOADER TO COMPENSATE API FETCH DELAY
    if (commentsProvider.getPostloading) {
      return const Center(child: CircularProgressIndicator());
    }

    //----------------------------------------------------> API EMPTY RESPOND HANDLER
    if (commentsProvider.commentsList!.isEmpty) {
      return const Center(child: Text("oops, its empty"));
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: commentsProvider.commentsList?.length,
        itemBuilder: (context, index) {
//-----------------------------------------------> TO PROCESS THE NAME
          String? truncatedName;
          if (commentsProvider.commentsList != null &&
              index < commentsProvider.commentsList!.length) {
            truncatedName = commentsProvider.commentsList![index].name.length >
                    20
                ? '${commentsProvider.commentsList![index].name.substring(0, 20)}...'
                : commentsProvider.commentsList![index].name;
          } else {
            truncatedName = '';
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Dismissible(
              key: ValueKey(commentsProvider.commentsList![index]),
              onDismissed: (direction) {
                setState(() {
                  commentsProvider.commentsList?.removeAt(index);
                });
                int postId = commentsProvider.commentsList![index].id;
                commentsProvider.customDismissFunction(postId);
                if (commentsProvider.dismissStatus == 200) {
                  print(commentsProvider.dismissStatus);
                  AwesomeSnackbar.show(
                      context, "Dissmised Successfully", Icons.thumb_up);
                } else {
                  AwesomeSnackbar.show(
                      context, "something went wrong", Icons.thumb_down);
                }
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 233, 231, 231),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              commentsProvider.commentsList?[index].name[0]
                                      .toUpperCase() ??
                                  "",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(truncatedName),
                              Text(
                                "@ ${commentsProvider.commentsList![index].email}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 85, 81, 81),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return CommentInput(
                                    //         editMode: true, postId: index);
                                    //   },
                                    // );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CommentInputs(
                                                editMode: true, id: (index))));
                                  },
                                  icon: const Icon(Icons.edit))
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ReadMoreText(
                            commentsProvider.commentsList?[index].body ?? "",
                            trimLines: 3,
                            preDataTextStyle:
                                TextStyle(fontWeight: FontWeight.w500),
                            style: TextStyle(color: Colors.black),
                            colorClickableText:
                                Color.fromARGB(255, 0, 119, 255),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: '\nShow less',
                          ),
                          const SizedBox(height: 10),
                          Theme(
                            data: ThemeData(
                              iconTheme: IconThemeData(
                                color: Colors.black,
                                size: 18.0,
                              ),
                              // Other theme configurations
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      8.0), // Adjust the padding as needed
                                  child: Icon(
                                    Icons.thumb_up_off_alt_rounded,
                                    color: Colors.blue, // Set the desired color
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.thumb_down_alt_rounded,
                                    color: Colors.red, // Set the desired color
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.flag_circle_rounded,
                                    color:
                                        Colors.green, // Set the desired color
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return const CommentInput(editMode: false, postId: 0);
          //   },
          // );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentInputs(
                      editMode: false,
                      id: (commentsProvider.commentsList!.length + 1))));
        },
      ),
    );
  }
}
