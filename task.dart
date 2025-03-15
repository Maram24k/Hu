//صفحة المهام 
import 'package:flutter/material.dart';
import 'dart:math';
import 'details.dart';
import 'main.dart'; // تأكد أن هذا الملف يحتوي على TaskEntryScreen
import 'profile_screen.dart';
import 'settings_screen.dart';

class TaskScreen extends StatefulWidget {
  final List<Map<String, String>> tasks;

  const TaskScreen({super.key, required this.tasks});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final Random random = Random();
  int _currentIndex = 1; // نحدد البداية على شاشة المهام (index = 1)

  void _shuffleTasks() {
    setState(() {
      widget.tasks.shuffle();
    });
  }
  void _completeTask(Map<String, String> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality( // لدعم اللغة العربية
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.all(16),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            title: Row(
              children: const [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "إنهاء المهمة",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            content: const Text(
              "هل أنت متأكد أنك أنهيت هذه المهمة؟",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
                child: const Text(
                  "إلغاء",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // هنا يتم حفظ المهمة كمنتهية في قاعدة البيانات


                  setState(() {
                    widget.tasks.remove(task); // إزالة المهمة من الشاشة فقط
                  });

                  Navigator.of(context).pop(); // إغلاق الحوار

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم إنهاء المهمة بنجاح!"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "نعم، انتهيت",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          tasks: List.from(widget.tasks.map((task) => {
            "name": task["name"] ?? "",
            "description": task["description"] ?? "",
            "hour": task["hour"] ?? "12",
            "minute": task["minute"] ?? "00",
            "period": task["period"] ?? "AM",
          })),
        ),
      ),
    ).then((updatedTasks) {
      if (updatedTasks != null && updatedTasks is List<Map<String, String>>) {
        setState(() {
          widget.tasks.clear();
          widget.tasks.addAll(updatedTasks);
        });
      }
    });
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return; // إذا هو نفس الصفحة لا تنتقل

    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskEntryScreen(tasks: widget.tasks)),
      );
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("أنت بالفعل في صفحة المهام!")),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TaskEntryScreen(tasks: widget.tasks)),
            );
          },
        ),
        title: const Text("مهامك اليوم", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _editTasks,
          ),
        ],
      ),

      body: Stack(




        children: [
          Positioned.fill(
            child: Image.asset("asset/back2.jpg", fit: BoxFit.cover),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Image.asset("asset/logo.png", width: 110, height: 110),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: widget.tasks.map((task) {
                      double size = 100 + random.nextDouble() * 80;
                      return GestureDetector(
                        onTap: () => _completeTask(task),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: widget.tasks.contains(task) ? 1.0 : 0.0,
                          child: Container(
                            width: size,
                            height: size,





                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('asset/bubble.png'), // <-- مسار الصورة
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),



                            alignment: Alignment.center,
                            child: Text(
                              task["name"] ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _shuffleTasks,
                    icon: const Icon(Icons.shuffle),
                    label: const Text("إعادة ترتيب المهام"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber[700],
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}

