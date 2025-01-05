import 'package:flutter/material.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/ui/widgets/top_bar/widgets/document_tab_item/document_tab_item.dart';
import 'package:stacked/stacked.dart';

import 'document_tabs_model.dart';

class DocumentTabs extends StackedView<DocumentTabsModel> {
  const DocumentTabs({super.key});

  @override
  Widget builder(
    BuildContext context,
    DocumentTabsModel viewModel,
    Widget? child,
  ) {
    final List<Widget> documentTabWidgets = [
      for (Document document in viewModel.documents)
        InkWell(
          key: Key(document.id),
          onTapDown: (event) => viewModel.onSelectDocumentTab(document),
          child: DocumentTabItem(
            key: Key(document.id),
            index: viewModel.documents.indexWhere((i) => document.id == i.id),
            name: '${document.isSaved ? '' : '*'}${document.name}',
            isSelected: viewModel.documents.indexOf(document) == viewModel.selectedDocumentIndex,
            onCloseDocument: () => viewModel.onCloseDocumentTab(document),
          ),
        ),
    ];

    Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
      return Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: documentTabWidgets[index],
      );
    }

    return Expanded(
      child: viewModel.documents.isEmpty
          ? Container()
          : ReorderableListView(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: false,
              proxyDecorator: proxyDecorator,
              onReorder: viewModel.onReorderDocumentTabs,
              children: documentTabWidgets,
            ),
    );
  }

  @override
  DocumentTabsModel viewModelBuilder(
    BuildContext context,
  ) =>
      DocumentTabsModel();
}
