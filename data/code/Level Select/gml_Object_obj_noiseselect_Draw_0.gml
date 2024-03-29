shader_set(global.Pal_Shader)
if(!is_string(global.currentsavefile)){
    var game = global.gameN[(global.currentsavefile - 1)]
    var pal = game.palette_player2
    var tex = game.palettetexture_player2
}
else{
    var palinfo = get_noise_palette_info()
    var pal = palinfo.paletteselect
    var tex = palinfo.patterntexture
}
pattern_set(global.Base_Pattern_Color, sprite_index, image_index, image_xscale, image_yscale, tex)
pal_swap_set(spr_noisepalette, pal, 0)
draw_self()
pattern_reset()
shader_reset()
