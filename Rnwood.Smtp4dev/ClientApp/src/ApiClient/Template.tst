﻿${
    using Typewriter.Extensions.WebApi;
 
    string ReturnType(Method m) => m.Type.Name == "IActionResult" ? "void" : m.Type.Name;
    string ParamType(Parameter p) => p.Type.Name.Replace("Delta<", "Partial<");
    string ServiceName(Class c) => c.Name;
     
    string Imports(Class c){
        List<string> neededImports = c.Properties
	        .Where(p => !p.Type.IsPrimitive && p.Type.Name.TrimEnd('[',']')  != c.Name)
	        .Select(p => "//" +  p.Type.Name + " from " + c.Name + "\nimport " + p.Type.Name.TrimEnd('[',']') + " from './" + p.Type.Name.TrimEnd('[',']') + "';").ToList();
        if (c.BaseClass != null) { 
	        neededImports.Add("import " + c.BaseClass.Name +" from './" + c.BaseClass.Name + "';");
        }
        return String.Join("\n", neededImports.Distinct());
    }
     
    string ControllerImports(Class c){
        List<string> returnTypeImports = c.Methods
	        .Where(m => !m.Type.IsPrimitive && !m.Type.Name.Contains("void") && m.Type.Name != "IActionResult")
	        .Select(p => "import " + p.Type.Name.TrimEnd('[',']') + " from './" + p.Type.Name.TrimEnd('[',']') + "';").ToList();

        List<string> paramTypeImports = c.Methods
            .SelectMany(m => m.Parameters)
	        .Where(p => !p.Type.IsPrimitive)
	        .Select(p => "import " + p.Type.Name.TrimEnd('[',']') + " from './" + p.Type.Name.TrimEnd('[',']') + "';").ToList();


        return String.Join("\n", returnTypeImports.Concat(paramTypeImports).Distinct());
    } 
}
$Classes(c => c.Namespace == "Rnwood.Smtp4dev.ApiModel")[$Imports
export default class $Name$TypeParameters {
 
    constructor($Properties(p => !p.Attributes.Any(a => a.Name.Contains("JsonIgnoreAttribute")))[$name: $Type, ]) {
        $Properties(p => !p.Attributes.Any(a => a.Name.Contains("JsonIgnoreAttribute")))[ 
        this.$name = $name;]
    }

    $Properties(p => !p.Attributes.Any(a => a.Name.Contains("JsonIgnoreAttribute")))[ 
    $name: $Type;]
}]
$Classes(*Controller)[$ControllerImports
import axios from "axios";

export default class $ServiceName {
               
    constructor(){
    }
        
    $Methods[
    
    // $HttpMethod: $Url  
    public $name_url($Parameters(p => p.Type.IsPrimitive)[$name: $Type][, ]): string {
        return `$Url`;
    }

    public async $name($Parameters[$name: $ParamType][, ]): Promise<$ReturnType> {

        return (await axios.$HttpMethod(this.$name_url($Parameters(p => p.Type.IsPrimitive)[$name][, ]), $RequestData || undefined)).data as $ReturnType;
    }]
}]