//
//  TTMHealthKitHelper.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMHealthKitHelper.h"

@implementation TTMHealthKitHelper

+ (NSArray *)quantityTypeIdentifiers {
    
    return @[
             // Discrete
             HKQuantityTypeIdentifierBodyMassIndex,              // Scalar(Count),
             HKQuantityTypeIdentifierBodyFatPercentage,          // Scalar(Percent,
             HKQuantityTypeIdentifierHeight,                     // Length,
             HKQuantityTypeIdentifierBodyMass,                   // Mass,
             HKQuantityTypeIdentifierLeanBodyMass,               // Mass,
             
             // Fitness
             HKQuantityTypeIdentifierStepCount,                  // Scalar(Count),
             HKQuantityTypeIdentifierDietaryZinc,                   // Length,
             HKQuantityTypeIdentifierBasalEnergyBurned,          // Energy,
             HKQuantityTypeIdentifierActiveEnergyBurned,         // Energy,
             HKQuantityTypeIdentifierFlightsClimbed,             // Scalar(Count),
             HKQuantityTypeIdentifierNikeFuel,                   // Scalar(Count),               Cumulative
             
             // Vitals
             HKQuantityTypeIdentifierHeartRate,                  // Scalar(Count)/Time,          Discrete
             HKQuantityTypeIdentifierBodyTemperature,            // Temperature,                 Discrete
             HKQuantityTypeIdentifierBloodPressureSystolic,      // Pressure,                    Discrete
             HKQuantityTypeIdentifierBloodPressureDiastolic,     // Pressure,                    Discrete
             HKQuantityTypeIdentifierRespiratoryRate,            // Scalar(Count)/Time,          Discrete
             
             // Results
             HKQuantityTypeIdentifierOxygenSaturation,           // Scalar (Percent, 0.0 - 1.0,  Discrete
             HKQuantityTypeIdentifierPeripheralPerfusionIndex,   // Scalar(Percent, 0.0 - 1.0),  Discrete
             HKQuantityTypeIdentifierBloodGlucose,               // Mass/Volume,                 Discrete
             HKQuantityTypeIdentifierNumberOfTimesFallen,        // Scalar(Count),               Cumulative
             HKQuantityTypeIdentifierElectrodermalActivity,      // Conductance,                 Discrete
             HKQuantityTypeIdentifierInhalerUsage,               // Scalar(Count),               Cumulative
             HKQuantityTypeIdentifierBloodAlcoholContent,        // Scalar(Percent, 0.0 - 1.0),  Discrete
             HKQuantityTypeIdentifierForcedVitalCapacity,        // Volume,                      Discrete
             HKQuantityTypeIdentifierForcedExpiratoryVolume1,    // Volume,                      Discrete
             HKQuantityTypeIdentifierPeakExpiratoryFlowRate,     // Volume/Time,                 Discrete
             
             // Nutrition
             HKQuantityTypeIdentifierDietaryFatTotal,            // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryFatPolyunsaturated,  // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryFatMonounsaturated,  // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryFatSaturated,        // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryCholesterol,         // Mass,   Cumulative
             HKQuantityTypeIdentifierDietarySodium,              // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryCarbohydrates,       // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryFiber,               // Mass,   Cumulative
             HKQuantityTypeIdentifierDietarySugar,               // Mass,   Cumulative
             HKQuantityTypeIdentifierDietaryEnergyConsumed,      // Energy, Cumulative
             HKQuantityTypeIdentifierDietaryProtein,             // Mass,   Cumulative
             
             HKQuantityTypeIdentifierDietaryVitaminA,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryVitaminB6,           // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryVitaminB12,          // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryVitaminC,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryVitaminD,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryVitaminE,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryVitaminK,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryCalcium,             // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryIron,                // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryThiamin,             // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryRiboflavin,          // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryNiacin,              // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryFolate,              // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryBiotin,              // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryPantothenicAcid,     // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryPhosphorus,          // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryIodine,              // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryMagnesium,           // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryZinc,                // Mass, Cumulative
             HKQuantityTypeIdentifierDietarySelenium,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryCopper,              // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryManganese,           // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryChromium,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryMolybdenum,          // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryChloride,            // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryPotassium,           // Mass, Cumulative
             HKQuantityTypeIdentifierDietaryCaffeine,            // Mass, Cumulative
             ];
}

+ (NSArray *)quantityTypes {
    
    NSMutableArray *arr = @[].mutableCopy;
    
    for (NSString *anIdentifier in [self quantityTypeIdentifiers]) {
        
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:anIdentifier];
        
        if (type) {
            [arr addObject:type];
        }
    }
    
    return arr;
}

+ (HKUnit *)defaultUnitForQuantityType:(HKQuantityType *)type {
    
    NSString *identifier = type.identifier;
    
    if (
        [identifier isEqualToString:HKQuantityTypeIdentifierBodyMassIndex] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierStepCount] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierFlightsClimbed] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierNikeFuel] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierNumberOfTimesFallen] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierInhalerUsage] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierHeartRate] ||
        [identifier isEqualToString:HKQuantityTypeIdentifierRespiratoryRate]
        )
    {
        return [HKUnit countUnit];
    }
    // length
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierHeight] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierDietaryZinc]
             )
    {
        return [HKUnit meterUnit];
    }
    // energy
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierBasalEnergyBurned] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierActiveEnergyBurned] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierDietaryEnergyConsumed]
             )
    {
        return [HKUnit kilocalorieUnit];
    }
    // mass
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierBloodGlucose] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierBodyMass] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierLeanBodyMass] ||
             [identifier hasPrefix:@"HKQuantityTypeIdentifierDietary"]
             )
    {
        return [HKUnit gramUnit];
    }
    // Percent
    else if (
             [identifier isEqualToString:HKQuantityTypeIdentifierBodyFatPercentage] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierOxygenSaturation] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierPeripheralPerfusionIndex] ||
             [identifier isEqualToString:HKQuantityTypeIdentifierBloodAlcoholContent]
             )
    {
        return [HKUnit percentUnit];
    }
    
    // TODO: Temperature, Pressure, Volume
    return nil;
}

@end
