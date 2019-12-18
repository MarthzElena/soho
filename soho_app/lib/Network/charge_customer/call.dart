import 'package:http/http.dart' as http;
import 'package:soho_app/Models/requests/charge_customer.dart';
import 'package:soho_app/Models/responses/charge_customer.dart';

void chargeCustomerCall({ChargeCustomerRequest request, stripeToken}) async {
  try {
    final response = await http.post(
      'https://api.stripe.com/v1/charges',
      headers: {
        'Authorization': 'Bearer $stripeToken',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: chargeCustomerRequestToJson(request),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print(chargeCustomerResponseFromJson(response.body).toJson().toString());
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
  }
}
