
  Widget _buildMapToggle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Show marker in the map?',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      CupertinoSwitch(
        value: isMapShowing,
        onChanged: (value) {
          setState(() {
            isMapShowing = value;
          });
        },
      ),
    ],
  );
}
