import 'package:dart_nn/dart_nn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:q_net/data/neural_network.dart';
import 'package:tuple/tuple.dart';

import 'neural_network_structure_edit.dart';

class NeuralNetworkEdit extends StatefulWidget {
  final NeuralNetworkDTO nn;
  NeuralNetworkEdit(this.nn);

  @override
  State<StatefulWidget> createState() {
    return _NeuralNetworkEditState(nn);
  }
}

class _NeuralNetworkEditState extends State<NeuralNetworkEdit> {
  int currentStep = 0;
  bool complete = false;
  List<Step> steps;
  TextEditingController inputSizeController = TextEditingController();
  TextEditingController outputSizeController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  NeuralNetworkDTO nn;
  _NeuralNetworkEditState(this.nn);

  List<Step> buildSteps() {
    inputSizeController.text = nn?.inputSize?.toString() ?? '';
    outputSizeController.text = nn?.outputSize?.toString() ?? '';
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
          title: Text("Done!"),
          content: Text("Done"),
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
        FlatButton(onPressed: goBack, child: Text("Go back")),
        FlatButton(
            onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => Scaffold(
                              body: Center(
                                  child: Container(
                                child: NeuralNetworkStructureEdit(nn),
                                width: 400,
                                height: 100,
                              )),
                              appBar: AppBar(
                                title: Text("data sets"),
                              )))).then((value) => goBack())
                },
            child: Text("edit structure")),
        FlatButton(
            onPressed: () => throw ("not implemented"), child: Text("Test"))
      ],
    ));
  }

  void goBack() {
    Navigator.pop(context, Tuple2(nameController.text, nn));
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
    if (nn != null) {
      if (step == 2 &&
          (int.parse(inputSizeController.text) != nn.inputSize ||
              int.parse(outputSizeController.text) != nn.outputSize)) {
        setState(() {
          nn.network = null;
          nn.inputSize = int.parse(inputSizeController.text);
          nn.outputSize = int.parse(outputSizeController.text);
        });
      }
      //todo: warn
    } else if (step == 2) {
      setState(() {
        nn = NeuralNetworkDTO(int.parse(inputSizeController.text),
            int.parse(outputSizeController.text), nameController.text);
        nn.network = NeuralNetwork(
            nn.inputSize, List(), Layer(nn.outputSize, 'Sigmoid'));
      });
    }
    setState(() => currentStep = step);
  }
}
