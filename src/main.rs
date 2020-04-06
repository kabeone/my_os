#![no_std]
#![no_main]
#![feature(asm)]
#![feature(abi_x86_interrupt)]
#![feature(panic_info_message)]

extern crate alloc;

pub mod vga_buffer;
pub mod interrupts;
pub mod gdt;

use core::panic::PanicInfo;
use bootloader::{BootInfo, entry_point};
use alloc::{vec, vec::Vec, rc::Rc};
use x86_64::VirtAddr;
use os::memory::{self, BootInfoFrameAllocator};
use os::allocator;

entry_point!(kernel_main);

#[panic_handler]
fn panic(info: &PanicInfo) -> !{
    println!("{}\n", info.message().unwrap());
    os::hlt();
}

fn kernel_main(boot_info: &'static BootInfo) -> ! {
    os::init();

    let phys_mem_offset = VirtAddr::new(boot_info.physical_memory_offset);
    let mut mapper = unsafe { memory::init(phys_mem_offset) };
    let mut frame_allocator = unsafe {
        BootInfoFrameAllocator::init(&boot_info.memory_map)
    };

    allocator::init_heap(&mut mapper, &mut frame_allocator)
        .expect("heap initialization failed");

    let mut vec = Vec::new();
    for i in 0..500 {
        vec.push(i);
    }
    println!("vec at {:p}", vec.as_slice());

    let reference_counted = Rc::new(vec![1, 2, 3]);
    let cloned_reference = reference_counted.clone();
    println!("current reference count is {}", Rc::strong_count(&cloned_reference));
    core::mem::drop(reference_counted);
    println!("reference count is {} now", Rc::strong_count(&cloned_reference));
    
    os::hlt();
}