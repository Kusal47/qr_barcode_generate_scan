import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../resources/colors.dart';
import '../../resources/size_config.dart';
import 'custom_icon_buttons.dart';
import 'custom_widget.dart';
import 'custom_grid-view.dart';

horizontalListItems(BuildContext context, SizeConfig config, List<dynamic> items) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
        children: List.generate(items.length, (index) {
      final placeItems = items[index];
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: config.appHorizontalPaddingMedium()),
        child: GestureDetector(
          onTap: () {
          },
          child: Container(
            width: config.appWidth(50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: greyColor.withOpacity(0.4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        placeItems.image,
                        fit: BoxFit.cover,
                        height: config.appWidth(40),
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () {},
                        child: circularIconButton(context,
                            icon: Icons.favorite, iconColor: redColor, onTap: () {}),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded, //Icons.favorite_sharp
                              color: colorYellowStar,
                              size: config.appHeight(2.5),
                            ),
                            Text(
                              placeItems.rating,
                              style: customTextStyle(
                                  fontSize: config.appHeight(1.5),
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeItems.title,
                        style: customTextStyle(
                          fontSize: config.appHeight(2.0),
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            HeroIcons.map_pin,
                            size: config.appHeight(2.5),
                            color: primaryColor,
                          ),
                          config.horizontalSpaceVerySmall(),
                          Expanded(
                            child: Text(
                              placeItems.address,
                              style: customTextStyle(
                                fontSize: config.appHeight(1.5),
                                color: darkGreyColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    })),
  );
}

gridViewList(BuildContext context, SizeConfig config, List<dynamic> items) {
  return SingleChildScrollView(
    child: GridViewBuilderWidget(
        itemBuilder: (context, index) {
          final placeItems = items[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: config.appWidth(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: greyColor.withOpacity(0.4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Image.asset(
                            placeItems.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(config.appHorizontalPaddingMedium()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              placeItems.title,
                              maxLines: 2,
                              style: customTextStyle(
                                fontSize: config.appHeight(2.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            config.verticalSpaceVerySmall(),
                            Row(
                              children: [
                                Icon(
                                  HeroIcons.map_pin,
                                  size: config.appHeight(2.5),
                                  color: primaryColor,
                                ),
                                config.horizontalSpaceVerySmall(),
                                Expanded(
                                  child: Text(
                                    placeItems.address,
                                    style: customTextStyle(
                                      fontSize: config.appHeight(1.5),
                                      color: darkGreyColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            config.verticalSpaceVerySmall(),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded, //Icons.favorite_sharp
                                  color: colorYellowStar,
                                  size: config.appHeight(2.5),
                                ),
                                Text(
                                  placeItems.rating,
                                  style: customTextStyle(
                                      fontSize: config.appHeight(1.5),
                                      fontWeight: FontWeight.bold,
                                      color: blackColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  onTap: () {},
                  child: circularIconButton(context,
                      icon: Icons.favorite, iconColor: redColor, onTap: () {}),
                ),
              ),
            ],
          );
        },
        crossAxisCount: 2,
        chilApectRatio: config.appWidth(15) / config.appWidth(20),
        crossAxisSpacing: config.appHeight(2),
        mainAxisSpacing: config.appHeight(2),
        itemCount: items.length),
  );
}
