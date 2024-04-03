import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:klitchyapp/models/items.dart';
import 'package:klitchyapp/models/orders.dart';
import 'package:klitchyapp/viewmodels/right_drawer_vm.dart';
import 'package:klitchyapp/views/right_drawer.dart';
import 'package:klitchyapp/widget/order_component.dart';
import 'package:klitchyapp/widget/table_timer.dart';
import 'package:klitchyapp/widget/tables/table_2.dart';
import 'package:klitchyapp/widget/tables/table_3.dart';
import 'package:klitchyapp/widget/tables/table_4.dart';
import 'package:klitchyapp/widget/tables/table_6.dart';
import 'package:klitchyapp/widget/tables/table_8.dart';
import 'package:klitchyapp/models/kitchenOrders.dart' as kitchenOrderAppState;

import '../config/app_colors.dart';

class AppState extends ChangeNotifier {
  ///toggle the drawer
  bool _isWidgetEnabled = true;

  bool get isWidgetEnabled => _isWidgetEnabled;

  void toggleWidget() {
    _isWidgetEnabled = true;
    notifyListeners();
  }

  ///number of tables
  int _numberOfTables = 0;

  int get numberOfTables => _numberOfTables;

  void setNumberOfTables(int number) {
    _numberOfTables = number;
    notifyListeners();
  }

  void addTable() {
    _numberOfTables += 1;
    notifyListeners();
  }

  void deleteTable() {
    if (_numberOfTables > 0) {
      _numberOfTables -= 1;
      notifyListeners();
    }
  }

  ///orders
  List<OrderComponent> _orders = [];

  List<OrderComponent> get orders => _orders;
  double _subtotal = 0.0;

  double get subtotal => _subtotal;
  double _subtotalInitial = 0.0;

  double get subtotalInitial => _subtotalInitial;
  double _total = 0.0;

  double get total => _total;
  double _tva = 0.0;

  double get tva => _tva;
  double _tvaInitial = 0.0;

  double get tvaInitial => _tvaInitial;
  double _discountTotal = 0.0;

  double get discountTotal => _discountTotal;
  double _initialTotal = 0.0;

  double get initialTotal => _initialTotal;

  void addOrder(int number, OrderComponent orderWidget) {
    if (number > 0) {
      final existingWidgetIndex = _orders.indexWhere(
        (widget) =>
            widget.name == orderWidget.name &&
            widget.price == orderWidget.price,
      );
      if (existingWidgetIndex != -1) {
        _subtotal -= _orders.elementAt(existingWidgetIndex).number *
            (orderWidget.price -
                _orders.elementAt(existingWidgetIndex).price * 0.07);
        _total -=
            _orders.elementAt(existingWidgetIndex).number * orderWidget.price;
        _initialTotal -=
            _orders.elementAt(existingWidgetIndex).number * orderWidget.price;
        _orders.elementAt(existingWidgetIndex).number = number;
        _tva -= orderWidget.price * 0.07 * (orderWidget.number - 1);
      } else {
        _orders.add(orderWidget);
      }
      _tva += orderWidget.price * 0.07 * orderWidget.number;
      _tvaInitial += orderWidget.price * 0.07 * orderWidget.number;
      _subtotal += number * (orderWidget.price - orderWidget.price * 0.07);
      _subtotalInitial +=
          number * (orderWidget.price - orderWidget.price * 0.07);
      _total += number * orderWidget.price;
      _initialTotal += number * orderWidget.price;
      notifyListeners();
    }
  }

  // void addOrder(int number, OrderComponent orderWidget) {
  //   if (number > 0) {
  //     final existingWidgetIndex = _orders.indexWhere(
  //       (widget) =>
  //           widget.name == orderWidget.name &&
  //           widget.price == orderWidget.price,
  //     );
  //     if (existingWidgetIndex != -1) {
  //       _subtotal -= _orders.elementAt(existingWidgetIndex).number * (orderWidget.price - _orders.elementAt(existingWidgetIndex).price* 0.07);
  //       _total -= _orders.elementAt(existingWidgetIndex).number * orderWidget.price;
  //       _orders.elementAt(existingWidgetIndex).number = number;
  //     } else {
  //       _orders.add(orderWidget);
  //
  //     }
  //     _tva += orderWidget.price * 0.07 * orderWidget.number;
  //     _subtotal += number * (orderWidget.price - orderWidget.price * 0.07);
  //     _total += number * orderWidget.price;
  //     notifyListeners();
  //
  //   }
  // }

  void deleteOrder(int number, OrderComponent orderWidget) {
    final existingWidgetIndex = _orders.indexWhere(
      (widget) =>
          widget.name == orderWidget.name && widget.price == orderWidget.price,
    );
    if (existingWidgetIndex != -1 && number > 0) {
      _orders.elementAt(existingWidgetIndex).number -= 1;

      if (_orders.elementAt(existingWidgetIndex).number == 0) {
        _orders.removeAt(existingWidgetIndex);
      }
      final entryItemIndex = _entryItems.indexWhere(
            (entryItem) => entryItem.item_name == orderWidget.name,
      );
      if (entryItemIndex != -1) {
        _entryItems.removeAt(entryItemIndex);
      }
    }
    if(_discount == 0) {
      _subtotal -= orderWidget.price - (orderWidget.price * 0.07);
      _tva -= orderWidget.price * 0.07;
      _total -= orderWidget.price;
    } else {
      _subtotal -= orderWidget.price * (1-_discount) - (orderWidget.price * (1-_discount) * 0.07);
      _tva -= orderWidget.price * (1-_discount) * 0.07;
      _total -= orderWidget.price * (1-_discount);
    }
    if (_subtotal < 0) {
      _subtotal = 0.0;
    }
    if (_tva < 0) {
      _tva = 0.0;
    }
    if (_total < 0) {
      _total = 0.0;
    }
    notifyListeners();
  }

  void deleteAllOrders() {
    _orders.clear();
    _tva = 0.0;
    _subtotal = 0.0;
    _total = 0.0;
    _subtotalInitial = 0.0;
    _tvaInitial = 0.0;
    _initialTotal = 0.0;
    _entryItems.clear();
    _discount = 0.0;
    _discountTotal = 0.0;
    notifyListeners();
  }

  ///discount
  double _discount = 0.0;
  double get discount => _discount;

  void addDiscount(String discountNumber) {
    double newDiscount = double.parse(discountNumber) / 100;

    if (newDiscount > 0.0) {
      _discount = newDiscount;
      _total = 0;
      _tva = 0;
      _subtotal = 0;
      for (var order in _orders) {
        _total += order.price * order.number * (1 - discount);
        _subtotal += ((order.price - order.price * 0.07) * order.number) * (1 - discount);
        _tva += (order.price * 0.07 * order.number)* (1 - discount);
      }

    } else {
      _discount = newDiscount;
      _total = 0;
      _tva = 0;
      _subtotal = 0;
      for (var order in _orders) {
        _total += order.price * order.number;
        _subtotal += (order.price - order.price * 0.07) * order.number;
        _tva += order.price * 0.07 * order.number;
      }
    }

    _total = double.parse(_total.toStringAsFixed(2));
    notifyListeners();
  }


  ///notes
  void updateOrderNote(String orderName, String newNote) {
    final orderToUpdate = _orders.firstWhere(
      (order) => order.name == orderName,
    );
    final entryItemToUpdate = entryItems.firstWhere(
      (order) => order.item_name == orderName,
    );
    entryItemToUpdate.notes=newNote;
    orderToUpdate.note = newNote;
    notifyListeners();
  }

  Color _enableColorNotes = Colors.transparent;

  Color get enableColorNotes => _enableColorNotes;
  bool _enabledNotes = false;

  bool get enabledNotes => _enabledNotes;

  void enableNotes() {
    _enabledNotes = !_enabledNotes;
    if (_enabledNotes) {
      _enabledDelete = false;
      _enabledDiscount = false;
      _enableColorNotes = AppColors.redColor;
      _enableColorDelete = Colors.transparent;
      _enableColorDiscount = Colors.transparent;
    } else {
      _enableColorNotes = Colors.transparent;
    }
    notifyListeners();
  }

  Color _enableColorDelete = Colors.transparent;

  Color get enableColorDelete => _enableColorDelete;
  bool _enabledDelete = false;

  bool get enabledDelete => _enabledDelete;

  void enableDelete() {
    _enabledDelete = !_enabledDelete;
    if (_enabledDelete) {
      _enabledNotes = false;
      _enabledDiscount = false;
      _enableColorDelete = AppColors.redColor;
      _enableColorNotes = Colors.transparent;
      _enableColorDiscount = Colors.transparent;
    } else {
      _enableColorDelete = Colors.transparent;
    }
    notifyListeners();
  }

  Color _enableColorDiscount = Colors.transparent;

  Color get enableColorDiscount => _enableColorDiscount;
  bool _enabledDiscount = false;

  bool get enabledDiscount => _enabledDiscount;

  void enableDiscount() {
    _enabledDiscount = !_enabledDiscount;
    if (_enabledDiscount) {
      _enabledNotes = false;
      _enabledDelete = false;
      _enableColorDelete = Colors.transparent;
      _enableColorNotes = Colors.transparent;
      _enableColorDiscount = AppColors.redColor;
    } else {
      _enableColorDiscount = Colors.transparent;
    }
    notifyListeners();
  }

  /// categories
  List<Item> _categorieClicked = [];

  List<Item> get categorieClicked => _categorieClicked;

  void clickOpenCategorie(List<Item> list) {
    _categorieClicked = list;
    notifyListeners();
  }

  void clickCloseCategorie() {
    _categorieClicked = [];
    notifyListeners();
  }

  /// room

  Map<String, dynamic> _choosenRoom = {};

  Map<String, dynamic> get choosenRoom => _choosenRoom;

  void chooseRoom(String name, String id) {
    _choosenRoom = {
      "name": name,
      "id": id,
    };
    notifyListeners();
  }

  bool _room = true;

  bool get room => _room;

  void switchRoom() {
    _room = true;
    notifyListeners();
  }

  void switchOrder() {
    _room = false;
    notifyListeners();
  }

  bool _checkout = false;

  bool get checkout => _checkout;

  void switchCheckout() {
    _checkout = true;
    notifyListeners();
  }

  void switchCheckoutOrder() {
    _checkout = false;
    notifyListeners();
  }

  /// tables type
  Widget _tableType = Container();

  Widget get tableType => _tableType;

  void changeTableType(String numberPlaces) {
    if (numberPlaces == "2") {
      _tableType = const TableTwo(
        name: '',
        rotation: 0,
      );
    }
    if (numberPlaces == "3") {
      _tableType = const TableThree(
        name: '',
        rotation: 0,
      );
    }
    if (numberPlaces == "4") {
      _tableType = const TableFour(
        name: '',
        rotation: 0,
      );
    }
    if (numberPlaces == "6") {
      _tableType = const TableSix(
        name: '',
        rotation: 0,
      );
    }
    if (numberPlaces == "8") {
      _tableType = const TableEight(
        rotation: 0,
      );
    }
    notifyListeners();
  }

  void changeTableRotation(double rotation) {
    if (_tableType is TableTwo) {
      _tableType = TableTwo(
        name: '',
        rotation: rotation,
      );
    } else if (_tableType is TableThree) {
      _tableType = TableThree(
        name: '',
        rotation: rotation,
      );
    } else if (_tableType is TableFour) {
      _tableType = const TableFour(
        name: '',
        rotation: 0,
      );
    } else if (_tableType is TableSix) {
      _tableType = TableSix(
        name: '',
        rotation: rotation,
      );
    } else if (_tableType is TableEight) {
      _tableType = TableEight(
        name: '',
        rotation: rotation,
      );
    }
    notifyListeners();
  }

  ///table timer
  // Map<String,List<TableTimer>> _tableTimer = {};
  // Map<String,List<TableTimer>> get tableTimer => _tableTimer;
  List<TableTimer> _tableTimer = [];

  List<TableTimer> get tableTimer => _tableTimer;

  set tableTimer(List<TableTimer> value) {
    _tableTimer = value;
  }

  void addTableTimer(TableTimer tableTimerWidget) {
    final existingWidgetIndex = _tableTimer.indexWhere(
      (widget) =>
          widget.tableId == tableTimerWidget.tableId &&
          widget.tableName == tableTimerWidget.tableName,
    );
    if (existingWidgetIndex == -1) {
      _tableTimer.add(tableTimerWidget);
    }
    notifyListeners();
  }

  void deleteTableTimer(String id) {
    final existingWidgetIndex =
        _tableTimer.indexWhere((widget) => widget.tableId == id);
    _tableTimer.removeAt(existingWidgetIndex);
    notifyListeners();
  }

  ///entry_items
  List<EntryItem> _entryItems = [];

  List<EntryItem> get entryItems => _entryItems;

  void addEntryItem(double number, EntryItem entryItem) {
    if (number > 0) {
      final existingWidgetIndex = _entryItems.indexWhere(
            (widget) =>
            widget.item_code == entryItem.item_code,
      );

      if (existingWidgetIndex != -1) {
        _entryItems[existingWidgetIndex].qty = number;
      } else {
        _entryItems.add(entryItem);
      }
    }
    notifyListeners();
  }




  void deleteEntryItems() {
    _entryItems = [];

    notifyListeners();
  }

  void updateEntryItemStatus(String entryItemCode, String status) {
    final entryItemToUpdate = _entryItems.firstWhere(
      (entryItem) => entryItem.item_code == entryItemCode,
    );
    if((entryItemToUpdate.status=="Attending" || entryItemToUpdate.status=="") && status=="Sent"){
      entryItemToUpdate.status = status;
    }
    print("entryItemToUpdate.status : ${entryItemToUpdate.status} ${entryItemToUpdate.item_name}");

    notifyListeners();
  }

  void updateEntryItemDocType(
      String entryItemCode, String docType, String warehouse) {
    final entryItemToUpdate = _entryItems.firstWhere(
      (entryItem) => entryItem.item_code == entryItemCode,
    );
    entryItemToUpdate.doctype = docType;
    entryItemToUpdate.warehouse = warehouse;
    notifyListeners();
  }

  // Kitchen
  int nbreCmd = 0;
  int nbreInprog = 0;
  int nbreDone = 0;
  bool isDone = false;
  kitchenOrderAppState.Order? selectedOrder;

  void updateIsDone(bool value) {
    isDone = value;
    notifyListeners();
  }

  void incrementNbreCmd() {
    nbreCmd++;
    notifyListeners();
  }

  void incrementNbreInprog() {
    nbreInprog++;
    notifyListeners();
  }

  void decreaseNbreInprog() {
    nbreInprog--;
    notifyListeners();
  }

  int totalnbreCmd(int orderListLength) {
    notifyListeners();
    return orderListLength;
  }

  void incrementNbreDone() {
    nbreDone++;
    notifyListeners();
  }

  void setSelectedOrder(kitchenOrderAppState.Order order) {
    print(' order.items = '+ order.items![0].toString());
    selectedOrder = order;
    notifyListeners();
  }
}
