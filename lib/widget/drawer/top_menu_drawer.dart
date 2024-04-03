part of gestion_de_table;

class TopMenuDrawer extends StatefulWidget {
  final Function()? onTap;
  const TopMenuDrawer(this.onTap,{Key? key});

  @override
  State<TopMenuDrawer> createState() => _TopMenuDrawerState();
}

class _TopMenuDrawerState extends State<TopMenuDrawer> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
     
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jumpark", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
            SizedBox(
              height: 5,
            ),
            Text("Coffee shop", style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.secondaryTextColor, fontSize: 12)),
          ],
        )
      ],
    );
  }
}