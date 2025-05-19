import 'package:flutter/material.dart';
import 'package:vpn_app/Views/constant.dart';


class DrawerItem extends StatelessWidget {
  final IconData leading;
  final String  title;
  final VoidCallback onTap;
  DrawerItem({
    required this.leading,
    required this.title,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 6,horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child:  ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => blueGradient.createShader(bounds),
                child:   Icon(
                 leading,
                  size: 26,
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1.0),
              child: Text(title,style:boldStyle.copyWith(fontSize: 14,color: white)),
            ),
          ],
        ),
      ),
    );
  }
}