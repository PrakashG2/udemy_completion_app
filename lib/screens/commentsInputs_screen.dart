import 'package:api_prov_try/models/comments_model.dart';
import 'package:api_prov_try/provider/comments_data_class.dart';
import 'package:api_prov_try/widgets/alert_daialog_widget.dart';
import 'package:api_prov_try/widgets/snackbar_widget.dart';

//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentInputs extends StatefulWidget {
  const CommentInputs({super.key, required this.editMode, required this.id});

  final bool editMode;
  final int id;

  @override
  State<CommentInputs> createState() => _CommentInputsState();
}

class _CommentInputsState extends State<CommentInputs> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //---------------------------------------------> CONTROLLERS
  TextEditingController postIdController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  //---------------------------------------------> INIT
  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      loadInputFields();
    }
  }

  //-------------------------------------> ALERT
  void submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      bool? result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CommentAlertDialog();
        },
      );

      if (result == true) {
        widget.editMode ? _editComment(widget.id.toString()) : _addComment();
      }
    }
  }

  //--------------------------------> LOAD INPUT FIELDS IF IT IS IN EDIT MODE
  void loadInputFields() {
    final commentsProvider =
        Provider.of<CommentsProvider>(context, listen: false);

    setState(() {
      postIdController.text =
          commentsProvider.commentsList![widget.id].postId.toString();
      idController.text =
          commentsProvider.commentsList![widget.id].id.toString();
      nameController.text =
          commentsProvider.commentsList![widget.id].name.toString();
      emailController.text =
          commentsProvider.commentsList![widget.id].email.toString();
      bodyController.text =
          commentsProvider.commentsList![widget.id].body.toString();
    });
  }

  void snackBar(String message, IconData icon) {
    AwesomeSnackbar.show(context, message, icon);
  }

  Future<void> _editComment(String id) async {
    try {
      CommentsModel inputData = CommentsModel(
        postId: int.parse(postIdController.text),
        id: int.parse(idController.text),
        name: emailController.text,
        email: nameController.text,
        body: bodyController.text,
      );

      var response = Provider.of<CommentsProvider>(context, listen: false);
      await response.editCommentProvider(inputData, id);

      if (response.responseCode == 200) {
        snackBar("COMMENT EDITED SUCCESSFULLY", Icons.thumb_up_rounded);
        Navigator.pop(context);
      } else {
        print(
            'ERROR @_editComment PROVIDER RESPONSE *****: ${response.responseCode}');
        snackBar("SOMETHING WENT WRONG", Icons.thumb_down_rounded);
        Navigator.pop(context);
      }
    } catch (e) {
      print('ERROR EDITING COMMENT *****: $e');
    }
  }

  //----------------------------------------------------------------------> POST DATA
  Future<void> _addComment() async {
    try {
      CommentsModel addCommentData = CommentsModel(
        postId: int.parse(postIdController.text),
        id: int.parse(idController.text),
        name: nameController.text,
        email: emailController.text,
        body: bodyController.text,
      );

      var provider = Provider.of<CommentsProvider>(context, listen: false);
      await provider.postData(addCommentData);

      setState(() {
        loading = true;
      });

      if (provider.responseCode == 201) {
        // ignore: use_build_context_synchronously
        AwesomeSnackbar.show(context, "Success", Icons.thumb_up_rounded);
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        AwesomeSnackbar.show(context, 'Something went wrong', Icons.warning);
      }
    } catch (e) {
      print('ERROR ADDING COMMENT *****: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<CommentsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editMode ? "EDIT" : "ADD COMMENT"),
      ),
      body: providerData.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: postIdController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "POST ID",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length >= 4) {
                                return "POST ID SHOULD BE BETWEEN 1-5 CHARACTERS";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: idController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "ID",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "ID IS REQUIRED";
                              } else if (!RegExp(r'^[0-9]+$')
                                  .hasMatch(value.trim())) {
                                return "ID SHOULD CONTAIN ONLY NUMERICS";
                              } else if (value.trim().length > 5) {
                                return "ID SHOULD BE AT MOST 5 CHARACTERS";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "NAME",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "NAME IS REQUIRED";
                              } else if (!RegExp(r'^[a-zA-Z]+$')
                                  .hasMatch(value.trim())) {
                                return "NAME SHOULD CONTAIN ONLY ALPHABETS";
                              } else if (value.trim().length > 14) {
                                return "NAME SHOULD BE AT MOST 14 CHARACTERS";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "E MAIL",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "E-MAIL IS REQUIRED";
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(value)) {
                                return "PLEASE ENTER A VALID E-MAIL";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: bodyController,
                            maxLength: 500,
                            decoration: InputDecoration(
                                labelText: "BODY",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "BODY IS REQUIRED";
                              } else if (value.trim().length < 5) {
                                return "BODY SHOULD BE AT LEAST 5 CHARACTERS";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton.large(
                                onPressed: () {
                                  submit(context);
                                },
                                splashColor: Colors.red,
                                elevation: 5,
                                child: const Icon(
                                  Icons.arrow_circle_right_rounded,
                                  size: 50,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
