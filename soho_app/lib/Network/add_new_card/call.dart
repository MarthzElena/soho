import 'package:http/http.dart' as http;
import 'package:soho_app/Models/requests/add_new_card.dart';
import 'package:soho_app/Models/responses/add_new_card.dart';
import 'package:soho_app/Utils/Application.dart';

Future<AddNewCardResponse> addNewCardCall({AddNewCardRequest request, customerId}) async {
  try {
    final response = await http.post(
      'https://api.stripe.com/v1/customers/$customerId/sources',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: addNewCardRequestToMap(request),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return addNewCardResponseFromJson(response.body);
    } else {
      return addNewCardResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return addNewCardResponseFromJson('error');
  }
}
