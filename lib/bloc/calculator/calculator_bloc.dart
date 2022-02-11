import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorState()) {
    on<ResetAC>((event, emit) => emit(_resetAC()));
    on<AddNumber>(
      (event, emit) => emit(
        state.copyWidth(
          mathResult: state.mathResult == '0'
              ? event.number
              : state.mathResult + event.number,
        ),
      ),
    );
    on<ChangeNegativePositive>(
      (event, emit) => emit(
        state.copyWidth(
          mathResult: state.mathResult.contains('-')
              ? state.mathResult.replaceFirst('-', '')
              : '-' + state.mathResult,
        ),
      ),
    );
    on<DeleteLastEntry>((event, emit) {
      emit(state.copyWidth(
        mathResult: state.mathResult.length > 1
            ? state.mathResult.substring(0, state.mathResult.length - 1)
            : '0',
      ));
    });
    on<OperationEntry>((event, emit) {
      emit(state.copyWidth(
        firstNumber: state.mathResult,
        mathResult: '0',
        operation: event.operation,
        secondNumber: '0',
      ));
    });
    on<CalculateResult>((event, emit) {
      _calculateResult(emit);
    });
  }

  void _calculateResult(Emitter<CalculatorState> emit) {
    final double num1 = double.parse(state.firstNumber);
    final double num2 = double.parse(state.mathResult);
    switch (state.operation) {
      case '+':
        emit(state.copyWidth(
            secondNumber: state.mathResult, mathResult: '${num1 + num2}'));
        break;
      case '-':
        emit(state.copyWidth(
            secondNumber: state.mathResult, mathResult: '${num1 - num2}'));
        break;
      case 'X':
        emit(state.copyWidth(
            secondNumber: state.mathResult, mathResult: '${num1 * num2}'));
        break;
      case '/':
        emit(state.copyWidth(
            secondNumber: state.mathResult, mathResult: '${num1 / num2}'));
        break;
      default:
        emit(state);
    }
  }

  CalculatorState _resetAC() {
    return CalculatorState(
      firstNumber: '0',
      mathResult: '0',
      secondNumber: '0',
      operation: '+',
    );
  }
}

/* class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorState()) {
    on<CalculatorEvent>((event, emit) {
      // TODO: implement event handler
      if (event is ResetAC) {
        emit(
          CalculatorState(
            firstNumber: '0',
            mathResult: '0',
            secondNumber: '0',
            operation: 'none',
          ),
        );
      }
      if (event is AddNumber) {
        emit(
          CalculatorState(
            firstNumber: '0',
            secondNumber: '0',
            operation: 'none',
            mathResult: state.mathResult == '0'
                ? event.number
                : state.mathResult + event.number,
          ),
        );
      }
    });
  }
}
 */