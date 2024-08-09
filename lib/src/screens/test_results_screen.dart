import 'package:danfoss_mobile/src/screens/main_screen.dart';
import 'package:danfoss_mobile/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:danfoss_mobile/src/widgets/buttons.dart'
    as danfoss; //Resolves problem with custom back-button
import 'package:danfoss_mobile/src/widgets/test_results.dart';
import '../services/database_service_class.dart';

class TestResultsScreen extends StatelessWidget {
  final String? serial;
  const TestResultsScreen({super.key, this.serial});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseservice = DatabaseService.instance;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // custom appbar from widgets
      appBar: CustomAppBar(showBackButton: true),

      body: FutureBuilder(
          future: _databaseservice.fetchTestResults(serial.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if(snapshot.hasError){ //catch for a query with no results in given table
              return AlertDialog(
                      title: const Text("Error"),
                      content: const Text("No results for given serial in this tab. Try again or view other tabs."),
                      actions: <Widget>[
                        
                        ElevatedButton(
                          child: const Text("Return to main page"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                          },
                        ),
                        
                      ],
                    );
            }
            else if (snapshot.hasData){
              final searchdata = snapshot.data;
              //Search data variables
              String? motorType = searchdata!['motor_type'] as String?;
              String? date = searchdata!['date'] as String?;
              String? motorTemp = searchdata!['motor_temperatures'] as String?;
              String? insResistance =
                  searchdata!['insulation_resistance']?.toString();
              String? heatResisNSide =
                  searchdata['heater_resistance_n_side']?.toString();
              String? heatResisDSide =
                  searchdata['heater_resistance_d_side']?.toString();
              String? rotationDirCorrect =
                  searchdata['rotation_direction_correct'] as String?;
              String? encoderDirCorrect =
                  searchdata['encoder_direction_correct'] as String?;
              String? encoderOffsetAngle =
                  searchdata['encoder_offset_angle']?.toString();
              String? idFluxLinkPu =
                  searchdata['id_flux_linkage_pu']?.toString();
              String? idRsResSi = searchdata['id_rs_resistance_si']?.toString();
              String? idLdInductSi =
                  searchdata['id_ld_inductance_si']?.toString();
              String? idLqInductSi =
                  searchdata['id_lq_inductance_si']?.toString();
              String? idLtdInductSi =
                  searchdata['id_ltd_inductance_si']?.toString();
              String? idLtqInductSi =
                  searchdata['id_ltq_inductande_si']?.toString();
              String? dVertHorAxDisplacementRms = searchdata[
                      'd_side_vertical_horizontal_axial_displacement_rms']
                  as String?;
              String? dVertHorAxVeloRms =
                  searchdata['d_side_vertical_horizontal_axial_velocity_rms']
                      as String?;
              String? dVertHorAxAccelRms = searchdata[
                      'd_side_vertical_horizontal_axial_accelaration_rms']
                  as String?;
              String? nVertHorAxDisplacementRms = searchdata[
                      'n_side_vertical_horizontal_axial_displacement_rms']
                  as String?;
              String? nVertHorAxVeloRms =
                  searchdata['n_side_vertical_horizontal_axial_velocity_rms']
                      as String?;
              String? nVertHorAxAccelRms =
                  searchdata['n_side_vertical_horizontal_accelaration_rms']
                      as String?;
              String? dVertHorAxDisplacementPtp = searchdata[
                      'd_side_vertical_horizontal_axial_displacement_ptp']
                  as String?;
              String? dVertHorAxVeloPtp =
                  searchdata['d_side_vertical_horizontal_axial_velocity_ptp']
                      as String?;
              String? dVertHorAxAccelPtp = searchdata[
                      'd_side_vertical_horizontal_axial_accelaration_ptp']
                  as String?;
              String? nVertHorAxDisplacementPtp = searchdata[
                      'n_side_vertical_horizontal_axial_displacement_ptp']
                  as String?;
              String? nVertHorAxVeloPtp =
                  searchdata['n_side_vertical_horizontal_axial_velocity_ptp']
                      as String?;
              String? nVertHorAxAccelPtp = searchdata[
                      'n_side_vertical_horizontal_axial_accelaration_ptp']
                  as String?;
              String? maxNoise = searchdata['maximum_noise']?.toString();
              String? bearingTemp =
                  searchdata['bearing_temperatures'] as String?;
              String? maxTorque = searchdata['maximum_torque']?.toString();
              String? pressureTestPassed =
                  searchdata['pressure_test_passed'] as String?;

              //Result-widgets
              return ListView(
                children: [
                  QueryBox_Light(title: 'Date', result: ('$date')),
                  QueryBox_Grey(title: 'Motor Type', result: ('$motorType')),
                  QueryBox_Light(
                      title: 'Motor Temperatures', result: ('$motorTemp')),
                  QueryBox_Grey(
                      title: 'Insulation Resistance',
                      result: ('$insResistance')),
                  QueryBox_Light(
                      title: 'Heater Resistance n-side',
                      result: ('$heatResisNSide')),
                  QueryBox_Grey(
                      title: 'Heater Resistance d-side',
                      result: ('$heatResisDSide')),
                  QueryBox_Light(
                      title: 'Rotation Direction Correct',
                      result: ('$rotationDirCorrect')),
                  QueryBox_Grey(
                      title: 'Encoder Direction Correct',
                      result: ('$encoderDirCorrect')),
                  QueryBox_Light(
                      title: 'Encoder Offset Angle',
                      result: ('$encoderOffsetAngle')),
                  QueryBox_Grey(
                      title: 'Id Flux Linkage Pu', result: ('$idFluxLinkPu')),
                  QueryBox_Light(
                      title: 'Id Rs Resistance Si', result: ('$idRsResSi')),
                  QueryBox_Grey(
                      title: 'Id Ld Inductance Si', result: ('$idLdInductSi')),
                  QueryBox_Light(
                      title: 'Id Lq Inductance Si', result: ('$idLqInductSi')),
                  QueryBox_Grey(
                      title: 'Id Ltd Inductance Si',
                      result: ('$idLtdInductSi')),
                  QueryBox_Light(
                      title: 'Id Ltq Inductance Si',
                      result: ('$idLtqInductSi')),
                  QueryBox_Grey(
                      title:
                          'D-side Vertical Horizontal Axial Displacement Rms',
                      result: ('$dVertHorAxDisplacementRms')),
                  QueryBox_Light(
                      title: 'D-side Vertical Horizontal Axial Velocity Rms',
                      result: ('$dVertHorAxVeloRms')),
                  QueryBox_Grey(
                      title:
                          'D-side Vertical Horizontal Axial Accelaration Rms',
                      result: ('$dVertHorAxAccelRms')),
                  QueryBox_Light(
                      title:
                          'N-side Vertical Horizontal Axial Displacement Ptp',
                      result: ('$nVertHorAxDisplacementRms')),
                  QueryBox_Grey(
                      title: 'N-side Vertical Horizontal Axial Velocity Rms',
                      result: ('$nVertHorAxVeloRms')),
                  QueryBox_Light(
                      title:
                          'N-side Vertical Horizontal Axial Accelaration Rms',
                      result: ('$nVertHorAxAccelRms')),
                  QueryBox_Grey(
                      title:
                          'D-side Vertical Horizontal Axial Displacement Ptp',
                      result: ('$dVertHorAxDisplacementPtp')),
                  QueryBox_Light(
                      title: 'D-side Vertical Horizontal Axial Velocity Ptp',
                      result: ('$dVertHorAxVeloPtp')),
                  QueryBox_Grey(
                      title:
                          'D-side Vertical Horizontal Axial Accelaration Ptp',
                      result: ('$dVertHorAxAccelPtp')),
                  QueryBox_Light(
                      title:
                          'N-side Vertical Horizontal Axial Displacement Ptp',
                      result: ('$nVertHorAxDisplacementPtp')),
                  QueryBox_Grey(
                      title: 'N-side Vertical Horizontal Axial Velocity Ptp',
                      result: ('$nVertHorAxVeloPtp')),
                  QueryBox_Light(
                      title:
                          'N-side Vertical Horizontal Axial Accelaration Ptp',
                      result: ('$nVertHorAxAccelPtp')),
                  QueryBox_Grey(title: 'Maximum Noise', result: ('$maxNoise')),
                  QueryBox_Light(
                      title: 'Bearing Temperatures', result: ('$bearingTemp')),
                  QueryBox_Grey(
                      title: 'Maximum Torque', result: ('$maxTorque')),
                  QueryBox_Light(
                      title: 'Pressure Test Passed',
                      result: ('$pressureTestPassed')),
                ],
              );
            }
            else{
              return AlertDialog(
                      title: const Text("Error"),
                      content: const Text("No results for given serial. Check it and try again."),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Return to main page"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                          },
                        ),
                      ],
                    );
            }
          }),
    );
  }
}
