import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneypros/app/locator.dart';
import 'package:moneypros/app/user_repository.dart';
import 'package:moneypros/app_widegt/AppErrorWidget.dart';
import 'package:moneypros/app_widegt/app_carousel.dart';
import 'package:moneypros/model/easyCashData.dart';
import 'package:moneypros/pages/dashboard/dashboard_view_model.dart';
import 'package:moneypros/pages/home/component/credit_meter.dart';
import 'package:moneypros/pages/loan_details/loan_details_page.dart';
import 'package:moneypros/pages/webview_page/webview_page.dart';
import 'package:moneypros/resources/images/images.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:moneypros/utils/urlList.dart';
import 'package:moneypros/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  _getSliderIndicator(DashboardViewModel model) {
    return Container(
        height: 20,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
              activeIndex: model.currentPosition,
              count: model.userRepo.dashboardData.banner.length,
              effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.green,
                  dotColor: AppColors.grey400,
                  spacing: 6.0),
            ),
          ],
        )
        //  List.generate(model.bannerList.length, (position) {
        //   return Container(
        //     height: 14,
        //     padding: EdgeInsets.all(3),
        //     margin: EdgeInsets.all(4),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: (model.currentPosition == position
        //           ? AppColors.green
        //           : AppColors.grey400),
        //     ),
        //   );
        // }

        );
  }

  _getOverViewWidget(DashboardViewModel model) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.smallMargin, vertical: Spacing.mediumMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: Spacing.smallMargin),
            child: Text(
              "Overview",
              style: TextStyle(
                  color: AppColors.blackGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                //crossAxisSpacing: 8,
                //mainAxisSpacing: 8,
                childAspectRatio: (itemWidth / 200)),
            itemCount: model.trandingList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final data = model.trandingList[index];
              return Hero(
                tag: "loan$index",
                child: LoanTile(
                  title: data.title,
                  desc: data.desc,
                  image: data.image,
                  onTap: () {
                    // final repo = Provider.of<UserRepo>(context,listen: false);
                    // repo.getUserDataFromTable("104");
                    myPrint("type is ${data.title}");
                    if(data.title == "Wealth Management"){
                      locator<NavigationService>().navigateToView(
                    AppBrowserPage(url:UrlList.EQUITY_TRADING_LINK ));
                    }else{
                       Utility.pushToNext(
                        LoanDetailsPage(type: data.title), context);
                    }
                   
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _getAboutUsWidget(DashboardViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.smallMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: [AppColors.blue, AppColors.kBlueLightColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.defaultMargin,
                  vertical: Spacing.defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We aspire to be India’s preferred destination for the widest range of financial products including Retail loans, SME loans, Credit Score, Rectify Credit, Elite services, and Mutual Funds. ",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
          ),
          SvgPicture.asset(
            ImageAsset.logo_white,
            height: 140,
            width: 140,
          ),
        ],
      ),
    );
  }

  _getCashEasyWidget(DashboardViewModel model) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.smallMargin, vertical: Spacing.mediumMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.mediumMargin,
                  vertical: Spacing.smallMargin),
              child: RichText(
                text: TextSpan(
                    text: "Getting Cash is Easy With ",
                    style: TextStyle(
                        color: AppColors.blackGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(
                        text: "MoneyPros",
                        style: TextStyle(
                            color: AppColors.blackGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
              )),
          SizedBox(
            height: 10,
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                //crossAxisSpacing: 8,
                //mainAxisSpacing: 8,
                childAspectRatio: (itemWidth / 230)),
            itemCount: model.easyCashList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              EasyCashData data = model.easyCashList[index];
              return Hero(
                tag: "cash$index",
                child: EasyCashTile(
                  data: data,
                  onTap: () {
                    model.validationOnCreditScore();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _getTestimonials(DashboardViewModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.smallMargin, vertical: Spacing.mediumMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: Spacing.mediumMargin),
            child: Text(
              "Testimonials",
              style: TextStyle(
                  color: AppColors.blackGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 330,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: model.userRepo.dashboardData.testimonial.length,
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final data = model.userRepo.dashboardData.testimonial[index];
                return Hero(
                  tag: "test$index",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Neumorphic(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 4),
                            style: NeumorphicStyle(
                              intensity: 0.3,
                              color: Colors.transparent,
                              border: NeumorphicBorder(
                                  isEnabled: true, color: AppColors.grey300),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12)),
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: Spacing.bigMargin,
                                horizontal: Spacing.bigMargin),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackGrey)),
                                SizedBox(height: 5),
                                SvgPicture.network(
                                  data.starImg,
                                  //width:60,
                                  height: 8,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.maxFinite,
                                  //height: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data.desc,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 14,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.blackGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepo>(context, listen: false);
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      onModelReady: (DashboardViewModel model) {
        model.initData(userRepo);
        model.setEasyData();
        model.setTrandingData();
      },
      builder: (_, model, child) => 
      (model.loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (model.hasError)
              ? AppErrorWidget(
                  message: SOMETHING_WRONG_TEXT,
                  onRetryCliked: () {
                    model.fetchDashboardData();
                  })
              : Container(
                  child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCarousel(
                        true,
                        height: 240,
                        bannerList: userRepo.dashboardData.banner
                            .map((e) => e.bannerImg)
                            .toList(),
                        margin: const EdgeInsets.symmetric(
                            horizontal: Spacing.mediumMargin,
                            vertical: Spacing.mediumMargin),
                        onPageChanged: (index, reason) {
                          model.updatePosition(index);
                        },
                      ),
                      _getSliderIndicator(model),
                      _getOverViewWidget(model),
                      _getAboutUsWidget(model),
                      _getCashEasyWidget(model),
                      _getTestimonials(model),
                    ],
                  ),
                )),
    );
  }
}

class EasyCashTile extends StatelessWidget {
  const EasyCashTile({
    Key key,
    @required this.data,
    this.onTap,
  }) : super(key: key);

  final EasyCashData data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      style: NeumorphicStyle(
        intensity: 0.3,
        color: AppColors.blueExtraLight,
        border: NeumorphicBorder(isEnabled: true, color: AppColors.grey300),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(data.image, height: 18, width: 18),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${data.title}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.blackGrey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${data.desc}",
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8, color: AppColors.blackGrey),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Apply Now >",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 7, color: AppColors.blue),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoanTile extends StatelessWidget {
  const LoanTile({
    Key key,
    this.onTap,
    this.title,
    this.image,
    this.desc,
  }) : super(key: key);

  final onTap;
  final String title;
  final String image;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        style: NeumorphicStyle(
          intensity: 0.3,
          color: AppColors.white,
          border: NeumorphicBorder(isEnabled: true, color: AppColors.grey300),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                image,
                height: 32,
                width: 32,
              ),
              // Icon(Icons.ac_unit_sharp, size: 32, color: AppColors.green),
              SizedBox(height: 10),
              Text(
                "$title",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.blackGrey),
              )
            ],
          )),
        ),
      ),
    );
  }
}
