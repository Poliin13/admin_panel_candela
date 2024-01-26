// import 'package:flutter/material.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
//
// class MathDisplayScreen extends StatelessWidget {
//   final String maxwellsEquation = r'''Maxwell's equations:
//   \left\{\begin{array}{l}
//     \nabla\cdot\vec{D} = \rho \\
//     \nabla\cdot\vec{B} = 0 \\
//     \nabla\times\vec{E} = -\frac{\partial\vec{B}}{\partial t} \\
//     \nabla\times\vec{H} = \vec{J}_f + \frac{\partial\vec{D}}{\partial t}
//   \end{array}\right.''';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mathematical Equations'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 3,
//           margin: EdgeInsets.symmetric(vertical: 8),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Math.tex(
//               maxwellsEquation,
//               textStyle: TextStyle(fontSize: 16),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
