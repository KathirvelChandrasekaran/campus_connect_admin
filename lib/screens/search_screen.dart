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
  TextEditingController _searchText = TextEditingController();
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
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Search',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                        },
                        icon: const Icon(
                          FluentIcons.text_clear_formatting_24_filled,
                        ),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RoundedButtonWidget(
                    buttonText: "Search",
                    width: MediaQuery.of(context).size.width * 0.95,
                    onpressed: () async {
                      var result = await supabase
                          .from('students')
                          .select()
                          .textSearch('roll_number', _searchText.text)
                          .execute();
                      print(result.data);
                    },
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
