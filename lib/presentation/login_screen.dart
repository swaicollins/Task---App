import 'package:flutter/material.dart';
import 'package:task/core/model/request/LoginRequest/LoginRequest.dart';
import 'package:task/data/network/NetworkService.dart';
import 'package:task/presentation/register_screen.dart';
import '../core/local/local_user.dart';
import '../core/model/response/LoginResponse/LoginResponse.dart';
import '../data/sharedPreference/shared_preference_helper.dart';
import '../themes/app_style.dart';
import '../themes/color_constant.dart';
import '../themes/size_utils.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  NetworkService service = NetworkService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  bool isLoading = false;
  String _errorMessage = '';
  Future<LoginResponse>? loginResponse;
  LoginResponse? login;

  @override
  void initState() {
    super.initState();
    setState(() {
      loginResponse = service.loginUser(
        LoginRequest(
          username: nameController.text.toString().trim(),
          password: passwordController.text.toString().trim(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textFieldWidth = screenWidth * 0.9;
    final double textFieldHeight = screenHeight * 0.1;


    InputDecoration textFieldDecoration(String label) {
      final borderRadius = BorderRadius.circular(8);

      return InputDecoration(
        labelText: label,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 12.0,
        ),

        labelStyle: AppStyle.txtInterMedium18.copyWith(
          letterSpacing: 0.5,
          height: 1.2,
        ),

        filled: true,
        fillColor: ColorConstant.whiteA700,

        border: OutlineInputBorder(
          borderRadius: borderRadius,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: 1,
            color: ColorConstant.plainGrey,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            width: 1.5,
            color: ColorConstant.teal800,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
        ),
      );
    }


    final nameField = TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      textAlignVertical: TextAlignVertical.center,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'The name field is required.';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColorConstant.plainGrey),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColorConstant.teal800),
        ),
        label: const Text("Full Name"),
        contentPadding: const EdgeInsets.fromLTRB(14.0, 1.0, 4.0, 2.0),
        labelStyle: AppStyle.txtInterMedium18.copyWith(
          letterSpacing: 0.50,
          height: 1.00,
        ),
        filled: true,
        fillColor: ColorConstant.whiteA700,
      ),
    );
    final passwordField = TextFormField(
      controller: passwordController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required.";
        } else if (value.length < 6) {
          return "Password must be at least 6 characters.";
        }
        return null;
      },
      obscureText: _isHidden,
      decoration: textFieldDecoration("Password").copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
            color: ColorConstant.lightGray,
          ),
          onPressed: _togglePasswordView,
        ),
      ),
    );


    final login = Container(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });

            var login = LoginRequest(
              username: nameController.text.toString().trim(),
              password: passwordController.text.toString().trim(),
            );

            try {
              final value = await service.loginUser(login);

              saveUserOffline(value);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                  ),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User logged in successfully")),
              );
            } catch (error) {
              showMessage("Incorrect Credentials");
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: ColorConstant.teal800,
          minimumSize: const Size(360, 55),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          "Log In",
          style: AppStyle.txtInterMediums18.copyWith(
            letterSpacing: 0.72,
          ),
        ),
      ),
    );


    return Scaffold(
      backgroundColor: ColorConstant.whiteA700,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: ColorConstant.black900,
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const AccountScreen()));
          },
        ),
        backgroundColor: ColorConstant.whiteA700,
        shadowColor: ColorConstant.whiteA700,
        elevation: 0.0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Login to your account",
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: getFontSize(34),
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.05),
                        child: Container(
                          width: textFieldWidth,
                          child: nameField,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: Container(
                          width: textFieldWidth,
                          child: passwordField,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 15),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: getPadding(bottom: 2),
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : login,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: TextButton(
                          child: Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: ColorConstant.teal800,
                              fontSize: getFontSize(17),
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<LocalUser> saveUserOffline(LoginResponse value) async {
    var localUser = LocalUser(accessToken: value.token);
    await SharedPreferenceHelper()
        .saveUserInformation(localUser)
        .whenComplete(() {});
    return localUser;
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
