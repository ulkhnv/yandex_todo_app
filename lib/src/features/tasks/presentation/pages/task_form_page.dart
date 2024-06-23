import 'package:flutter/material.dart';
import 'package:yandex_todo_app/src/core/utils/utils.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  String? _selectedImportance = 'Нет';

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 4,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: context.colorScheme.primary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Сохранить",
                style: context.textTheme.labelMedium!.copyWith(
                  color: context.customColors.blue,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    minLines: 4,
                    maxLines: 40,
                    style: context.textTheme.bodyMedium,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "Что надо сделать...",
                      hintStyle: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.tertiary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedImportance,
                  icon: const SizedBox.shrink(),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: context.colorScheme.primary,
                    ),
                    labelText: "Важность",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  items:
                      <String>['Нет', 'Низкий', 'Высокий'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: context.textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedImportance = newValue;
                    });
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Сделать до",
                    style: context.textTheme.bodyMedium,
                  ),
                  activeTrackColor: Colors.blueAccent,
                  activeColor: Colors.blue,
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  value: false,
                  onChanged: (val) {},
                )
              ],
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: context.customColors.red,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Удалить",
                    style: TextStyle(color: context.customColors.red),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
