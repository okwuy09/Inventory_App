import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/datefield.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/component/success_button_sheet.dart';
import 'package:viicsoft_inventory_app/models/future_event.dart';
import 'package:viicsoft_inventory_app/services/apis/event_api.dart';

class UpdateEventPage extends StatefulWidget {
  final EventsFuture eventDetail;
  const UpdateEventPage({Key? key, required this.eventDetail})
      : super(key: key);

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  // ignore: unused_field
  XFile? _eventImage;
  //DateTime? selecteddate;

  DateTime? endingDate;
  DateTime? startingDate;

  bool hasData = false;

  final EventAPI _eventAPI = EventAPI();

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
    endingDate = DateTime.parse('${widget.eventDetail.checkInDate}');
    startingDate = DateTime.parse('${widget.eventDetail.checkOutDate}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    TextEditingController _eventName =
        TextEditingController(text: widget.eventDetail.eventName);
    TextEditingController _eventType =
        TextEditingController(text: widget.eventDetail.eventType);
    TextEditingController _eventLocation =
        TextEditingController(text: widget.eventDetail.eventLocation);
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
                            controller: _eventName,
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
                            controller: _eventType,
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
                            controller: _eventType,
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
                            child: Text(
                              'UPDATE EVENT',
                              style: style.copyWith(
                                fontSize: 14,
                                color: AppColor.buttonText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: AppColor.primaryColor,
                            onTap: () async {
                              if (startingDate == DateTime.now() &&
                                  endingDate == DateTime.now()) {
                                startingDate = widget.eventDetail.checkOutDate;
                                endingDate = widget.eventDetail.checkInDate;
                              }
                              var res = await _eventAPI.updateEvent(
                                _eventName.text,
                                _eventType.text,
                                _eventLocation.text,
                                endingDate.toString(),
                                startingDate.toString(),
                                widget.eventDetail.id,
                              );

                              if (res.statusCode == 200) {
                                successButtomSheet(
                                    context: context,
                                    buttonText: 'BACK TO EVENTS',
                                    title: ' Event Updated \n  Successfully!',
                                    onTap: () => Navigator.pop(context));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Something went wrong"),
                                  ),
                                );
                              }
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
    startingDate = widget.eventDetail.checkOutDate;
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
    endingDate = widget.eventDetail.checkInDate;
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: endingDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != endingDate) {
      setState(() {
        widget.eventDetail.checkInDate = endingDate!;
        endingDate = selected;
      });
    }
  }
}
