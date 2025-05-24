import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_t/firebase/authProvider.dart';
import 'package:star_t/firebase/dataProvider.dart';
import 'package:star_t/firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import 'package:star_t/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../firebase/providerTotalScore.dart';

class Week extends StatefulWidget {
  final int currentSelectedWeek;

  const Week({super.key, required this.currentSelectedWeek});

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> with AutomaticKeepAliveClientMixin {
  late int week;
  final List<String> weeksList = List.generate(
    48,
        (index) => 'Week ${index + 1}',
  );

  @override
  void initState() {
    super.initState();
    week = widget.currentSelectedWeek;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FireBaseGetDataForLeader.saveDateInProvider(context);
  }

  Future<void> _confirmSelection(BuildContext context) async {
    final DataProvider dataProvider = Provider.of(context, listen: false);
    final AuthProviders authProviders = Provider.of(context, listen: false);
    final ProviderTotalScore providerTotalScore = Provider.of(context, listen: false);

    int? nextWeek = await FireBaseGetDataForLeader.getNextWeek();
    int? previousWeek = await FireBaseGetDataForLeader.getPreviousWeek();
    int selectedWeek = week + 1;

    bool isValidSelection = selectedWeek <= nextWeek;
    bool isOldSelection = selectedWeek < (previousWeek + 1);
    bool isCurrentSelection = selectedWeek == nextWeek;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isOldSelection ? Colors.red[100] : null,
        title: Text(
          'Confirm Selection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isOldSelection ? Colors.red[900] : Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Next Week: $nextWeek | Current Week: ${previousWeek + 1}'),
            const SizedBox(height: 15),
            Text(
              'You selected Week $selectedWeek',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isValidSelection
                    ? (isOldSelection ? Colors.red[900] : Colors.black)
                    : Colors.red,
              ),
            ),
            if (isCurrentSelection)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Perfect choice!', style: TextStyle(color: Colors.green)),
                  Icon(Icons.grade_rounded, color: Colors.green),
                ],
              ),
            if (isOldSelection)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '⚠ You are selecting a past week! Be careful.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            if (!isValidSelection)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '⚠ Cannot select a week greater than Next Week!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isValidSelection ? (isOldSelection ? Colors.red : Colors.teal) : Colors.grey,
            ),
            onPressed: isValidSelection
                ? () {
              Navigator.pop(context);
              providerTotalScore.resetScores();
              FireBaseSetDataForLeader.numWeek(numWeek: selectedWeek);
              FireBaseSetDataForLeader.updateCurrentWeek(selectedWeek);
              FireBaseSetDataForLeader.updateNextWeek(selectedWeek);
              FireBaseSetDataForLeader.updatePreviousWeek(selectedWeek - 1);

              Navigator.pop(context, selectedWeek);
            }
                : null,
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exitAction(BuildContext context) {
    FireBaseSetDataForLeader.numWeek(numWeek: week);
    Navigator.pop(context, week);
  }

  void _updateAction(BuildContext context) {
    final AuthProviders authProviders = Provider.of(context, listen: false);
    authProviders.setCurrentWeek(week);
    authProviders.setCurrentMonth(week);

    Navigator.pop(context, week);
    Navigator.pushNamed(
      context,
      ListOfUsers.routeName,
      arguments: {'week': week + 1, 'update': true},
    );
    FireBaseSetDataForLeader.updateWeek(week + 1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            thickness: 3,
            indent: 150,
            endIndent: 150,
            color: Colors.teal,
          ),
          const Text(
            'Select Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 50,
              scrollController: FixedExtentScrollController(initialItem: week),

              onSelectedItemChanged: (index) {
                week = index+1;
              },
              children: weeksList.map((w) {
                return Center(child: Text(w));
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionButton(
                text: 'Exit',
                color: const [Color(0xff9b1010), Colors.red],
                onTap: () => _exitAction(context),
              ),
              ActionButton(
                text: 'Confirm',
                color: [Colors.teal[800]!, Colors.teal[600]!],
                onTap: () => _confirmSelection(context),
              ),
              ActionButton(
                text: 'Update',
                color: [Colors.blueAccent, Colors.cyan[700]!],
                onTap: () => _updateAction(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// ✨ زر مخصص لإعادة الاستخدام
class ActionButton extends StatelessWidget {
  final String text;
  final List<Color> color;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(colors: color),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}