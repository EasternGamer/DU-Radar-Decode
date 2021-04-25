# DU-Radar-Decode
A functional way to decode radar data into arrays

## How to use
Basically, the code snippet is "decode.lua" should be pasted in a start method somewhere.

## Performance
The performance is okay, however, consider using [D.Mentia's method](https://discord.com/channels/760240626942869546/760240628394623038/832291950886387762) if all you care about is actual ship data and maximal performance.
As for a metric, executing the function 170/s with approximately 170 constructs is the fastest you will be able to achieve before CPU overload. In most cases, decoding at such a rate is impossible and pointless since radar data doesn't update that fast.

## Array Structure

    ConstructData {
      1: {
        1: {
          1: ID (string)
          2: Distance (number)
          3: In Identify Range (bool)
          4: Is Identified (bool)
          5: My Threat State To Target (number)
          6: Name (string)
          7: Size (string)
          8: Target Threat State (number)
        },
        2: {
        }
      },
      2: {
        1: {
          1: ID (string)
          2: Distance (number)
          3: In Identify Range (bool)
          4: Is Identified (bool)
          5: My Threat State To Target (number)
          6: Name (string)
          7: Size (string)
          8: Target Threat State (number)
        },
        2: {
          1: angular speed (number)
          2: anti gravity (number)
          3: atmo engines (number)
          4: construct type (number)
          5: mass (number)
          6: radars (number)
          7: radial speed (number) 
          8: rocket boosters (number)
          9: space engines (number)
          10: speed (number)
          11: weapons (number)
        }
      }
      ...
    }
    ConstructData[2] is a construct that is locked, thus the second info array is filled with data.
    
    PropertiesArray {
      1: Broken (bool)
      2: Error Message (string)
      3: Radar Status (number)
      4: Selected Construct (string)
      5: Works in environment (bool) 
    }
    
    IdentifiedConstructs {
      1: Construct ID 1 (string)
      2: Construct ID 2 (string)
      ...
    }
    
    IdentifyConstructs {
      1: {
        1: Construct ID (string)
        2: Time (number)
      },
      2: {
        1: Construct ID (string)
        2: Time (number)
      }
      ...
    }

