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
  bool isDepartmentsLoaded = false;
  List<dynamic>? departments;

  @override
  void initState() {
    super.initState();
    getDetails();
    getAllDepartments();
  }

  getAllDepartments() async {
    setState(() {
      isDepartmentsLoaded = true;
    });
    var res = await supabase.rpc('get_departments').execute();
    setState(() {
      departments = res.data;
      isDepartmentsLoaded = false;
    });
  }

  getDetails() async {
    setState(() {
      isDataLoaded = true;
    });
    var res = await supabase.from('students').select().execute();
    setState(() {
      students = res.data;
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
              FluentIcons.add_circle_24_filled,
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isDepartmentsLoaded
                                  ? const LinearProgressIndicator()
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            departments![index],
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onTap: () async {
                                            var res = await supabase
                                                .from('students')
                                                .select()
                                                .eq('department',
                                                    departments![index])
                                                .execute();
                                            setState(() {
                                              students = res.data;
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      itemCount: departments?.length ?? 0,
                                    ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        FluentIcons.filter_24_filled,
                        size: 24.0,
                      ),
                      label: const Text('Filter by Department'),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        FluentIcons.number_row_24_filled,
                        size: 24.0,
                      ),
                      label: const Text('Filter by Roll no'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isDataLoaded
                  ? const Center(child: LinearProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _createDataTable(),
                    ),
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
      const DataColumn(label: Text('Roll no')),
      const DataColumn(label: Text('Department')),
      const DataColumn(label: Text('Email ID')),
    ];
  }

  List<DataRow> _createRows() {
    return students!
        .map(
          (students) => DataRow(
            cells: [
              DataCell(Text(students['id'].toString())),
              DataCell(Text(students['roll_number'].toString())),
              DataCell(Text(students['department'].toString())),
              DataCell(Text(students['email_id'].toString())),
            ],
          ),
        )
        .toList();
  }
}
