import 'package:bloc_cubit_exam/count_bloc.dart';
import 'package:bloc_cubit_exam/count_cubit.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class CountViewPage extends StatelessWidget {
  const CountViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CountBloc, int>(
              builder: (context, state) {
                return Text(
                  state.toString(),
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CountBloc>().add(AddCountEvent());
              },
              child: const Text("Add"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CountBloc>().add(SubtractCountEvent());
              },
              child: const Text('Sub'),
            ),
          ],
        ),
      ),
    );
  }
}
