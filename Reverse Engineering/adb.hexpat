// Based ENTIRELY on animals.adb decompressed data
// VERY WIP
import std.sys;
import std.io;
import std.core;
import std.mem;
import type.base;

std::core::set_endian(std::mem::Endian::Big);


char signature[] @ 0x00;
std::assert(signature == "LhBiNaRy####\0", "SIGNATURE MISMATCH!");

u32 colorCount = 0 [[hidden]];
fn CycleColor(str c1, str c2) {
    colorCount += 1;
    return colorCount % 2 == 0 ? c2 : c1;
};

// Waveform size = 0x4E

// Waveforms -> Defines a sound (pitch, duration?) and ties it to a file's filehash.csv value
// SmartVariationEntries -> Ties Waveforms to SmartVariations
// SmartVariations -> Ties SmartVariations to event names (kinda? that's what the FNVMap does too...)
// SplitterEntries -> Ties SmartVariations to Splitters
// Splitters -> ... Randomizes sounds? bee_mult.wav has two waveforms.
//                  Maybe pitch (unkfloat4?) is the only difference?

struct FNVMapItem {
    type::Hex<u32> FNVHash;
    type::Hex<u32> Value;
    u8 unk[10] [[color(0)]];
};

struct FNVHashMap {
    u32 count;
    FNVMapItem items[count];
};
FNVHashMap fnvHashMap @ 0x00000014;

struct fxnamelist {
    u32 nameCount;
    type::Hex<u32> unk_hash;
    type::Hex<u32> sound_hash [[color("00A0FF")]];
};

struct smartvariationentry {
    type::Hex<u32> sound_variation_key [[color("ff00ff")]];
    type::Hex<u32> smart_variation_hash [[color("ffa0ff")]];
    type::Hex<u32> sound [[color("00A0FF")]];
};
struct smartvariationentries {
    u32 sig_len;
    char section_sig[sig_len];
    u32 entrycount;
    smartvariationentry entries[entrycount];
} [[color("ff7f0c")]];
smartvariationentries smart_variation_entries @ std::mem::find_string(0, "SmartVariationEntries") - 4;


u32 readvariation = 0;
fn FormatVariation(u32 c1, u32 c2) {
    readvariation += 1;
    return readvariation % 2 == 0 ? c2 : c1;
};
struct smartvariation {
    u32 smart_variation_hash [[color("ffa0ff")]];
    u32 string_len;
    char variation_name[];
    $ -= 1;
    u32 unklong1;
    u32 unklong2;
} [[color("ff7f0c")]];

struct smartvariations {
    u32 sig_len;
    char section_sig[sig_len];
    u32 variations_count;
    smartvariation variations[variations_count];
} [[color("ff7f0c")]];
smartvariations smartvariations @ std::mem::find_string(0, "SmartVariations") - 4;

struct SplitterEntry {
    type::Hex<u32> hash1;
    type::Hex<u32> splitter [[color("FF00")]];
    type::Hex<u32> smart_variation [[color("ffa0ff")]];
    u32 unk1;
    u32 unk2;
    type::Hex<u32> hash4;
    u32 unk3;
} [[color(CycleColor("0xff3030", "0xA03030"))]];

struct SplitterEntries {
    u32 sig_len;
    char section_sig[sig_len];
    u32 entry_count;
    SplitterEntry entries[entry_count];
} [[color("FF0000")]];
SplitterEntries splitterEntries @ std::mem::find_string(0, "SplitterEntries") - 4;

struct Splitter {
    type::Hex<u32> splitter_hash [[color("FF00")]];
    u32 unk;
    u32 unk1;
    u32 unk2;
    u32 unk3;
    u16 unk4;
    u32 string_len;
    char splitter_name[string_len];
}  [[color("AF")]];

struct Splitters {
    u32 sig_len;
    char section_sig[sig_len];
    u32 count;
    Splitter splitters[count];
};
Splitters splitters @ std::mem::find_string(0, "Splitters") - 4;


struct waveform {
    type::Hex<u32> sound_hash [[color("00A0FF")]];
    type::Hex<u32> audiofile_hash;
    u32 unk3;
    float unkfloat1;
    float unkfloat2;
    float unkfloat3;
    float unkfloat4;
    u32 unk4;
    u32 unk5;
    u32 unk6;
    u32 unk7;
    float unkfloat5;
    u32 unk8;
    s32 unk9;
    u32 unk10;
    u32 unk11;
    u32 unk12;
    bool unkbool1;
    bool unkbool2;
    u32 unk;
} [[color(CycleColor("0xa0f000", "0xa0a000"))]];
std::print(colorCount);



struct waveform_array {
    u32 sig_len;
    char section_sig[sig_len];
    u32 waveformcount;
    waveform forms[waveformcount];
};

waveform_array waveforms @ std::mem::find_string(0, "Waveforms") - 4;

std::print("WOTS UP GUYS");
