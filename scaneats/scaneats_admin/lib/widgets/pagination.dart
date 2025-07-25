library flutter_web_pagination;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_custom_text_input_formatter/formatter.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:provider/provider.dart';

class WebPagination extends StatefulWidget {
  final bool isDark;
  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onPageChanged;
  final int displayItemCount;
  const WebPagination({super.key, required this.isDark, required this.onPageChanged, required this.currentPage, required this.totalPage, this.displayItemCount = 11});

  @override
  _WebPaginationState createState() => _WebPaginationState();
}

class _WebPaginationState extends State<WebPagination> {
  late int currentPage = widget.currentPage;
  late int totalPage = widget.totalPage;
  late int displayItemCount = widget.displayItemCount;
  late TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(covariant WebPagination oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPage != widget.currentPage || oldWidget.totalPage != widget.totalPage) {
      setState(() {
        currentPage = widget.currentPage;
        totalPage = widget.totalPage;
      });
    }
  }

  void _updatePage(int page) {
    setState(() {
      currentPage = page;
    });
    widget.onPageChanged(page);
  }

  List<Widget> _buildPageItemList(bool isDark) {
    List<Widget> widgetList = [];
    widgetList.add(_PageControlButton(
      isDark: isDark,
      enable: currentPage > 1,
      title: '«',
      onTap: () {
        _updatePage(currentPage - 1);
      },
    ));

    var leftPageItemCount = (displayItemCount / 2).floor();

    var rightPageItemCount = max(0, displayItemCount - leftPageItemCount - 1);

    int startPage = max(1, currentPage - max(leftPageItemCount, (displayItemCount - totalPage + currentPage - 1)));

    for (; startPage <= currentPage; startPage++) {
      widgetList.add(_PageItem(
        page: startPage,
        isChecked: startPage == currentPage,
        onTap: (page) {
          _updatePage(page);
        },
      ));
    }

    int endPage = min(totalPage, max(displayItemCount, currentPage + rightPageItemCount));

    for (; startPage <= endPage; startPage++) {
      widgetList.add(_PageItem(
        page: startPage,
        isChecked: startPage == currentPage,
        onTap: (page) {
          _updatePage(page);
        },
      ));
    }

    widgetList.add(_PageControlButton(
      isDark: isDark,
      enable: currentPage < totalPage,
      title: '»',
      onTap: () {
        _updatePage(currentPage + 1);
      },
    ));
    return widgetList;
  }

  Widget _buildPageInput(bool isDark) {
    return Container(
        height: 40,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: isDark ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200, width: 1)),
        width: 50,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          maxLines: 1,
          cursorColor: isDark ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
          inputFormatters: CustomTextInputFormatter.getIntFormatter(maxValue: totalPage.toDouble()),
          style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              color: isDark ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood700,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: totalPage.toString(),
              hintStyle: const TextStyle(color: AppThemeData.pickledBluewood200, fontSize: 15, fontWeight: FontWeight.normal),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._buildPageItemList(themeChange.getThem()),
        const SizedBox(width: 10),
        _buildPageInput(themeChange.getThem()),
        const SizedBox(width: 10),
        _PageControlButton(
            isDark: themeChange.getThem(),
            enable: true,
            title: "GO",
            onTap: () {
              setState(() {
                try {
                  _updatePage(int.parse(controller.text));
                  controller.clear();
                } catch (e) {
                  // print(e);
                }
              });
            })
      ],
    );
  }
}

class _PageControlButton extends StatefulWidget {
  final bool isDark;
  final bool enable;
  final String title;
  final VoidCallback onTap;
  const _PageControlButton({required this.isDark, required this.enable, required this.title, required this.onTap});

  @override
  _PageControlButtonState createState() => _PageControlButtonState();
}

class _PageControlButtonState extends State<_PageControlButton> {
  Color normalTextColor = AppThemeData.pickledBluewood950;
  late Color textColor = widget.enable ? normalTextColor : Colors.grey;

  @override
  void didUpdateWidget(_PageControlButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enable != widget.enable) {
      setState(() {
        textColor = widget.enable ? normalTextColor : Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
        onTap: widget.enable ? widget.onTap : null,
        onHover: (b) {
          if (!widget.enable) return;
          setState(() {
            textColor = themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950;
          });
        },
        child: _ItemContainer(
            backgroundColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : Colors.grey,
            child: Text(
              widget.title,
              style: TextStyle(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood700, fontSize: 14),
            )));
  }
}

class _PageItem extends StatefulWidget {
  final int page;
  final bool isChecked;
  final ValueChanged<int> onTap;
  const _PageItem({required this.page, required this.isChecked, required this.onTap});

  @override
  __PageItemState createState() => __PageItemState();
}

class __PageItemState extends State<_PageItem> {
  Color normalBackgroundColor = const Color(0xFFF3F3F3);
  Color normalHighlightColor = AppThemeData.pickledBluewood100;

  late Color backgroundColor = normalBackgroundColor;
  late Color highlightColor = normalHighlightColor;

  @override
  void didUpdateWidget(covariant _PageItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isChecked != widget.isChecked) {
      if (!widget.isChecked) {
        setState(() {
          backgroundColor = normalBackgroundColor;
          highlightColor = normalHighlightColor;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
        onHover: (b) {
          if (widget.isChecked) return;
          setState(() {
            backgroundColor = b ? const Color(0xFFEAEAEA) : normalBackgroundColor;
            highlightColor = b ? AppThemeData.pickledBluewood100 : normalHighlightColor;
          });
        },
        onTap: () {
          widget.onTap(widget.page);
        },
        child: _ItemContainer(
          backgroundColor: widget.isChecked ? highlightColor : backgroundColor,
          child: Text(
            widget.page.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.isChecked
                    ? AppThemeData.crusta500
                    : themeChange.getThem()
                        ? AppThemeData.pickledBluewood50
                        : AppThemeData.pickledBluewood700,
                fontSize: 14),
          ),
        ));
  }
}

class _ItemContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  const _ItemContainer({required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100, borderRadius: BorderRadius.circular(4)),
      child: child,
    );
  }
}
