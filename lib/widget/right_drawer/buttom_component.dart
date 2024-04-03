import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/AppState.dart';
import 'package:klitchyapp/utils/size_utils.dart';
import 'package:klitchyapp/widget/custom_button.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/app_colors.dart';
import '../../config/pos_params.dart';

class ButtomComponent extends StatefulWidget {
  final Function() onTap;
  final AppState appState;
  const ButtomComponent({
    super.key,
    required this.onTap,
    required this.appState,
  });

  @override
  State<ButtomComponent> createState() => _ButtomComponentState();
}

class _ButtomComponentState extends State<ButtomComponent> {
  void printTicket2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString("orderId");
    String url =
        '${PosParams.erpnextURL}/api/method/frappe.utils.print_format.download_pdf?doctype=Table%20Order&name=$orderId&no_letterhead=1&letterhead=No%20Letterhead&settings=%7B%7D&format=ticket%20restau&_lang=en';
    try {
      final token = prefs.getString("token");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
      );
      if (response.statusCode == 200) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async {
            // Use the alias
            return response.bodyBytes; // Pass the response body directly
          },
        );
      } else {
        print(
            'Failed to update Table Order status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //  show a popup to confirm the order
  void showConfirmOrderAlert(
      BuildContext context, String msg, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: SizedBox(
            height: 100.v,
            child: Column(
              children: [
                Text(msg),
                SizedBox(
                  height: 10.v,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: "Cancel",
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    CustomButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: "Confirm",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> confirmOrder(
      BuildContext context, String message, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, //
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showError(
      BuildContext context, String message, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 383.h,
      height: 310.v,
      decoration: BoxDecoration(
        color: AppColors.itemsColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Subtotal",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.subtotal.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "TVA 7%",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.tva.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15.fSize),
                ),
                const Spacer(),
                Text(
                  "${widget.appState.total.toStringAsFixed(3)} TND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textItems,
                      fontSize: 15.fSize),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.v),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    widget.onTap();
                    confirmOrder(
                        context, "Order added successfully", "Success");
                  },
                  child: Container(
                    width: 191.5.h,
                    height: 100.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: AppColors.lightColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: AppColors.greenColor.withOpacity(0.8),
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          "Send to Kitchen",
                          style: TextStyle(
                              color: AppColors.greenColor.withOpacity(0.8),
                              fontSize: 20.fSize),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.appState.entryItems.isNotEmpty) {
                      if (widget.appState.checkout) {
                        widget.appState.switchCheckoutOrder();
                      } else {
                        widget.appState.switchCheckout();
                      }
                    } else {
                      showError(
                          context,
                          "Please enter items before perceding to payment",
                          "No items entered");
                    }
                  },
                  child: Container(
                    width: 191.5.h,
                    height: 100.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: AppColors.lightColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_card_outlined,
                          color: AppColors.turquoise,
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          "Payment",
                          style: TextStyle(
                              color: AppColors.turquoise, fontSize: 20.fSize),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.v),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    printTicket2();
                  },
                  child: Container(
                    width: 381.h,
                    height: 50.v,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: AppColors.lightColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.h,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print,
                          color: AppColors.greenColor.withOpacity(0.8),
                          size: 30.fSize,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Print Ticket",
                          style: TextStyle(
                              color: AppColors.greenColor.withOpacity(0.8),
                              fontSize: 20.fSize),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
