import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'document_tab_item_model.dart';

class DocumentTabItem extends StackedView<DocumentTabItemModel> {
  const DocumentTabItem({
    super.key,
    required this.index,
    required this.name,
    required this.isSelected,
    required this.onCloseDocument,
  });

  final int index;
  final String name;
  final bool isSelected;
  final Function() onCloseDocument;

  @override
  Widget builder(
    BuildContext context,
    DocumentTabItemModel viewModel,
    Widget? child,
  ) {
    return ReorderableDragStartListener(
      key: super.key,
      index: index,
      child: Container(
        height: 28.0,
        constraints: const BoxConstraints(minWidth: 100.0, maxWidth: 150.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF272727) : Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          spacing: 12.0,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: onCloseDocument,
              child: PhosphorIcon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                color: isSelected ? Colors.white60 : Colors.white30,
                size: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DocumentTabItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      DocumentTabItemModel();
}
