package ale.rulescript;

import rulescript.RuleScript as OGRuleScript;
import rulescript.interps.RuleScriptInterp;
import rulescript.Context;

import haxe.Exception;

using StringTools;

class RuleScript extends OGRuleScript
{
    public final codePath:String;

    public function new(scriptName:String, ?superInstance:Dynamic, ?shouldExecute:Bool = false, ?context:Context)
    {
        super(new RuleScriptInterp(), new HxParser(scriptName), context);

        this.superInstance = superInstance;

        codePath = RuleScriptGlobal.SCRIPT_PATH + scriptName.replace('.', '/') + RuleScriptGlobal.SCRIPT_EXTENSION;

        getInterp(RuleScriptInterp).scriptName = codePath;

        errorHandler = RuleScriptGlobal.ERROR_HANDLER;

        if (shouldExecute)
            run();
    }

    public function run():Dynamic
    {
        if (RuleScriptGlobal.FILE_CHECKER(codePath))
            return tryExecute(RuleScriptGlobal.FILE_READER(codePath), RuleScriptGlobal.ERROR_HANDLER);

        return null;
    }

    public function call(name:String, ?args:Array<Dynamic>):Dynamic
    {
        final func:Dynamic = variables.get(name);

        if (func != null && Reflect.isFunction(func))
        {
            try
            {
                return Reflect.callMethod(null, func, args ?? []);
            } catch(error:Exception) {
                RuleScriptGlobal.ERROR_HANDLER(error.details());
            }
        }

        return null;
    }

    public function set(name:String, value:Dynamic):Void
        variables.set(name, value);

	public function setClass(cls:Class<Dynamic>):Void
		set(Type.getClassName(cls).split('.').pop(), cls);
}