using System;
using System.IO;
using System.Threading.Tasks;
using System.Linq;
using System.Text.Json;
using UndertaleModLib.Util;
using UndertaleModLib.Models;

EnsureDataLoaded();

string exportFolder = PromptChooseDirectory();
string filename = "objectscompatibility.json";
if (exportFolder == null)
    throw new ScriptException("The export folder was not set.");

//Overwrite Check One
if (File.Exists(exportFolder + "\\"+filename))
{
    bool overwriteCheckOne = ScriptQuestion(@"A "+filename+" file already exists. Would you like to overwrite it?");
    if (overwriteCheckOne)
        File.Delete(exportFolder + "\\"+filename);
    if (!overwriteCheckOne)
    {
        ScriptError("A "+filename+" file already exists. Please remove it and try again.", "Error: Export already exists.");
        return;
    }
}

var options = new JsonWriterOptions
{
    Indented = true
};

List<String> objects = new List<String>();
foreach(UndertaleGameObject obj in Data.GameObjects){
    objects.Add(obj.Name.ToString().Trim('\u0022'));
}

String[] objectarray = objects.ToArray();
var json = JsonSerializer.Serialize(objectarray);
File.WriteAllText(exportFolder + "\\"+filename, json);