package ale.rulescript;

import rulescript.RuleScript as OGRuleScript;
import rulescript.interps.RuleScriptInterp;
import rulescript.Context;

import haxe.Exception;

using StringTools;

class RuleScript extends OGRuleScript
{
    public function new(scriptName:String, ?context:Context)
    {
        super(new RuleScriptInterp(), new HxParser(scriptName), context);

        getInterp(RuleScriptInterp).scriptName = scriptName.replace('.', '/') + RuleScriptGlobal.SCRIPT_EXTENSION;

        this.errorHandler = RuleScriptGlobal.ERROR_HANDLER;
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