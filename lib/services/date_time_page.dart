import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';

class DateTimePickerPage extends StatefulWidget {
  const DateTimePickerPage({Key? key}) : super(key: key);

  @override
  State<DateTimePickerPage> createState() => _DateTimePickerPageState();
}

class _DateTimePickerPageState extends State<DateTimePickerPage> {
  DateTime? date;

  String gettext() {
    if (date == null) {
      return 'select datess';
    } else {
      print(date);
      return ' ${date!.month}/${date!.day}/${date!.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }

                    return true;
                  },
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
                DateTimePicker(
                  initialValue: '',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Date',
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Text(
                  'Date',
                  style: TextStyle(color: kwhite, fontSize: 25),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    DateTimePicker();
                    // pickDate(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: kwhite,
                    height: 50,
                    width: double.infinity,
                    child: Text(gettext()),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'Time',
                  style: TextStyle(color: kwhite, fontSize: 25),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  color: kwhite,
                  height: 50,
                  width: double.infinity,
                  child: const Text('Select Time'),
                )
              ]),
        ),
      ),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;
    setState(() {
      gettext();
      newDate;
      print(newDate);
    });
    DateTimePicker(
      initialValue: '',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      dateLabelText: 'Date',
      onChanged: (val) => print(val),
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) => print(val),
    );
  }
}
