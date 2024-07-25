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
      //Navigation system
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(207, 45, 36, 1),
        leading: Container(
          margin: const EdgeInsets.only(left: 40),
          child: Transform.scale(
              scale: 6.0, // here is the scale of the logo
              child: Image.asset('Resources/Images/danfoss.png')),
        ),
      ),

      body: FutureBuilder(
          future: _databaseservice.fetchTestResults(serial.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final searchdata = snapshot.data;
              //Search data variables
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
                  QueryBox_Grey(
                      title: 'Motor Temperatures', result: ('$motorTemp')),
                  QueryBox_Light(
                      title: 'Insulation Resistance',
                      result: ('$insResistance')),
                  QueryBox_Grey(
                      title: 'Heater Resistance n-side',
                      result: ('$heatResisNSide')),
                  QueryBox_Light(
                      title: 'Heater Resistance d-side',
                      result: ('$heatResisDSide')),
                  QueryBox_Grey(
                      title: 'Rotation Direction Correct',
                      result: ('$rotationDirCorrect')),
                  QueryBox_Light(
                      title: 'Encoder Direction Correct',
                      result: ('$encoderDirCorrect')),
                  QueryBox_Grey(
                      title: 'Encoder Offset Angle',
                      result: ('$encoderOffsetAngle')),
                  QueryBox_Light(
                      title: 'Id Flux Linkage Pu', result: ('$idFluxLinkPu')),
                  QueryBox_Grey(
                      title: 'Id Rs Resistance Si', result: ('$idRsResSi')),
                  QueryBox_Light(
                      title: 'Id Ld Inductance Si', result: ('$idLdInductSi')),
                  QueryBox_Grey(
                      title: 'Id Lq Inductance Si', result: ('$idLqInductSi')),
                  QueryBox_Light(
                      title: 'Id Ltd Inductance Si',
                      result: ('$idLtdInductSi')),
                  QueryBox_Grey(
                      title: 'Id Ltq Inductance Si',
                      result: ('$idLtqInductSi')),
                  QueryBox_Light(
                      title:
                          'D-side Vertical Horizontal Axial Displacement Rms',
                      result: ('$dVertHorAxDisplacementRms')),
                  QueryBox_Grey(
                      title: 'D-side Vertical Horizontal Axial Velocity Rms',
                      result: ('$dVertHorAxVeloRms')),
                  QueryBox_Light(
                      title:
                          'D-side Vertical Horizontal Axial Accelaration Rms',
                      result: ('$dVertHorAxAccelRms')),
                  QueryBox_Grey(
                      title:
                          'N-side Vertical Horizontal Axial Displacement Ptp',
                      result: ('$nVertHorAxDisplacementRms')),
                  QueryBox_Light(
                      title: 'N-side Vertical Horizontal Axial Velocity Rms',
                      result: ('$nVertHorAxVeloRms')),
                  QueryBox_Grey(
                      title:
                          'N-side Vertical Horizontal Axial Accelaration Rms',
                      result: ('$nVertHorAxAccelRms')),
                  QueryBox_Light(
                      title:
                          'D-side Vertical Horizontal Axial Displacement Ptp',
                      result: ('$dVertHorAxDisplacementPtp')),
                  QueryBox_Grey(
                      title: 'D-side Vertical Horizontal Axial Velocity Ptp',
                      result: ('$dVertHorAxVeloPtp')),
                  QueryBox_Light(
                      title:
                          'D-side Vertical Horizontal Axial Accelaration Ptp',
                      result: ('$dVertHorAxAccelPtp')),
                  QueryBox_Grey(
                      title:
                          'N-side Vertical Horizontal Axial Displacement Ptp',
                      result: ('$nVertHorAxDisplacementPtp')),
                  QueryBox_Light(
                      title: 'N-side Vertical Horizontal Axial Velocity Ptp',
                      result: ('$nVertHorAxVeloPtp')),
                  QueryBox_Grey(
                      title:
                          'N-side Vertical Horizontal Axial Accelaration Ptp',
                      result: ('$nVertHorAxAccelPtp')),
                  QueryBox_Light(title: 'Maximum Noise', result: ('$maxNoise')),
                  QueryBox_Grey(
                      title: 'Bearing Temperatures', result: ('$bearingTemp')),
                  QueryBox_Light(
                      title: 'Maximum Torque', result: ('$maxTorque')),
                  QueryBox_Grey(
                      title: 'Pressure Test Passed',
                      result: ('$pressureTestPassed')),
                ],
              );
              //Remember to make sure there is empty space after last result, so the back-button wont be on the way
            }
          }),
      floatingActionButton: danfoss.BackButton(),
    );
  }
}