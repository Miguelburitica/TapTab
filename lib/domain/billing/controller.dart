import 'package:get/get.dart';
import 'package:orders_handler/domain/billing/models/tab_model.dart';
import 'package:orders_handler/domain/billing/models/table_model.dart';
import 'package:orders_handler/domain/items/models/item_model.dart';

class BillingController extends GetxController {
  final _tables = <TableModel>[];
  final _sessionTabs = <TabModel>[];

  List<TableModel> get tables => _tables;
  List<TabModel> get currentActiveTabs => _sessionTabs.where((tab) => tab.status == TabStatus.active).toList();

  // method to add a new table to the list
  void addTable(TableModel table) {
    _tables.add(table);
    update();
  }

  void addTab(TabModel tab) {
    _sessionTabs.add(tab);
    update();
  }

  void addItemsToTab(String tabId, List<ItemModel> items) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);

    tab.items.addAll(items);

    List<ItemsResume> itemsResume = tab.itemsResume;
    for (var element in items) {
      if (itemsResume.any((item) => item.itemId == element.id)) {
        ItemsResume currentItemResume = itemsResume.firstWhere((item) => item.itemId == element.id);
        currentItemResume.quantity++;
        currentItemResume.subtotal += element.price;
      } else {
        itemsResume.add(ItemsResume(
          itemId: element.id,
          name: element.name,
          quantity: 1,
          subtotal: element.price,
        ));
      }
    }
    
    update();
  }

  void finishTab(String tabId) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);
    tab.status = TabStatus.closed;
    // todo: add a method to calculate the total of the tab and add it to the table

    TableModel table = _tables.firstWhere((table) => table.id == tab.tableId);
    table.tableTotal += tab.subtotal;
    
    update();
  }

  void associateTabWithTable(String tabId, String tableId) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);
    TableModel table = _tables.firstWhere((table) => table.id == tableId);

    tab.tableId = tableId;
    table.tabIds.add(tabId);
    update();
  }
}