#include <assert.h>
#include <stdint.h>
#include <stdio.h>

// packet:
//   vvv - version (msb first, e.g. 100 => 4)
//   ttt - type id
//   if ttt == 4: // literal value
//     leading-0-padded until multiple of 4 bits, then in 4-bit groups:
//     N * (1bbbb) - leading groups
//     0bbbb - last group
//   if ttt != 4: // operator
//     0 // length-type-id = 0 ==> next 15 bits contain total length
//     1 // length-type-id = 1 ==> next 11 bits contain count of sub-pakets

int bits[100000];
int bits_consumed = 0;
int bits_loaded = 0;

int getbit() {
  if (bits_consumed == bits_loaded) {
    int c = getchar();
    // printf("read char: %d\n", c);
    assert(c != EOF);
    int value = c - '0';
    if (c >= 'A' && c <= 'Z') {
      value = c - 'A' + 10;
    }
    // printf("read value: %d\n", value);
    for (int n = 3; n >= 0; n -= 1) {
      // printf("set n=%d to %d\n", bits_loaded + n, value % 2);
      bits[bits_loaded + n] = value % 2;
      value /= 2;
    }
    bits_loaded += 4;
  }
  int b = bits[bits_consumed];
  bits_consumed += 1;
  // printf("%d", b);
  return b;
}

int readnum(int len) {
  int n = 0;
  for (int l = 0; l < len; l += 1) {
    n *= 2;
    int b = getbit();
    if (b == -1) return -1;
    n += b;
  }
  return n;
}

void discardbits(int n) {
  for (int i = 0; i < n; i += 1) {
    getbit();
  }
}

int total_version_count = 0;

void processpacket(int ptype, int idx, int64_t value, int64_t* state) {
  switch (ptype) {
    case 0:  // sum
      if (idx == 0) *state = 0;
      *state += value;
      return;
    case 1:  // product
      if (idx == 0) *state = 1;
      *state *= value;
      return;
    case 2:  // minimum
      if (idx == 0) *state = value;
      if (value < *state) *state = value;
      return;
    case 3:  // maximum
      if (idx == 0) *state = value;
      if (value > *state) *state = value;
      return;
    case 5:  // first greater-than second
      if (idx == 0)
        *state = value;
      else if (idx == 1)
        *state = (*state > value) ? 1 : 0;
      else
        assert("invalid greater-than packet");
      return;
    case 6:  // first less-than second
      if (idx == 0)
        *state = value;
      else if (idx == 1)
        *state = (*state < value) ? 1 : 0;
      else
        assert("invalid less-than packet");
      return;
    case 7:  // first equal-to second
      if (idx == 0)
        *state = value;
      else if (idx == 1)
        *state = (*state == value) ? 1 : 0;
      else
        assert("invalid equal-to packet");
      return;
    default:
      assert("invalid operator packet");
  }
}

int64_t readpacket() {
  int pversion = readnum(3);
  total_version_count += pversion;
  int ptype = readnum(3);
  if (ptype == 4) {
    // printf("literal packet, version: %d\n", pversion);
    int needmore = 1;
    int64_t value = 0;
    do {
      needmore = getbit();
      value *= 16;
      value += readnum(4);
    } while (needmore == 1);
    return value;
  } else {
    // printf("operator packet, version: %d\n", pversion);
    int lengthtypeid = getbit();
    if (lengthtypeid == 0) {
      int64_t state = 0;
      int len = readnum(15);
      int bits_consumed_before = bits_consumed;
      int packetidx = 0;
      while (bits_consumed < bits_consumed_before + len) {
        int64_t v = readpacket();
        processpacket(ptype, packetidx, v, &state);
        packetidx += 1;
      }
      return state;
    } else if (lengthtypeid == 1) {
      int64_t state = 0;
      int count = readnum(11);
      int packetidx = 0;
      for (int c = 0; c < count; c += 1) {
        int64_t v = readpacket();
        processpacket(ptype, packetidx, v, &state);
        packetidx += 1;
      }
      return state;
    } else {
      assert("error: invalid operator packet");
      return -1;
    }
  }
}

#include <stdio.h>
int main() {
  int64_t value = readpacket();
  printf("total_version_count: %d\n", total_version_count);
  printf("value: %ld\n", value);
}
