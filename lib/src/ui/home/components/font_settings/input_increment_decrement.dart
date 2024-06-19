import 'package:flutter/material.dart';

class InputIncrementDecrement extends StatefulWidget {
  const InputIncrementDecrement({
    super.key,
    required this.onValueChanged,
    required this.initialValue,
  });
  final ValueChanged<int> onValueChanged;
  final int initialValue;

  @override
  State<InputIncrementDecrement> createState() =>
      _InputIncrementDecrementState();
}

class _InputIncrementDecrementState extends State<InputIncrementDecrement> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue.toString();
  }

  void changeValue(int value) {
    widget.onValueChanged(value);
  }

  @override
  void didUpdateWidget(covariant InputIncrementDecrement oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue.toString();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          width: 60.0,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.blueGrey,
              width: 2.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                ),
              ),
              SizedBox(
                height: 38.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5)),
                      ),
                      child: InkWell(
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 18.0,
                        ),
                        onTap: () {
                          int currentValue = int.parse(_controller.text);
                          setState(() {
                            currentValue++;
                            _controller.text = (currentValue).toString();
                            changeValue(currentValue);
                          });
                        },
                      ),
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.arrow_drop_down,
                        size: 18.0,
                      ),
                      onTap: () {
                        int currentValue = int.parse(_controller.text);
                        setState(() {
                          currentValue--;
                          _controller.text =
                              (currentValue > 0 ? currentValue : 0).toString();
                          changeValue(currentValue);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
