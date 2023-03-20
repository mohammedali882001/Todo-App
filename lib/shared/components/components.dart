import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:todo/shared/cubit/cubit.dart';

Widget defaultTextFormFaild({
  required TextEditingController controller,
  void Function(String)? onChanged,
  bool obscureText = false,
  void Function(String)? onFieldSubmitted,
  void Function()? onTap,
  required String? Function(String?)? validator,
  required String hintText,
  required String label,
  required Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    onChanged: onChanged,
    obscureText: obscureText,
    onFieldSubmitted: onFieldSubmitted,
    onTap: onTap,
    validator: validator,
    decoration: InputDecoration(
      hintText: hintText,
      label: Text(label),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(),
      ),
    ),
  );
}

Widget defaultTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDatabase(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}',
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${model['data']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(status: 'done', id: model['id']);
            },
            icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(status: 'archived', id: model['id']);
            },
            icon: const Icon(Icons.archive),
            color: Colors.black45,
          ),
        ],
      ),
    ),
  );
}

Widget taskBuiler(List<Map<dynamic, dynamic>> tasks) {
  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) {
        return defaultTaskItem(tasks[index], context);
      },
      separatorBuilder: (context, index) {
        return Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[200],
        );
      },
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
          ),
          Text('there is no tasks yet , please add some tasks')
        ],
      ),
    ),
  );
}
