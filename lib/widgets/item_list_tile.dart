import 'package:app_tracking/utils/styles.dart';
import 'package:flutter/material.dart';

class ItemListTile extends StatelessWidget {
  final String title;
  final int index;
  final VoidCallback onClickItem;

  const ItemListTile(
      {super.key,
      required this.title,
      required this.index,
      required this.onClickItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClickItem();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          leading: const Icon(
            Icons.square,
            color: Colors.white,
            size: 20,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class buildInfoCard extends StatelessWidget {
  const buildInfoCard({super.key, this.title,  this.field,  this.status,  this.controller, this.enabled});
  final String? title;
  final String? field;
  final bool? status;
  final bool? enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!, style: robotoRegular),
          status!
              ? TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
              : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: .5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(field!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
