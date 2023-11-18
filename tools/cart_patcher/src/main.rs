// The idea is to load the .bin image initialized with `main.xex` and put auxiliary data
// in additional banks according to the following schema:
//
// ----- ADVENTURE PICTURES -----
// Banks 16-21: "PXXX.sra"
//
// ".sra" extension is not included.
// Data in these banks is terminated with "DUPA"
//
//
// ----- ADVENTURE MESSAGES -----
// Banks 23. 24, 25
//
// Message file record structure:
// 0xFF ID Ox9B ROW_1 0x9B ROW_2 ... 0x9B ROW_n

use std::{
    collections::{BTreeMap, BTreeSet},
    fs::{self, File},
    io::{self, ErrorKind, Read, Write},
    path::Path,
};

use regex::Regex;

const CART_PATH: &str = "../../build/rzygon.bin";
const BANK_SIZE: usize = 1024 * 8;
const CART_SIZE: usize = 128 * BANK_SIZE;
const DATA_PATH: &str = "../../build/";

fn fill_banks_adventure_pictures(start: usize, filter: &str, banks: &mut [Vec<u8>]) {
    println!("\n\n*** ADVENTURE PICTURES ***\n");
    let re = Regex::new(filter).expect("unable to build regex");

    let mut current_bank = start;
    let mut current_bank_size = 0;
    let mut file_counter = 1;
    let paths = fs::read_dir(DATA_PATH).expect("unable to read data path");
    for path in paths {
        let path = path.expect("path error");
        let filename = path.file_name();
        let filename_str = filename.to_str().expect("unable to get filename as &str");

        if re.is_match(filename_str) {
            let file_size = path.metadata().unwrap().len();
            println!("\nprocessing file #{file_counter} - '{filename_str}' ({file_size} b)...",);
            file_counter += 1;

            let mut bank = banks.get_mut(current_bank).unwrap();

            let left_in_bank = BANK_SIZE - current_bank_size;
            println!("\tspace left in bank: {left_in_bank}");
            // -4 to be able to fit DUPA
            // +4 to be able to fit file ID
            if left_in_bank - 4 < file_size as usize + 4 {
                println!("\tno room in current bank, switching to next");
                bank[current_bank_size] = b'D';
                bank[current_bank_size + 1] = b'U';
                bank[current_bank_size + 2] = b'P';
                bank[current_bank_size + 3] = b'A';
                current_bank += 1;
                bank = banks.get_mut(current_bank).unwrap();
                current_bank_size = 0;
            } else {
                println!("\tcontinuing with current bank")
            }

            let mut buffer = vec![];
            let full_path = Path::new(DATA_PATH);
            let full_path = full_path.join(filename_str);
            let mut file = File::open(full_path.clone())
                .unwrap_or_else(|_| panic!("cannot open {:?}", full_path));
            let _ = file
                .read_to_end(&mut buffer)
                .unwrap_or_else(|_| panic!("unable to read {:?}", full_path));

            bank[current_bank_size] = filename_str.to_uppercase().as_bytes()[0];
            bank[current_bank_size + 1] = filename_str.to_uppercase().as_bytes()[1];
            bank[current_bank_size + 2] = filename_str.to_uppercase().as_bytes()[2];
            bank[current_bank_size + 3] = filename_str.to_uppercase().as_bytes()[3];
            current_bank_size += 4;
            bank[current_bank_size..(buffer.len() + current_bank_size)]
                .copy_from_slice(&buffer[..]);
            current_bank_size += file_size as usize;

            println!(
                "\tadded '{filename_str}' to bank {current_bank} - bank size {current_bank_size}"
            );
        }
    }
    let bank = banks.get_mut(current_bank).unwrap();
    bank[current_bank_size] = b'D';
    bank[current_bank_size + 1] = b'U';
    bank[current_bank_size + 2] = b'P';
    bank[current_bank_size + 3] = b'A';
}

fn fill_banks_adventure_messages(banks: &mut [Vec<u8>]) {
    println!("\n\n*** ADVENTURE MESSAGES ***\n");
    let paths = [format!("{}/mt", DATA_PATH), format!("{}/ms", DATA_PATH)];
    let mut all_msgs = BTreeMap::new();
    for path in paths {
        println!("processing {path}");
        let mut buffer = vec![0_u8];
        let mut file =
            File::open(path.clone()).unwrap_or_else(|_| panic!("cannot open {:?}", path));

        file.read_exact(&mut buffer)
            .expect("unable to read from file");
        assert_eq!(buffer[0], 0xFF);

        let mut finish = false;
        loop {
            let mut message_buffer = vec![];
            loop {
                match file.read_exact(&mut buffer) {
                    Ok(_) => {
                        if buffer[0] == 0xFF {
                            break;
                        }
                        message_buffer.extend(buffer.clone());
                    }
                    Err(err) if err.kind() == ErrorKind::UnexpectedEof => {
                        message_buffer.extend(buffer.clone());
                        finish = true;
                        break;
                    }
                    Err(err) => {
                        panic!("read error: {err}");
                    }
                }
            }

            let msg_id = format!(
                "{}{}{}",
                message_buffer[0] - 48,
                message_buffer[1] - 48,
                message_buffer[2] - 48
            );
            println!("\tread message {} - {}", msg_id, {
                let mut s = String::new();
                for i in 3..message_buffer.len() {
                    let c = message_buffer[i];
                    if c != 0xFF && c != 0x9B {
                        if c != 0 && c != 0x0C && c != 0x0D{
                            if c.is_ascii() {
                                s.push(c as char);
                            }
                        } else {
                            s.push(' ');
                        }
                    }
                }
                s
            });

            all_msgs.insert(msg_id, message_buffer.clone());
            message_buffer.clear();
            if finish {
                break;
            }
        }
    }
}

fn main() {
    let mut file = File::open(CART_PATH).expect("cannot open cart file");
    let mut buffer = Vec::with_capacity(CART_SIZE); // 128 8kb banks
    let read = file
        .read_to_end(&mut buffer)
        .expect("unable to read cart file");
    assert_eq!(CART_SIZE, read);

    let mut banks: Vec<Vec<u8>> = buffer
        .chunks(BANK_SIZE)
        .map(|chunk| chunk.to_vec())
        .collect();

    fill_banks_adventure_pictures(16, r"[p|P]\d\d\d\.[s|S][r|R][a|A]", &mut banks);
    fill_banks_adventure_messages(&mut banks);

    let mut cart = vec![];
    for bank in banks {
        cart.extend(bank);
    }

    let mut file = fs::OpenOptions::new()
        .write(true)
        .open(CART_PATH)
        .expect("cannot open cart file");
    file.write_all(cart.as_slice())
        .expect("unable to write to cart file");
    println!("written to {CART_PATH}");
}
