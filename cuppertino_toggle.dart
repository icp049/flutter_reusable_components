Widget _buildMapToggle() {
  return Container(
    padding: const EdgeInsets.all(10), // Optional padding inside the container
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.3), // Transparent black background
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min, // Makes the Row take the minimum width required by its children
      children: [
        const Text(
          'Show marker in the map?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for contrast
          ),
        ),
        const SizedBox(width: 10), // Spacing between text and switch
        CupertinoSwitch(
          value: isMapShowing,
          onChanged: (value) {
            setState(() {
              isMapShowing = value;
            });
          },
          activeColor: Colors.green, // Green color when switch is on
          trackColor: Colors.grey, // Gray color for the track (off state)
          thumbColor: Colors.white, // White thumb color for the switch
        ),
      ],
    ),
  );
}
