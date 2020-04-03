ENTRY(main);

PHDRS
{
	code PT_LOAD;
	headers PT_PHDR FILEHDR PHDRS;
}

SECTIONS
{       
	.text 0x600: ALIGN(0x100) { *(.text) } :code       
	.data : { *(.data) } 
	.bss : { *(.bss) }   
	/DISCARD/ : { *(.eh_frame) }
}

