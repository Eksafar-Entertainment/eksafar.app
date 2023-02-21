import 'dart:async';

import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/screens/me/orders.dart';
import 'package:eksafar/service/event_service.dart';
import 'package:eksafar/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import "package:intl/intl.dart";
import 'package:razorpay_flutter/razorpay_flutter.dart';
class EventBookingScreen extends StatefulWidget {
  var event;
  EventBookingScreen({super.key, required this.event});
  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  Razorpay? _razorpay;
  var _date_tickets = null;
  var _tickets = null;
  var _dates = null;
  var _selected_date = null;
  var _timer;
  bool _is_processing = false;


  var _quantities = {};
  int _total = 0;
  int _total_quantity=0;


  bool _loading = true;
  var top = 0.0;

  fetchTickets() async {
    setState(() {
      _loading = true;
    });

    var response = await EventService.tickets(widget.event["id"]);
    setState(() {
      _dates = response["dates"];
      _date_tickets = response["date_tickets"];

      _selected_date = _dates[0];
      _tickets = _date_tickets[_dates[0]];
      _loading = false;
    });
  }

  selectDate(String date){
    setState(() {
      _selected_date = date;
      _tickets = _date_tickets[date];
      _quantities = {};
      _total = 0;
    });

  }

  changeQty(ticket_id, int qtde){
    int _qtde = (_quantities[ticket_id]??0)+(qtde);
    setState(() {
      _quantities[ticket_id] = _qtde > -1? _qtde : 0;
      calculateForm();
    });
  }

  calculateForm(){
    int overall = 0;
    int totalQuantity = 0;
    for(int index=0; index < _tickets.length; index++){
      var ticket = _tickets[index];
      int price = ticket["price"] ?? 0;
      int quantity = _quantities[ticket["id"]] ?? 0;
      overall += (price * quantity);
      totalQuantity+=quantity;
    }
    setState(() {
      _total = overall;
      _total_quantity = totalQuantity;
    });
  }

  processBooking() async {
    Map<String, dynamic> data = {
      "event_id": widget.event["id"]
    };
    List <dynamic> items = [];
    for(int index = 0; index < _tickets.length; index++){
      var ticket = _tickets[index];
      if(_quantities[ticket["id"]]!=null){
        items.add({
          "event_ticket_id": ticket["id"],
          "quantity": _quantities[ticket["id"]]
        });
      }
    }

    if(items.isEmpty || _total_quantity <= 0){
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select ticket"),
      ));
    }

    data["items"] = items;
    try {
      setState(() {
        _is_processing = true;
      });
      var response = await EventService.createCheckoutSession(data);
      if(response["is_free"]){
        Navigator.pop(context);
        showAlert("Congratulation booking successful", true);
        setState(() {
          _is_processing = false;
        });
      } else {
        var options = {
          'key': response["key"],
          'amount': response["order_details"]["amount"],
          //in the smallest currency sub-unit.
          'name': "Eksafar Entertainment",
          'order_id': response["order_details"]["id"],
          // Generate order_id using Orders API
          'description': 'Ticket Booking',
          'timeout': 60,
          // in seconds
          'prefill': {
            'contact': response["user"]["mobile"],
            'email': response["user"]["email"]
          }
        };
        _razorpay?.open(options);
      }
    }catch(err){
      showAlert(err.toString(), false);
      setState(() {
        _is_processing = false;
      });
    }
    setState(() {
      _quantities = {};
      _total = 0;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTickets();

    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }
  void showAlert(String message, bool success) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(success?Icons.check : Icons.error, color: success?Colors.green:Colors.red, size: 50,),
                Container(height: 15,),
                Text(message, style: const TextStyle(), textAlign: TextAlign.center,),
                Container(height: 15,),
                Visibility(
                    visible: success,
                    child: ThemeButton(
                      height: 35,
                      label: "View Tickets",
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrdersScreen()),
                        );
                      },
                    )
                )
              ],
            ),
          ),
        )
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _is_processing = false;
    });
    Navigator.pop(context);
    // Do something when payment succeeds
    showAlert("Congratulation booking successful", true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _is_processing = false;
    });
    // Do something when payment fails
    showAlert(response.message.toString() + response.code.toString(), false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _is_processing = false;
    });
    // Do something when an external wallet was selected
    showAlert(response.walletName.toString(), true);
  }
  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {

          if(_loading == true){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(widget.event?["name"]??""),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(_dates.length > 0? 80:0),
                  child:    Visibility(
                    visible: _dates.length > 0,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.02),
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white.withOpacity(0.05)),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Container(
                              child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(_dates.length, (index) =>
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: ButtonTheme(
                                          height: 55.0,
                                          minWidth: 10,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: MaterialButton(
                                            color: _dates[index] == _selected_date? Colors.white.withOpacity(0.8): Colors.white.withOpacity(0.15),
                                            elevation: 0,
                                            shape: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(18),
                                                borderSide: const BorderSide(width: 1, color: Colors.transparent)
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                selectDate(_dates[index]);
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${DateFormat("d").format(DateTime.parse(_dates[index]?? ""))}", style: TextStyle(
                                                        fontSize: 20,
                                                      color: _dates[index] == _selected_date? Theme.of(context).primaryColor: Colors.white
                                                    )),
                                                    Container(width: 5,),
                                                    Text("${DateFormat("MMM").format(DateTime.parse(_dates[index]?? ""))}", style: TextStyle(fontSize: 12,  color: _dates[index] == _selected_date? Theme.of(context).primaryColor: Colors.white)),
                                                  ],
                                                ),
                                                Text("${DateFormat("EEEE").format(DateTime.parse(_dates[index]?? ""))}", style: TextStyle(fontSize: 10,   color: _dates[index] == _selected_date? Theme.of(context).primaryColor: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  )
                              )
                          ),
                        )
                    ),
                  ),
                ),
              ),
              body : Container(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: ListView.separated(
                            itemCount: _tickets?.length??0,
                            itemBuilder: (BuildContext context, index){
                              return ListTile(
                                  title: Text("${_tickets[index]["name"]} @ ${NumberFormat.currency(locale: "en_IN", symbol: "₹", decimalDigits: 0).format(_tickets[index]["price"])}", style: const TextStyle(fontSize: 15),),
                                  subtitle: Text(_tickets[index]["description"], style: const TextStyle(fontSize: 11, color: Colors.grey),),
                                  trailing: Container(
                                    width: 90,
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            changeQty(_tickets[index]["id"], -1);
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          child: GestureDetector(
                                              onLongPressStart: (detail){
                                                setState(() {
                                                  if (_timer != null) {
                                                    _timer!.cancel();
                                                  }
                                                  _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
                                                    changeQty(_tickets[index]["id"], -1);
                                                  });
                                                });
                                              },
                                              onLongPressEnd: (detail){
                                                if (_timer != null) {
                                                  _timer!.cancel();
                                                }
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.all(2.5),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                                                      borderRadius: const BorderRadius.all(Radius.circular(8))
                                                  ),
                                                  child: const Icon(Icons.remove, size: 20, color: Colors.white,)
                                              )
                                          ),
                                        ),
                                        Container(
                                            width: 40,
                                            child: Text((_quantities[_tickets[index]["id"]]??0).toString(), textAlign: TextAlign.center,)
                                        ) ,
                                        InkWell(
                                          onTap: () {
                                              changeQty(_tickets[index]["id"], 1);
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          child: GestureDetector(
                                            onLongPressStart: (detail){
                                              setState(() {
                                                _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
                                                  changeQty(_tickets[index]["id"], 1);
                                                });
                                              });
                                            },
                                            onLongPressEnd: (detail){
                                              if (_timer != null) {
                                                _timer!.cancel();
                                              }
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.all(2.5),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                                ),
                                                child: const Icon(Icons.add, size: 20, color: Colors.white,)
                                            )
                                        ),
                                        )
                                      ],
                                    ),
                                  )

                              );
                            },
                            separatorBuilder: (BuildContext context, index){
                              return Container(height: 1, color: Colors.white.withOpacity(0.03), margin: const EdgeInsets.symmetric(horizontal: 15),);
                            },
                          )
                      ),
                      Visibility(
                          visible: _total_quantity > 0,
                          child: Container(
                            width: double.infinity,

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                              )
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child:  Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(NumberFormat.currency(locale: "en_IN", symbol: "₹", decimalDigits: 2).format(_total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                                        const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12),),
                                      ],
                                    )
                                ),
                                ButtonTheme(
                                    shape: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                            width: 0
                                        )
                                    ),
                                    child: ThemeButton(
                                        height: 40,
                                        label: "BOOK NOW",
                                        color: Theme.of(context).primaryColor,
                                        onPressed: (){
                                          processBooking();
                                        },
                                        isLoading: _is_processing
                                    )
                                )
                              ],
                            ),
                          )
                      )

                    ],
                  )
              )
          );
        }
    );
  }
}