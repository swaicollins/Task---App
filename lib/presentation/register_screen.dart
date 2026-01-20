import 'package:flutter/material.dart';
import 'package:task/core/model/request/register/RegisterRequest.dart';
import 'package:task/core/model/response/RegisterResponse/RegisterResponse.dart';
import 'package:task/data/network/NetworkService.dart';
import '../themes/app_style.dart';
import '../themes/color_constant.dart';
import '../themes/size_utils.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<RegisterResponse>? registerResponse;
  RegisterResponse? create;
  NetworkService service = NetworkService();

  bool _isHidden = true;
  bool isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      registerResponse = service.registerUser(
        RegisterRequest(
          username: nameController.text.toString().trim(),
          password: passwordController.text.toString().trim(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05;
    double textFieldWidth = screenWidth * 0.9;
    double textFieldHeight = 74.0;

    InputDecoration textFieldDecoration(String label) {
      return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColorConstant.plainGrey),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColorConstant.teal800),
        ),
        label: Text(label),
        contentPadding: EdgeInsets.fromLTRB(14.0, 1.0, 4.0, 2.0),
        labelStyle: AppStyle.txtInterMedium18.copyWith(
          letterSpacing: 0.50,
          height: 1.00,
        ),
        filled: true,
        fillColor: ColorConstant.whiteA700,
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
      decoration: textFieldDecoration("Full Name"),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value!.isEmpty) {
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

    final registerButton = Material(
      child: MaterialButton(
        color: ColorConstant.teal800,
        shape: StadiumBorder(),
        minWidth: 350,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
              _errorMessage = '';
            });

            var registerRequest = RegisterRequest(
              username: nameController.text.trim(),
              password: passwordController.text.trim(),
            );

            try {
              RegisterResponse response =
              await service.registerUser(registerRequest);

              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User registered successfully"),
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } catch (e) {
              setState(() {
                isLoading = false;
              });

              showMessage("Registration failed:\n$e");
            }
          }
        },
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text("Sign Up", style: TextStyle(color: Colors.white)),
      ),
    );



    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: AppBar(
          backgroundColor: ColorConstant.whiteA700,
          shadowColor: ColorConstant.whiteA700,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Create an account",
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
                  Padding(padding: EdgeInsets.only(top: 45), child: nameField),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: passwordField,
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
                                : registerButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextButton(
                      child: Text(
                        "Already have an account?",
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
                            builder: (context) => LoginScreen(),
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

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
