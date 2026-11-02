import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../utils/app_colors.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;

  const TeamMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Avatar with border
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.dashedBorder, // #3498db
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                color: const Color(0xFFE1F5FE),
                child: Center(
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.headingDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            member.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.headingBlack,
            ),
          ),
          const SizedBox(height: 6),

          // Role
          if (member.role.isNotEmpty)
            Text(
              member.role,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.dashedBorder,
              ),
            ),
          const SizedBox(height: 10),

          // Bio
          Text(
            member.bio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 14,
              color: AppColors.textGrey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

