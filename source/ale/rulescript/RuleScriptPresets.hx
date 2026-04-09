package ale.rulescript;

import sys.FileSystem;
import sys.io.File;

import rulescript.scriptedClass.RuleScriptedClassUtil;
import rulescript.scriptedClass.RuleScriptedClass;
import rulescript.interps.RuleScriptInterp;
import rulescript.types.ScriptedTypeUtil;
import rulescript.types.ScriptedModule;
import rulescript.RuleScript as OGRuleScript;
import rulescript.Tools;

import haxe.Exception;

import hscript.Expr;

using StringTools;

class RuleScriptPresets
{
    public static final FILE_CHECKER:String -> Bool = FileSystem.exists;

    public static final FILE_READER:String -> String = File.getContent;

    
    public static final IMPORTS:Array<Class<Dynamic>> = [
        Array,
        Date,
        DateTools,
        EReg,
        IntIterator,
        Lambda,
        List,
        Math,
        Reflect,
        Std,
        StringBuf,
        StringTools,
        Sys,
        Xml
    ];
    
    public static final ABSTRACTS:Array<String> = [];

    public static final TYPEDEFS:Map<String, Class<Dynamic>> = [];

    public static final VARIABLES:Map<String, Dynamic> = [];


    public static final MODULE_EXTENSION:String = '.hx';

    public static final MODULE_PATH:String = 'scripts/classes/';

    public static function MODULE_RESOLVER(name:String):Array<ModuleDecl>
    {
        final path:Array<String> = name.split('.');

        final pack:Array<String> = [];

        while (path[0].charAt(0) == path[0].charAt(0).toLowerCase())
            pack.push(path.shift());

        final moduleName:String = path.length > 1 ? path.shift() : null;

        final filePath:String = RuleScriptGlobal.MODULE_PATH + (pack.length >= 1 ? pack.join('.') + '.' + (moduleName ?? path[0]) : path[0]).replace('.', '/') + RuleScriptGlobal.MODULE_EXTENSION;

        if (!RuleScriptGlobal.FILE_CHECKER(filePath))
            return null;

        return new HxParser(name, MODULE).parseModule(RuleScriptGlobal.FILE_READER(filePath));
    }

    
    public static final SCRIPT_PATH:String = 'scripts/';

    public static final SCRIPT_EXTENSION:String = '.hx';

    public static function SCRIPT_RESOLVER(name:String):Dynamic
    {
        final path:TypePath = Tools.parseTypePath(name);

        final module:Array<ModuleDecl> = ScriptedTypeUtil.resolveModule(path.modulePath());

        @:privateAccess
        return module == null ? null : new ScriptedModule(path.modulePath(), module, ScriptedTypeUtil._currentContext).types[path.typeName];
    }
    

    public static function BUILD_BRIDGE(typePath:String, superInstance:Dynamic):OGRuleScript
    {
        final type:Dynamic = ScriptedTypeUtil.resolveScript(typePath);

        final script:RuleScript = new RuleScript(typePath);
        script.getInterp(RuleScriptInterp).skipNextRestore = true;
        script.superInstance = superInstance;

        if (type.isExpr)
            script.execute(cast type);
        else
            RuleScriptedClassUtil.buildScriptedClass(cast (type, ScriptedClass), script);

        return script;
    }


    public static final SCRIPT_NAME:String = 'ale-rulescript.hx';

    public static function ERROR_HANDLER(error:String):Void
    {
        Sys.println('[ RuleScript Error ] ' + error);
    }
}