import 'package:flutter/material.dart';
import 'colors.dart';

class AutomationContainer extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isAutomationOn;
  final bool isManualOn;
  final ValueChanged<bool> onAutomationChanged;
  final ValueChanged<bool> onManualChanged;

  const AutomationContainer({
    Key? key,
    required this.icon,
    required this.label,
    required this.isAutomationOn,
    required this.isManualOn,
    required this.onAutomationChanged,
    required this.onManualChanged,
  }) : super(key: key);

  @override
  _AutomationContainerState createState() => _AutomationContainerState();
}

class _AutomationContainerState extends State<AutomationContainer> {
  late bool _isAutomationOn;
  late bool _isManualOn;

  @override
  void initState() {
    super.initState();
    _isAutomationOn = widget.isAutomationOn;
    _isManualOn = widget.isManualOn;
  }

  void _handleAutomationChanged(bool value) {
    if (value) {
      // AUTO turned ON
      setState(() {
        _isAutomationOn = true;
        _isManualOn = true; // manual is ON internally but hidden
      });
      widget.onAutomationChanged(true);
      widget.onManualChanged(true);
    } else {
      // AUTO turned OFF
      setState(() {
        _isAutomationOn = false;
        _isManualOn = true; // manual toggle visible and initially ON
      });
      widget.onAutomationChanged(false);
      widget.onManualChanged(true);
    }
  }

  void _handleManualChanged(bool value) {
    setState(() {
      _isManualOn = value;
    });
    widget.onManualChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 177,
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: (_isAutomationOn || _isManualOn)
            ? Colors.pink
            : const Color.fromRGBO(237, 237, 237, 1),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(widget.icon, size: 50),
          const SizedBox(height: 10),
          Text(
            widget.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          SwitchListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            title: const Text("AUTO",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            value: _isAutomationOn,
            onChanged: _handleAutomationChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.pink,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            dense: true,
          ),
          // Show manual toggle ONLY if automation is OFF
          if (!_isAutomationOn)
            SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              title: const Text("ON",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              value: _isManualOn,
              onChanged: _handleManualChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.pink,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              dense: true,
            ),
        ],
      ),
    );
  }
}
