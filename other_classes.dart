import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset("assets/logo.png", height: 500),
        ),
      ),
    );
  }
}

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),
              SizedBox(
                width: 280,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: Center(
                    child: Text(
                      "تسجيل دخول",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  items: ['مستخدم', 'مسؤول'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Center(
                        child: Text(
                          role,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          textAlign: TextAlign.center, // لضمان أن النص داخل القائمة في المنتصف أيضًا
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // الخلفية البيضاء
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // زوايا مستديرة
                      borderSide: BorderSide(color: Colors.grey), // حدود رمادية خفيفة
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  dropdownColor: Colors.white, // لون قائمة الاختيارات
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_small.png', height: 129, width: 105),
                  SizedBox(height: 20),
                  Text(
                    "مرحبا بعودتك",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اسم المستخدم أو البريد الإلكتروني",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 280,
                          height: 48,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "كلمة المرور",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 280,
                          height: 48,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 280,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFCC63),
                      ),
                      onPressed: () {},
                      child: Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text("ليس لديك حساب؟ أنشئ حساب جديد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: Text("هل نسيت كلمة المرور؟", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/signup_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    "التسجيل",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(label: "اسم المستخدم"),
                  CustomTextField(label: "البريد الإلكتروني"),
                  CustomTextField(label: "كلمة المرور", isPassword: true),
                  CustomTextField(label: "تأكيد كلمة المرور", isPassword: true),
                  SizedBox(height: 20),
                  Container(
                    width: 280,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFCC63),
                      ),
                      child: Text(
                        "تسجيل",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.white54, thickness: 1),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "لديك حساب بالفعل؟ سجل الدخول",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
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
}

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;

  const CustomTextField({required this.label, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 280,
          height: 48,
          child: TextField(
            obscureText: isPassword,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("هل نسيت كلمة المرور؟", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text("يرجى كتابة بريدك الإلكتروني لاستلام رمز التأكيد وإعادة تعيين كلمة المرور", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
            SizedBox(height: 20),
            InputField(hint: "عنوان البريد الإلكتروني"),
            SizedBox(height: 20),
            ConfirmButton(text: "تأكيد البريد الإلكتروني", onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen()));
            }),
            SizedBox(height: 10),
            BackButtonWidget()
          ],
        ),
      ),
    );
  }
}

class VerifyCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("التحقق من البريد الإلكتروني", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text("تم إرسال رمز التحقق على البريد الإلكتروني التالي", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
            Text("Nado@gmail.com", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => CodeInputBox()),
            ),
            SizedBox(height: 20),
            ConfirmButton(text: "تأكيد الرمز", onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewPasswordScreen()));
            }),
            SizedBox(height: 10),
            Text("إعادة إرسال رمز التأكيد 00:29", style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class NewPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("كلمة المرور الجديدة", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            InputField(hint: "كلمة المرور", obscureText: true),
            SizedBox(height: 20),
            InputField(hint: "تأكيد كلمة المرور", obscureText: true),
            SizedBox(height: 20),
            ConfirmButton(text: "تأكيد كلمة المرور", onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }),
            SizedBox(height: 10),
            BackButtonWidget()
          ],
        ),
      ),
    );
  }
}

class PasswordBackground extends StatelessWidget {
  final Widget child;
  PasswordBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/reset_password_screens.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: child,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hint;
  final bool obscureText;

  InputField({required this.hint, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hint,
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ConfirmButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("العودة", style: TextStyle(color: Colors.orange)),
    );
  }
}

class CodeInputBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(" ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
