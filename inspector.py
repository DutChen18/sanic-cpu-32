with open("load-32-bit-max.bin", "rb") as f:
    byte_data = f.read()

binary_string = ""
for byte in byte_data:
    binary_string += bin(byte)[2:].zfill(8)

print(binary_string)