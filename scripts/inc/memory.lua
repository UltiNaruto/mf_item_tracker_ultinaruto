function get_address(memory_type, address)
	if memory_type == "IRAM" then
		return 0x03000000 + address
	end
	if memory_type == "ROM" then
		return 0x08000000 + address
	end
	return nil
end

function read_u8(memory_type, address)
	return AutoTracker:ReadU8(get_address(memory_type, address), 0)
end

function read_u16(memory_type, address)
	return read_u8(memory_type, address + 1) << 8 |
		   read_u8(memory_type, address)
end

function read_u32(memory_type, address)
	return read_u8(memory_type, address + 3) << 24 |
           read_u8(memory_type, address + 2) << 16 |
		   read_u8(memory_type, address + 1) << 8 |
		   read_u8(memory_type, address)
end

function read_s8(memory_type, address)
	return AutoTracker:ReadS8(get_address(memory_type, address), 0)
end

function read_s16(memory_type, address)
	return read_s8(memory_type, address + 1) << 8 |
		   read_s8(memory_type, address)
end

function read_s32(memory_type, address)
	return read_s8(memory_type, address + 3) << 24 |
           read_s8(memory_type, address + 2) << 16 |
		   read_s8(memory_type, address + 1) << 8 |
		   read_s8(memory_type, address)
end

function read_char(memory_type, address)
	return string.char(read_u8(memory_type, address))
end

function read_string(memory_type, address, length)
	str = ""
	for i=1,length do
		str = str..read_char(memory_type, address+(i - 1))
	end
	return str
end