import 'package:flutter/material.dart';
import 'package:wonder_pod/common/helpers/darkModeExtension.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;

  final bool hideBack;

  const BasicAppBar(
      {this.title, this.hideBack = false, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? const Text(""),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: action ?? Container(),
        )
      ],
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: hideBack
          ? null
          : IconButton(
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.04),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
