import 'package:campus_connect_admin/utils/constants.dart';
import 'package:campus_connect_admin/utils/theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<dynamic>? students;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    setState(() {
      isDataLoaded = true;
    });
    var res = await supabase.from('students').select().execute();
    students = res.data;
    setState(() {
      isDataLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_students');
            },
            child: Icon(
              FluentIcons.add_24_filled,
              color: theme.darkTheme ? Colors.black : Colors.white,
            ),
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Available Students',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              isDataLoaded
                  ? const Center(child: LinearProgressIndicator())
                  : _createDataTable(),
            ],
          ),
        );
      },
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Roll number')),
      const DataColumn(label: Text('Email ID'))
    ];
  }

  List<DataRow> _createRows() {
    return students!
        .map((students) => DataRow(cells: [
              DataCell(Text(students['id'].toString())),
              DataCell(Text(students['roll_number'].toString())),
              DataCell(Text(students['email_id'].toString()))
            ]))
        .toList();
  }
}
