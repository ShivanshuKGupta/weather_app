import 'package:flutter/material.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/utils/utils.dart';

class WeatherTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;
  final String unit;
  const WeatherTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.value,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GlassWidget(
        radius: 10,
        child: Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: colorScheme.onBackground,
                    ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: colorScheme.primary,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
