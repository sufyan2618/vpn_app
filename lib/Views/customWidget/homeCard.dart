import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final image;
  final Color iconColor;
  final VoidCallback? onTap;

  const HomeCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.image,
    this.iconColor = Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2C45),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: image != null
                  ? BoxDecoration(
                color: const Color(0xFF00BCD4),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              )
                  : BoxDecoration(
                color: const Color(0xFF00BCD4),
                shape: BoxShape.circle,
              ),
              child: image == null
                  ? Icon(icon, size: 26, color: iconColor)
                  : null,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
