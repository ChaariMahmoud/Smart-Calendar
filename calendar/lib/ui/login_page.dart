
import 'package:calendar/controllers/user_controller.dart';
import 'package:calendar/ui/send_otp.dart';
import 'package:calendar/ui/register_page.dart';
import 'package:calendar/ui/start_page.dart';
import 'package:calendar/ui/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _staySignedIn = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkStaySignedIn();
   // _checkBiometrics();
  }

  Future<void> _checkStaySignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final staySignedIn = prefs.getBool('staySignedIn') ?? false;

    if (staySignedIn) {
      _checkBiometrics();
      final email = prefs.getString('userEmail');
      final password = prefs.getString('userPassword');

      if (email != null && password != null) {
        await userController.loginUser(email, password);
        Get.to(const SurveyPage());
      }
    }
  }

Future<void> _checkBiometrics() async {
  try {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('userEmail');
        final password = prefs.getString('userPassword');

        if (email != null && password != null) {
          await userController.loginUser(email, password);
          Get.to(const SurveyPage());
        }
      } else {
        // Handle the case where authentication fails
        Get.snackbar('Authentication Failed', 'Please try again', snackPosition: SnackPosition.BOTTOM);
        //sleep(const Duration(seconds: 1));
        //SystemNavigator.pop();
         Get.offAll(StartPage());
      }
    }
  } catch (e) {
    // Handle the exception if the authentication fails
            Get.snackbar('Authentication Failed', 'Please try again', snackPosition: SnackPosition.BOTTOM);
        //sleep(const Duration(seconds: 1));
        //SystemNavigator.pop();
         Get.offAll(StartPage());
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("Stay signed in"),
                  value: _staySignedIn,
                  onChanged: (newValue) {
                    setState(() {
                      _staySignedIn = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        await userController.loginUser(emailController.text, passwordController.text);
                        
                        if (_staySignedIn) {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('staySignedIn', true);
                          prefs.setString('userEmail', emailController.text);
                          prefs.setString('userPassword', passwordController.text);
                        }

                        Get.to(const SurveyPage());
                      } catch (e) {
                        Get.snackbar('Login Failed', "Email or password incorrect", snackPosition: SnackPosition.BOTTOM);
                      }
                    }
                  },
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Get.to(RegisterPage());
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(SendOtpPage());
                  },
                  child: const Text('Forget password? Click here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
