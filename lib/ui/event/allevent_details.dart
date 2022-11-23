import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/models/events.dart';

class AllEventDetailPage extends StatefulWidget {
  final Event futureEvent;
  const AllEventDetailPage({
    Key? key,
    required this.futureEvent,
  }) : super(key: key);

  @override
  State<AllEventDetailPage> createState() => _AllEventDetailPageState();
}

class _AllEventDetailPageState extends State<AllEventDetailPage> {
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
                    widget.futureEvent.eventName,
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
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                          margin: const EdgeInsets.only(right: 30, left: 30),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: screenSize * 0.21,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image:
                                  NetworkImage(widget.futureEvent.eventImage),
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
                              widget.futureEvent.eventName,
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
                              widget.futureEvent.eventType,
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
                              '${widget.futureEvent.checkOutDate.day}-${widget.futureEvent.checkOutDate.month}-${widget.futureEvent.checkOutDate.year}',
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
                              '${widget.futureEvent.checkInDate.day}-${widget.futureEvent.checkInDate.month}-${widget.futureEvent.checkInDate.year}',
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
                              widget.futureEvent.eventLocation,
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
