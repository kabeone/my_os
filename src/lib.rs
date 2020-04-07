#![no_std]
#![feature(asm)]
#![feature(abi_x86_interrupt)]
#![feature(alloc_error_handler)]
#![feature(alloc_layout_extra)]
#![feature(const_fn)]
#![feature(const_in_array_repeat_expressions)]

extern crate alloc;

pub mod interrupts;
pub mod vga_buffer;
pub mod gdt;
pub mod memory;
pub mod allocator;
//pub mod task;

pub fn init() {
    gdt::init();
    interrupts::init_idt();
    unsafe {
        interrupts::PICS.lock().initialize();
    };
    x86_64::instructions::interrupts::enable();
}

pub fn hlt() -> ! {
    loop {
        x86_64::instructions::hlt();
    }
}

#[alloc_error_handler]
fn alloc_error_handler(layout: alloc::alloc::Layout) -> ! {
    panic!("allocation error: {:?}", layout)
}