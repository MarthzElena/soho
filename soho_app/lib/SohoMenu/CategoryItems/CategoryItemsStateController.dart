import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemObject.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/items/item_detail.dart';

class CategoryItemsState extends Model {
  bool isDistributionList = true;
  Image listDistribution = Image.asset('assets/category_detail/grid_view.png');
  List<SubcategoryItems> _categoryItems = List<SubcategoryItems>();
  List<Widget> widgetsList = List<Widget>();
  BuildContext context;

  void changeItemsDistribution(context) {
    if (isDistributionList) {
      // Change to GRIDview
      isDistributionList = false;
      listDistribution = Image.asset('assets/category_detail/list_view.png');
      widgetsList = _getProductWidgetGrid(_categoryItems);
    } else {
      // Change to LISTview
      isDistributionList = true;
      listDistribution = Image.asset('assets/category_detail/grid_view.png');
      widgetsList = _getProductWidgetList(_categoryItems, context);
    }
    notifyListeners();
  }

  List<SubcategoryItems> getData(AsyncSnapshot snapshot) {
    CategoryItemObject categoryItem = snapshot.data;
    if (categoryItem != null) {
      return categoryItem.allItems;
    }
    return List<SubcategoryItems>();
  }

  void updateItems(List<SubcategoryItems> items, context) {
    _categoryItems = items;
    if (isDistributionList) {
      widgetsList = _getProductWidgetList(_categoryItems, context);
    } else {
      widgetsList = _getProductWidgetGrid(_categoryItems);
    }
  }

  List<Widget> _getProductWidgetGrid(List<SubcategoryItems> items) {
    List<Widget> result = List<Widget>();
    for (var item in items) {
      var categoryText = "- ${item.subcategoryName}";
      var subcategoryTitle = Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 40.0, bottom: 16.0),
        child: Text(
          categoryText,
          style: interLightStyle(
            fSize: 14.0,
            color: Color(0xff789090),
          ),
        ),
      );
      result.add(subcategoryTitle);

      var productCarousel = CarouselSlider(
        viewportFraction: 0.5,
        height: 378.0,
        enableInfiniteScroll: false,
        items: item.items.map((product) {
          return Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
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
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        // TODO: Add child with item image
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
                        "\$${product.price}",
                        style: interMediumStyle(fSize: 16.0),
                      )
                    ],
                  )),
            );
          });
        }).toList(),
      );
      result.add(productCarousel);
    }
    result.add(SizedBox(height: 40.0));

    return result;
  }

  List<Widget> _getProductWidgetList(List<SubcategoryItems> items, context) {
    List<Widget> result = List<Widget>();
    for (var item in items) {
      var categoryText = "- ${item.subcategoryName}";
      var subcategoryTitle = Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 40.0),
        child: Text(
          categoryText,
          style: interLightStyle(
            fSize: 14.0,
            color: Color(0xff789090),
          ),
        ),
      );
      result.add(subcategoryTitle);

      for (var product in item.items) {
        var productWidget = GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProductDetail(
                  currentProduct: product,
                ),
              ),
            );
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
                      "\$${product.price}",
                      style: interMediumStyle(fSize: 16.0),
                    )
                  ],
                ),
                Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
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

    result.add(SizedBox(height: 40.0));
    return result;
  }
}
