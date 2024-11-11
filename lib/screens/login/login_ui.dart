import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';

import 'package:fsek_mobile/util/authentication/authentication_bloc.dart';
import 'package:fsek_mobile/util/authentication/login_bloc.dart';
import 'package:fsek_mobile/services/user.service.dart';
import 'package:fsek_mobile/util/authentication/login_event.dart';
import 'package:fsek_mobile/util/authentication/login_state.dart';
import 'package:fsek_mobile/widgets/forgotten_password.dart';

class LoginUI extends StatefulWidget {
  final LoginBloc? loginBloc;
  final AuthenticationBloc? authenticationBloc;
  final UserService? userService;

  LoginUI({
    Key? key,
    required this.loginBloc,
    required this.authenticationBloc,
    required this.userService,
  }) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetController = TextEditingController();

  late AnimationController _animationController;
  late Animation loginBtnAnimation;
  late Animation loadingAnimation;

  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  Color? _emailLabelColor;
  Color? _passLabelColor;

  LoginBloc? get _loginBloc => widget.loginBloc;

  @override
  void initState() {
    super.initState();

    // workaround for this bug: https://github.com/flutter/flutter/issues/21385
    // Update: The bug is fixed (since 2021), but removing this still changes stuff
    _emailLabelColor = locator<ThemeService>().theme.inputDecorationTheme.hintStyle!.color;
    _emailFocusNode.addListener(() {
      setState(() {
        _emailLabelColor = _emailFocusNode.hasFocus
            ? Theme.of(context).inputDecorationTheme.floatingLabelStyle!.color
            : Theme.of(context).inputDecorationTheme.hintStyle!.color;
      });
    });
    _passLabelColor = locator<ThemeService>().theme.inputDecorationTheme.hintStyle!.color;
    _passFocusNode.addListener(() {
      setState(() {
        _passLabelColor = _passFocusNode.hasFocus
            ? Theme.of(context).inputDecorationTheme.floatingLabelStyle!.color
            : Theme.of(context).inputDecorationTheme.hintStyle!.color;
      });
    });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    loginBtnAnimation = new Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
        new CurvedAnimation(parent: _animationController, curve: new Interval(0.0, 0.5, curve: Curves.bounceInOut)));
    loadingAnimation = new Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
        new CurvedAnimation(parent: _animationController, curve: new Interval(0.5, 1, curve: Curves.bounceInOut)));

    // Set Portrait mode only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Allow any rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    _resetController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    final FormState validForm = _formKey.currentState!;
    if (validForm.validate()) {
      _animationController.forward();
      _emailFocusNode.unfocus();
      _passFocusNode.unfocus();
      _loginBloc!.add(LoginButtonPressed(
        username: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  void onForgottenPassword() {
    ForgottenPassword.openDialog(context, _resetController, widget.userService);
  }

  @override
  Widget build(BuildContext context) {
    final _emailField = Focus(
        key: Key("login_email_field"),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.account_circle, color: _emailLabelColor),
              labelStyle: TextStyle(color: _emailLabelColor)),
          focusNode: _emailFocusNode,
          controller: _emailController,
          validator: (String? value) {
            return value!.trim().isEmpty ? 'Required field' : null;
          },
        ));
    final _passwordField = Focus(
        key: Key("login_password_field"),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
                color: _passLabelColor,
              ),
              labelStyle: TextStyle(color: _passLabelColor)),
          focusNode: _passFocusNode,
          controller: _passwordController,
          validator: (String? value) {
            return value!.isEmpty ? 'Required field' : null;
          },
        ));
    final _forgotPasswordButton = TextButton(
      key: Key("login_forgot_btn"),
      onPressed: () => onForgottenPassword(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).primaryColorLight,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.onSecondary
        ),
      ),
      child: Text(
        "Forgot my password",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
      ),
    );

    final form = Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 32.0),
            _emailField,
            SizedBox(height: 32.0),
            _passwordField,
            SizedBox(height: 20.0),
          ],
        ));

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        final _loginButton = ScaleTransition(
            scale: loginBtnAnimation as Animation<double>,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                key: Key("login_btn"),
                onPressed: state is! LoginLoading ? _onLoginButtonPressed : null,
                child: Text(
                  "Log in",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary, 
                    fontSize: 16
                  ),
                )));
        final _loadingIcon =
            ScaleTransition(scale: loadingAnimation as Animation<double>, child: CircularProgressIndicator());

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: locator<ThemeService>().loginIcon),
                          form,
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [_forgotPasswordButton]),
                          Stack(children: [Center(child: _loginButton), Center(child: _loadingIcon)])
                        ]))));
      },
      listener: (context, state) {
        // Show Errors in snackbar
        if (state is! LoginLoading) {
          _animationController.reverse();
        }
        if (state is LoginFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onError),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          });
        }
      },
    );
  }
}
