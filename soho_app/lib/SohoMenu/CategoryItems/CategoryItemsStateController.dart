import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';

class CategoryItemsState extends Model {

  bool isDistributionList = true;
  Image listDistribution = Image.asset('assets/category_detail/grid_view.png');
  List<SubcategoryItems> _categoryItems = List<SubcategoryItems>();
  List<Widget> widgetsList = List<Widget>();

  void changeItemsDistribution() {
    if (isDistributionList) {
      // Change to GRIDview
      isDistributionList = false;
      listDistribution = Image.asset('assets/category_detail/list_view.png');
      widgetsList = _getproductWidgetGrid(_categoryItems);
    } else {
      // Change to LISTview
      isDistributionList = true;
      listDistribution = Image.asset('assets/category_detail/grid_view.png');
      widgetsList = _getProductWidgetList(_categoryItems);
    }
    notifyListeners();
  }

  void updateItems(List<SubcategoryItems> items) {
    _categoryItems = items;
    if (isDistributionList) {
      widgetsList = _getProductWidgetList(_categoryItems);
    } else {
      widgetsList = _getproductWidgetGrid(_categoryItems);
    }
  }

  List<Widget> _getproductWidgetGrid(List<SubcategoryItems> items) {
    List<Widget> result = List<Widget>();
    for (var item in items) {
      var categoryText = "- ${item.subcategoryName}";
      var subcategoryTitle = Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 40.0, bottom: 16.0),
        child: Text(
          categoryText,
          style: TextStyle(
              fontSize: 14.0,
              color: Color.fromARGB(255, 120, 144, 144)
          ),
        ),
      );
      result.add(subcategoryTitle);

      var productCarousel = CarouselSlider(
        viewportFraction: 0.5,
        height: 378.0,
        enableInfiniteScroll: false,
        items: item.items.map((product) {
          return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    constraints: BoxConstraints.expand(),
                    alignment: Alignment(-1.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 220,
                          height: 268,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(8.0))
                          ),
                          // TODO: Add child with item image
                        ),
                        Text(
                          product.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          product.description,
                          style: TextStyle(
                              color: Color.fromARGB(255, 90, 98, 101),
                              fontSize: 12.0
                          ),
                        ),
                        Text(
                          "\$${product.price}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    )
                );
              }
          );
        }).toList(),
      );
      result.add(productCarousel);
    }

    return result;
  }

  List<Widget> _getProductWidgetList(List<SubcategoryItems> items) {
    List<Widget> result = List<Widget>();
    for (var item in items) {
      var categoryText = "- ${item.subcategoryName}";
      var subcategoryTitle = Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 40.0),
        child: Text(
          categoryText,
          style: TextStyle(
              fontSize: 14.0,
              color: Color.fromARGB(255, 120, 144, 144)
          ),
        ),
      );
      result.add(subcategoryTitle);

      for (var product in item.items) {
        var productWidget = InkWell(
          onTap: () {
            _onCategoryItemTapped(product);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                          color: Color.fromARGB(255, 90, 98, 101),
                          fontSize: 12.0
                      ),
                    ),
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  // TODO: Add child with item image
                )
              ],
            ),
          ),
        );
        result.add(productWidget);
      }

    }

    return result;
  }

  void _onCategoryItemTapped(ProductItemObject product) {

  }

}