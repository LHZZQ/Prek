import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override 
  Widget build(BuildContext context){
    //const pink = Color(0xFFFB7DA8);
    //const yellow = Color(0xFFFFC567);
    //const blue = Color(0xFF058CD7);
   // const softWhite = Color(0xFFFFFFFF); 
    const textColor = Color(0xFF94697E); 
    const bgTop = Color(0xFFFFF1F5);
    const bgBottom = Color(0xFFFFF8EE);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar( 
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        centerTitle: true,
        leading: IconButton(icon: const
        Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
        onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("not available right now")),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: textColor),
          ),
        ],
     ),
     body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [bgTop, bgBottom],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 6),

                const _ProfileTopCard(
                  displayName: "Username",
                  email: "user@email.com",
                  reflections: "14",
                  streak: "06",
                  daysActive: "12",
                 ),
                 const SizedBox(height: 14),

                 const _FunInfoPill(
                  leftText: "PREK",
                  rightText: "Member since 2025",
                ),
                 const SizedBox(height: 18),

                 const Text(
                  "Your wellness",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _ProfileTopCard extends StatelessWidget {
  final String displayName;
  final String email;
  final String reflections;
  final String streak;
  final String daysActive;

  const _ProfileTopCard({
    required this.displayName,
    required this.email,
    required this.reflections,
    required this.streak,
    required this.daysActive,

  }
  );

  @override
  Widget build(BuildContext context) {
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
    const pink = Color(0xFFFB7DA8);
    //const peach = Color(0xFFFFE4B5);
    const blue = Color(0xFF058CD7);
    const yellow = Color(0xFFFFC567);

    

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softWhite.withOpacity(0.78),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: softWhite.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [pink, yellow]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 38),
              ),
              Positioned(
                right: -4,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _MiniChip(label: "Reflections", value: reflections, accent: pink),
                    _MiniChip(label: "Streak", value: streak, accent: yellow),
                    _MiniChip(label: "Days", value: daysActive, accent: blue),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _MiniChip({
    required this.label,
    required this.value,
    required this.accent,
  });
  @override
  Widget build(BuildContext context) {
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: softWhite.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: textColor)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.75))),
        ],
      ),
    );
  }
}
class _FunInfoPill extends StatelessWidget {
  final String leftText;
  final String rightText;

  const _FunInfoPill({required this.leftText, required this.rightText});

  @override 
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFC567);
    const pink = Color(0xFFFB7DA8);
    const blue = Color(0xFF058CD7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [yellow, pink, blue]),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Text(leftText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          const Spacer(),
          Text(rightText, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}