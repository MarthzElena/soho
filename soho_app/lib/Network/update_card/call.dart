import 'package:http/http.dart' as http;
import 'package:soho_app/Models/requests/update_card.dart';
import 'package:soho_app/Models/responses/update_card.dart';
import 'package:soho_app/Utils/Application.dart';

Future<UpdateCardResponse> updateCardCall({UpdateCardRequest request, customerId, cardId}) async {
  try {
    final response = await http.post(
      'https://api.stripe.com/v1/customers/$customerId/sources/$cardId',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: updateCardRequestToJson(request),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return updateCardResponseFromJson(response.body);
    } else {
      return updateCardResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return updateCardResponseFromJson('error');
  }
}
