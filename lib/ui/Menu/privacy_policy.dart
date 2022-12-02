import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 50),
        child: Column(children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.black,
                ),
              ),
              SizedBox(width: screensize.width / 5),
              Text(
                'Privacy Policy',
                style: style.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screensize.height * 0.05),
          RichText(
            text: TextSpan(
              text:
                  'Thank you for choosing to be part of our community at Crisptv. We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us at ',
              style: style.copyWith(
                fontSize: 15,
                color: AppColor.black.withOpacity(0.8),
                fontWeight: FontWeight.normal,
                //letterSpacing: 0.3,
              ),
              children: [
                TextSpan(
                  text: 'crisptvent@gmail.com.',
                  style: style.copyWith(color: AppColor.homePageTotalEquip),
                ),

                //
                TextSpan(
                  text:
                      ' This privacy notice applies to all information collected through our Services (which, as described above, includes our Website), as well as, any related services, sales, marketing or events. ',
                  style: style.copyWith(
                    fontSize: 15,
                    color: AppColor.black.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    //letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'We collect personal information that you voluntarily provide to us when you register on the App, express an interest in obtaining information about us or our products and Services, when you participate in activities on the Application or otherwise when you contact us.',
          ),
          const SizedBox(height: 10),
          const Text(
            'Based on the applicable laws of your country, you may have the right to request access to the personal information we collect from you, change that information, or delete it in some circumstances. To request to review, update, or delete your personal information, please do so by contacting us using the information listed above.',
          )
        ]),
      ),
    );
  }
}
