import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'result_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen>
    with SingleTickerProviderStateMixin {
  bool isMale = true;
  double height = 170;
  int weight = 65;
  int age = 22;

  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _iconAnimation = Tween<double>(begin: 0, end: 8)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_iconController);
    _iconController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  Widget genderCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: [Colors.pinkAccent, Colors.pink.shade200])
                : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
            border: Border.all(
              color: selected ? Colors.pinkAccent : Colors.grey.shade300,
              width: 2,
            ),
          ),
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, selected ? -_iconAnimation.value : 0),
                    child: Icon(
                      icon,
                      size: 50,
                      color: selected ? Colors.white : Colors.grey.shade700,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget counterCard({
    required String title,
    required int value,
    required VoidCallback onPlus,
    required VoidCallback onMinus,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        elevation: 6,
        shadowColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "$title-",
                    mini: true,
                    onPressed: onMinus,
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.pink,
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    heroTag: "$title+",
                    mini: true,
                    onPressed: onPlus,
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.pink,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bmiIndicator(double bmi) {
    Color color;
    String label;
    if (bmi < 18.5) {
      color = Colors.blue;
      label = "Underweight";
    } else if (bmi < 25) {
      color = Colors.green;
      label = "Normal";
    } else if (bmi < 30) {
      color = Colors.orange;
      label = "Overweight";
    } else {
      color = Colors.red;
      label = "Obese";
    }

    return Column(
      children: [
        Text(
          "BMI Range",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: bmi / 40,
          minHeight: 12,
          backgroundColor: Colors.grey.shade300,
          color: color,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  double minIdealWeight() {
    // Min weight for normal BMI = 18.5
    return 18.5 * (height / 100) * (height / 100);
  }

  double maxIdealWeight() {
    // Max weight for normal BMI = 24.9
    return 24.9 * (height / 100) * (height / 100);
  }

  void goToResult() {
    double bmi = weight / ((height / 100) * (height / 100));

    String result;
    if (bmi < 18.5) {
      result = "Thinness";
    } else if (bmi < 25) {
      result = "Normal";
    } else if (bmi < 30) {
      result = "Gain Weight";
    } else {
      result = "Obesity";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          bmi: bmi,
          result: result,
          isMale: isMale,
          age: age,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BMI Calculator",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        elevation: 6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.pinkAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Gender Selection
              Row(
                children: [
                  genderCard(
                    title: "Male",
                    icon: Icons.male,
                    selected: isMale,
                    onTap: () => setState(() => isMale = true),
                  ),
                  genderCard(
                    title: "Female",
                    icon: Icons.female,
                    selected: !isMale,
                    onTap: () => setState(() => isMale = false),
                  ),
                ],
              ),

              /// Height Slider
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "HEIGHT",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${height.toInt()} cm",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        min: 100,
                        max: 220,
                        value: height,
                        activeColor: Colors.pinkAccent,
                        inactiveColor: Colors.grey.shade300,
                        onChanged: (val) {
                          setState(() => height = val);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// Weight & Age
              Row(
                children: [
                  counterCard(
                    title: "WEIGHT",
                    value: weight,
                    onMinus: () =>
                        setState(() => weight > 1 ? weight-- : weight),
                    onPlus: () => setState(() => weight++),
                  ),
                  counterCard(
                    title: "AGE",
                    value: age,
                    onMinus: () => setState(() => age > 1 ? age-- : age),
                    onPlus: () => setState(() => age++),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BMI Indicator
              bmiIndicator(weight / ((height / 100) * (height / 100))),

              const SizedBox(height: 20),

              /// Ideal Weight Info
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                color: Colors.pink.shade50,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Column(
                    children: [
                      const Text(
                        "Ideal Weight Range",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${minIdealWeight().toStringAsFixed(1)} kg - ${maxIdealWeight().toStringAsFixed(1)} kg",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "for your height",
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Calculate BMI Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                  ),
                  onPressed: goToResult,
                  child: const Text(
                    "CALCULATE BMI",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
