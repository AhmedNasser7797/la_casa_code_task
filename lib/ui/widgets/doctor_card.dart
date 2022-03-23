import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../provider/doctors/doctor_provider.dart';
import 'loading_widget.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctor = context.watch<DoctorProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: doctor.doctor.imageUrl,
            fit: BoxFit.fill,
            height: 100,
            width: 100,
            placeholder: (_, __) => const Center(
              child: LoadingWidget(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error_outline),
            ),
            imageBuilder: (ctx, image) => CircleAvatar(
              foregroundImage: image,
              radius: 60,
            ),
          ),
          title: Text(
            doctor.doctor.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: ReadMoreText(
            doctor.doctor.aboutMe,
            trimLines: 2,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
