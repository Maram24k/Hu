import 'package:flutter/material.dart';
import 'main.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class DetailsScreen extends StatefulWidget {
  final List<Map<String, String>> tasks;

  const DetailsScreen({super.key, required this.tasks});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> descriptionControllers;
  late List<String> hours;
  late List<String> minutes;
  late List<String> periods;

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    nameControllers = widget.tasks
        .map((task) => TextEditingController(text: task["name"]))
        .toList();

    descriptionControllers = widget.tasks
        .map((task) => TextEditingController(text: task["description"]))
        .toList();

    hours = widget.tasks.map((task) => task["hour"] ?? "12").toList();
    minutes = widget.tasks.map((task) => task["minute"] ?? "00").toList();
    periods = widget.tasks.map((task) => task["period"] ?? "AM").toList();
  }

  void _saveChanges() {
    setState(() {
      for (int i = 0; i < widget.tasks.length; i++) {
        widget.tasks[i]["name"] = nameControllers[i].text;
        widget.tasks[i]["description"] = descriptionControllers[i].text;
        widget.tasks[i]["hour"] = hours[i];
        widget.tasks[i]["minute"] = minutes[i];
        widget.tasks[i]["period"] = periods[i];
      }
    });

    // ارجاع البيانات للصفحة السابقة
    Navigator.pop(context, widget.tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
      nameControllers.removeAt(index);
      descriptionControllers.removeAt(index);
      hours.removeAt(index);
      minutes.removeAt(index);
      periods.removeAt(index);
    });
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskEntryScreen(tasks: widget.tasks)),
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
    final List<String> hourOptions = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
    final List<String> minuteOptions = List.generate(60, (index) => index.toString().padLeft(2, '0'));
    final List<String> periodOptions = ["AM", "PM"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text("تعديل المهام", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("asset/back2.jpg", fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // عنوان المهمة مع زر حذف
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "المهمة ${index + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      // تأكيد قبل الحذف
                                      showDialog(
                                        context: context,
                                        builder: (context) => Directionality(
                                          textDirection: TextDirection.rtl, // هذا يخلي كل شيء RTL
                                          child: AlertDialog(
                                            title: const Text("تأكيد الحذف"),
                                            content: const Text("هل أنت متأكد أنك تريد حذف هذه المهمة؟"),
                                            actions: [
                                              // زر إلغاء (يسار)
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text(
                                                  "إلغاء",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                              ),

                                              // زر حذف (يمين)
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteTask(index);
                                                },
                                                child: const Text(
                                                  "حذف",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // حقل اسم المهمة
                              TextField(
                                controller: nameControllers[index],
                                decoration: InputDecoration(
                                  labelText: "اسم المهمة",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // حقل وصف المهمة
                              TextField(
                                controller: descriptionControllers[index],
                                decoration: InputDecoration(
                                  labelText: "وصف المهمة",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // حقل الوقت (ساعات - دقائق - AM/PM)
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: hours[index],
                                      items: hourOptions.map((hour) {
                                        return DropdownMenuItem<String>(
                                          value: hour,
                                          child: Text(hour),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          hours[index] = value!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: "الساعة",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: minutes[index],
                                      items: minuteOptions.map((minute) {
                                        return DropdownMenuItem<String>(
                                          value: minute,
                                          child: Text(minute),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          minutes[index] = value!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: "الدقيقة",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: periods[index],
                                      items: periodOptions.map((period) {
                                        return DropdownMenuItem<String>(
                                          value: period,
                                          child: Text(period),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          periods[index] = value!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: "AM/PM",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // زر حفظ التغييرات أسفل الشاشة
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text("حفظ التغييرات"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
