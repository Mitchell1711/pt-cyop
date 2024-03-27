function levelsUrl(argument0, argument1, argument2, argument3, argument4, argument5) //page, type, filter, perPage, isOldCustom, search
//(int page, TypeFilter type, FeedFilter filter, GameBananaCategory category, GameBananaCategory subcategory, int perPage, bool nsfw, string search)
{
    var page = argument0;
    var type = argument1;
    var filter = argument2;
    var ids = ["22962", "21991"]
    var category = struct_new([["Name", "Custom Levels"], ["ID", ids[argument4]]])//argument3;
    var subcategory = struct_new([["ID", undefined]])//argument4;
    var perPage = argument3;
    ///var nsfw = argument4;
    var search = argument5;
    
    var TypeFilter = struct_new([
        ["Mods", 0],
        ["Sounds", 1],
        ["WiPs", 2]
    ])
    
    var FeedFilter = struct_new([
        ["Recent", 0],
        ["Featured", 1],
        ["Popular", 2]
    ])
    
    // Base
    var url = "https://gamebanana.com/apiv6/";
    switch (type)
    {
        case TypeFilter.Mods:
            url += "Mod/";
            break;
        case TypeFilter.Sounds:
            url += "Sound/";
            break;
        case TypeFilter.WiPs:
            category.ID = "1928";
            url += "Wip/";
            break;
    }
    // Different starting endpoint if requesting all mods instead of specific category
    if (search != undefined)
        url += "ByName?_sName=*" + string(search) + "*&_idGameRow=7692&";
    else if (category.ID != undefined)
        url += "ByCategory?";
    else
        url += "ByGame?_aGameRowIds[]=7692&";
    // Consistent args
    url += "_csvProperties=_sName,_sModelName,_sProfileUrl,_aSubmitter,_tsDateUpdated,_tsDateAdded,_aPreviewMedia,_sText,_sDescription,_aCategory,_aRootCategory,_aGame,_nViewCount," +
        "_nLikeCount,_nDownloadCount,_aFiles,_aModManagerIntegrations,_bIsNsfw,_aAlternateFileSources&_nPerpage=" + string(perPage);
    //if (!nsfw)
    url += "&_aArgs[]=_sbIsNsfw = false";
    // Sorting filter
    switch (filter)
    {
        case FeedFilter.Recent:
            url += "&_sOrderBy=_tsDateUpdated,DESC";
            break;
        case FeedFilter.Featured:
            url += "&_aArgs[]=_sbWasFeatured = true& _sOrderBy=_tsDateAdded,DESC";
            break;
        case FeedFilter.Popular:
            url += "&_sOrderBy=_nDownloadCount,DESC";
            break;
    }
    // Choose subcategory or category
    if (subcategory.ID != undefined)
        url += "&_aCategoryRowIds[]=" + subcategory.ID;
    else if (category.ID != undefined)
        url += "&_aCategoryRowIds[]=" + category.ID;
    
    // Get page number
    url += "&_nPage=" + string(page);
    
    //get_string("", url)
    return url;
}