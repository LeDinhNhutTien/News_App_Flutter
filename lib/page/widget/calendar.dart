import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:webview_flutter/webview_flutter.dart';
void main() {
  runApp(const Calendar());
}
class Calendar extends StatefulWidget {
  const Calendar({super.key});


  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today=DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today=day;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch vạn niên")),
      body: content(),
    );
  }

  Widget content(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("Selected Day = "+today.toString().split(" ")[0]),
          Container(
            child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day)=>isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010,10,16),
                lastDay: DateTime.utc(2030,3,14),
                onDaySelected: _onDaySelected,
            ),
          ),
        ],
      ),
    );
  }
}
