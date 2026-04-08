package ale.rulescript;

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
}