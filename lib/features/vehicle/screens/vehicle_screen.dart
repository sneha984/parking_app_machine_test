import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:parking_app_machine_test/core/commons/global_variables/global_variables.dart';
import 'package:parking_app_machine_test/core/commons/snackbar.dart';
import 'package:parking_app_machine_test/theme/palette.dart';

import '../../../models/vehicle_model.dart';
import '../controller/vehicle_controller.dart';
import 'create_vehicle.dart';
import 'edit_vehicle.dart';

class VehicleListScreen extends ConsumerStatefulWidget {
  const VehicleListScreen({super.key});

  @override
  ConsumerState<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends ConsumerState<VehicleListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(paginatedVehicleListProvider.notifier).fetchVehicles();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(int timestamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleList = ref.watch(paginatedVehicleListProvider);

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await confirmQuitDialog(context);
        if (shouldPop == true) {}
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.primaryColor, Palette.secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VEHICLE LIST',
                        style: GoogleFonts.urbanist(
                          color: Palette.whiteColor,
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final created = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VehicleCreateScreen(),
                            ),
                          );

                          if (created == true) {
                            ref
                                .read(paginatedVehicleListProvider.notifier)
                                .fetchVehicles(refresh: true);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add, color: Palette.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: vehicleList.when(
                    data: (vehicles) {
                      if (vehicles.isEmpty) {
                        return const Center(
                          child: Text(
                            'No vehicles found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                            left: width * 0.07, right: width * 0.07),
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final Vehicle vehicle = vehicles[index];

                          return Dismissible(
                            key: Key(vehicle.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              width: double.infinity,
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: const Color(0xFF2C0A0A),
                                  title: const Text(
                                    "Delete Vehicle",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete ${vehicle.name}?",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  actionsPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.white),
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFD64545),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Palette.whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final success = await ref
                                    .read(vehicleControllerProvider.notifier)
                                    .deleteVehicle(vehicle.id);

                                if (!success) {
                                  showPrimarySnackBar(
                                      context, "Failed to delete vehicle ");
                                } else {
                                  showPrimarySnackBar(
                                      context, "${vehicle.name} deleted");

                                  ref
                                      .read(
                                          paginatedVehicleListProvider.notifier)
                                      .fetchVehicles(refresh: true);
                                }
                              }

                              return false;
                            },
                            child: GestureDetector(
                              onTap: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VehicleEditScreen(vehicle: vehicle),
                                  ),
                                );
                                if (updated == true) {
                                  ref
                                      .read(
                                          paginatedVehicleListProvider.notifier)
                                      .fetchVehicles(refresh: true);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(width * 0.03),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade900.withOpacity(0.6),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.04),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          vehicle.name.toUpperCase(),
                                          style: GoogleFonts.urbanist(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w800,
                                            fontSize: width * 0.05,
                                          ),
                                        ),
                                        Text(
                                          formatDate(vehicle.createdAt),
                                          style: GoogleFonts.urbanist(
                                              color: Colors.white54,
                                              fontSize: width * 0.03),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Text(
                                      vehicle.number,
                                      style: GoogleFonts.urbanist(
                                          color: Palette.whiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: width * 0.043),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Color : ${vehicle.color}",
                                          style: GoogleFonts.urbanist(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          "Model : ${vehicle.model}",
                                          style: GoogleFonts.urbanist(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                    error: (err, _) => Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
