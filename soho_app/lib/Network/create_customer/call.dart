import 'package:http/http.dart' as http;
import 'package:soho_app/Models/requests/create_customer.dart';
import 'package:soho_app/Models/responses/create_customer.dart';

void createCustomerCall({CreateCustomerRequest request, stripeToken}) async {
  try {
    final response = await http.post(
      'https://api.stripe.com/v1/customers',
      headers: {
        'Authorization': 'Bearer $stripeToken',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: createCustomerRequestToJson(request),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print(createCustomerResponseFromJson(response.body).toJson().toString());
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
  }
}
