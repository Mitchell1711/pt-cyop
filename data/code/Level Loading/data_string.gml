function convert_to_hexstring()
{
    var fileName = get_open_filename("zip file|*.zip", "");
    if (fileName == "")
        return;
    
    var zip = buffer_load(fileName)
    var finalStr = ""
    var f = file_text_open_write(fileName + ".txt")
    for (var i = 0; i < buffer_get_size(zip) / 8; i++)
    {
        var byte = 0;
        var diff = buffer_get_size(zip) - buffer_tell(zip);
        if (diff >= 8)
            byte = buffer_read(zip, buffer_u64)
        else
        {
            for (var j = 0; j < diff; j ++)
            {
                byte += buffer_read(zip, buffer_u8)
            }
        }
        //finalStr += string(byte) + " "
        file_text_write_string(f, string(byte));
        if (i % 10000 == 0)
            show_message("first " + string(i * 8) + " bytes read")
    }
    file_text_close(f)
    show_message("done");
}