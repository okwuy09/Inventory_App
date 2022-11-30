import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/event/add_event_page.dart';
import 'package:viicsoft_inventory_app/ui/event/all_event.dart';
import 'package:viicsoft_inventory_app/ui/event/future_event.dart';
import 'package:viicsoft_inventory_app/ui/event/past_event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EventsPage> createState() => _ItemsPageState();
}

late final List<Event> eventsList;
late Future futureEvent;

// setColor(int tabIndex) {
//   if (tabIndex == 0) {
//     return const Color(0xFFFBD59E);
//   } else if (tabIndex == 1) {
//     return const Color(0xFFC8E0DA);
//   } else if (tabIndex == 2) {
//     return Colors.yellow;
//   }
// }

class _ItemsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var priority = Provider.of<UserData>(context).userData.rolesPriority;
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColor.homePageColor,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: screensize.height * 0.12,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            bottom: TabBar(
              // onTap: (index) {
              //   setState(() {
              //     tabIndex = index;
              //     setInactiveColor(index);
              //   });
              // },
              labelStyle: style.copyWith(
                color: AppColor.white,
                fontSize: 12,
              ),
              unselectedLabelColor: AppColor.primaryColor,
              padding: const EdgeInsets.only(
                  left: 20, right: 10, bottom: 20, top: 10),
              indicator: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              labelPadding: const EdgeInsets.only(right: 5, left: 5),
              labelColor: AppColor.white,
              tabs: const [
                Tab(
                  text: 'ALL EVENTS',
                ),
                Tab(
                  text: 'FUTURE EVENTS',
                ),
                Tab(
                  text: 'PAST EVENTS',
                ),
              ],
            ),
            title: Row(
              children: [
                Text(
                  'Events',
                  style: style.copyWith(fontSize: 24),
                ),
                Expanded(child: Container()),
                priority == 'admin'
                    ? TextButton(
                        child: Row(children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColor.primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Create Event',
                            style: style.copyWith(fontSize: 14),
                          )
                        ]),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddEventPage(),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          body: const TabBarView(
            children: [AllEvent(), FutureEventPage(), PastEvent()],
          ),
        ),
      ),
    );
  }
}
