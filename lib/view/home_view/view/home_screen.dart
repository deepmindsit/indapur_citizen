import 'package:indapur_citizen/config/exported_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = getIt<HomeController>();
  final _languageController = getIt<LanguageController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.isSearch.value = false;
      controller.getHome();
      checkLocationAccess();
    });

    // UpdateController().checkForUpdate();
    FirebaseTokenController().updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      autoAlign: true,
      floatingWidget: Container(),
      floatingWidgetWidth: Get.height * 0.1,
      floatingWidgetHeight: Get.height * 0.07,
      mainScreenWidget: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        drawer: SafeArea(child: DrawerWidget()),
        body: Obx(() {
          if (controller.isMainLoading.value) {
            return LoadingWidget(color: primaryBlack);
          } else if (controller.isSearch.value) {
            return searchView();
          } else {
            return _buildHomeContent();
          }
        }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Image.asset(Images.logo, width: Get.width * 0.6),
      actions: [
        _buildLanguageToggle(),
        _buildNotificationButton(),
        _buildSearchIcon(),
      ],
    );
  }

  Widget _buildSearchIcon() => Padding(
    padding: EdgeInsets.only(right: 12),
    child: GestureDetector(
      onTap: () => controller.isSearch.toggle(),
      child: const HugeIcon(icon: HugeIcons.strokeRoundedSearch01, size: 20),
    ),
  );

  Widget _buildNotificationButton() => IconButton(
    padding: EdgeInsets.symmetric(horizontal: 4),
    icon: const HugeIcon(icon: HugeIcons.strokeRoundedNotification02, size: 20),
    onPressed: () => Get.to(() => const NotificationList()),
  );

  Widget _buildLanguageToggle() {
    return GestureDetector(
      onTap: () async {
        _languageController.toggleLanguage();
        await controller.getHome();
      },
      child: Image.asset(
        _languageController.isEnglish.value
            ? 'assets/images/translation_english_marathi.png'
            : 'assets/images/translation_marathi_english.png',
        color: Colors.black,
        width: Get.width * 0.04,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      color: Colors.grey.shade50,
      child: CustomScrollView(
        slivers: <Widget>[
          _buildSlider(),
          _buildLastComplaintHeadline(),
          SliverToBoxAdapter(
            child: controller.complaintList.isNotEmpty
                ? lastComplaint()
                : const SizedBox(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDivider(),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Departments'.tr),
                  ),
                  _buildDivider(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Text('complaint_line'.tr, textAlign: TextAlign.center),
          ),
          departmentSection(),
          _buildImportantLinksSection(),
          importantLink(),
        ],
      ),
    );
  }

  Widget _buildLastComplaintHeadline() {
    return SliverToBoxAdapter(
      child: controller.complaintList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width * 0.3,
                    height: Get.height * 0.002,
                    color: Color(0xFFE0E0E0),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    alignment: Alignment.center,
                    child: Text(
                      'Recent Complaint'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.3,
                    height: Get.height * 0.002,
                    color: Color(0xFFE0E0E0),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  Widget importantLink() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return GestureDetector(
            onTap: () {
              if (controller.linksList[index]['url'] != null) {
                launchInBrowser(Uri.parse(controller.linksList[index]['url']));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  controller.linksList[index]['image'],
                  height: Get.height * 0.07,
                ),
                Text(
                  controller.linksList[index]['name'] ?? '',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(height: 1, fontSize: Get.width * 0.035),
                ),
              ],
            ),
          );
        }, childCount: controller.linksList.length),
      ),
    );
  }

  Widget _buildImportantLinksSection() {
    return SliverToBoxAdapter(child: _buildSectionTitle('Important Links'.tr));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDivider(),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(title.tr),
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
    width: Get.width * 0.3,
    height: Get.height * 0.001,
    color: primaryGrey,
  );

  Widget departmentSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      sliver: Obx(
        () => AnimationLimiter(
          child: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: controller.departmentList.length,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: DepartmentTile(
                      onTap: () {
                        Get.to(
                          () => ComplaintForm(
                            deptId: controller.departmentList[index]['id']
                                .toString(),
                            deptName: controller.departmentList[index]['name'].toString(),
                          ),
                        );
                      },
                      isLink: false,
                      department: controller.departmentList[index]['id']
                          .toString(),
                      image: controller.departmentList[index]['image'],
                      dept: controller.departmentList[index]['name'],
                    ),
                  ),
                ),
              );
            }, childCount: controller.departmentList.length),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: SliverAppBarDelegate(
        minHeight: Get.height * 0.25,
        maxHeight: Get.height * 0.25,
        child: carouselContainer(),
      ),
    );
  }

  Widget carouselContainer() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimationLimiter(
        child: ListView(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(child: widget),
            ),
            children: [const SizedBox(height: 10), carouselSliderWidget()],
          ),
        ),
      ),
    );
  }

  Widget searchView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          searchTextField(),
          SizedBox(height: Get.height * 0.02),
          Expanded(child: searchResult()),
        ],
      ),
    );
  }

  Widget searchResult() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of items in each row
        mainAxisSpacing: 8.0, // spacing between rows
        crossAxisSpacing: 8.0, // spacing between columns
      ),
      itemCount: controller.filteredDataList.length,
      itemBuilder: (context, index) {
        return DepartmentTile(
          onTap: () {
            Get.to(
              () => ComplaintForm(
                deptId: controller.departmentList[index]['id'].toString(),
                deptName: controller.departmentList[index]['name'].toString(),
              ),
            );
          },
          isLink: false,
          department: controller.filteredDataList[index]['id'].toString(),
          image: controller.filteredDataList[index]['image'],
          dept: controller.filteredDataList[index]['name'],
        );
      },
    );
  }

  Widget searchTextField() {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.filterData,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            // setState(() {
            controller.searchController.clear();
            controller.filteredDataList.clear();
            controller.isSearch.value = false;
            // });
          },
          child: const Icon(Icons.cancel_rounded, color: Colors.red),
        ),
        hintText: 'Search...'.tr,
        border: InputBorder.none,
      ),
    );
  }

  Widget howToUseButton() {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: Colors.transparent,
      onPressed: () {
        Get.dialog(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: Get.width * 0.9,
                      height: Get.height * 0.7,
                      color: Colors.white,
                      child: Center(
                        child: YoutubeUrlWidget(
                          videoUrl: controller.videoUrl.isEmpty
                              ? ''
                              : controller.videoUrl.value,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 16,
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Image.asset('assets/images/how_to_use.png'),
    );
  }

  Widget lastComplaint() {
    final complaint = controller.complaintList[0];
    final int statusColor =
        int.tryParse(complaint['status_color'] ?? '0xFF000000') ?? 0xFF000000;
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ComplaintSummary(
            isList: true,
            complaintId: complaint['id'].toString(),
          ),
        );
      },
      child: ComplaintCard(
        title: complaint['department'] ?? 'N/A',
        location: complaint['complaint_type']?.toString() ?? 'N/A',
        date: complaint['created_on_date'] ?? 'N/A',
        status: complaint['status'] ?? 'N/A',
        statusColor: statusColor.toString(),
        ticketNo: complaint['code'] ?? '',
        deptImg: complaint['department_image'],
      ),
    );
  }

  Widget carouselSliderWidget() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 15 / 7,
        autoPlay: true,
        viewportFraction: 0.9,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        pauseAutoPlayOnTouch: true,
      ),
      items: controller.sliderList
          .map(
            (item) => GestureDetector(
              onTap: () async {
                final uri = Uri.tryParse(item['url'] ?? '');
                if (uri != null) {
                  await launchInBrowser(uri);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: AssetImage(Images.defaultSlider),
                  imageErrorBuilder: (_, __, ___) =>
                      Image.asset(Images.defaultSlider),
                  image: NetworkImage(item['image']),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
