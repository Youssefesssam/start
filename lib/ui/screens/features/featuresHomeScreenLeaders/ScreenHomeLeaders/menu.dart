import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int score = 0; // إجمالي النقاط
  final Map<String, bool> states = { // حالة كل عنصر
    "mass": false,
    "communion": false,
    "confession": false,
    "meeting": false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xe42f2e2e),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow("القداس", "mass"),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("التناول", "communion"),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاعتراف", "confession"),
          const Divider(thickness: 1, color: Colors.white),
          buildRow("الاجتماع", "meeting"),
          const Divider(thickness: 1, color: Colors.white),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "حذف",
                  style: TextStyle(fontSize: 25, color: Colors.red),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: resetScore,
                child: const Icon(Icons.delete, color: Colors.red, size: 35),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إنشاء صف عنصر واحد مع أنيميشن
  Widget buildRow(String label, String key) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            label,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: states[key]!
              ? const Text(
            "+25",
            key: ValueKey("visible"),
            style: TextStyle(color: Colors.green, fontSize: 20),
          )
              : const SizedBox(key: ValueKey("hidden")),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => toggleState(key),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              states[key]!
                  ? Icons.check_box
                  : Icons.check_box_outline_blank_outlined,
              key: ValueKey(states[key]),
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  /// تحديث الحالة عند الضغط
  void toggleState(String key) {
    setState(() {
      if (states[key] == true) {
        // إذا كان مفعل، قم بإلغاء النقاط
        states[key] = false;
        score -= 25;
      } else {
        // إذا كان غير مفعل، أضف النقاط
        states[key] = true;
        score += 25;
      }
    });
    print("Score: $score");
  }

  /// إعادة تعيين النقاط والحالات
  void resetScore() {
    setState(() {
      score = 0;
      states.updateAll((key, value) => false);
    });
    print("Score reset: $score");
  }
}
