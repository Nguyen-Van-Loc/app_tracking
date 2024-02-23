import 'package:app_tracking/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final double? width;
  final double? heigth;
  final Function()? onClear;
  final bool? checkEye;
  final bool? enabled;
  final TextInputType? textInputType;
  final bool? text;
  final double? vetical;

  const InputTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.onClear,
    this.width,
    this.heigth,
    this.checkEye,
    this.textInputType,
    this.enabled,
    this.text,
    this.vetical,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.heigth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.text!
              ? Text(
                  widget.hintText,
                  style: robotoRegular,
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: widget.vetical ?? 0),
            child: TextField(
              controller: widget.controller,
              onChanged: (_) {
                setState(() {});
              },
              obscureText: widget.obscureText,
              keyboardType: widget.textInputType,
              enabled: widget.enabled,
              decoration: InputDecoration(
                suffixIcon: MaterialButton(
                  onPressed: widget.onClear,
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  shape: const CircleBorder(),
                  child: widget.checkEye != null
                      ? widget.checkEye!
                          ? const Icon(
                              CupertinoIcons.eye_solid,
                              color: Colors.grey,
                            )
                          : const Icon(
                              CupertinoIcons.eye_slash_fill,
                              color: Colors.grey,
                            )
                      : widget.controller.text.isNotEmpty
                          ? const Icon(
                              Icons.close,
                              size: 25,
                            )
                          : null,
                ),
                contentPadding: const EdgeInsets.all(15),
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
