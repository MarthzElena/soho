import 'package:http/http.dart' as http;
import 'package:soho_app/Models/responses/get_customer.dart';

void getCustomerCall({customerId, stripeToken}) async {
  try {
    final response = await http.get(
      'https://api.stripe.com/v1/customers/$customerId',
      headers: {
        'Authorization': 'Bearer $stripeToken',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print(getCustomerResponseFromJson(response.body).toJson().toString());
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
  }
}
