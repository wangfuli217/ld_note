value & 0x04     Get
value |= 0x04    Set
value &= ~0x04   Clear

value & (1 << bitnumber)
value |= (1 << bitnumber)
value &= ~(1 << bitnumber)


unsigned int masks[] =
	{0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};

value & masks[bitnumber]
value |= masks[bitnumber]
value &= ~masks[bitnumber]