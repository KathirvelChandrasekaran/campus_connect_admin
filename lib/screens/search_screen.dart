import 'package:campus_connect_admin/utils/constants.dart';
import 'package:campus_connect_admin/utils/theme.dart';
import 'package:campus_connect_admin/widgets/rounded_button_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchText = TextEditingController();
  List<dynamic>? students;
  bool isLoading = false;
  bool isDataLoaded = false;

  getSearchResults() async {
    setState(() {
      isDataLoaded = false;
      isLoading = true;
    });

    var result = await supabase
        .from('students')
        .select()
        .like('email_id', '%${_searchText.text}%')
        .execute();

    setState(() {
      students = result.data;
      isDataLoaded = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);

        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Search Students',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _searchText,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: theme.darkTheme
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: theme.darkTheme
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      hintText: 'Enter roll number',
                      hintStyle: TextStyle(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchText.clear();
                          isDataLoaded = false;
                        },
                        icon: const Icon(
                          FluentIcons.text_clear_formatting_24_filled,
                        ),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    style: TextStyle(
                      color: theme.darkTheme
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RoundedButtonWidget(
                    buttonText: "Search Students",
                    width: MediaQuery.of(context).size.width * 0.90,
                    onpressed: getSearchResults,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                isDataLoaded
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: students!
                                .map(
                                  (student) => Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            student['roll_number'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            student['email_id'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Text(
                                            student['department'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              enableDrag: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              elevation: 2,
                                              builder: (context) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child:
                                                            RoundedButtonWidget(
                                                          buttonText:
                                                              "View Student",
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.90,
                                                          onpressed: () {},
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      Center(
                                                        child:
                                                            RoundedButtonWidget(
                                                          buttonText:
                                                              "Delete Student",
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.90,
                                                          onpressed: () async {
                                                            await supabase
                                                                .from(
                                                                    'students')
                                                                .delete()
                                                                .eq(
                                                                    'email_id',
                                                                    student[
                                                                        'email_id'])
                                                                .execute();
                                                            getSearchResults();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error,
                                                          textColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            'No data found',
                            style: TextStyle(
                              color: theme.darkTheme
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
