# pt-new-level-editor
Public repo for PizzaTower's Make your own Pizza mod

# Editing source code
You will NEED to use either SrPerez' ([UTMT Fork](https://github.com/GithubSPerez/UndertaleModTool)) or ([UTMT Community edition](https://gamebanana.com/tools/14193)) to import these scripts as those implement the struct support used for this project.

If you want to import scripts into UTMTCE use the included ImportGMLRecursive.csx script, this will grab all .gml files from all folders in the directory. The collision scripts are in their own seperate folder, if you include these in the import don't choose the option to automatically link all imported code, since it can mess with a bunch of unrelated object references. If you do then a popup will come up asking to supply an object id, just close this and UTMT should stop trying to import it.

Alternatively you can work with the same workflow as SrPerez did by using his fork, then moving all of the code entries into the main "code" directory without any subfolders. This allows you to sync up code changes between your external IDE and UTMT. I personally found this not much better than just importing manually however since it only seems to sync scripts when you open them in UTMT as well, plus you won't be able to use subfolders for organization. Perhaps something that's still worth looking into though.

Just place your game files (minus the steam .dlls) in the directory, rename your game .exe to "PizzaTower_GM2" and you'll be able to work on this the same as I do.

# Issues section is only for bug reports!!
### To make a bug report you should provide both a tower file (if the bug is related to gameplay) and a reliable way to replicate the bug, otherwise it's not helpful.
### Don't open an issue to propose a feature.
