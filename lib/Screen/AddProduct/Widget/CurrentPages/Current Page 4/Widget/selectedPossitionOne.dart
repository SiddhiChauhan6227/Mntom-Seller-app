
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../../../../../Helper/Color.dart';
import '../../../../../../Helper/Constant.dart';
import '../../../../../../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../../../../../../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../../../../../../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../../../../../../Model/ProductModel/Variants.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../../../Widget/FilterChips.dart';
import '../../../../../../Widget/desing.dart';
import '../../../../../../Widget/snackbar.dart';
import '../../../../../../Widget/validation.dart';
import '../../../../Add_Product.dart';
import '../../../getCommanWidget.dart';

int max = 0;
int col = 0;

Widget selectionPossitionOne(BuildContext context, Function setState) {
  return addProvider!.curSelPos == 1 &&
      (addProvider!.digitalProductSaveSettings ||
          addProvider!.simpleProductSaveSettings ||
          addProvider!.variantProductVariableLevelSaveSettings ||
          addProvider!.variantProductProductLevelSaveSettings)
      ? Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      getCommanSizedBox(),
      getCommanSizedBox(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              getPrimaryCommanText(
                  getTranslated(context, "Attributes")!, false),
              SizedBox(width: 8),
              Tooltip(
                message: getTranslated(context, "attributetooltip")!,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                child: Icon(Icons.info_outline, size: 20),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  print(
                      'Add Attribute clicked: attributeIndiacator = ${addProvider!.attributeIndiacator}, attrController.length = ${addProvider!.attrController.length}');
                  if (addProvider!.attributeIndiacator ==
                      addProvider!.attrController.length) {
                    addProvider!.attrController.add(TextEditingController());
                    addProvider!.attrValController.add(TextEditingController());
                    addProvider!.variationBoolList.add(false);
                    print(
                        'Added new attribute: attrController.length = ${addProvider!.attrController.length}');
                    setState(() {});
                  } else {
                    setSnackbar(
                      getTranslated(context, "fill the box then add another")!,
                      context,
                    );
                  }
                },
                child: Text(
                  getTranslated(context, "Add Attribute")!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  addProvider!.tempAttList.clear();
                  List<String> attributeIds = [];
                  for (var i = 0; i < addProvider!.variationBoolList.length; i++) {
                    if (addProvider!.variationBoolList[i]) {
                      final attributes = addProvider!.attributesList
                          .where((element) =>
                      element.name == addProvider!.attrController[i].text)
                          .toList();
                      if (attributes.isNotEmpty) {
                        attributeIds.add(attributes.first.id!);
                      }
                    }
                  }
                  addProvider!.resultAttr = [];
                  addProvider!.resultID = [];
                  addProvider!.variationList = [];
                  addProvider!.finalAttList = [];
                  for (var key in attributeIds) {
                    addProvider!.tempAttList
                        .add(addProvider!.selectedAttributeValues[key]!);
                  }
                  for (int i = 0; i < addProvider!.tempAttList.length; i++) {
                    addProvider!.finalAttList.add(addProvider!.tempAttList[i]);
                  }
                  if (addProvider!.finalAttList.isNotEmpty) {
                    max = addProvider!.finalAttList.length - 1;
                    getCombination([], [], 0);
                    addProvider!.row = 1;
                    col = max + 1;
                    for (int i = 0; i < col; i++) {
                      int singleRow = addProvider!.finalAttList[i].length;
                      addProvider!.row = addProvider!.row * singleRow;
                    }
                  }
                  setSnackbar(
                    getTranslated(context, "Attributes saved successfully")!,
                    context,
                  );
                  setState(() {});
                },
                child: Text(
                  getTranslated(context, "Save Attribute")!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
      getCommanSizedBox(),
      addProvider!.productType == 'variable_product'
          ? Text(
        getTranslated(
          context,
          "Note : select checkbox if the attribute is to be used for variation",
        )!,
      )
          : Container(),
      getCommanSizedBox(),
      for (int i = 0; i < addProvider!.attrController.length; i++)
        addAttribute(i, context, setState),
    ],
  )
      : Container();
}

void deleteAttribute(int index, Function setState) {
  final attributeName = addProvider!.attrController[index].text;
  final result = addProvider!.attributesList
      .where((element) => element.name == attributeName)
      .toList();
  final attributeId = result.isEmpty ? null : result.first.id;

  setState(() {
    addProvider!.attrController.removeAt(index);
    addProvider!.attrValController.removeAt(index);
    addProvider!.variationBoolList.removeAt(index);

    // Remove the corresponding attrId if it exists
    if (index < addProvider!.attrId.length) {
      addProvider!.attrId.removeAt(index);
      print('Removed attrId at index $index. New attrId list: ${addProvider!.attrId}');
    }

    // Remove selected attribute values if attributeId exists
    if (attributeId != null) {
      addProvider!.selectedAttributeValues.remove(attributeId);
      print('Removed selectedAttributeValues for attributeId: $attributeId');
    }

    // Adjust attributeIndiacator properly
    if (addProvider!.attrController.isEmpty) {
      addProvider!.attributeIndiacator = 0;
      print('After deletion: List is empty, reset attributeIndiacator to 0');
    } else if (addProvider!.attributeIndiacator > index) {
      addProvider!.attributeIndiacator--;
      print(
          'After deletion: Decremented attributeIndiacator to ${addProvider!.attributeIndiacator}, attrController.length: ${addProvider!.attrController.length}');
    } else if (addProvider!.attributeIndiacator >= addProvider!.attrController.length) {
      addProvider!.attributeIndiacator = addProvider!.attrController.length - 1;
      print(
          'After deletion: Clamped attributeIndiacator to ${addProvider!.attributeIndiacator}, attrController.length: ${addProvider!.attrController.length}');
    }

    if (addProvider!.attributeIndiacator < 0) {
      addProvider!.attributeIndiacator = 0;
      print('After deletion: Ensured attributeIndiacator is not negative, set to 0');
    }
  });
}

Widget addAttribute(int pos, BuildContext context, Function setState) {
  final result = addProvider!.attributesList
      .where((element) => element.name == addProvider!.attrController[pos].text)
      .toList();
  final attributeId = result.isEmpty ? "" : result.first.id;
  return Card(
    color: grey1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(circularBorderRadius15),
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10,
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getPrimaryCommanText(getTranslated(context, "Select Attribute")!, true),
              Container(
                child: Row(
                  children: [
                    Checkbox(
                      value: addProvider!.variationBoolList[pos],
                      onChanged: (bool? value) {
                        addProvider!.variationBoolList[pos] = value ?? false;
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade500),
                      onPressed: () {
                        deleteAttribute(pos, setState);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          getCommanSizedBox(),
          TextFormField(
            textAlign: TextAlign.center,
            readOnly: true,
            onTap: () {
              attributeDialog(pos, context, setState);
            },
            controller: addProvider!.attrController[pos],
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
            ),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              // filled: true,
              // fillColor: fillColor,
              hintText: getTranslated(context, "Select Attributes")!,
              hintStyle: const TextStyle(
                color: primary,
                fontWeight: FontWeight.normal,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              prefixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 20),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(circularBorderRadius7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: lightWhite),
                borderRadius: BorderRadius.circular(circularBorderRadius8),
              ),
            ),
          ),
          getCommanSizedBox(),
          getCommanSizedBox(),
          GestureDetector(
            onTap: () {
              print("dfvgh $attributeId");
              if (attributeId!.isEmpty) {
                setSnackbar(
                  getTranslated(context, "Please select an attribute first")!,
                  context,
                );
                return;
              }
              final attributeValues = addProvider!.attributesValueList
                  .where((element) => element.attributeId == attributeId)
                  .toList();
              if (attributeValues.isEmpty) {
                setSnackbar(
                  getTranslated(context, "No attribute values available")!,
                  context,
                );
                return;
              }
              addValAttribute(
                addProvider!.selectedAttributeValues[attributeId] ?? [],
                attributeValues,
                attributeId,
                context,
                setState,
              );
            },
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circularBorderRadius7),
                // color: fillColor,
              ),
              constraints: const BoxConstraints(
                minHeight: 50,
              ),
              child: (addProvider!.selectedAttributeValues[attributeId] ?? []).isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    getTranslated(context, "Add attribute value")!,
                    style: const TextStyle(
                      color: primary,
                      fontSize: textFontSize16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
                  : Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: addProvider!.selectedAttributeValues[attributeId]!
                    .map(
                      (value) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(circularBorderRadius10),
                        color: primary_app,
                        border: Border.all(
                          color: Colors.transparent,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value.value!,
                          style: const TextStyle(
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
          getCommanSizedBox(),
        ],
      ),
    ),
  );
}

void getCombination(List<String> att, List<String> attId, int i) {
  for (int j = 0, l = addProvider!.finalAttList[i].length; j < l; j++) {
    List<String> a = [];
    List<String> aId = [];
    if (att.isNotEmpty) {
      a.addAll(att);
      aId.addAll(attId);
    }
    a.add(addProvider!.finalAttList[i][j].value!);
    aId.add(addProvider!.finalAttList[i][j].id!);
    if (i == max) {
      addProvider!.resultAttr.addAll(a);
      addProvider!.resultID.addAll(aId);
      Product_Varient model =
      Product_Varient(attr_name: a.join(","), id: aId.join(","));
      addProvider!.variationList.add(model);
    } else {
      getCombination(a, aId, i + 1);
    }
  }
}

Future<void> attributeDialog(int pos, BuildContext context, Function setState) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStater) {
              addProvider!.taxesState = setStater;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, "Select Attribute")!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: fontColor),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: lightBlack),
                      addProvider!.suggessionisNoData
                          ? DesignConfiguration.getNoItem(context)
                          : SizedBox(
                        width: double.maxFinite,
                        height: addProvider!.attributeSetList.isNotEmpty
                            ? MediaQuery.of(context).size.height * 0.3
                            : 0,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: addProvider!.attributeSetList.length,
                            itemBuilder: (context, index) {
                              List<AttributeModel> attrList = [];
                              AttributeSetModel item =
                              addProvider!.attributeSetList[index];
                              for (int i = 0;
                              i < addProvider!.attributesList.length;
                              i++) {
                                if (item.id ==
                                    addProvider!.attributesList[i].attributeSetId) {
                                  attrList.add(addProvider!.attributesList[i]);
                                }
                              }
                              return Material(
                                child: StickyHeaderBuilder(
                                  builder: (BuildContext context, double stuckAmount) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius:
                                          BorderRadius.circular(circularBorderRadius5)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        addProvider!.attributeSetList[index].name ?? '',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List<int>.generate(attrList.length, (i) => i).map(
                                          (item) {
                                        return InkWell(
                                          onTap: () {
                                            print(
                                                'Attribute selected at pos $pos: attributeIndiacator = ${addProvider!.attributeIndiacator}, attrController.length = ${addProvider!.attrController.length}');
                                            final selectedAttrId =
                                            int.parse(attrList[item].id!);
                                            final selectedAttrName = attrList[item].name!;
                                            bool isDuplicate = addProvider!.attrController
                                                .asMap()
                                                .entries
                                                .any((entry) =>
                                            entry.key != pos &&
                                                entry.value.text == selectedAttrName);
                                            if (isDuplicate) {
                                              setSnackbar(
                                                  getTranslated(
                                                      context, "Already inserted..")!,
                                                  context);
                                              Navigator.pop(context);
                                              return;
                                            }
                                            if (pos < addProvider!.attrId.length) {
                                              addProvider!.attrId[pos] = selectedAttrId;
                                            } else {
                                              addProvider!.attrId.add(selectedAttrId);
                                            }
                                            setState(() {
                                              addProvider!.attrController[pos].text =
                                                  selectedAttrName;
                                              addProvider!.attributeIndiacator = pos + 1;
                                              print(
                                                  'After selection: attributeIndiacator set to ${addProvider!.attributeIndiacator}, attrController.length = ${addProvider!.attrController.length}');
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  attrList[item].name ?? '',
                                                  textAlign: TextAlign.start,
                                                ),
                                                Spacer(),
                                                if (addProvider!.attrId
                                                    .contains(int.parse(attrList[item].id!)))
                                                  Icon(Icons.check),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void addValAttribute(
    List<AttributeValueModel> selected,
    List<AttributeValueModel> searchRange,
    String attributeId,
    BuildContext context,
    Function update,
    ) {
  addProvider!.selectedAttributeValues.putIfAbsent(attributeId, () => []);
  showModalBottomSheet<List<AttributeValueModel>>(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(circularBorderRadius10),
        topRight: Radius.circular(circularBorderRadius10),
      ),
    ),
    enableDrag: true,
    context: context,
    builder: (context) {
      return SizedBox(
        height: 240,
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranslated(context, "Select Attribute Value")!,
                          style: const TextStyle(
                            fontSize: textFontSize16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return filterChipWidget(
                    chipName: searchRange[index],
                    selectedList: selected,
                    update: update,
                    fromAdd: true,
                  );
                },
                childCount: searchRange.length,
              ),
            ),
          ],
        ),
      );
    },
  );
}