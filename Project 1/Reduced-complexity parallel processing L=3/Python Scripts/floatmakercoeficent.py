import numpy as np

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

# Function to convert to 32-bit binary representation
def convert_to_binary(num):
    return format(num & 0xffffffff, '032b')  # Keep 32-bit signed format

# Polyphase decomposition with M=3
N = len(numbers_32)  # Number of taps (102)
M = 3  # Number of polyphase components

# Split into three polyphase components
H0 = np.array(numbers_32[0::M], dtype=np.int32)  # h[0], h[3], h[6], ...
H1 = np.array(numbers_32[1::M], dtype=np.int32)  # h[1], h[4], h[7], ...
H2 = np.array(numbers_32[2::M], dtype=np.int32)  # h[2], h[5], h[8], ...

# Compute element-wise sums
H0_H1 = H0 + H1
H1_H2 = H1 + H2
H0_H1_H2 = H0 + H1 + H2

# Save results to separate files with binary representation
def save_polyphase_to_file(filename, data):
    with open(filename, "w") as f:
        for num in data:
            f.write(convert_to_binary(num) + "\n")

save_polyphase_to_file("H0.txt", H0)
save_polyphase_to_file("H1.txt", H1)
save_polyphase_to_file("H2.txt", H2)
save_polyphase_to_file("H0_H1.txt", H0_H1)
save_polyphase_to_file("H1_H2.txt", H1_H2)
save_polyphase_to_file("H0_H1_H2.txt", H0_H1_H2)

print("\nPolyphase decomposition and summations complete. Files saved:")
print(" - H0.txt")
print(" - H1.txt")
print(" - H2.txt")
print(" - H0_H1.txt")
print(" - H1_H2.txt")
print(" - H0_H1_H2.txt")