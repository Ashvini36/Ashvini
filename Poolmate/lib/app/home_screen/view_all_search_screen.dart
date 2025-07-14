import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/controller/view_all_search_controller.dart';
import 'package:poolmate/model/recent_search_model.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';

class ViewAllSearchScreen extends StatelessWidget {
  const ViewAllSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ViewAllSearchController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              titleSpacing: 0,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                    child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),),
              title: Text(
                "Recent Searches".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: controller.isLoading.value
                  ? Constant.loader()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.recentSearch.length,
                      itemBuilder: (context, index) {
                        RecentSearchModel recentSearchModel = controller.recentSearch[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${recentSearchModel.pickUpAddress}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: SvgPicture.asset("assets/icons/ic_right_arrow.svg"),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${recentSearchModel.dropAddress}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Constant.timestampToDateTime(recentSearchModel.createdAt!),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: AppThemeData.regular,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        });
  }
}
