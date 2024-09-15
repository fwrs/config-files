#!/usr/bin/python3

from base64 import b32decode
from hmac import digest
from time import time
from urllib.parse import urlparse, parse_qs
from subprocess import check_output

url = check_output(["op", "read", "op://Personal/Steam/totp secret"])
query = urlparse(url).query
key_b32 = parse_qs(query)[b"secret"][0]
key = b32decode(key_b32)

t = time()
t_rounded = int(t // 30)
t_bytes = t_rounded.to_bytes(8, byteorder="big")

d = digest(key, t_bytes, "sha1")

d_offset = d[len(d) - 1] & 0x0F
d_value = (d[d_offset] & 0x7F) << 24 | (d[d_offset + 1] & 0xFF) << 16 | (d[d_offset + 2] & 0xFF) << 8 | (d[d_offset + 3] & 0xFF)

alpha_lut = "23456789BCDFGHJKMNPQRTVWXY"

code = ""
for n in range(5):
	code += alpha_lut[d_value % len(alpha_lut)]
	d_value //= len(alpha_lut)

print(code)
