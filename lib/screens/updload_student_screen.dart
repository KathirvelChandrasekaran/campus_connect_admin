import 'dart:convert';
import 'dart:io';

import 'package:campus_connect_admin/models/students.dart';
import 'package:campus_connect_admin/utils/constants.dart';
import 'package:campus_connect_admin/widgets/rounded_button_widget.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadStudentScreen extends StatefulWidget {
  const UploadStudentScreen({Key? key}) : super(key: key);

  @override
  State<UploadStudentScreen> createState() => _UploadStudentScreenState();
}

class _UploadStudentScreenState extends State<UploadStudentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loadingPath = false;
  bool _isFileSelected = false;
  List<Students>? stdLists;
  dynamic stdSets;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = File(file.path!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toSet();

      final data = fields.skip(1).map((e) => Students(e[0], e[1], e[2]));
      setState(() {
        stdLists = data.toList();
        _isFileSelected = true;
        _loadingPath = false;
      });
      FilePicker.platform.clearTemporaryFiles();
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Upload Students',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            _isFileSelected
                ? RoundedButtonWidget(
                    buttonText: "Upload Student details",
                    width: MediaQuery.of(context).size.width * 0.80,
                    onpressed: () async {
                      await supabase.from('students').insert([
                        for (var i = 0; i < stdLists!.length; i++)
                          {
                            'roll_number': stdLists![i].rollnumber,
                            'email_id': stdLists![i].emailid,
                            'department': stdLists![i].department,
                          }
                      ]).execute();
                      Navigator.pop(context);
                    },
                  )
                : RoundedButtonWidget(
                    buttonText: "Select csv file",
                    width: MediaQuery.of(context).size.width * 0.80,
                    onpressed: _openFileExplorer,
                  ),
            const SizedBox(height: 20),
            _loadingPath
                ? const LinearProgressIndicator()
                : _isFileSelected
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _createDataTable(),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Roll no')),
      const DataColumn(label: Text('Email ID')),
      const DataColumn(label: Text('Dept.'))
    ];
  }

  List<DataRow> _createRows() {
    return stdLists!
        .map((students) => DataRow(cells: [
              DataCell(Text(students.rollnumber.toString())),
              DataCell(Text(students.emailid.toString())),
              DataCell(Text(students.department.toString()))
            ]))
        .toList();
  }
}
