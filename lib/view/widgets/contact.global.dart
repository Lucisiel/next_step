import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactGlobal extends StatelessWidget {
  const ContactGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact us',
          style: TextStyle(
            color: GlobalConfigs.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Any problem here? you can contact to our customer service in the bottom of the description. Thank you!',
          style: TextStyle(
            color: GlobalConfigs.textColor,
            fontSize: GlobalConfigs.textBodySize,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  Uri instagramUrl =
                      Uri.parse('https://www.instagram.com/ferdinand_f.c/');
                  await canLaunchUrl(instagramUrl)
                      ? await launchUrl(
                          instagramUrl,
                          mode: LaunchMode.externalApplication,
                        )
                      : Get.snackbar(
                          'Error',
                          'Could not launch $instagramUrl.',
                        );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  child: SvgPicture.asset(
                    'assets/images/instagram.svg',
                    height: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () async {
                  Uri facebookUrl =
                      Uri.parse('https://www.facebook.com/fredick.ferdinand');
                  await canLaunchUrl(facebookUrl)
                      ? await launchUrl(
                          facebookUrl,
                          mode: LaunchMode.externalApplication,
                        )
                      : Get.snackbar(
                          'Error',
                          'Could not launch $facebookUrl.',
                        );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  child: SvgPicture.asset(
                    'assets/images/facebook.svg',
                    height: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () async {
                  Uri whatsappUrl = Uri.parse('https://wa.me/085248608983');
                  await canLaunchUrl(whatsappUrl)
                      ? await launchUrl(
                          whatsappUrl,
                          mode: LaunchMode.externalApplication,
                        )
                      : Get.snackbar(
                          'Error',
                          'Could not launch $whatsappUrl.',
                        );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  child: SvgPicture.asset(
                    'assets/images/whatsapp.svg',
                    height: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
