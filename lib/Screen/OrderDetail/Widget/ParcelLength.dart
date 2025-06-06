import 'package:flutter/material.dart';
import '../../../../../../Helper/Color.dart';
import '../../../../../../Helper/Constant.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../../../Widget/validation.dart';

class ParcelLength extends StatelessWidget {
  String lengthC;
  Function update;

  ParcelLength({Key? key, required this.lengthC, required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              getTranslated(context, "Length (kg)")!,
              style: const TextStyle(
                fontSize: textFontSize16,
                color: black,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
          Expanded(
              child: Container(
            width: width * 0.4,
            height: height * 0.06,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              validator: (val) => StringValidation.validateField(val, context),
              keyboardType: TextInputType.number,
              initialValue: lengthC.toString(),
              style: const TextStyle(
                color: black,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (String? value) {
                lengthC = value!;
                update(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor:  grey2,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: grey2),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: lightWhite),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
