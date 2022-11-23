// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/models/pastevent.dart';

class PastEventDetailPage extends StatefulWidget {
  EventsPast pastEvent;
  PastEventDetailPage({
    Key? key,
    required this.pastEvent,
  }) : super(key: key);

  @override
  State<PastEventDetailPage> createState() => _PastEventDetailPageState();
}

class _PastEventDetailPageState extends State<PastEventDetailPage> {
  //XFile? _itemimage;
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 30),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 25,
                    color: AppColor.iconBlack,
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.pastEvent.eventName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: screenSize * 0.21,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(widget.pastEvent.eventImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize * 0.08),
                        Row(
                          children: [
                            Text(
                              'Event Name:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.homePageTitle,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              widget.pastEvent.eventName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenSize * 0.06),
                        Row(
                          children: [
                            Text(
                              'Event Type:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.homePageTitle,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              widget.pastEvent.eventType,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize * 0.06),
                        Row(
                          children: [
                            Text(
                              'Event Starting Date:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.homePageTitle,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              '${widget.pastEvent.checkOutDate.day}-${widget.pastEvent.checkOutDate.month}-${widget.pastEvent.checkOutDate.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize * 0.06),
                        Row(
                          children: [
                            Text(
                              'Event Ending Date:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.homePageTitle,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              '${widget.pastEvent.checkInDate.day}-${widget.pastEvent.checkInDate.month}-${widget.pastEvent.checkInDate.year}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenSize * 0.06),
                        Row(
                          children: [
                            Text(
                              'Event Location:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.homePageTitle,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              widget.pastEvent.eventLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize * 0.06),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_circle_left, color: AppColor.red),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                      fontSize: 20, color: AppColor.red),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
