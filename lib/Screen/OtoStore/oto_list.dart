import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/otoStore/otoStoreModel.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';

import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/validation.dart';
import '../../bloc/OtoStore/otostore_bloc.dart';
import '../../bloc/OtoStore/otostore_event.dart';
import '../../bloc/OtoStore/otostore_state.dart';
import '../AddPickUpLocation/Widget/getCommanInputTextFieldWidget.dart';

class OtoStore extends StatefulWidget {
  const OtoStore({super.key, required bool fromNavbar});

  @override
  State<OtoStore> createState() => _OtoStoreState();
}

class _OtoStoreState extends State<OtoStore> {
  bool isNetworkAvail = true;
  String warehouseCity = "";
  TextEditingController storeNameController = TextEditingController();
  TextEditingController warehouseCityController = TextEditingController();
  TextEditingController warehouseCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    print("wewae ${context.read<SettingProvider>().currentUerID}");
    BlocProvider.of<OtoStoreBloc>(context).add(
        OtoStoreLists(int.parse(context.read<SettingProvider>().currentUerID)));
  }

  setStateNoInternate() async {
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
        } else {
          if (mounted) setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightWhite,
        floatingActionButton: SizedBox(
          height: 40.0,
          width: 40.0,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: newPrimary,
              child: const Icon(
                Icons.add,
                size: 32,
                color: white,
              ),
              onPressed: () => _openCreateOtoManagement(context),
              // final value = await Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => const AddProduct(),
              //   ),
              // );
              //refresh the page if user adds a product
              // if (value != null && value) {
              //   Future.delayed(Duration.zero, () {
              //     _refresh();
              //   });
              // }
              // },
            ),
          ),
        ),
        //refresh the page if user edits a product
        body: isNetworkAvail
            ? Column(
                children: [
                  GradientAppBar(
                    getTranslated(context, "Otostore")!,
                  ),
                  _otoStoreBloc(),
                ],
              )
            : Text("No internet"));
  }

  void _openCreateOtoManagement(BuildContext context) {
    warehouseCityController = TextEditingController(text: warehouseCity);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // optional rounded corners
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // to allow full-screen or keyboard push
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(getTranslated(context, 'oto Manangement')!,
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Row(
                children: [
                  getPrimaryCommanText(
                      getTranslated(context, "Store Name")!, false),
                  const Text(
                    " *",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              getTextFields(storeNameController, false),
              SizedBox(height: 20),
              Row(
                children: [
                  getPrimaryCommanText(
                      getTranslated(context, "Warehouse City")!, false),
                  const Text(
                    " *",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              getTextFields(warehouseCityController, true),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  getPrimaryCommanText(
                    getTranslated(context, "Warehouse Code")!,
                    false,
                  ),
                  const Text(
                    " *",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              Text(
                getTranslated(context,
                    "Enter the warehouse code provided by the admin. If you haven't received one, please contact the admin")!,
                style: const TextStyle(
                  fontSize: textFontSize16,
                  color: grey,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 5,
              ),
              SizedBox(
                height: 5,
              ),
              getTextFields(warehouseCodeController, false),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (warehouseCodeController.text.isNotEmpty &&
                          storeNameController.text.isNotEmpty) {
                        OtoStoreModel oto = OtoStoreModel(
                            warehouseCode:
                                int.parse(warehouseCodeController.text),
                            warehouseCity: warehouseCity,
                            storeName: storeNameController.text,
                            sellerId:
                                context.read<SettingProvider>().currentUerID);
                        context.read<OtoStoreBloc>().add(AddOtoStore(oto));
                      } else {
                        setSnackbar(
                            getTranslated(
                                context, "please fill the required fields")!,
                            context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Button shape
                      ),
                      elevation: 0, // Optional: no shadow
                      backgroundColor: Colors
                          .transparent, // Make transparent to see gradient
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [grad1Color, grad2Color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 1],
                          tileMode: TileMode.clamp,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        child: Text(
                          'Add Store',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _otoStoreBloc() {
    return Expanded(
      child: BlocBuilder<OtoStoreBloc, OtoStoreState>(
        builder: (context, state) {
          print("State: $state");

          if (state is OtoStoreLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OtoStoreCreateError) {
            setSnackbar(state.errorMessage, context);
            context.read<OtoStoreBloc>().add(OtoStoreLists(
                int.parse(context.read<SettingProvider>().currentUerID)));
          }
          if (state is OtoStoreCreateSuccess) {
            Navigator.pop(context);
            context.read<OtoStoreBloc>().add(OtoStoreLists(
                int.parse(context.read<SettingProvider>().currentUerID)));
          } else if (state is OtoStorePaginated) {
            // If the list is empty, show a message
            if (state.oto.isEmpty) {
              return const Center(
                child: Text(
                  "No items found",
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              );
            }

            // Show Meeting list with pagination
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                // Check if the user has scrolled to the end and load more Meeting if needed
                if (!state.hasReachedMax &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                  context
                      .read<OtoStoreBloc>()
                      .add(LoadMoreOtoStore("searchWord"));
                }
                return false;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.hasReachedMax
                    ? state.oto.length
                    : state.oto.length + 1,
                itemBuilder: (context, index) {
                  print(
                      "Building item at index: $index, total items: ${state.oto.length}");

                  if (index < state.oto.length) {
                    var oto = state.oto[index];
                    warehouseCity = oto.warehouseCity!;
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                        left: 15.0,
                        top: 13,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: blarColor,
                                offset: Offset(0, 0),
                                blurRadius: 4,
                                spreadRadius: 0),
                          ],
                          color: white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(circularBorderRadius10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: 12.0,
                            start: 12.0,
                            end: 12.0,
                            bottom: 5.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              oto.storeLogo!= "" ?  Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(oto.storeLogo!),
                                    fit: BoxFit
                                        .cover, // or BoxFit.fill, BoxFit.contain, etc.
                                  ),
                                ),
                              ):Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                 color: Colors.grey.withValues(alpha: 0.4)
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    itemRow("#", oto.id),
                                    itemRow(
                                        getTranslated(context, 'Company Id'),
                                        oto.companyId),
                                    itemRow(
                                        getTranslated(context, 'Store Name'),
                                        oto.storeName),
                                    itemRow(getTranslated(context, 'Store Id'),
                                        oto.storeId),
                                    itemRow(
                                        getTranslated(
                                            context, 'Warehouse Name'),
                                        oto.warehouseName),
                                    itemRow(
                                        getTranslated(
                                            context, 'Warehouse City'),
                                        oto.warehouseCity),
                                    itemRow(
                                        getTranslated(context, 'Warehouse Id'),
                                        oto.warehouseId),
                                    itemRow(getTranslated(context, 'Date'),
                                        oto.createdAt),
                                  ],
                                ),
                              )
                              // Add more fields from your oto object as needed
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Loading indicator at the end of the list
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Center(
                        child: !state.hasReachedMax
                            ? const Text('')
                            : CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            );
          } else if (state is OtoStoreError) {
            // Show error message
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(
            child: Text(
              "No data available",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  itemRow(label, value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            color: black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 3,
          child: Text(
            value?.isNotEmpty == true ? value! : "-", // fallback value
            style: const TextStyle(
              color: lightBlack,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  getTextFields(controller, readOnly) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey.withValues(alpha: 0.4) : grey1,
        borderRadius: BorderRadius.circular(circularBorderRadius10),
        border: Border.all(
          color: grey,
          width: 2,
        ),
      ),
      width: double.infinity,
      height: 46,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: TextFormField(
          onFieldSubmitted: (v) {},
          readOnly: readOnly ? true : false,
          textInputAction: TextInputAction.newline,
          style: const TextStyle(
            color: black,
            fontWeight: FontWeight.normal,
          ),
          controller: controller,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          validator: (val) => () {}(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: textFontSize14,
            ),
            hintText: title,
          ),
          // minLines: null,
          // maxLines: 2,
          expands: false,
        ),
      ),
    );
  }
}
