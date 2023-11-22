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
// Banks 23, 24, 25
//
// Message file record structure:
// 0xFF ID Ox9B ROW_1 0x9B ROW_2 ... 0x9B ROW_n
//
//
// ----- FONTS -----
// Banks 27..53
//
// Bank 27: ADVMSG.fnt
// Bank 28: pocket.fnt
// Bank 29: F000.FNT
// Bank 30: F001.FNT
// ...
// Bank 53: f024.fnt
//
//
// ----- .SCR TEMPLATES -----
// Bank: 27 ($AFE9..$B1C9) - ADVMSG.SCR - 480 bytes
// Bank: 27 ($B1CA..$B4EA) - POCKET.SCR - 800 bytes
//
// Message file record structure:
// 0xFF ID Ox9B ROW_1 0x9B ROW_2 ... 0x9B ROW_n
//
//
// ----- MAPS (shapes) -----
// Banks 55-XX: "MXXX.map"
//
// ".map" extension is not included.
// The leading '0' of the 4 digit map number is stripped (there are much less than 1000 maps)
// Each "shape" is exactly 800b long
//

use std::{
    collections::BTreeMap,
    fs::{self, File},
    io::{ErrorKind, Read, Write},
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

fn fill_banks_adventure_messages(start: usize, banks: &mut [Vec<u8>]) {
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

        let mut finish = false;
        loop {
            let mut message_buffer = vec![0xFF];
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
                message_buffer[1] - 48,
                message_buffer[2] - 48,
                message_buffer[3] - 48
            );
            println!("\tread message {} - {}", msg_id, {
                let mut s = String::new();
                for i in 3..message_buffer.len() {
                    let c = message_buffer[i];
                    if c != 0xFF && c != 0x9B {
                        if c != 0 && c != 0x0C && c != 0x0D {
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

    let mut current_bank = start;
    let mut current_bank_size = 0;

    [23, 24, 25].into_iter().for_each(|bank_num| {
        let bank = banks.get_mut(bank_num).unwrap();
        for i in 0..BANK_SIZE {
            bank[i] = 0xFF;
        }
    });

    for (id, msg) in &all_msgs {
        let bank = banks.get_mut(current_bank).unwrap();
        let left_in_bank = BANK_SIZE - current_bank_size;
        println!(
            "processing msg {} (len={}) in bank {}. Bytes left: {}",
            id,
            msg.len(),
            current_bank,
            left_in_bank,
        );
        if left_in_bank >= msg.len() {
            for i in msg {
                bank[current_bank_size] = *i;
                current_bank_size += 1;
            }
        } else {
            println!("\tno room in current bank, filling with FF and switching to next");

            current_bank += 1;
            current_bank_size = 0;
        }
    }

    println!(
        "longest message: {} bytes",
        all_msgs
            .into_iter()
            .map(|(_, msg)| msg.len())
            .max()
            .unwrap()
    );
}

fn fill_banks_fonts(start: usize, banks: &mut [Vec<u8>]) {
    println!("\n\n*** FONTS ***\n");

    let paths = [
        "ADVMSG.fnt",
        "pocket.fnt",
        "F000.FNT",
        "F001.FNT",
        "F002.FNT",
        "F003.FNT",
        "F004.FNT",
        "F005.FNT",
        "F006.FNT",
        "F007.FNT",
        "F008.FNT",
        "F009.FNT",
        "F010.FNT",
        "F011.FNT",
        "F012.FNT",
        "F013.FNT",
        "F014.FNT",
        "F015.FNT",
        "F016.FNT",
        "F017.FNT",
        "F018.FNT",
        "F019.FNT",
        "F020.FNT",
        "F021.FNT",
        "F022.FNT",
        "F023.FNT",
        "F024.FNT",
    ];

    let mut current_bank = start;
    for path in paths {
        println!("processing {path} into bank {current_bank}");
        let mut buffer = vec![];
        let mut file = File::open(format!("{}/{}", DATA_PATH, path))
            .unwrap_or_else(|_| panic!("cannot open {:?}", path));

        file.read_to_end(&mut buffer)
            .expect("unable to read from file");
        let bank = banks.get_mut(current_bank).unwrap();
        for i in 0..1024 {
            bank[i] = buffer[i];
        }
        current_bank += 1;
    }
}

fn fill_banks_scr_templates(banks: &mut [Vec<u8>]) {
    println!("processing ADVMSG.SCR into bank 27 @($AFE9..$B1C9)");
    let mut buffer = vec![];
    let mut file = File::open(format!("{}/{}", DATA_PATH, "ADVMSG.SCR"))
        .unwrap_or_else(|_| panic!("cannot open {:?}", "ADVMSG.SCR"));

    file.read_to_end(&mut buffer)
        .expect("unable to read from file");
    let bank = banks.get_mut(27).unwrap();
    for i in 0..480 {
        bank[i + 0xAFE9 - 0xA000] = buffer[i];
    }

    println!("processing POCKET.SCR into bank 27 @($B1CA..$B4EA)");
    let mut buffer = vec![];
    let mut file = File::open(format!("{}/{}", DATA_PATH, "POCKET.SCR"))
        .unwrap_or_else(|_| panic!("cannot open {:?}", "POCKET.SCR"));

    file.read_to_end(&mut buffer)
        .expect("unable to read from file");
    let bank = banks.get_mut(27).unwrap();
    for i in 0..800 {
        bank[i + 0xB1CA - 0xA000] = buffer[i];
    }
}

fn string2num(bytes: &[u8]) -> u8 {
    (bytes[0] - 0x30) * 100 + (bytes[1] - 0x30) * 10 + (bytes[2] - 0x30)
}

fn dump_rendered(r: &[u8]) {
    for i in 0..r.len() {
        if i % 40 == 0 {
            println!();
        }
        let c = r[i];
        print!(
            "{}",
            match c {
                0 => ".",
                _ => "#",
            }
        );
    }
    println!();
}

#[derive(Debug)]
struct MapObject<'a> {
    name: Vec<u8>,
    is_transparent: u8,
    width: u8,
    height: u8,
    bytes: Vec<&'a u8>,
}

fn fill_banks_maps(start: usize, filter: &str, banks: &mut [Vec<u8>]) {
    println!("\n\n*** MAPS ***\n");
    let re = Regex::new(filter).expect("unable to build regex");

    (55..=67).into_iter().for_each(|bank_num| {
        let bank = banks.get_mut(bank_num).unwrap();
        for i in 0..BANK_SIZE {
            bank[i] = 0xFF;
        }
    });

    let mut buffer_ob = vec![];
    let mut file_ob = File::open(format!("{}/{}", DATA_PATH, "ob"))
        .unwrap_or_else(|_| panic!("cannot open {:?}", "ob"));
    file_ob
        .read_to_end(&mut buffer_ob)
        .expect("unable to read from file");
    let mut parts_ob: Vec<_> = buffer_ob.split(|c| c == &0xff).collect();
    parts_ob.remove(0); // Remove first lonely 0xFF
    println!("Loaded {} map objects, parsing...", parts_ob.len());
    let all_objects: Vec<_> = parts_ob
        .iter()
        .map(|ob_part| {
            let chunks: Vec<_> = ob_part.split(|c| c == &0x9b).collect();

            let name = chunks[0];
            print!("\t");
            for c in name {
                print!("{}", *c as char);
            }
            println!();
            let is_transparent = chunks[1][0];
            let width = chunks[1][1];
            let height = chunks[1][2];
            let bytes: Vec<_> = chunks.into_iter().skip(2).flatten().collect();

            MapObject {
                name: name.to_vec(),
                is_transparent,
                width,
                height,
                bytes,
            }
        })
        .collect();

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
            println!("\ndissecting map #{file_counter} - '{filename_str}' ({file_size} b)...",);

            let mut buffer = vec![];
            let mut file = File::open(format!("{}/{}", DATA_PATH, filename_str))
                .unwrap_or_else(|_| panic!("cannot open {:?}", filename_str));

            file.read_to_end(&mut buffer)
                .expect("unable to read from file");

            let mut parts: Vec<_> = buffer.split(|byte| byte == &0x9b).collect();
            parts.remove(parts.len() - 1); // Remove last, lonely part (empty)

            let mut stripped: Vec<u8> = vec![];
            let mut rendered = vec![0u8; 800];

            stripped.extend(parts[0]); // Font number

            let num_builders = string2num(parts[1]);
            println!("\tbuilders: {}", num_builders);
            let mut current_part = 2;
            for i in 0..num_builders {
                let p = parts[current_part];
                current_part += 1;
                let x = p[0];
                let y = p[1];
                let len = p[2];
                let rep = p[3];
                println!(
                    "\t\t{:2}/{num_builders:2} - {x:2},{y:2} - len={len:2} rep={rep:2}",
                    i + 1
                );
                let stamp: Vec<_> = p.iter().skip(4).take(len as usize).collect();
                for j in 0..rep {
                    for (i, c) in stamp.iter().enumerate() {
                        rendered[(y as u32 * 40 + x as u32 + i as u32 + j as u32 * len as u32)
                            as usize] = **c;
                    }
                }
            }
            println!("\n\nRendered map geometry:");
            dump_rendered(&rendered);

            let num_objects_part = current_part + 8;
            assert_eq!(parts[num_objects_part].len(), 5);

            let logic_dll_number = &parts[num_objects_part][0..2];
            stripped.extend(logic_dll_number); // Logic number dll
            stripped.extend(parts[current_part]); // Link to the right
            stripped.extend(parts[current_part + 1]); // Link to the left
            stripped.extend(parts[current_part + 2]); // Link to the left
            stripped.extend(parts[current_part + 3]); // Link to the left
            stripped.extend(parts.last().expect("should have last part").iter());
            stripped.push(0x9b);

            let num_objects = string2num(&parts[num_objects_part][2..]);
            println!("\t{num_objects} object types on this map");

            current_part = num_objects_part + 1;
            for obi in 0..num_objects {
                let name_part = parts[current_part];
                print!("\t\t{}/{} - ", obi + 1, num_objects);
                for c in name_part.iter().take(5) {
                    print!("{}", *c as char);
                }
                println!();
                let mut st = 5;
                loop {
                    let x = name_part[st + 0];
                    let y = name_part[st + 1];
                    println!("\t\t\tat {},{}", x, y);
                    let obj = all_objects
                        .iter()
                        .find(|obj| obj.name == name_part[0..5])
                        .expect("should have object");

                    let mut cur_x = x;
                    let mut cur_y = y;
                    let mut cur_width = obj.width;
                    for b in &obj.bytes {
                        rendered[cur_y as usize * 40 + cur_x as usize] = **b;
                        cur_width -= 1;
                        if cur_width == 0 {
                            cur_width = obj.width;
                            cur_x = x;
                            cur_y += 1;
                        } else {
                            cur_x += 1;
                        }
                    }

                    if st + 2 == name_part.len() {
                        break;
                    }
                    st += 2;
                }

                current_part += 1;
            }

            println!("\n\nRendered map objects on top of geometry:");
            dump_rendered(&rendered);

            let num_items = string2num(parts[current_part]);
            stripped.push(num_items);
            println!("\t{num_items} items on this map");
            for ii in 0..num_items {
                print!("\t\t{}/{} - ", ii + 1, num_items);
                let item_name = &parts[current_part + 1 + ii as usize][0..5];
                for c in item_name.iter().take(5) {
                    print!("{}", *c as char);
                }
                let item_x = string2num(&parts[current_part + 1 + ii as usize][6..9]);
                let item_y = string2num(&parts[current_part + 1 + ii as usize][10..13]);
                println!(" - at {},{}", item_x, item_y);
                stripped.extend(item_name);
                stripped.push(item_x);
                stripped.push(item_y);
            }
            dbg!(&stripped);

            // Map structure:
            // - XXX - Font number (0x9b)
            // - XXX - Number of "builders" (9b) , where each builder is:
            //      - xpos - 1 byte
            //      - ypos - 1 byte
            //      - len  - 1 byte
            //      - rep  - 1 byte
            //      - pattern itself
            //      - 0x9b
            // - XXXX - link to map on the right (9b)
            // - XXXX - link to map on the left (9b)
            // - XXXX - link to map on the top (9b)
            // - XXXX - link to map on the bottom (9b)
            // - XXX - COLOR 1 (9b)
            // - XXX - COLOR 1 (VBXE) (9b)
            // - XXX - COLOR 2 (9b)
            // - XXX - COLOR 2 (VBXE) (9b)
            // - XX - logic DLL number
            // - XXX - number of objects (9b), for each object:
            //      - XXXXX - name of the object
            //      - xpos - 1 byte
            //      - ypos - 1 byte
            //      - xpos - 1 byte
            //      - ypos - 1 byte
            //      - ... repeat until 9b
            // - XXX - number of items (9b), for each item:
            //      - XXXXX - name of the item (9b)
            //      - comma (0x2c)
            //      - XXX - xpos (9b)
            //      - comma (0x2c)
            //      - XXX - ypos (9b)
            // - Level Name (9b)

            // Stripped structure
            // XXX  - font number
            // XX   - logic DLL number
            // XXXX - link to map on the right
            // XXXX - link to map on the left
            // XXXX - link to map on the top
            // XXXX - link to map on the bottom
            // - Level Name
            // X    - 9b
            // X    - number of items
            //      XXXXX   - item name
            //      X       - X pos
            //      Y       - Y pos
        }
    }

    // let paths = fs::read_dir(DATA_PATH).expect("unable to read data path");
    // for path in paths {
    //     let path = path.expect("path error");
    //     let filename = path.file_name();
    //     let filename_str = filename.to_str().expect("unable to get filename as &str");

    //     if re.is_match(filename_str) {
    //         let file_size = path.metadata().unwrap().len();
    //         println!("\nprocessing file #{file_counter} - '{filename_str}' ({file_size} b)...",);
    //     }
    // }
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
    fill_banks_adventure_messages(23, &mut banks);
    fill_banks_fonts(27, &mut banks);
    fill_banks_scr_templates(&mut banks);
    fill_banks_maps(55, r"[m|M]\d\d\d\d\.[m|M][a|A][p|P]", &mut banks);

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
