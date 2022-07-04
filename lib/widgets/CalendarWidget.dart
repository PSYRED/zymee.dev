import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../resources/firestore.dart';
import '../screens/CreateSchedule.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {


  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child:  Column(
            children: <Widget>[
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2022, 01, 01),
                lastDay: DateTime.utc(2030, 3, 14),
                selectedDayPredicate: (day){
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
                  });
                },
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                        fontSize: 26.0
                    )
                ),
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  }
              ),

              const SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
                  color: Colors.blueGrey,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 50),
                        child: _selectedDay == null ? Text(
                          "${DateFormat.yMMMd().format(_focusedDay)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold
                          ),
                        ) :
                        Text(
                          "${DateFormat.yMMMd().format(_selectedDay!)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        ),
                    ],
                    ),
                    Positioned(
                        bottom: 0,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.white54.withOpacity(0),
                                Colors.white30
                              ],
                              stops: [
                                0.0,
                                1.0
                              ]
                            )
                          ),
                        )
                    ),
                    Positioned(
                        bottom: 40,
                        right: 20,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.indigoAccent,
                              boxShadow: [BoxShadow(
                                color: Colors.black38,
                                blurRadius: 30
                              )]
                            ),
                            child: Text("Choose Date", style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                          onTap: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => CreateSchedule(date: _selectedDay == null ? _focusedDay : _selectedDay!)));
                          },
                        )
                    )
                  ],
                ),
              )


            ],
          )
        ),
      ),
    );
  }

  Container TaskList(String title, String description){
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.access_time,
            color: Colors.indigoAccent,
            size: 25.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                )),
                const SizedBox(height: 10.0),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.normal
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


}
