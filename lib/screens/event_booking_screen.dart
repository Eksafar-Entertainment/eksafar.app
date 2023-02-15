import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/service/event_service.dart';
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


  var _quantities = {};
  int _total = 0;


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
    for(int index=0; index < _tickets.length; index++){
      var ticket = _tickets[index];
      int price = ticket["price"] ?? 0;
      int quantity = _quantities[ticket["id"]] ?? 0;
      overall += (price * quantity);
    }
    setState(() {
      _total = overall;
    });
  }

  createCheckoutSession() async {
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

    data["items"] = items;
    try {
      var response = await EventService.createCheckoutSession(data);
      print(response);
      var options = {
        'key': response["key"],
        'amount':  response["order_details"]["amount"], //in the smallest currency sub-unit.
        'name': "Eksafar Entertainment",
        'order_id': response["order_details"]["id"], // Generate order_id using Orders API
        'description': 'Ticket Booking',
        'timeout': 60, // in seconds
        'prefill': {
          'contact': response["user"]["mobile"],
          'email': response["user"]["email"]
        }
      };
      _razorpay?.open(options);
    }catch(err){
      showAlert(err.toString(), false);
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
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: 150,
            child: Column(
              children: [
                Icon(success?Icons.check : Icons.error, color: success?Colors.green:Colors.red, size: 50,),
                Container(height: 15,),
                Text(message, style: TextStyle(), textAlign: TextAlign.center,),
              ],
            ),
          ),
        )
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    showAlert("Congratulation booking successful", true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showAlert(response.message.toString() + response.code.toString(), false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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
                  title: Text(widget.event?["name"]??"")
              ),
              body : Column(
                children: [
                  Visibility(
                    visible: _dates.length > 0,
                    child:   Container(
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.03),
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Container(
                              child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(_dates.length, (index) =>
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: ButtonTheme(
                                          height: 70.0,
                                          minWidth: 10,
                                          child: MaterialButton(
                                            color: _dates[index] == _selected_date? Theme.of(context).primaryColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                            shape: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(18),
                                                borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                selectDate(_dates[index]);
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Text("${DateFormat("d").format(DateTime.parse(_dates[index]?? ""))}", style: TextStyle(fontSize: 20)),
                                                Text("${DateFormat("E").format(DateTime.parse(_dates[index]?? ""))}", style: TextStyle(fontSize: 10)),
                                                Text("${DateFormat("MMM").format(DateTime.parse(_dates[index]?? ""))}", style: TextStyle(fontSize: 12)),
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
                  Expanded(
                      flex: 1,
                      child:  SingleChildScrollView(
                          child: ListView(
                        shrinkWrap: true,
                        children: List.generate(_tickets.length, (index) =>
                            ListTile(
                              title: Text("${_tickets[index]["name"]} @ ₹${_tickets[index]["price"]}"),
                              subtitle: Text(_tickets[index]["description"], style: TextStyle(fontSize: 11, color: Colors.grey),),
                              trailing: Container(
                                width: 120,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        color: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.all(0),
                                        onPressed: (){
                                          changeQty(_tickets[index]["id"], -1);
                                        },
                                          icon: Icon(Icons.remove, size: 20,)
                                    ),
                                    Container(
                                      width: 20,
                                        child: Text((_quantities[_tickets[index]["id"]]??0).toString(), textAlign: TextAlign.center,)
                                    ) ,
                                    IconButton(
                                      color: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.all(0),
                                        onPressed: (){
                                          changeQty(_tickets[index]["id"], 1);
                                        },
                                        icon: Icon(Icons.add, size: 20,)
                                    ),
                                  ],
                                ),
                              )
                            )
                        ),
                      )
                      )
                  ),
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                        onTap: (){
                          createCheckoutSession();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Text("PAY (₹${_total.toString()})", textAlign: TextAlign.center,),
                        )
                    ),
                  ),

                ],
              )
          );

        }
    );
  }
}