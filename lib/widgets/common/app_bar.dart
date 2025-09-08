import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:radio_odan_app/config/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final bool centerTitle;
  final double? titleSpacing;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double toolbarHeight;
  final ShapeBorder? shape;
  final bool primary;
  final Widget? flexibleSpace;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.centerTitle = true,
    this.titleSpacing,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = kToolbarHeight,
    this.shape,
    this.primary = true,
    this.flexibleSpace,
  }) : super(key: key);

  // Transparan + blur + gradasi halus dari surface → transparan
  factory CustomAppBar.transparent({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    Color? titleColor,
    Color? iconColor,
    required BuildContext context,
    bool showGradient = true,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return CustomAppBar(
      title: title,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      titleColor: titleColor ?? colors.onSurface,
      iconColor: iconColor ?? colors.onSurface,
      actions: actions,
      leading: leading,
      flexibleSpace: showGradient
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.surface.withOpacity(0.90),
                        colors.surface.withOpacity(0.70),
                        colors.surface.withOpacity(0.40),
                        colors.surface.withOpacity(
                          0.0,
                        ), // transparan tanpa hardcode
                      ],
                      stops: const [0.0, 0.30, 0.60, 1.0],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // Varian gelap semi-transparan
  factory CustomAppBar.dark({
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
    required BuildContext context,
    Widget? leading,
    Color? backgroundColor,
    Color? titleColor,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return CustomAppBar(
      title: title,
      backgroundColor: backgroundColor ?? colors.surface.withOpacity(0.90),
      titleColor: titleColor ?? colors.onSurface,
      iconColor: iconColor ?? colors.onSurface,
      actions: actions,
      showBackButton: showBackButton,
      leading: leading,
      elevation: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveIconColor = iconColor ?? colors.onSurface;

    return AppBar(
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: titleColor ?? colors.onSurface,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          height: 1.2,
        ),
      ),
      backgroundColor: backgroundColor ?? colors.surface,
      elevation: elevation,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      shape: shape,
      primary: primary,
      flexibleSpace: flexibleSpace,
      iconTheme: IconThemeData(color: effectiveIconColor),
      actionsIconTheme: IconThemeData(color: effectiveIconColor),
      leading:
          leading ??
          (showBackButton ? _buildModernBackButton(context, colors) : null),
      leadingWidth: showBackButton ? 56 : null,
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ),
            ]
          : null,
      bottom: bottom,
    );
  }

  // Tombol back selalu kontras: pakai primary/onPrimary dari ColorScheme
  Widget _buildModernBackButton(BuildContext context, ColorScheme colors) {
    final bg = colors.primary;
    final fg = colors.onPrimary;

    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: colors.outline.withOpacity(0.3), width: 1),
      ),
      tooltip: 'Kembali',
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
