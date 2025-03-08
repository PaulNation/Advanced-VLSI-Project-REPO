
numbers_32 = [-503524,    -1890226,    -4979597,   -10625992,   -19534716,   -31897586,
     -47029310,   -63130666,   -77321328,   -86037964,   -85794376,   -74168423,
     -50760427,   -17804280,    19851701,    55534092,    82217350,    94351153,
      89532901,    69480321,    39899711,     9149420,   -14022239,   -23043559,
     -15599634,     5492156,    32996881,    57458657,    70257434,    66559117,
      47147262,    18425901,    -9538556,   -26397842,   -25244497,    -5387713,
      26878433,    59959737,    80722339,    79194170,    52650844,     7611173,
     -41138873,   -74436580,   -74508942,   -30879372,    55483563,   171219331,
     293325340,   394949726,   452592558,   452592558,   394949726,   293325340,
     171219331,    55483563,   -30879372,   -74508942,   -74436580,   -41138873,
       7611173,    52650844,    79194170,    80722339,    59959737,    26878433,
      -5387713,   -25244497,   -26397842,    -9538556,    18425901,    47147262,
      66559117,    70257434,    57458657,    32996881,     5492156,   -15599634,
     -23043559,   -14022239,     9149420,    39899711,    69480321,    89532901,
      94351153,    82217350,    55534092,    19851701,   -17804280,   -50760427,
     -74168423,   -85794376,   -86037964,   -77321328,   -63130666,   -47029310,
     -31897586,   -19534716,   -10625992,    -4979597,    -1890226,     -503524]

def convert_to_binary(num):
    # Format the number as a 32-bit binary string with leading zeros.
    return format(num & 0xffffffff, '032b')


def main():
    # Extract even and odd indexed values
    H0 = [numbers_32[i] for i in range(0, len(numbers_32), 2)]
    H1 = [numbers_32[i] for i in range(1, len(numbers_32), 2)]

    # Convert to binary
    H0_binary = [convert_to_binary(num) for num in H0]
    H1_binary = [convert_to_binary(num) for num in H1]

    # Element-wise sum of H0 and H1
    H0_H1 = [H0[i] + H1[i] for i in range(len(H0))]
    H0_H1_binary = [convert_to_binary(num) for num in H0_H1]

    # Define output directory
    output_dir = r"C:\Users\nievep\Downloads\Advanced VLSI Design\Project 1\REPO\Advanced-VLSI-Project-REPO\Project 1\Reduced-complexity parallel processing L=2\Python Scripts\Parrellel Coefs\\"

    # Write to files
    with open(output_dir + "H0.txt", "w") as f:
        f.write("\n".join(H0_binary))

    with open(output_dir + "H1.txt", "w") as f:
        f.write("\n".join(H1_binary))

    with open(output_dir + "H0_H1.txt", "w") as f:
        f.write("\n".join(H0_H1_binary))

    print("Files H0.txt, H1.txt, and H0_H1.txt have been created successfully in", output_dir)


if __name__ == "__main__":
    main()
