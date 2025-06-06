import 'package:flutter/material.dart';
import 'package:sellermultivendor/Screen/FAQ/faq.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/validation.dart';

class GetMediaWidget extends StatefulWidget {
  int index;
  String id;
  Function update;
  GetMediaWidget({
    Key? key,
    required this.index,
    required this.update,
    required this.id,
  }) : super(key: key);

  @override
  State<GetMediaWidget> createState() => _GetMediaWidgetState();
}

class _GetMediaWidgetState extends State<GetMediaWidget> {
  setStateNow() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          color: white,
          boxShadow: [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 15,
            left: 15,
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.radio_button_checked_outlined,
                color: primary,
                size: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              faqProvider!.tagList[widget.index].question!,
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "PlusJakartaSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Text(
                              faqProvider!.tagList[widget.index].answer!.isNotEmpty
                                  ? faqProvider!.tagList[widget.index].answer!
                                  : getTranslated(context, "No Answer Yet..!")!,
                              style: TextStyle(
                                color: black.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                                fontFamily: "PlusJakartaSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text(getTranslated(context, "Confirm Delete")!),
                                content: Text(getTranslated(context, "Are you sure you want to delete this answer?")!),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(), // cancel
                                    child: Text(getTranslated(context, "Cancel")!),
                                  ),
                                  TextButton(
                              onPressed: () async {
                              Navigator.of(dialogContext).pop();

                              try {
                              await faqProvider!.deleteTagsAPI(
                              faqProvider!.tagList[widget.index].id,
                              context,
                              update: widget.update,
                              productId: widget.id,
                              );

                              if (!mounted) return;

                              if (faqProvider!.tagList.isEmpty) {
                              faqProvider!.scrollGettingData = false;
                              faqProvider!.scrollLoadmore = false;
                              }

                              widget.update(); // parent setState
                              setState(() {}); // local update
                              } catch (error) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete: $error')),
                              );
                              }
                              }
,
                              // onPressed: () async {
                                    //   Navigator.of(dialogContext).pop();
                                    //
                                    //   try {
                                    //     // Delete from API with proper parameters
                                    //     await faqProvider!.deleteTagsAPI(
                                    //       faqProvider!.tagList[widget.index].id,
                                    //       context,
                                    //       update: widget.update,
                                    //       productId: widget.id,
                                    //     );
                                    //
                                    //     // Additional UI update to ensure refresh
                                    //     if (mounted) {
                                    //       widget.update();
                                    //       setState(() {});
                                    //     }
                                    //
                                    //   } catch (error) {
                                    //     ScaffoldMessenger.of(context).showSnackBar(
                                    //       SnackBar(content: Text('Failed to delete: $error')),
                                    //     );
                                    //   }
                                    // },
                                    child: Text(
                                      getTranslated(context, "Delete")!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          color: primary,
                          size: 20,
                        ),
                      ),

                      // InkWell(
                      //   onTap: () {
                      //     faqProvider!.deleteTagsAPI(
                      //       faqProvider!.tagList[index].id,
                      //       context,
                      //     );
                      //     faqProvider!.scrollGettingData=false;
                      //     Future.delayed(const Duration(seconds: 2)).then(
                      //       (_) async {
                      //         faqProvider!.scrollLoadmore = false;
                      //         faqProvider!.scrollOffset = 0;
                      //         faqProvider!.getFaQs(context, update, id);
                      //         update();
                      //       },
                      //     );
                      //   },
                      //   child: const Icon(
                      //     Icons.delete,
                      //     color: primary,
                      //     size: 20,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
