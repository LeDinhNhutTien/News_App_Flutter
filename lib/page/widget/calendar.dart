import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/widget/eventCalendar.dart';
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
  CalendarFormat _calendarFormat=CalendarFormat.month;
  DateTime _focusedDay=DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventCalendar>> events={};
  TextEditingController _eventController=TextEditingController();
  late final ValueNotifier<List<EventCalendar>> _selectedEvents;

  @override
  void initState(){
    super.initState();
    _selectedDay=_focusedDay;
    _selectedEvents=ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose(){
    super.dispose();
  }
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    if(!isSameDay(_selectedDay,selectedDay) ){
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay=focusedDay;
        _selectedEvents.value=_getEventsForDay(selectedDay);
      });
    }
  }

  // Hàm xóa sự kiện
  void _deleteEvent(EventCalendar event, DateTime day) {
    setState(() {
      events[day]?.remove(event);
      if (events[day]?.isEmpty ?? true) {
        events.remove(day);
      }
      _selectedEvents.value = _getEventsForDay(day);
    });
  }

  void _showAddEditEventDialog({EventCalendar? eventToEdit}) {
    _eventController.text = eventToEdit?.title ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(eventToEdit == null ? "Thêm sự kiện" : "Chỉnh sửa sự kiện"),
          content: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _eventController,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (eventToEdit == null) {
                  // Thêm sự kiện mới
                  if (_eventController.text.isNotEmpty) {
                    setState(() {
                      final event = EventCalendar(_eventController.text);
                      final list = events[_selectedDay];
                      if (list != null) {
                        list.add(event);
                      } else {
                        events[_selectedDay!] = [event];
                      }
                    });
                  }
                } else {
                  // Chỉnh sửa sự kiện hiện tại
                  setState(() {
                    eventToEdit.title = _eventController.text;
                  });
                }
                Navigator.of(context).pop();
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

List<EventCalendar>_getEventsForDay(DateTime day){
    return events[day]??[];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch vạn niên")),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _showAddEditEventDialog()
        // {
        //   showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           scrollable: true,
        //           title: Text("Event name"),
        //           content: Padding(
        //             padding: EdgeInsets.all(8),
        //             child: TextField(
        //               controller: _eventController,
        //             ),
        //           ),
        //           actions: [
        //             ElevatedButton(
        //                 onPressed: (){
        //                   events.addAll({
        //                     _selectedDay!: [EventCalendar(_eventController.text)]
        //                   });
        //                   Navigator.of(context).pop();
        //                   _selectedEvents.value=_getEventsForDay(_selectedDay!);
        //                 },
        //                 child: Text("Submit"),)
        //           ],
        //         );
        //       });
        // }
          ,
        child: Icon(Icons.add),),
      body: Column(
          children: [
            Text("Ngày đã chọn = "+_focusedDay.toString().split(" ")[0]),
            Container(
              child: TableCalendar(
                locale: "en_US",
                firstDay: DateTime.utc(2010,10,16),
                lastDay: DateTime.utc(2030,3,14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day)=>isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(outsideDaysVisible: false),
                onFormatChanged: (format){
                  if(_calendarFormat!=format){
                    setState(() {
                      _calendarFormat=format;
                    });
                  }
                },
                onPageChanged:(focusedDay){
                  _focusedDay=focusedDay;
                },
                // rowHeight: 43,
                // headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                // availableGestures: AvailableGestures.all,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<EventCalendar>>(valueListenable: _selectedEvents,
                  builder: (context,value,_){
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context,index){
                      final event = value[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4 ),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: ListTile(
                          onTap: ()=>_showAddEditEventDialog(eventToEdit: event),
                          title: Text(value[index].title),
                          trailing: IconButton(
                            icon:Icon(Icons.delete),
                            onPressed: (){
                              _deleteEvent(value[index], _selectedDay!);
                            },
                          ),
                        ),
                      );
              
                });
              }),
            )
          ],
      ),
    );
  }
}
