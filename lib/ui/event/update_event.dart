import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/datefield.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';

class UpdateEventPage extends StatefulWidget {
  final Event eventDetail;
  const UpdateEventPage({Key? key, required this.eventDetail})
      : super(key: key);

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  // ignore: unused_field
  XFile? _eventImage;
  //DateTime? selecteddate;
  TextEditingController? eventName;
  TextEditingController? eventType;
  TextEditingController? eventLocation;
  DateTime? endingDate;
  DateTime? startingDate;

  bool hasData = false;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 700, maxWidth: 650);

    setState(() {
      _eventImage = pickedFile;
    });
  }

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    endingDate = widget.eventDetail
        .checkInDate; //DateTime.parse('${widget.eventDetail.checkInDate}');
    startingDate = widget.eventDetail
        .checkOutDate; // DateTime.parse('${widget.eventDetail.checkOutDate}');
    eventName = TextEditingController(text: widget.eventDetail.eventName);
    eventType = TextEditingController(text: widget.eventDetail.eventType);
    eventLocation =
        TextEditingController(text: widget.eventDetail.eventLocation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<AppData>(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 30),
            width: screenSize.width,
            height: 110,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: screenSize.width * 0.06,
                        color: AppColor.iconBlack,
                      ),
                    ),
                    const SizedBox(width: 26),
                    Text(
                      widget.eventDetail.eventName,
                      style: style,
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              width: screenSize.width,
              decoration: BoxDecoration(
                color: AppColor.homePageColor,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenSize.width * 0.03),
                      child: ListView(
                        children: [
                          Text(
                            'Event name',
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          MyTextForm(
                            controller: eventName,
                            obscureText: false,
                            labelText: widget.eventDetail.eventName,
                          ),
                          SizedBox(height: screenSize.width * 0.02),
                          //
                          Text(
                            'Event type',
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          MyTextForm(
                            controller: eventType,
                            obscureText: false,
                            labelText: widget.eventDetail.eventType,
                          ),
                          SizedBox(height: screenSize.width * 0.02),
                          //
                          Text(
                            'Event location',
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          MyTextForm(
                            controller: eventLocation,
                            obscureText: false,
                            labelText: widget.eventDetail.eventLocation,
                          ),
                          SizedBox(height: screenSize.width * 0.02),
                          //
                          Text(
                            'Event starting date',
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          DateField(
                            pickedDate:
                                '${startingDate!.day} ${months[startingDate!.month - 1]}, ${startingDate!.year}',
                            onPressed: () => _startingDate(context),
                          ),
                          SizedBox(height: screenSize.width * 0.02),

                          // ending date
                          Text(
                            'Event ending date',
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          DateField(
                            pickedDate:
                                '${endingDate!.day}  ${months[endingDate!.month - 1]}, ${endingDate!.year}',
                            onPressed: () => _endingDate(context),
                          ),

                          SizedBox(height: screenSize.width * 0.27),
                          MainButton(
                            borderColor: Colors.transparent,
                            child: provider.isUpdatingEvent
                                ? buttonCircularIndicator
                                : Text(
                                    'UPDATE EVENT',
                                    style: style.copyWith(
                                      fontSize: 14,
                                      color: AppColor.buttonText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            backgroundColor: AppColor.primaryColor,
                            onTap: () async {
                              await provider.updateEvent(
                                context: context,
                                eventName: eventName!.text,
                                eventLocation: eventLocation!.text,
                                eventType: eventType!.text,
                                checkInDate: endingDate!,
                                checkOutDate: startingDate!,
                                eventId: widget.eventDetail.id,
                              );
                            },
                          ),
                        ],
                      ),
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

  _startingDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: startingDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != startingDate) {
      setState(() {
        startingDate = selected;
      });
    }
  }

  _endingDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: endingDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != endingDate) {
      setState(() {
        endingDate = selected;
      });
    }
  }
}
