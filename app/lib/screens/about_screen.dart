import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../utils/app_text_styles.dart';
import '../widgets/team_member_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'About Our Team',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 12),
        const Text(
          'We are a dedicated team of medical imaging specialists and AI researchers working to improve diagnostic capabilities.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 24),

        // Team members
        ...TeamMember.team.map((member) => TeamMemberCard(member: member)),
      ],
    );
  }
}

