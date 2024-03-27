if (window_has_focus() != lastFocus)
{
    with obj_modAssets
    {
        modAssets_extractTowers();
    }
    loadTowerList();
}
lastFocus = window_has_focus();