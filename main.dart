//home page هذا كود خاص بصفحة ادخال المهام 
import 'package:flutter/material.dart';
import 'task.dart'; // تأكد أن الملف موجود
import 'profile_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: const TaskEntryScreen(),
    );
  }
}

class TaskEntryScreen extends StatefulWidget {
  final List<Map<String, String>> tasks;

  const TaskEntryScreen({super.key, this.tasks = const []});

  @override
  _TaskEntryScreenState createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();

  late List<Map<String, String>> tasks;

  String _selectedHour = "12";
  String _selectedMinute = "00";
  String _selectedPeriod = "AM";

  int _currentIndex = 0;

  final List<String> _hours = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> _minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));
  final List<String> _periods = ["AM", "PM"];

  @override
  void initState() {
    super.initState();
    tasks = List<Map<String, String>>.from(widget.tasks);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void _showDrillDownTimePicker() {
    int selectedHourIndex = _hours.indexOf(_selectedHour);
    int selectedMinuteIndex = _minutes.indexOf(_selectedMinute);
    int selectedPeriodIndex = _periods.indexOf(_selectedPeriod);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 330,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'اختر الوقت',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 1.2, color: Colors.grey),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimePicker(_hours, selectedHourIndex, (index) {
                      setState(() {
                        _selectedHour = _hours[index];
                      });
                    }),
                    const Text(":", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    _buildTimePicker(_minutes, selectedMinuteIndex, (index) {
                      setState(() {
                        _selectedMinute = _minutes[index];
                      });
                    }),
                    _buildTimePicker(_periods, selectedPeriodIndex, (index) {
                      setState(() {
                        _selectedPeriod = _periods[index];
                      });
                    }),
                  ],
                ),
              ),
              const Divider(thickness: 1.2, color: Colors.grey),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("تأكيد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimePicker(List<String> items, int selectedIndex, Function(int) onSelectedItemChanged) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.2,
        controller: FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: onSelectedItemChanged,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) => Center(
            child: Text(
              items[index],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void _addTaskAndNavigate() {
    if (_taskNameController.text.isEmpty || _taskDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء إدخال اسم المهمة ووصفها")),
      );
      return;
    }

    setState(() {
      tasks.add({
        "name": _taskNameController.text,
        "description": _taskDescriptionController.text,
        "hour": _selectedHour,
        "minute": _selectedMinute,
        "period": _selectedPeriod,
      });
    });

    _taskNameController.clear();
    _taskDescriptionController.clear();

    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'تمت إضافة المهمة بنجاح',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
                const Text(
                  '!',
                  style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            actions: [
              TextButton(
                child: const Text('تراجع'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
                child: const Text('استمرار'),




                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TaskScreen(tasks: tasks)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    Widget destination;
    switch (index) {
      case 1:
        destination = TaskScreen(tasks: tasks);
        break;
      case 2:
        destination = const ProfileScreen();
        break;
      case 3:
        destination = const SettingsScreen();
        break;
      default:
        destination = TaskEntryScreen(tasks: tasks);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('asset/back1.jpg', fit: BoxFit.cover),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Image.asset('asset/logo.png', width: 110, height: 110),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 60),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ادرج مهامك اليومية',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                _buildLabeledTextField(
                  label: 'اسم المهمة',
                  controller: _taskNameController,
                  hintText: "مثال: تناول الدواء",
                  fontSize: 18,
                ),
                const SizedBox(height: 16),
                _buildLabeledTextField(
                  label: 'وصف المهمة',
                  controller: _taskDescriptionController,
                  hintText: "مثال: تناول دواء كونسيرتا بعد الإفطار",
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text('وقت المهمة', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showDrillDownTimePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        "$_selectedHour:$_selectedMinute $_selectedPeriod",
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _addTaskAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('ادراج المهمة', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber[700]!.withOpacity(0.95),
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

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String hintText = '',
    double fontSize = 16,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: fontSize),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
