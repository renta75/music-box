import 'package:flutter/material.dart';
import 'package:tmdb/utils/my_colors.dart';
import 'package:tmdb/utils/my_text_styles.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool? autofocus;
  final bool isPasswordField;
  final TextInputType? inputType;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final Function(BuildContext, String?)? fieldValidator;
  final bool expanded;
  final bool readOnly;
  final int? maxLines;
  final bool Function()? onEditingComplete;

  const MyTextFormField({
    required this.controller,
    required this.label,
    this.autofocus,
    this.isPasswordField = false,
    this.fieldValidator,
    this.inputType,
    this.focusNode,
    this.nextFocus,
    this.expanded = false,
    this.readOnly = false,
    this.onEditingComplete,
    this.maxLines = 1,
  });

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  var hidePassword = true;

  @override
  Widget build(BuildContext context) {
    Widget textField = LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: widget.expanded ? null : 380,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 9),
                  child: Text(
                    widget.label,
                    style: MyTextStyles.inputFieldLabelStyle,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                TextFormField(
                  onEditingComplete: widget.onEditingComplete,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: (_) => widget.nextFocus!.requestFocus(),
                  // onEditingComplete: () => widget.nextFocus!.requestFocus(),
                  textInputAction: TextInputAction.next,
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus ?? false,
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  obscureText: widget.isPasswordField ? hidePassword : false,
                  enableSuggestions: widget.isPasswordField,
                  autocorrect: widget.isPasswordField,
                  maxLines: widget.maxLines,

                  style: TextStyle(
                    fontSize: hidePassword && widget.isPasswordField ? 12 : 12,
                    fontFamily: 'Roboto',
                  ),

                  decoration: InputDecoration(
                    isDense: true,
                    // labelText: label,
                    fillColor: MyColors.textFormFieldBackgroundColor,
                    // errorStyle: ,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      borderSide: BorderSide(
                        color: MyColors.textFormFieldBackgroundColor,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 9,
                    ),

                    labelStyle: MyTextStyles.inputFieldLabelStyle,
                    suffixIcon: widget.isPasswordField
                        ? MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              child: Icon(
                                Icons.remove_red_eye_rounded,
                                color: MyColors.cardTextColor,
                              ),
                            ),
                          )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xff9797AC),
                        width: 1,
                      ),
                    ),
                  ),

                  validator: (text) {
                    if (widget.fieldValidator != null) {
                      return widget.fieldValidator!(context, text);
                    }
                    return null;
                  },
                ),
                // ),
              ],
            ),
          ),
        );
      },
    );
    return widget.expanded ? Expanded(child: textField) : textField;
  }
}
