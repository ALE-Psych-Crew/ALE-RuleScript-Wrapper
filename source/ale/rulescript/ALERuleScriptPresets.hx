package ale.rulescript;

import rulescript.scriptedClass.RuleScriptedClassUtil;
import rulescript.scriptedClass.RuleScriptedClass;
import rulescript.interps.RuleScriptInterp;
import rulescript.types.ScriptedModule;
import rulescript.RuleScript;
import rulescript.Tools;

import hscript.Expr;

using StringTools;

class ALERuleScriptPresets
{
    public static function MODULE_RESOLVER(name:String):Array<ModuleDecl>
    {
        final path:Array<String> = name.split('.');

        final pack:Array<String> = [];

        while (path[0].charAt(0) == path[0].charAt(0).toLowerCase())
            pack.push(path.shift());

        final moduleName:String = path.length > 1 ? path.shift() : null;

        final filePath:String = ALERuleScriptGlobal.MODULE_PATH + (pack.length >= 1 ? pack.join('.') + '.' + (moduleName ?? path[0]) : path[0]).replace('.', '/') + ALERuleScriptGlobal.MODULE_EXTENSION;

        if (!ALERuleScriptGlobal.FILE_CHECKER(filePath))
            return null;

        return new ALEHxParser(name, MODULE).parseModule(ALERuleScriptGlobal.FILE_READER(filePath));
    }

    public static function SCRIPT_RESOLVER(name:String):Dynamic
    {
        final path:TypePath = Tools.parseTypePath(name);

        final module:Array<ModuleDecl> = ScriptedTypeUtil.resolveModule(path.moduleType());

        return module == null ? null : new ScriptedModule(path.modulePath(), module, ScriptedTypeUtil._currentContext).types[path.typeName];
    }

    public static function BUILD_BRIDGE(typePath:String, superInstance:Dynamic):RuleScript
    {
        final type:ScriptedClassType = ScriptedTypeUtil.resolveScript(typePath);

        final script:ALERuleScript = new ALERuleScript(typePath);
        script.getInterp(RuleScriptInterp).skipNextRestore = true;
        script.superInstance = superInstance;

        if (type.isExpr)
            script.execute(cast type);
        else
            RuleScriptedClassUtil.buildScriptedClass(cast (type, ScriptedClass), script);

        return script;
    }
}