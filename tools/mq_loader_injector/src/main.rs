use std::fs::File;
use std::io::{self, Read};

fn main() {
    let input_file = "../../build/main.xex";

    let mut file = File::open(input_file).expect("Failed to open input file");
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer).expect("Failed to read file");

    let bank_size = 8192;
    let banks: Vec<&[u8]> = buffer.chunks(bank_size).collect();

    println!(
        "Split into {} banks of {} bytes (last may be smaller)",
        banks.len(),
        bank_size
    );
    if let Some(last_bank) = banks.last() {
        println!("Size of last bank: {} bytes", last_bank.len());
    }

    let mut padded_buffer = buffer.clone();
    let remainder = padded_buffer.len() % bank_size;
    if remainder != 0 {
        let padding = bank_size - remainder;
        padded_buffer.extend(std::iter::repeat(0xff).take(padding));
    }

    let padded_banks: Vec<&[u8]> = padded_buffer.chunks(bank_size).collect();
    println!(
        "After padding, split into {} banks of {} bytes each",
        padded_banks.len(),
        bank_size
    );

    let prefix = "../../build/bank_0.bnk";
    let mut prefix_file = File::open(prefix).expect("Failed to open prefix file");
    let mut prefix_buffer = Vec::new();
    prefix_file
        .read_to_end(&mut prefix_buffer)
        .expect("Failed to read prefix file");

    let mut final_banks = Vec::new();
    final_banks.push(prefix_buffer); // bank 0

    // Move banks 1-5 from padded_banks (skip the first one)
    for bank in padded_banks.iter() {
        final_banks.push(bank.to_vec());
    }

    // Now final_banks[0] is the prefix, final_banks[1..=5] are the next banks
    for (i, bank) in final_banks.iter().enumerate() {
        let filename = format!("../../build/input_bank_{}.bnk", i);
        std::fs::write(&filename, bank).expect("Failed to write bank file");
        println!("Wrote {}", filename);
    }

    // Merge all 5 banks (final_banks[0..5]) into a single file
    let mut merged = Vec::new();
    for bank in final_banks.iter().take(5) {
        merged.extend_from_slice(bank);
    }

    // Pad merged file with 0xFF up to 1048576 bytes (128 banks * 8192)
    let target_size = 1048576;
    if merged.len() < target_size {
        merged.extend(std::iter::repeat(0xFF).take(target_size - merged.len()));
    }

    let merged_filename = "../../build/merged_5banks_padded.bin";
    std::fs::write(&merged_filename, &merged).expect("Failed to write merged file");
    println!("Wrote merged and padded file: {}", merged_filename);
}
