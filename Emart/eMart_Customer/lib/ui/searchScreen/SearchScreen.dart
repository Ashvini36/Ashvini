import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/constants.dart';
import 'package:emartconsumer/model/ProductModel.dart';
import 'package:emartconsumer/model/VendorModel.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:emartconsumer/services/helper.dart';
import 'package:emartconsumer/theme/app_them_data.dart';
import 'package:emartconsumer/ui/productDetailsScreen/ProductDetailsScreen.dart';
import 'package:emartconsumer/ui/vendorProductsScreen/NewVendorProductsScreen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late List<VendorModel> vendorList = [];
  late List<VendorModel> vendorSearchList = [];

  late List<ProductModel> productList = [];
  late List<ProductModel> productSearchList = [];

  final FireStoreUtils fireStoreUtils = FireStoreUtils();

  @override
  void initState() {
    super.initState();

    fireStoreUtils.getVendors().then((value) {
      setState(() {
        vendorList = value;
      });
    });
    fireStoreUtils.getAllProducts().then((value) {
      setState(() {
        productList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isDarkMode(context) ? AppThemeData.surfaceDark : AppThemeData.surface,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back)),
          actions: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 50, top: 10, right: Directionality.of(context).toString().contains(TextDirection.RTL.value.toLowerCase()) ? 50 : 10, bottom: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      onSearchTextChanged(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...'.tr(),
                      contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      hintStyle: const TextStyle(color: Color(0XFF8A8989)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: AppThemeData.primary300, width: 2.0)),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: vendorSearchList.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Store",
                        style: TextStyle(color: Colors.black, fontFamily: AppThemeData.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: vendorSearchList.length,
                        itemBuilder: (context, index) {
                          return data(vendorSearchList[index]);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: productSearchList.isNotEmpty,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Item".tr(),
                        style: const TextStyle(color: Colors.black, fontFamily: AppThemeData.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productSearchList.length,
                        itemBuilder: (context, index) {
                          return product(productSearchList[index]);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  onSearchTextChanged(String text) {
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      vendorSearchList = vendorList.where((element) => element.title.toLowerCase().contains(text.toLowerCase())).toList();
      productSearchList = productList.where((element) => element.name.toLowerCase().contains(text.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    vendorSearchList.clear();
    productSearchList.clear();
    super.dispose();
  }

  data(VendorModel vendorModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => push(
          context,
          NewVendorProductsScreen(
            vendorModel: vendorModel,
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.16,
                imageUrl: getImageVAlidUrl(vendorModel.photo),
                imageBuilder: (context, imageProvider) => Container(
                      // width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                    ),
                errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      placeholderImage,
                      fit: BoxFit.cover,
                    ))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(vendorModel.title,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode(context) ? const Color(0xffFFFFFF) : const Color(0xff272727),
                            // Color(0xff272727)
                          )),
                      const SizedBox(height: 3),
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Icon(
                          Icons.location_on_sharp,
                          color: Color(0xff9091A4),
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Container(
                            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 50),
                            child: Text(
                              vendorModel.location,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14, color: Color(0XFF555353)),
                            ))
                      ]),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  product(ProductModel productModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        VendorModel? vendorModel = await FireStoreUtils.getVendor(productModel.vendorID);
        if (vendorModel != null) {
          push(
            context,
            ProductDetailsScreen(
              vendorModel: vendorModel,
              productModel: productModel,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.16,
                imageUrl: getImageVAlidUrl(productModel.photo),
                imageBuilder: (context, imageProvider) => Container(
                      // width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                    ),
                errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      placeholderImage,
                      fit: BoxFit.cover,
                    ))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(productModel.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode(context) ? const Color(0xffFFFFFF) : const Color(0xff272727),
                            // Color(0xff272727)
                          )),
                      const SizedBox(height: 3),
                      productModel.disPrice == "" || productModel.disPrice == "0"
                          ? Text(
                              amountShow(amount: productCommissionPrice(productModel.price)),
                              style: TextStyle(fontSize: 16, letterSpacing: 0.5, color: AppThemeData.primary300),
                            )
                          : Row(
                              children: [
                                Text(
                                  "${amountShow(amount: productCommissionPrice(productModel.disPrice.toString()))}",
                                  // "$symbol${double.parse(productModel.disPrice.toString()).toStringAsFixed(decimal)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppThemeData.primary300,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  amountShow(amount: productCommissionPrice(productModel.price)),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
