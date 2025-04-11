class MenuItem {
  final String title;
  final String imagePath;

  MenuItem({required this.title, required this.imagePath});
}

List<MenuItem> menuItems = [
  MenuItem(title: 'Change Model', imagePath: 'assets/icons/bot.svg'),
  MenuItem(title: 'Chat History', imagePath: 'assets/icons/history.svg'),
  MenuItem(
    title: 'Connect on LinkedIn',
    imagePath: 'assets/icons/linkedin.svg',
  ),
  MenuItem(title: 'View my Github', imagePath: 'assets/icons/github.svg'),
];
