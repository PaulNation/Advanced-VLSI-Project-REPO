#txt file maker
#!/usr/bin/env python3
import struct

numbers_32 = [247947,      769347,     1719592,     3060166,     4502884,     5417905,
       4842781,     1632410,           0,           0,           0,           0,
             0,           0,           0,           0,           0,           0,
             0,     9375377,    27794364,    35581343,    31515859,    17608214,
             0,           0,           0,           0,           0,           0,
      14221567,    26514252,    28889506,    20385977,     4022201,           0,
             0,           0,           0,           0,    16764061,    31111195,
      33664658,    22554468,     1230523,           0,           0,           0,
             0,     2472774,    33331061,    54418908,    55304592,    32082021,
             0,           0,           0,           0,           0,    34894879,
     150478000,   273330885,   376057962,   434480361,   434480361,   376057962,
     273330885,   150478000,    34894879,           0,           0,           0,
             0,           0,    32082021,    55304592,    54418908,    33331061,
       2472774,           0,           0,           0,           0,     1230523,
      22554468,    33664658,    31111195,    16764061,           0,           0,
             0,           0,           0,     4022201,    20385977,    28889506,
      26514252,    14221567,           0,           0,           0,           0,
             0,           0,    17608214,    31515859,    35581343,    27794364,
       9375377,           0,           0,           0,           0,           0,
             0,           0,           0,           0,           0,           0,
       1632410,     4842781,     5417905,     4502884,     3060166,     1719592,
        769347,      247947]

def convert_to_binary(num):
    # Format the number as a 32-bit binary string with leading zeros.
    return format(num, '032b')

def read_unsigned_32bit_integers(filename):
    numbers = []
    with open(filename, "rb") as f:
        while True:
            bytes_read = f.read(4)  # Read 4 bytes (32 bits) at a time.
            if not bytes_read:
                break
            if len(bytes_read) < 4:
                print("Warning: Incomplete 4-byte chunk encountered. Skipping.")
                break
            # Unpack the 4 bytes as an unsigned 32-bit integer.
            # Change '<I' to '>I' if your data is in big-endian format.
            num = struct.unpack('<I', bytes_read)[0]
            numbers.append(num)
    return numbers

def main():

    output_file = "lpFilterTapsBinary.txt"

    # Write each integer's binary representation to the output text file.
    with open(output_file, "w") as out:
        for num in numbers_32:
            binary_str = convert_to_binary(num)
            out.write(binary_str + "\n")
    
    print(f"Converted {len(numbers_32)} numbers to binary and wrote to '{output_file}'.")

if __name__ == "__main__":
    main()
