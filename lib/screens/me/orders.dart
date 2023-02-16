import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _controller = ScrollController();
  int _current_page = 0;
  int _last_page = 1;
  var _orders = [];
  fetchOrders () async {
    if(_last_page > _current_page) {
      try {
        var response = await UserService.orders(_current_page + 1);
        setState(() {
          _orders.addAll(response["orders"]["data"]);
          _current_page = response["orders"]["current_page"];
          _last_page = response["orders"]["last_page"];
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          fetchOrders();
        }
      }
    });
  }

  void showAlert(var order) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: 335 + double.parse((order["order_details"].length*80).toString()),
            child: Column(
              children: [
                Text("Order Details", style: TextStyle(fontSize: 20),),
                Container(
                  height: 15,
                ),
                QrImage(
                    data: order["id"].toString(),
                    version: QrVersions.auto,
                    size: 200,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                ),
                Text(order["event_name"]),
                Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.parse(order["event_datetime"])),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12
                  ),
                ),
                Container(
                  height: 15,
                ),
                ListView.separated(
                  itemCount: order["order_details"].length,
                  shrinkWrap: true,
                  itemBuilder: (context, _index){
                    return ListTile(
                      title: Text(order["order_details"][_index]["name"]),
                      subtitle: Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(order["order_details"][_index]["start_datetime"])), style: TextStyle(color: Colors.grey, fontSize: 12),),
                      trailing: Text("x${order["order_details"][_index]["quantity"].toString()}", style: TextStyle(color: Theme.of(context).primaryColor),),
                    );
                  },
                  separatorBuilder: (context,index){
                    return Container(height: 1, color: Colors.white.withOpacity(0.3), margin: EdgeInsets.symmetric(horizontal: 15),);
                  },
                )
              ],
            ),
          ),
        )
    );
  }


  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Bookings"),
              ),
              body: ListView.builder(
                controller: _controller,
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_orders[index]["event_name"]),
                    subtitle: Text(
                      "Qtde: ${_orders[index]["quantity"].toString()} - ₹${_orders[index]["total_price"].toString()}",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                      ),
                    ),
                    leading: Container(
                      width: 45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: Column(
                        children: [
                          Text(DateFormat("d").format(DateTime.parse(_orders[index]["event_datetime"])), style: TextStyle(fontSize: 18),),
                          Text(DateFormat("MMM").format(DateTime.parse(_orders[index]["event_datetime"])),style: TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                    onTap: (){
                     showAlert(_orders[index]);
                    },
                  );
                },
              )
          );
        }
    );
  }
}