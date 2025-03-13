def generate_sv_with_hardcoded_taps(input_file, output_file):
    with open(input_file, 'r') as f:
        taps = [line.strip() for line in f.readlines()]
    # Format each tap value as a 32-bit signed binary number
    formatted_taps = [f"32'b{tap}" for tap in taps]
    
    sv_module = f"reg signed [TAP_WIDTH-1:0]  taps [0:TAP_COUNT-1] = '{{{', '.join(formatted_taps)}}};\n\n"

    #sv_module = f"""reg signed [TAP_WIDTH-1:0]  taps [0:TAP_COUNT-1] = '{{{', '.join(taps)}}};"""
    
    with open(output_file, 'w') as f:
        f.write(sv_module)

# Example usage
generate_sv_with_hardcoded_taps('lpFilterTapsBinarySigned.txt', 'fir_pipeline_hardcoded_taps.txt')
