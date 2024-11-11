import 'package:flutter/material.dart';
import 'package:fsek_mobile/services/user.service.dart';

class ForgottenPassword {
  static void openDialog(BuildContext context,
      TextEditingController resetController, UserService? userService) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String contentText = "Enter email to reset password";
          bool notClicked = true;
          bool loading = false;
          bool validate = false;
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: <Widget>[
                  Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: GestureDetector(
                          key: Key('back_btn'),
                          child: Icon(Icons.close),
                          onTap: () => Navigator.of(context).pop())),
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              width: 220.0,
                              child: Text(
                                contentText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //fontWeight: FontWeight.w600,
                                  //color: Colors.black,
                                ),
                              )),
                        ),
                        Visibility(
                          visible: notClicked,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: 300.0,
                              child: TextFormField(
                                key: Key('email_field'),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.account_circle),
                                  errorText:
                                      validate ? 'Please input an email' : null,
                                ),
                                controller: resetController,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !loading && notClicked,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(children: <Widget>[
                              ElevatedButton(
                                  key: Key('submit_btn'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary),
                                  child: Text(
                                    "SUBMIT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      resetController.text.isEmpty
                                          ? validate = true
                                          : validate = false;
                                    });
                                    if (!validate) {
                                      setState(() {
                                        loading = true;
                                      });
                                      userService!
                                          .resetPasswordRequest(
                                              resetController.text)
                                          .then((success) {});
                                      setState(() {
                                        contentText =
                                            "Your password has been reset. An email has been sent with your new password.";
                                        notClicked = false;
                                        loading = false;
                                        resetController.text = "";
                                      });
                                    }
                                  }),
                              Visibility(
                                  visible: loading,
                                  child: CircularProgressIndicator())
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }
}
