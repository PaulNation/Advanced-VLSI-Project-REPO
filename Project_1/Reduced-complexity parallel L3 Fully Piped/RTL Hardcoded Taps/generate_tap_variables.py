def generate_tap_variables(input_file, tap_name):
    with open(input_file, 'r') as f:
        taps = [line.strip() for line in f.readlines()]
    
    # Format each tap value as a 32-bit signed binary number
    formatted_taps = [f"32'b{tap}" for tap in taps]
    
    return f"localparam signed [TAP_WIDTH-1:0] {tap_name} [0:TAP_COUNT-1] = '{{{', '.join(formatted_taps)}}};\n\n"

# List of input files and corresponding tap names
tap_files = {
    "H0.txt": "H0_taps",
    "H1.txt": "H1_taps",
    "H2.txt": "H2_taps",
    "H0_H1.txt": "H0_H1_taps",
    "H1_H2.txt": "H1_H2_taps",
    "H0_H1_H2.txt": "H0_H1_H2_taps"
}

# Generate tap variables and write them to a single file
output_filename = "tap_variables.v"
with open(output_filename, 'w') as f:
    for file, tap_name in tap_files.items():
        f.write(generate_tap_variables(file, tap_name))

print(f"All tap variables written to {output_filename}")
