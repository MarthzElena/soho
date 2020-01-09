import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemObject.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/items/item_detail.dart';

class SearchState extends Model{
  List<Widget> results = List<Widget>();
  bool spinner = false;
  String currentQuery = "";

  void showSpinner(bool show) {
    if (show) {
      spinner = true;
    } else {
      spinner = false;
    }
    notifyListeners();
  }

  void clearResults() {
    results.clear();
    notifyListeners();
  }

  void performSearch(String query) async {
    await SquareHTTPRequest.searchForItems(query).then((result) {
      // Only continue if query is current
      if (currentQuery == query) {
        clearResults();
        if (result.isNotEmpty) {
          results = _getWidgetList(result);
          notifyListeners();
        }
      }

    }).catchError((error) {
      // TODO: Handle error
      print("Search error: ${error.toString()}");
    });
  }

  List<Widget> _getWidgetList(List<SubcategoryItems> searchResult) {
    var results = List<Widget>();
    var text1 = Padding(
      padding: const EdgeInsets.only(left: 14.0, top: 40.0, bottom: 16.0),
      child: Text(
        "- Resultados de la búsqueda",
        style: interLightStyle(
          fSize: 14.0,
          color: Color(0xff789090),
        ),
      ),
    );
    results.add(text1);

    var resultCarousel = CarouselSlider(
      viewportFraction: 0.5,
      height: 378.0,
      enableInfiniteScroll: false,
      items: searchResult.map((item) {
        // Each SubCategory item should have only one product
        var product = item.items.first;
        return Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              // Go to product detail
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProductDetail(
                    currentProduct: product,
                  ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              constraints: BoxConstraints.expand(),
              alignment: Alignment(-1.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 220,
                    height: 268,
                    decoration: BoxDecoration(
                      color: product.imageUrl.isEmpty ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: product.imageUrl.isEmpty ? SizedBox.shrink() : Image(image: NetworkImage(product.imageUrl)),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    product.name,
                    style: interBoldStyle(fSize: 16.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    product.description,
                    style: interLightStyle(
                      fSize: 12.0,
                      color: Color(0xff5A6265),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "\$${product.price}0",
                    style: interMediumStyle(fSize: 16.0),
                  )
                ]
              ),
            ),
          );
        });
      }).toList(),
    );
    results.add(resultCarousel);

    return results;
  }
}