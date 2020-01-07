import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemObject.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';

class SearchState extends Model{
  List<SubcategoryItems> _results = List<SubcategoryItems>();

  void performSearch(String query) async {
    await SquareHTTPRequest.searchForItems(query).then((result) {
      _results = result;
      notifyListeners();

    }).catchError((error) {
      // TODO: Handle error
      print("Search error: ${error.toString()}");
    });
  }
}