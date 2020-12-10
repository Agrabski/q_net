import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import 'data/data_set_entry.dart';
import 'edit/data_set_edit.dart';

class AnyDataSetWizard extends StatefulWidget {
  final DataSet dataSet;

  const AnyDataSetWizard({Key key, this.dataSet}) : super(key: key);
  @override
  _wizardState createState() => new _wizardState(dataSet);
}

class _wizardState extends State<AnyDataSetWizard> {
  int currentStep = 0;
  bool complete = false;
  List<Step> steps;
  TextEditingController inputSizeController = TextEditingController();
  TextEditingController outputSizeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final DataSet dataSet;

  _wizardState(this.dataSet);

  List<Step> buildSteps() {
    inputSizeController.text = dataSet.inputSize.toString();
    outputSizeController.text = dataSet.outputSize.toString();
    return steps = [
      Step(
        title: Text("Name"),
        state: StepState.editing,
        content: TextFormField(
          controller: nameController,
        ),
      ),
      Step(
          title: Text("Size"),
          state: StepState.editing,
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Input dimension"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: inputSizeController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Output dimension"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: outputSizeController,
              ),
            ],
          )),
      Step(
          title: Text("Training examples"),
          content: DataSetEdit(set: dataSet),
          state: StepState.complete),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New data set"),
        ),
        body: Column(children: [
          complete
              ? Expanded(child: buildDialog(context))
              : Expanded(child: buildStepper(context)),
        ]));
  }

  Widget buildDialog(BuildContext context) {
    return Center(
        child: AlertDialog(
      title: Text("Done!"),
      content: Text("you did it!"),
      actions: [
        FlatButton(
            onPressed: () =>
                Navigator.pop(context, Tuple2(nameController.text, dataSet)),
            child: Text("Go back")),
        FlatButton(
            onPressed: () => throw ("not implemented"), child: Text("Test"))
      ],
    ));
  }

  Widget buildStepper(BuildContext context) {
    void Function() onContinue = () => {
          if (currentStep + 1 != steps.length)
            goTo(currentStep + 1)
          else
            setState(() => complete = true)
        };
    return Stepper(
      steps: buildSteps(),
      onStepCancel: cancel,
      onStepTapped: (step) => goTo(step),
      currentStep: currentStep,
      onStepContinue: onContinue,
    );
  }

  next() {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    if (step == 2 &&
        (int.parse(inputSizeController.text) != dataSet.inputSize ||
            int.parse(outputSizeController.text) != dataSet.outputSize)) {
      setState(() {
        dataSet.examples.clear();
        dataSet.inputSize = int.parse(inputSizeController.text);
        dataSet.outputSize = int.parse(outputSizeController.text);
      });
      //todo: warn
    }
    setState(() => currentStep = step);
  }
}
