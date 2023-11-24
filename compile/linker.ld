SECTIONS
{
  .text : 
  {
    header.o(.text)
    *(.text)
  }
}