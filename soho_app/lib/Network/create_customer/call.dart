import 'package:http/http.dart' as http;
import 'package:soho_app/Models/requests/create_customer.dart';
import 'package:soho_app/Models/responses/create_customer.dart';
import 'package:soho_app/Utils/Application.dart';

Future<CreateCustomerResponse> createCustomerCall({CreateCustomerRequest request}) async {
  try {
    final response = await http.post(
      'https://api.stripe.com/v1/customers',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: createCustomerRequestToJson(request),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return createCustomerResponseFromJson(response.body);
    } else {
      return createCustomerResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return createCustomerResponseFromJson('error');
  }
}
